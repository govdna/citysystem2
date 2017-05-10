package com.govmade.service.system.table;

import java.util.List;

import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.service.base.BaseService;
import com.govmade.service.base.CanSimpleFields;

public interface GovTableService extends BaseService<GovTable>,CanSimpleFields{
	
	/** 
	* @Title: insertList 
	* @Description: TODO(批量插入) 
	* @param @param list    设定文件 
	* @return void    返回类型 
	* 2017年3月15日    日期   
	*/ 
	public void insertList(List<GovTable> list);
	

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

