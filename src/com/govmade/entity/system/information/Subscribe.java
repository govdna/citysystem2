package com.govmade.entity.system.information;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;


/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 信息资源订阅
* @date 2017年1月18日 下午1:49:28   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: Subscribe.java
* @Package com.govmade.entity.system.information
* @version V1.0   
*/
@Alias("Subscribe")
public class Subscribe extends IdBaseEntity {
	private Integer informationResourceId;//信息资源id
	private Integer accountId;//订阅者
	public Integer getInformationResourceId() {
		return informationResourceId;
	}
	public void setInformationResourceId(Integer informationResourceId) {
		this.informationResourceId = informationResourceId;
	}
	public Integer getAccountId() {
		return accountId;
	}
	public void setAccountId(Integer accountId) {
		this.accountId = accountId;
	}

	
}
