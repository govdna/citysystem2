package com.govmade.entity.system.customFields;

import com.govmade.entity.system.base.CustomField;

/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan 通用自定义字段
* @date 2017年3月1日 上午9:55:32   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: SimpleFields.java
* @Package com.govmade.entity.system.customFields
* @version V1.0   
*/
public class SimpleFields extends CustomField{
	private String className;

	public String getClassName() {
		return className;
	}

	public void setClassName(String className) {
		this.className = className;
	}
}
