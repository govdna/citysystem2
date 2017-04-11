package com.govmade.service.system.information;

import com.govmade.entity.system.information.Application;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.information.SearchLog;
import com.govmade.service.base.BaseService;

public interface ApplicationService extends BaseService<Application>{
	public void updateStatus(Application app);
}
