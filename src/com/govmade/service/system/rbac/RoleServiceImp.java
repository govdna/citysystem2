package com.govmade.service.system.rbac;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.gson.JsonArray;
import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.rbac.Role;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.entity.system.account.Account;
import com.govmade.repository.system.rbac.PermissionDAO;
import com.govmade.repository.system.rbac.RoleDAO;
import com.govmade.repository.system.rbac.ScopeDAO;
import com.govmade.service.base.BaseService;
import com.govmade.service.base.BaseServiceImp;
import com.govmade.service.base.GovmadeBaseServiceImp;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("RoleService")
public class RoleServiceImp extends GovmadeBaseServiceImp<Role> implements RoleService {

	@Autowired
	private RoleDAO roleDAO;

}
