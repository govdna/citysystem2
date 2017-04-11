package com.govmade.repository.system.information;

import com.govmade.entity.system.information.Application;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.information.SearchLog;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;



/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem TODO
* @date 2017年1月11日 上午9:07:10   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: ApplicationDao.java
* @Package com.govmade.repository.system.information
* @version V1.0   
*/
@MYBatis
public interface ApplicationDao extends GovmadeBaseDao<Application> {
	
	/** 
	* @Title: updateStatus 
	* @Description: TODO(流程状态) 
	* @param @param info    设定文件 
	* @return void    返回类型 
	* 2017年1月11日    日期   
	*/ 
	public void updateStatus(Application app);
}
