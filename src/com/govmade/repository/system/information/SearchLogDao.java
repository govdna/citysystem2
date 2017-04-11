package com.govmade.repository.system.information;

import java.util.List;

import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.SearchLog;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;


/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem TODO
* @date 2017年1月10日 下午4:30:15   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: SearchLogDao.java
* @Package com.govmade.repository.system.information
* @version V1.0   
*/
@MYBatis
public interface SearchLogDao extends GovmadeBaseDao<SearchLog> {
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
