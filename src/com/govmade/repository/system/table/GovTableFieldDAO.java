package com.govmade.repository.system.table;


import java.util.List;

import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;
import com.govmade.service.base.CanSimpleFields;

@MYBatis
public interface GovTableFieldDAO  extends GovmadeBaseDao<GovTableField>,CanSimpleFields {

	/** 
	* @Title: findByGovTable 
	* @Description: TODO(根据数据表查找字段) 
	* @param @param list
	* @param @return    设定文件 
	* @return List<GovTableField>    返回类型 
	* 2017年4月27日    日期   
	*/ 
	public List<GovTableField> findByGovTable(List<GovTable> list);
}

