package com.govmade.repository.system.application;

import java.util.List;

import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;
import com.govmade.service.base.CanSimpleFields;

@MYBatis
public interface GovApplicationSystemDAO  extends GovmadeBaseDao<GovApplicationSystem>,CanSimpleFields {
	public List<GovApplicationSystem> getAppSysList(GovApplicationSystem app);
	public  void deleteRelation(GovApplicationSystem o);
}

