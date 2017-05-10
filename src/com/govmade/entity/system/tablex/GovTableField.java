package com.govmade.entity.system.tablex;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.system.base.SimpleFieldsValues;



/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan value1 代码/value2 名称/value3 所属表 /value4 关联字段/value5 类型/value6 长度/value7 是否主键//value8 小数位//value9 主键//value10 可否空//value11 默认值//value12 是否外键
* @date 2017年3月11日 下午4:14:19   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: GovTableField.java
* @Package com.govmade.entity.system.tablex
* @version V1.0   
*/
@Alias("GovTableField")
public class GovTableField  extends SimpleFieldsValues{
	//value1 代码
	//value2 名称
	//value3 所属表 
	//value4 关联字段
	//value5 类型
	//value6 长度
	//value7 精度
	//value8 小数位
	//value9 主键
	//value10 可否空
	//value11 默认值
	//value12 是否外键
	private Integer dataElementId;//对应数据元id
	public Integer getDataElementId() {
		return dataElementId;
	}

	public void setDataElementId(Integer dataElementId) {
		this.dataElementId = dataElementId;
	}
}
