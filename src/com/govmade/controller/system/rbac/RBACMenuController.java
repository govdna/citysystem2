package com.govmade.controller.system.rbac;

import java.util.ArrayList;
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
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.tree.entity.ZNodes;
import com.govmade.controller.base.BaseController;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.account.Account;
import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.account.AccountService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.rbac.PermissionService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/backstage/rbac/menu/")
public class RBACMenuController extends GovmadeBaseController<Permission>{

	@Autowired
	private PermissionService service;
	
	@Override
	public String indexURL() {
		return "/system/rbac/menu/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}
	
	@Autowired
	private GovmadeDicService govmadeDicservice;
	
	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map= super.getDataHandlers();
		map.put("menuType", new DataHandler() {
             //服务对象分类（serObjSort）根据数据字典配置，通过ID读取dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic=new GovmadeDic();
				dic.setDicNum("MENUTYPE");
				dic.setDicKey((Integer)obj+"");			
				List<GovmadeDic> l=govmadeDicservice.getDicList(dic);
				if(l!=null&&l.size()>0){
					return l.get(0).getDicValue();
				}
				return "";
			}

			@Override
			public int getMode() {
				return ADD_MODE;
			}
			
		});
		return map;
	}
	
	@Override
	public String insertAjax(Permission o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		o.setNodeName(req.getParameter("nodeNameForShow"));
		o.setType(Permission.MENU);
		return super.insertAjax(o, req, res);
	}

	@RequestMapping(value = "treeJson")
	public String treeJson(HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		Permission p=new Permission();
		p.setType(Permission.MENU);
		res.getWriter().write(service.getPermissionTreeJson(p).toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
	
	
	@RequestMapping(value = "jqGridTreeJson")
	public String jqGridTreeJson(HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		Permission p=new Permission();
		p.setType(Permission.MENU);
		res.getWriter().write(service.getJqGridTreeJson(p).toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
	
	@RequestMapping(value = "search")
	public String search(Permission o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		//获得前端传过来的menuT（菜单模块）放入sss
		String sss=req.getParameter("menuT");	
		//获得前端传过来的nodeN（菜单名称）放入cc
		String cc = new String(req.getParameter("nodeN").getBytes("iso8859-1"), "utf-8");
		System.out.println("cc="+cc);
		if(sss!=null&&sss!=""){
        	int menuType = Integer.parseInt(sss);
        	Permission p=new Permission();
        	p.setType(Permission.MENU);
    		p.setMenuType(menuType);
    		res.getWriter().write(service.getsearch(p).toString());
    		res.getWriter().flush();
    		res.getWriter().close();
        }else if(StringUtils.isNotEmpty(cc)){
        	Permission per=new Permission();
    		per.setType(Permission.MENU);
    		per.setNodeName(cc);
    		String str=service.getsearchName(per).toString();
    		System.out.println(str);
    		res.getWriter().write(str);
    		res.getWriter().flush();
    		res.getWriter().close();
        }
        else{
		Permission p=new Permission();
		p.setType(Permission.MENU);
		res.getWriter().write(service.getJqGridTreeJson(p).toString());
		res.getWriter().flush();
		res.getWriter().close();
        }
		return null;
	}
	
}
