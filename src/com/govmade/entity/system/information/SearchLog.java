package com.govmade.entity.system.information;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;

/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 资源搜索热词
* @date 2017年1月10日 下午4:27:42   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: SearchLog.java
* @Package com.govmade.entity.system.information
* @version V1.0   
*/
@Alias("SearchLog")
public class SearchLog extends IdBaseEntity{
	private String keyWord;//关键字
	private Integer accountId;//搜索者
	private Integer count;//搜索数
	public String getKeyWord() {
		return keyWord;
	}
	public Integer getCount() {
		return count;
	}
	public void setCount(Integer count) {
		this.count = count;
	}
	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}
	public Integer getAccountId() {
		return accountId;
	}
	public void setAccountId(Integer accountId) {
		this.accountId = accountId;
	}
	
}
