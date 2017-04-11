package com.govmade.repository.system.api;

import java.util.List;

import com.govmade.entity.system.api.ApiAccount;
import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;
import com.govmade.service.base.CanSimpleFields;

@MYBatis
public interface ApiAccountDAO  extends GovmadeBaseDao<ApiAccount> {
	
}

