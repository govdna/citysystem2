package com.govmade.controller.system.organization;

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
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.tree.entity.ZNodes;
import com.govmade.controller.base.BaseController;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.account.Account;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.organization.City;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.organization.Groups;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.account.AccountService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.organization.CityService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.organization.GroupsService;
import com.govmade.service.system.rbac.PermissionService;

import net.sf.json.JSONObject;

@Controller
@RequestMapping("/backstage/city/")
public class CityController extends GovmadeBaseController<City>{

	@Autowired
	private CityService service;

	@Override
	public String indexURL() {
		return "/system/organization/city/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}


	
	@RequestMapping(value = "jqGridTreeJson")
	public String jqGridTreeJson(City c,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		res.getWriter().write(service.getJqGridTreeJson(c).toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
}
