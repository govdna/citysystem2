package com.govmade.controller.system.rbac;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.govmade.common.ajax.AjaxRes;
import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.tree.entity.ZNodes;
import com.govmade.controller.base.BaseController;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.account.Account;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.account.AccountService;
import com.govmade.service.system.rbac.PermissionService;
import com.govmade.service.system.rbac.ScopeService;

import net.sf.json.JSONObject;

@Controller
@RequestMapping("/backstage/rbac/scope/")
public class RBACScopeController extends GovmadeBaseController<Scope> {

	@Autowired
	private ScopeService service;

	@Autowired
	private PermissionService permissionService;

	@Override
	public String indexURL() {
		return "/system/rbac/scope/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public String detailAjax(Scope o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		try {
			List<Permission> permissions = null;
			if (StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
				int id = Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow")));
				o.setId(id);

				Scope scope = service.find(o).get(0);
				Permission per = new Permission();
				per.setType(Permission.PERMISSION);
				permissions = permissionService.find(per);
				String ps = scope.getPermissions();
				ps = "," + ps + ",";
				for (Permission p : permissions) {
					if (ps.contains("," + p.getId() + ",")) {
						p.setIsSelected(1);
					}
				}
			} else {
				Permission per = new Permission();
				per.setType(Permission.PERMISSION);
				permissions = permissionService.find(per);
			}
			res.setContentType("text/html;charset=utf-8");
			res.setCharacterEncoding("utf-8");
			res.getWriter().write(permissionService.buildTreeJson(permissions).toString());
			res.getWriter().flush();
			res.getWriter().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
