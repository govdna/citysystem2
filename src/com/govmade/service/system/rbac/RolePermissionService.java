package com.govmade.service.system.rbac;

import java.util.List;

import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.rbac.Role;
import com.govmade.entity.system.rbac.RolePermission;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.service.base.BaseService;

import net.sf.json.JSONArray;

public interface RolePermissionService extends BaseService<RolePermission>{
	public void addRolePermissionScope(Role role, String permissions, String scopes);
		
}
