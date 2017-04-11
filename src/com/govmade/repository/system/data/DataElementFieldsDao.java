package com.govmade.repository.system.data;

import com.govmade.entity.system.customFields.DataElementFields;
import com.govmade.entity.system.data.DataManager;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;


/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 数据元自定义字段
* @date 2017年2月1日 下午9:33:33   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: DataElementFieldsDao.java
* @Package com.govmade.repository.system.data
* @version V1.0   
*/
@MYBatis
public interface DataElementFieldsDao  extends GovmadeBaseDao<DataElementFields> {
	
}
