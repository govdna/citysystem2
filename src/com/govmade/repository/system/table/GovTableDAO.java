package com.govmade.repository.system.table;

import java.util.List;

import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;
import com.govmade.service.base.CanSimpleFields;

@MYBatis
public interface GovTableDAO  extends GovmadeBaseDao<GovTable>,CanSimpleFields {
	
	/** 
	* @Title: findByGovDatabase 
	* @Description: TODO(根据数据库查找表) 
	* @param @param list
	* @param @return    设定文件 
	* @return List<GovTable>    返回类型 
	* 2017年4月27日    日期   
	*/ 
	public List<GovTable> findByGovDatabase(List<GovDatabase> list);
}

