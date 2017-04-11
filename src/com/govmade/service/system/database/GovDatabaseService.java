package com.govmade.service.system.database;

import java.util.List;

import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.service.base.BaseService;
import com.govmade.service.base.CanSimpleFields;

public interface GovDatabaseService extends BaseService<GovDatabase>,CanSimpleFields{
	/** 
	* @Title: insertList 
	* @Description: TODO(批量插入) 
	* @param @param list    设定文件 
	* @return void    返回类型 
	* 2017年3月15日    日期   
	*/ 
	public void insertList(List<GovDatabase> list);
}

