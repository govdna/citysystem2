package com.govmade.entity.system.data;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;

/**
 * @author (作者) Zhanglu 274059078@qq.com
 * @Description: CitySystem TODO
 * @date 2016年12月11日 下午1:21:27
 * @Title: DataList.java
 */

@Alias("DataList")
public class DataList extends IdBaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -499579577513258954L;
	private Integer dataElementId;// 一对多数据元ID
	private Integer dataManagerId;// 关联信息资源管理的id
	private Integer informationResId;// 资源架构
	private Integer houseModelId;// 模型库ID
	private Integer itemSortId;
	private String applicationMaterials;
	private Integer isShare;//是否共享 0共享1不共享
	private Integer customizationId;//
	
	public Integer getCustomizationId() {
		return customizationId;
	}

	public void setCustomizationId(Integer customizationId) {
		this.customizationId = customizationId;
	}

	public String getApplicationMaterials() {
		return applicationMaterials;
	}

	public void setApplicationMaterials(String applicationMaterials) {
		this.applicationMaterials = applicationMaterials;
	}

	public Integer getItemSortId() {
		return itemSortId;
	}

	public void setItemSortId(Integer itemSortId) {
		this.itemSortId = itemSortId;
	}

	public Integer getDataElementId() {
		return dataElementId;
	}

	public void setDataElementId(Integer dataElementId) {
		this.dataElementId = dataElementId;
	}

	public Integer getDataManagerId() {
		return dataManagerId;
	}

	public void setDataManagerId(Integer dataManagerId) {
		this.dataManagerId = dataManagerId;
	}

	public Integer getInformationResId() {
		return informationResId;
	}

	public void setInformationResId(Integer informationResId) {
		this.informationResId = informationResId;
	}

	public Integer getHouseModelId() {
		return houseModelId;
	}

	public void setHouseModelId(Integer houseModelId) {
		this.houseModelId = houseModelId;
	}

	public Integer getIsShare() {
		return isShare;
	}

	public void setIsShare(Integer isShare) {
		this.isShare = isShare;
	}

}
