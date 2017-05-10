package com.govmade.repository.system.memorizer;

import com.govmade.entity.system.memorizer.GovMemorizer;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;
import com.govmade.service.base.CanSimpleFields;

@MYBatis
public interface GovMemorizerDAO  extends GovmadeBaseDao<GovMemorizer>,CanSimpleFields {
	
}

