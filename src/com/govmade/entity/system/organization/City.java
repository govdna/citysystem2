package com.govmade.entity.system.organization;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;

/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 城市
* @date 2016年12月12日 上午9:44:43   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: City.java
* @Package com.govmade.entity.system.organization
* @version V1.0   
*/
@Alias("City")
public class City extends IdBaseEntity{
	private String number;//城市编号
	private String cityName;//城市名称
	private Integer cityType;//省、市、区
	private Integer level;
	private Integer fatherId;
	public String getNumber() {
		return number;
	}
	public void setNumber(String number) {
		this.number = number;
	}
	public String getCityName() {
		return cityName;
	}
	public void setCityName(String cityName) {
		this.cityName = cityName;
	}
	public Integer getLevel() {
		return level;
	}
	public void setLevel(Integer level) {
		this.level = level;
	}
	public Integer getCityType() {
		return cityType;
	}
	public void setCityType(Integer cityType) {
		this.cityType = cityType;
	}
	public Integer getFatherId() {
		return fatherId;
	}
	public void setFatherId(Integer fatherId) {
		this.fatherId = fatherId;
	}
	
}
