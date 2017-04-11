package com.govmade.service.system.information;

import java.util.List;

import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.SearchLog;
import com.govmade.service.base.BaseService;

public interface SearchLogService extends BaseService<SearchLog>{
	/** 
	* @Title: getHotKeyWord 
	* @Description: TODO(获取最近7天热门搜词) 
	* @param @return    设定文件 
	* @return List<SearchLog>    返回类型 
	* 2017年1月12日    日期   
	*/ 
	public List<SearchLog> getHotKeyWord();
	public List<SearchLog> hotres();
}
