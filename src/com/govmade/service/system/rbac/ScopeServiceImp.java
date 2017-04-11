package com.govmade.service.system.rbac;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.gson.JsonArray;
import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.rbac.RolePermission;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.entity.system.account.Account;
import com.govmade.repository.system.rbac.PermissionDAO;
import com.govmade.repository.system.rbac.ScopeDAO;
import com.govmade.service.base.BaseService;
import com.govmade.service.base.BaseServiceImp;
import com.govmade.service.base.GovmadeBaseServiceImp;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("ScopeService")
public class ScopeServiceImp extends GovmadeBaseServiceImp<Scope> implements ScopeService {

	@Autowired
	private ScopeDAO scopeDAO;

	@Override
	public List<Scope> getScopesByRoleId(String id, Permission p) {
		return scopeDAO.getScopesByRoleId(id, p);
	}

}
