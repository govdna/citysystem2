package com.govmade.controller.system.rbac;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.rbac.Role;
import com.govmade.entity.system.rbac.RolePermission;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.rbac.PermissionService;
import com.govmade.service.system.rbac.RolePermissionService;
import com.govmade.service.system.rbac.RoleService;
import com.govmade.service.system.rbac.ScopeService;
import net.sf.json.JSONArray;

@Controller
@RequestMapping("/backstage/rbac/role/")
public class RBACRoleController extends GovmadeBaseController<Role> {

	@Autowired
	private RoleService service;

	@Autowired
	private PermissionService permissionService;

	@Autowired
	private ScopeService scopeService;

	@Autowired
	private RolePermissionService rolePermissionService;

	@Override
	public String indexURL() {
		return "/system/rbac/role/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public void doAfterInsertUpdate(Role o,HttpServletRequest req, HttpServletResponse res) {
		String[] permission = req.getParameterValues("sel_permissions");
		String[] scope = req.getParameterValues("sel_scopes");
		StringBuffer sb = new StringBuffer();
		if (permission != null && permission.length > 0) {

			for (String per : permission) {
				sb.append(per + ",");
			}
		}
		StringBuffer sb2 = new StringBuffer();

		if (scope != null && scope.length > 0) {
			for (String per : scope) {
				sb2.append(per + ",");
			}
		}

		rolePermissionService.addRolePermissionScope(o, sb.toString(), sb2.toString());

	}

	@Override
	public String detailAjax(Role o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		try {
			if (o instanceof IdBaseEntity && StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
				int id = Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow")));
				((IdBaseEntity) o).setId(id);
			}
			List l = service.find(o);
			if (l != null && l.size() > 0) {
				Role role = (Role) l.get(0);
				RolePermission rpf = new RolePermission();
				rpf.setRoleId(role.getId());
				List<RolePermission> rolePermission = rolePermissionService.find(rpf);
				Permission pf = new Permission();
				pf.setType(Permission.PERMISSION);
				Permission mf = new Permission();
				mf.setType(Permission.MENU);
				List<Permission> permissions = permissionService.find(pf);
				List<Permission> menus = permissionService.find(mf);
				List<Scope> scopes = scopeService.find(new Scope());
				if (StringUtils.isNotEmpty(req.getParameter("menu"))) {
					JSONArray mj = new JSONArray();
					for (int i = 0; i < menus.size(); i++) {
						Permission menuJO = menus.get(i);
						if (rolePermission != null) {
							for (RolePermission rp : rolePermission) {
								if (rp.getPermissionId().intValue() == menuJO.getId().intValue()) {

									menuJO.setIsChecked(1);
								}
							}
						}
					}
					res.getWriter().write(permissionService.buildTreeJson(menus).toString());
					res.getWriter().flush();
					res.getWriter().close();
				} else {
					for (Permission p : permissions) {
						List<Scope> scopesArr = new ArrayList<Scope>();
						for (Scope sc : scopes) {
							Scope s = (Scope) sc.clone();
							if (s.getPermissions() != null && s.getPermissions().contains("," + p.getId() + ",")) {
								s.setValue(p.getId() + "#" + s.getId());
								if (rolePermission != null) {
									for (RolePermission rp : rolePermission) {
										if (rp.getPermissionId().intValue() == p.getId()
												&& rp.getScopeId().intValue() == s.getId()) {
											s.setIsSelected(1);
										}
									}
								}
								scopesArr.add(s);
							}
						}
						if (scopesArr.size() > 0) {
							p.setScopes(scopesArr);
						}
						if (rolePermission != null) {
							for (RolePermission rp : rolePermission) {
								if (rp.getPermissionId().intValue() == p.getId()) {
									p.setIsSelected(1);
								}
							}
						}

					}
					res.getWriter().write(permissionService.buildTreeJson(permissions).toString());
					res.getWriter().flush();
					res.getWriter().close();
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
