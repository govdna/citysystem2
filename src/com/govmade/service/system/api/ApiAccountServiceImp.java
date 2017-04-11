package com.govmade.service.system.api;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.system.api.ApiAccount;
import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.repository.system.application.GovApplicationSystemDAO;
import com.govmade.service.base.GovmadeBaseServiceImp;

@Service("ApiAccountService")
public class ApiAccountServiceImp extends GovmadeBaseServiceImp<ApiAccount> implements ApiAccountService {

}


