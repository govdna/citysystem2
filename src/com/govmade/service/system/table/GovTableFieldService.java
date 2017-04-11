package com.govmade.service.system.table;


import java.util.List;

import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.service.base.BaseService;
import com.govmade.service.base.CanSimpleFields;

public interface GovTableFieldService extends BaseService<GovTableField>,CanSimpleFields{
	/** 
	* @Title: insertList 
	* @Description: TODO(批量插入) 
	* @param @param list    设定文件 
	* @return void    返回类型 
	* 2017年3月15日    日期   
	*/ 
	public void insertList(List<GovTableField> list);
}

