package com.govmade.service.system.rbac;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.gson.JsonArray;
import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.account.Account;
import com.govmade.repository.system.rbac.PermissionDAO;
import com.govmade.service.base.BaseService;
import com.govmade.service.base.BaseServiceImp;
import com.govmade.service.base.GovmadeBaseServiceImp;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("PermissionService")
public class PermissionServiceImp extends GovmadeBaseServiceImp<Permission> implements PermissionService {

	@Autowired
	private PermissionDAO permissionDAO;

	@Override
	public List<Permission> getPermissionTree(Permission p) {
		List<Permission> list = find(p,"menu_type,level_s,list_no","asc");
		return buildTree(list);
	}
	
	@Override
	public JSONArray getPermissionTreeJson(Permission p) {
		List<Permission> list = find(p,"menu_type,level_s,list_no","asc");
		return buildTreeJson(list);
	}

	// 返回菜单树
	public List<Permission> buildTree(List<Permission> list) {
		if (list == null || list.size() <= 1) {
			return list;
		}
		List<Permission> re = new ArrayList<Permission>();
		for (Permission p : list) {
			if (p.getParent() == null || p.getParent() == 0) {
				List<Permission> ja = getChild(p, list);
				if (ja != null && ja.size() > 0) {
					p.setChildren(ja);
				}
				re.add(p);
			}
		}
		return re;
	}

	// 返回子菜单树
	public List<Permission> getChild(Permission parent, List<Permission> list) {
		List<Permission> re = new ArrayList<Permission>();
		for (Permission p : list) {
			if (p.getParent().intValue() == parent.getId()) {
				List<Permission> ps = getChild(p, list);
				if (ps != null && ps.size() > 0) {
					p.setChildren(ps);
				}
				re.add(p);
			}
		}
		return re;
	}


	//返回菜单json格式
	public JSONArray buildTreeJson(List<Permission> list){
		if(list==null||list.size()==0){
			return null;
		}
		JSONArray re = new JSONArray();
		for (Permission p : list) {
			if (p.getParent() == null || p.getParent() == 0) {
				JSONObject menu=JSONObject.fromObject(p);
				menu.put("text", p.getNodeName());
				menu.put("nodeNameForShow", p.getNodeName());
				menu.put("iconCls", p.getIcon());
				menu.put("idForShow", SecurityUtil.encrypt(p.getId()));
				JSONArray ja=getChildJson(p,list);
				if(ja!=null&&ja.size()>0){
					menu.put("children", ja);
				}
				re.add(menu);
			}
		}
		return re;
	}
	//返回菜单json格式
	public JSONArray getChildJson(Permission parent, List<Permission> list) {
		
		JSONArray re = new JSONArray();
		for (Permission p : list) {
			if (p.getParent().intValue() == parent.getId()) {
				JSONObject menu=JSONObject.fromObject(p);
				menu.put("text", p.getNodeName());
				menu.put("nodeNameForShow", p.getNodeName());
				menu.put("iconCls", p.getIcon());
				menu.put("idForShow", SecurityUtil.encrypt(p.getId()));
				JSONArray ps = getChildJson(p, list);
				if (ps !=null&&ps.size()>0) {
					//re.addAll(ps);
					menu.put("children", ps);
				}
				re.add(menu);
			}
		}
		return re;
	}

	@Override
	public List<Permission> getPermissionsByRoleId(String id,Permission p) {
		List<Permission> ps=permissionDAO.getPermissionsByRoleId(StringUtil.toSQLArray(id),p);
		for(Permission pp:ps){
			//System.out.println(pp.getNodeName());
		}
		return buildTree(ps);
	}

	//是否是叶子节点
	private boolean isLeaf(Permission p,List<Permission> list){
		for(Permission pp:list){
			if(pp.getParent().intValue()==p.getId().intValue()){
				return false;
			}
		}
		return true;
	}
	
	@Override
	public JSONArray getJqGridTreeJson(Permission permission) {
		List<Permission> list =sort(find(permission,"menu_type,level_s,list_no","asc"));
		if(list==null||list.size()==0){
			return null;
		}
		JSONArray re = new JSONArray();
		for (Permission p : list) {
			JSONObject menu=JSONObject.fromObject(p);
			menu.put("text", p.getNodeName());
			menu.put("nodeNameForShow", p.getNodeName());
			menu.put("iconCls", p.getIcon());
			menu.put("idForShow", SecurityUtil.encrypt(p.getId()));
			if(isLeaf(p,list)){
				menu.put("isLeaf", true);
			}else{
				menu.put("isLeaf", false);
			}
			menu.put("expanded", true);
			
			re.add(menu);
			
		}
		return re;
	}
	
	public JSONArray getsearchName(Permission permission) {
		List<Permission> list =findByPage(permission,"menu_type,level_s,list_no","asc");
		if(list==null||list.size()==0){
			return null;
		}
		JSONArray re = new JSONArray(); 
		for (Permission p : list) {		
			JSONObject menu=JSONObject.fromObject(p);
			menu.put("text", p.getNodeName());
			menu.put("nodeNameForShow", p.getNodeName());
			menu.put("iconCls", p.getIcon());
			menu.put("idForShow", SecurityUtil.encrypt(p.getId()));
			if(isLeaf(p,list)){
				menu.put("isLeaf", true);
			}else{
				menu.put("isLeaf", false);
			}
			menu.put("expanded", true);
			
			re.add(menu);
			
		}
		return re;
	}
	
	public JSONArray getsearch(Permission permission) {
		List<Permission> list =sort(find(permission,"menu_type,level_s,list_no","asc"));
		if(list==null||list.size()==0){
			return null;
		}
		JSONArray re = new JSONArray();
		for (Permission p : list){
			JSONObject menu=JSONObject.fromObject(p);
			menu.put("text", p.getNodeName());
			menu.put("nodeNameForShow", p.getNodeName());
			menu.put("iconCls", p.getIcon());
			menu.put("idForShow", SecurityUtil.encrypt(p.getId()));
			if(isLeaf(p,list)){
				menu.put("isLeaf", true);
			}else{
				menu.put("isLeaf", false);
			}
			menu.put("expanded", true);
			
			re.add(menu);
		    }
		return re;
	}
	//对树进行排序
		public List<Permission> sort(List<Permission> list) {
			if(list==null||list.size()<=1){
				return list;
			}
			List<Permission> ps = new ArrayList<Permission>();
			for (Permission p : list) {
				if (p.getParent() == null || p.getParent() == 0) {
					ps.add(p);
					ps.addAll(getTreeChild(p, list));
				}
			}
			return ps;
		}

		public List<Permission> getTreeChild(Permission parent, List<Permission> list) {
			List<Permission> re = new ArrayList<Permission>();
			for (Permission p : list) {
				if (p.getParent().intValue() == parent.getId()) {
					p.setParentCode(parent.getCode());
					re.add(p);
					List<Permission> ps = getTreeChild(p, list);
					if (ps.size() > 0) {
						re.addAll(ps);
					}
				}
			}
			return re;
		}

		@Override
		public boolean hasPermission(String id, Permission p) {
			List<Permission> ps=permissionDAO.getPermissionsByRoleId(StringUtil.toSQLArray(id),p);
			if(ps!=null&&ps.size()>0){
				return true;
			}
			return false;
		}

		@Override
		public boolean hasPermission(String id, String url) {
			Permission p=new Permission();
			p.setUrl(url);
			List<Permission> ps=permissionDAO.getPermissionsByRoleId(StringUtil.toSQLArray(id),p);
			if(ps!=null&&ps.size()>0){
				return true;
			}
			return false;
		}
}
