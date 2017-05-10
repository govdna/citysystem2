package com.govmade.controller.system.model;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.customFields.SimpleFields;
import com.govmade.entity.system.model.HouseModelFields;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.rbac.RolePermission;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.model.HouseModelFieldsService;
import com.govmade.service.system.rbac.PermissionService;
import com.govmade.service.system.rbac.RolePermissionService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2017年2月14日 下午1:41:14   
* @Title: HouseModelFieldsControlle.java  
*/
@Controller
@RequestMapping("/backstage/model/houseModelFields/")
public class HouseModelFieldsController extends GovmadeBaseController<HouseModelFields>{

	@Autowired
	private HouseModelFieldsService service;
	@Autowired
	private PermissionService permissionService;
	@Autowired
	private RolePermissionService rolePermissionService;
	
	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public String indexURL() {
		return "/system/model/houseModelFields/index";
	}
	
	@Override
	public void doAfterInsertUpdate(HouseModelFields o,HttpServletRequest req, HttpServletResponse res) {
		
		if(o.getFatherId()==0 && o.getLevel()==1){
		
			Permission permission=new Permission();
			permission.setParent(76);
			permission.setLevel(3);
			permission.setListNo(o.getModelType());
			permission.setMenuType(2);
			permission.setOpenMethod(1);
			permission.setType(0);
			permission.setUrl("/backstage/model/customModel/index?model="+o.getModelType());
			permission.setIcon("fa-cube");
			
			List<Permission> plist = permissionService.find(permission);

			if(plist==null || plist.size()==0){
			
				RolePermission rp=new RolePermission();
				
				// 添加菜单				
				permission.setNodeName(o.getModelName());
				permissionService.insert(permission);
				//
				Permission p=new Permission();
				p.setParent(77);
				p.setLevel(3);
				p.setListNo(o.getModelType());
				p.setMenuType(2);
				p.setOpenMethod(1);
				p.setType(0);
				p.setUrl("/backstage/model/houseModel/treeAjax?type="+o.getModelType());
				p.setIcon("fa-cube");
				p.setNodeName(o.getModelName()+"树形图");
				permissionService.insert(p);
				
				// 添加角色显示
				rp.setRoleId(Integer.valueOf(AccountShiroUtil.getCurrentUser().getRoleId()));
				rp.setScopeId(0);
				rp.setPermissionId(permission.getId());
				rolePermissionService.insert(rp);
				//
				rp.setPermissionId(p.getId());
				rolePermissionService.insert(rp);
			}else if(plist.size()==1){
				Permission p=plist.get(0);
				p.setNodeName(o.getModelName());
				permissionService.update(p);
				
				permission.setParent(77);
				permission.setUrl("/backstage/model/houseModel/treeAjax?type="+o.getModelType());
				Permission p2=permissionService.find(permission).get(0);
				p2.setNodeName(o.getModelName()+"树形图");
				permissionService.update(p2);
			}
			
		}

	}
	
	@Override
	public void doBeforeInsertUpdate(HouseModelFields o, HttpServletRequest req, HttpServletResponse res) {
		if(o.getModelType() == null){
			HouseModelFields hm=new HouseModelFields();
			hm.setLevel(1);
			List<HouseModelFields> hmList=service.find(hm, "model_type", "desc");
			if(hmList!=null && hmList.size()>0){
				o.setModelType(hmList.get(0).getModelType()+1);
			}else{
				o.setModelType(1);
			}
		}
		
		
		if(o.getValueNo()!=null || o.getFatherId()==0){
			return;
		}
		HouseModelFields sm=new HouseModelFields();
		sm.setModelType(o.getModelType());
		List<HouseModelFields> dmList=service.find(sm);
		for(int i=1;i<=30;i++){
			boolean used=false;
			for(HouseModelFields dm:dmList){
				if(dm.getValueNo()!=null&&dm.getValueNo().intValue()==i){
					used=true;
					break;
				}
			}
			if(!used){
				o.setValueNo(i);
				return;
			}
		}
	}


	@RequestMapping(value = "jqGridTreeJson")
	public String jqGridTreeJson(HouseModelFields sm, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		List<HouseModelFields> smlist = service.find(sm);
		if (smlist != null && smlist.size() > 0) {
			res.getWriter().write(service.getJqGridTreeJson(sm).toString());
			res.getWriter().flush();
			res.getWriter().close();
		}
		return null;
	}


}
