package com.govmade.service.system.rbac;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.rbac.RolePermission;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.service.base.BaseService;

import net.sf.json.JSONArray;

public interface ScopeService extends BaseService<Scope>{
	
	/** 
	* @Title: getScopesByRoleId 
	* @Description: TODO(根据角色Id获取Scope) 
	* @param @param id
	* @param @param p
	* @param @return    设定文件 
	* @return List<Scope>    返回类型 
	* 2017年1月5日    日期   
	*/ 
	public List<Scope> getScopesByRoleId(String id,Permission p);

}
