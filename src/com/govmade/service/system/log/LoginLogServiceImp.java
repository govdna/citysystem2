package com.govmade.service.system.log;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.govmade.entity.system.log.LoginLog;
import com.govmade.repository.system.log.LoginLogDao;
import com.govmade.service.base.GovmadeBaseServiceImp;

@Service("LoginLogService")
public class LoginLogServiceImp extends GovmadeBaseServiceImp<LoginLog> implements LoginLogService{

	@Autowired
	private LoginLogDao dao;

}
