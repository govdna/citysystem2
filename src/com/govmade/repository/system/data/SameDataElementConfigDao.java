package com.govmade.repository.system.data;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.govmade.common.mybatis.Page;
import com.govmade.entity.system.data.CleanDataElement;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.data.SameDataElementConfig;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;




/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan 数据元近义词配置
* @date 2017年3月27日 上午10:53:28   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: SameDataElementConfigDao.java
* @Package com.govmade.repository.system.data
* @version V1.0   
*/
@MYBatis
public interface SameDataElementConfigDao  extends GovmadeBaseDao<SameDataElementConfig> {
	
}
