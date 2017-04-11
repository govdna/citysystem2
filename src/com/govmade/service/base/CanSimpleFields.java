package com.govmade.service.base;

import org.apache.ibatis.annotations.Param;

/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan 自定义字段的dao、service需要实现clearColumn方法
* @date 2017年3月1日 上午10:47:10   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: CanSimpleFields.java
* @Package com.govmade.service.base
* @version V1.0   
*/
public interface CanSimpleFields {
	/** 
	* @Title: clearColumn 
	* @Description: TODO(清空某一行的数据) 
	* @param @param no    设定文件 
	* @return void    返回类型 
	* 2016年12月28日    日期   
	*/ 
	public void clearColumn(@Param("valueNo")int no);
}
