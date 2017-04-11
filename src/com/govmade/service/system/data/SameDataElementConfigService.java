package com.govmade.service.system.data;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.govmade.common.mybatis.Page;
import com.govmade.entity.system.data.CleanDataElement;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.data.SameDataElementConfig;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.service.base.BaseService;



/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan 数据元近义词配置
* @date 2017年3月27日 上午10:55:03   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: SameDataElementConfigService.java
* @Package com.govmade.service.system.data
* @version V1.0   
*/
public interface SameDataElementConfigService extends BaseService<SameDataElementConfig>{
	public List<SameDataElementConfig> getTreeList(SameDataElementConfig g);
}
