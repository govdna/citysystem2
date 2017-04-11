package com.govmade.repository.system.database;

import com.govmade.entity.system.database.GovDatabase;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;
import com.govmade.service.base.CanSimpleFields;

@MYBatis
public interface GovDatabaseDAO  extends GovmadeBaseDao<GovDatabase>,CanSimpleFields {
	
}

