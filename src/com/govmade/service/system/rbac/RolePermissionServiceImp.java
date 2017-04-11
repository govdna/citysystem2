package com.govmade.service.system.rbac;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.gson.JsonArray;
import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.rbac.Role;
import com.govmade.entity.system.rbac.RolePermission;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.entity.system.account.Account;
import com.govmade.repository.system.rbac.PermissionDAO;
import com.govmade.repository.system.rbac.RoleDAO;
import com.govmade.repository.system.rbac.RolePermissionDAO;
import com.govmade.repository.system.rbac.ScopeDAO;
import com.govmade.service.base.BaseService;
import com.govmade.service.base.BaseServiceImp;
import com.govmade.service.base.GovmadeBaseServiceImp;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("RolePermissionService")
public class RolePermissionServiceImp extends GovmadeBaseServiceImp<RolePermission> implements RolePermissionService {

	@Autowired
	private RolePermissionDAO rolePermissionDAO;
	
	@Override
	public void addRolePermissionScope(Role role, String permissions, String scopes) {
		RolePermission rpf=new RolePermission();
		rpf.setRoleId(role.getId());
		rolePermissionDAO.deletePhysically(rpf);
		String[] ps = permissions.split(",");
		scopes=","+scopes;
		for (String permission : ps) {
			Pattern pattern = Pattern.compile(","+permission+"#(\\d+)");
			Matcher matcher = pattern.matcher(scopes);
			boolean find=false;
			while (matcher.find()) {
				find=true;
				RolePermission rp=new RolePermission();
				rp.setRoleId(role.getId());
				rp.setPermissionId(Integer.valueOf(permission));
				rp.setScopeId(Integer.valueOf(matcher.group(1)));
				rolePermissionDAO.insert(rp);
			}
			if(!find){
				RolePermission rp=new RolePermission();
				rp.setRoleId(role.getId());
				rp.setPermissionId(Integer.valueOf(permission));
				rp.setScopeId(0);
				rolePermissionDAO.insert(rp);
			}
		}
	}

}
