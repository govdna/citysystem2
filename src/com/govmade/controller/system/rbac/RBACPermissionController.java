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
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.tree.entity.ZNodes;
import com.govmade.controller.base.BaseController;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.account.Account;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.account.AccountService;
import com.govmade.service.system.rbac.PermissionService;

import net.sf.json.JSONObject;

@Controller
@RequestMapping("/backstage/rbac/permission/")
public class RBACPermissionController extends GovmadeBaseController<Permission>{

	@Autowired
	private PermissionService service;
	
	@Override
	public String indexURL() {
		return "/system/rbac/permission/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}
	
	@Override
	public String insertAjax(Permission o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		o.setNodeName(req.getParameter("nodeNameForShow"));
		o.setType(Permission.PERMISSION);
		return super.insertAjax(o, req, res);
	}

	@RequestMapping(value = "treeJson")
	public String treeJson(HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		Permission p=new Permission();
		p.setType(Permission.PERMISSION);
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
		p.setType(Permission.PERMISSION);
		res.getWriter().write(service.getJqGridTreeJson(p).toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
	@RequestMapping(value = "search")
	public String search(Permission o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		//获得前端传过来的nodeN（权限名称）放入cc
		String cc = new String(req.getParameter("nodeN").getBytes("iso8859-1"), "utf-8");
        if(StringUtils.isNotEmpty(cc)){
        	Permission per=new Permission();
    		per.setType(Permission.PERMISSION);
    		per.setNodeName(cc);
    		String str=service.getsearchName(per).toString();
    		System.out.println(str);
    		res.getWriter().write(str);
    		res.getWriter().flush();
    		res.getWriter().close();
        }
        else{
		Permission p=new Permission();
		p.setType(Permission.PERMISSION);
		res.getWriter().write(service.getJqGridTreeJson(p).toString());
		res.getWriter().flush();
		res.getWriter().close();
        }
		return null;
	}
	
}
