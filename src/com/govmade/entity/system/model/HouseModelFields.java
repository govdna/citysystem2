package com.govmade.entity.system.model;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.system.base.CustomField;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2017年2月13日 下午2:51:56   
* @Title: HouseModelFields.java  
*/
@Alias("HouseModelFields")
public class HouseModelFields extends CustomField{

	private Integer modelType;	// 1.人口库 2.法人 3.信用 5.证照   其他 
	private String modelName;	// 库名	
	private Integer fatherId;
	private Integer level;
	private Integer isShow;//是否列表显示字段
	private String modelCode; // 代码
	
	public String getModelCode() {
		return modelCode;
	}
	public void setModelCode(String modelCode) {
		this.modelCode = modelCode;
	}
	public Integer getIsShow() {
		return isShow;
	}
	public void setIsShow(Integer isShow) {
		this.isShow = isShow;
	}
	public Integer getFatherId() {
		return fatherId;
	}
	public void setFatherId(Integer fatherId) {
		this.fatherId = fatherId;
	}
	public Integer getLevel() {
		return level;
	}
	public void setLevel(Integer level) {
		this.level = level;
	}
	public Integer getModelType() {
		return modelType;
	}
	public void setModelType(Integer modelType) {
		this.modelType = modelType;
	}
	public String getModelName() {
		return modelName;
	}
	public void setModelName(String modelName) {
		this.modelName = modelName;
	}

}
