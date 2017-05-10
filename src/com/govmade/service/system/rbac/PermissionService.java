package com.govmade.service.system.rbac;

import java.util.List;

import com.govmade.entity.system.rbac.Permission;
import com.govmade.service.base.BaseService;

import net.sf.json.JSONArray;

public interface PermissionService extends BaseService<Permission>{

	public List<Permission> getPermissionTree(Permission p);
	
	public JSONArray getPermissionTreeJson(Permission p);
	
	public JSONArray getJqGridTreeJson(Permission p);
	
	public JSONArray getsearch(Permission p);
	
	public JSONArray getsearchName(Permission p);
	
	public JSONArray buildTreeJson(List<Permission> list);
		
	public List<Permission> buildTree(List<Permission> list);
	
	public List<Permission> getPermissionsByRoleId(String id,Permission p);
	
	public boolean hasPermission(String id,Permission p);
	
	/** 
	* @Title: hasPermission 
	* @Description: TODO(是否有权限) 
	* @param @param id 角色id
	* @param @param url 权限url
	* @param @return    设定文件 
	* @return boolean    返回类型 
	* 2017年1月5日    日期   
	*/ 
	public boolean hasPermission(String id,String url);
}
