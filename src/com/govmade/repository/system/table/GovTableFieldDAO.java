package com.govmade.repository.system.table;


import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;
import com.govmade.service.base.CanSimpleFields;

@MYBatis
public interface GovTableFieldDAO  extends GovmadeBaseDao<GovTableField>,CanSimpleFields {
	
}

