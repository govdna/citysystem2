package com.govmade.service.system.application;

import java.util.List;

import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.service.base.BaseService;
import com.govmade.service.base.CanSimpleFields;

public interface GovApplicationSystemService extends BaseService<GovApplicationSystem>,CanSimpleFields{

	public List<GovApplicationSystem> getAppSysList(GovApplicationSystem i);
	public  void deleteRelation(GovApplicationSystem o);
	
}

