package com.govmade.controller.system.organization;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.organization.Groups;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.account.AccountService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.organization.GroupsService;
import com.govmade.service.system.rbac.PermissionService;

import net.sf.json.JSONObject;

@Controller
@RequestMapping("/backstage/groups/")
public class GroupsController extends GovmadeBaseController<Groups>{

	@Autowired
	private GroupsService service;
	@Autowired
	private CompanyService companyService;
	
	
	@Override
	public String indexURL() {
		return "/system/organization/groups/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map= super.getDataHandlers();
		map.put("companyId", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				Company c=new Company();
				c.setId((Integer)obj);
				List<Company> l=companyService.find(c);
				if(l!=null&&l.size()>0){
					return l.get(0).getCompanyName();
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
	
	
	
}
