package com.govmade.entity.system.information;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;

/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem TODO上传的实体数据文件
* @date 2017年1月13日 下午1:41:20   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: DataFile.java
* @Package com.govmade.entity.system.information
* @version V1.0   
*/
@Alias("DataFile")
public class DataFile extends IdBaseEntity {
	private Integer informationResourceId;//信息资源id
	private String fileName;//文件名
	private String note;//备注
	private String realPath;//文件实际路径
	private String showJson;//预览前几条的json数据
	public Integer getInformationResourceId() {
		return informationResourceId;
	}
	public void setInformationResourceId(Integer informationResourceId) {
		this.informationResourceId = informationResourceId;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public String getRealPath() {
		return realPath;
	}
	public void setRealPath(String realPath) {
		this.realPath = realPath;
	}
	public String getShowJson() {
		return showJson;
	}
	public void setShowJson(String showJson) {
		this.showJson = showJson;
	}
	
}
