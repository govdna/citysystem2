package com.govmade.controller.system.log;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.log.LoginLog;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.log.LoginLogService;
/*
 * 登录日志
 */
@Controller
@RequestMapping("/backstage/loginLog/")
public class LoginLogController extends GovmadeBaseController<LoginLog>{
	
	@Autowired
	public LoginLogService service;

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public String indexURL() {
		return "/system/loginLog/index";
	}

}
