package com.govmade.repository.system.information;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.information.InformationLog;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.information.Subscribe;
import com.govmade.entity.system.organization.Company;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;



/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 最近操作的信息资源
* @date 2017年2月9日 下午1:39:42   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: InformationLogDao.java
* @Package com.govmade.repository.system.information
* @version V1.0   
*/
@MYBatis
public interface InformationLogDao extends GovmadeBaseDao<InformationLog> {
	

}
