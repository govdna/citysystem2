package com.govmade.entity.system.information;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.base.SimpleFieldsValues;

/**
 * @author (作者) Zhanglu 274059078@qq.com
 * @Description: CitySystem TODO
 * @date 2016年12月8日 上午9:40:29
 * @Title: InformationBusiness.java
 */

@Alias("InformationBusiness")
public class InformationBusiness extends SimpleFieldsValues {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5645806278746049667L;
	private String busNumber;// 业务编码
	private String busName;// 业务名称
	private Integer objectTypes;// 服务对象分类
	private Integer objectContents;// 服务内容
	private String busSystem;// 业务应用系统名称

	public String getBusNumber() {
		return busNumber;
	}

	public void setBusNumber(String busNumber) {
		this.busNumber = busNumber;
	}

	public String getBusName() {
		return busName;
	}

	public void setBusName(String busName) {
		this.busName = busName;
	}

	public Integer getObjectTypes() {
		return objectTypes;
	}

	public void setObjectTypes(Integer objectTypes) {
		this.objectTypes = objectTypes;
	}

	public Integer getObjectContents() {
		return objectContents;
	}

	public void setObjectContents(Integer objectContents) {
		this.objectContents = objectContents;
	}

	public String getBusSystem() {
		return busSystem;
	}

	public void setBusSystem(String busSystem) {
		this.busSystem = busSystem;
	}

}
