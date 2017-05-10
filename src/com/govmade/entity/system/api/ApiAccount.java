package com.govmade.entity.system.api;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;


/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan api接口账号
* @date 2017年4月5日 下午1:53:34   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: ApiAccount.java
* @Package com.govmade.entity.system.api
* @version V1.0   
*/
@Alias("ApiAccount")
public class ApiAccount extends IdBaseEntity{
	private String name;
	private String appKey;
	private String secret;//密匙
	private String listenerUrl;//回调url
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAppKey() {
		return appKey;
	}
	public void setAppKey(String appKey) {
		this.appKey = appKey;
	}
	public String getSecret() {
		return secret;
	}
	public void setSecret(String secret) {
		this.secret = secret;
	}
	public String getListenerUrl() {
		return listenerUrl;
	}
	public void setListenerUrl(String listenerUrl) {
		this.listenerUrl = listenerUrl;
	}
	
}
