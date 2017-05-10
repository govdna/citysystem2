package com.govmade.controller.system.api;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.api.ApiSecurityUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.api.ApiAccount;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.api.ApiAccountService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.sort.SortManagerService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/backstage/apiAccount/")
public class ApiAccountController extends GovmadeBaseController<ApiAccount>{

	@Autowired
	private ApiAccountService service;
	
	
	@Override
	public String indexURL() {
		return "/system/api/account/index";
	}

	@Override
	public void doBeforeInsertUpdate(ApiAccount o, HttpServletRequest req, HttpServletResponse res) {
		try {
			if(o.getId()==null){
				o=ApiSecurityUtil.setAppKey(o);
				ApiAccount apiAccount=new ApiAccount();
				apiAccount.setAppKey(o.getAppKey());
				List<ApiAccount> list=service.find(apiAccount);
				while(list!=null&&list.size()>0){
					o=ApiSecurityUtil.setAppKey(o);
					apiAccount=new ApiAccount();
					apiAccount.setAppKey(o.getAppKey());
					list=service.find(apiAccount);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println(o);
	}

	@Override
	public BaseService getService() {
		return service;
	}
	
	
}
