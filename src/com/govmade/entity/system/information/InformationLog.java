package com.govmade.entity.system.information;

import com.govmade.entity.base.IdBaseEntity;

/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 最近操作的信息资源
* @date 2017年2月9日 下午1:36:48   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: InformationLog.java
* @Package com.govmade.entity.system.information
* @version V1.0   
*/
public class InformationLog extends IdBaseEntity{
	private Integer informationId;//信息资源id
	private Integer accountId;//用户id
	public Integer getInformationId() {
		return informationId;
	}
	public void setInformationId(Integer informationId) {
		this.informationId = informationId;
	}
	public Integer getAccountId() {
		return accountId;
	}
	public void setAccountId(Integer accountId) {
		this.accountId = accountId;
	}
	
}
