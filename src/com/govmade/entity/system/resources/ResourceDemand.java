/**   
* @author (作者) Yulei 117815986@qq.com   
* @date 2016年12月8日 下午1:10:51   
* @Title: ResourceDemand.java
* @Package com.govmade.entity.system.resources
* @version V1.0   
*/
package com.govmade.entity.system.resources;

import com.govmade.entity.base.IdBaseEntity;

/**
 * @author (作者) Yulei 117815986@qq.com
 * @Description: CitySystem TODO
 * @date 2016年12月8日 下午1:10:51
 * @company (开发公司) 国脉海洋信息发展有限公司
 * @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
 * @since (该版本支持的JDK版本) 1.7
 * @Title: ResourceDemand.java
 * @Package com.govmade.entity.system.resources
 * @version V1.0
 */
public class ResourceDemand extends IdBaseEntity {
	private static final long serialVersionUID = 1L;
	private String  number;  // '序号',
	private String  resName; // '所需资源名称',
	private String  resDataName;  //具体数据项名称',
	private Integer resCompanyId; // ' 资源所在部门',
	private Integer resGroupId;  //' 资源所在处室',
	private Integer resFormat; // '信息资源格式',
    private String  resPurpose; // '主要用途',
    private Integer updateCycle; //'更新周期',
	private String  remarks; //'备注',
	private String  status; // '状态',
	public String getNumber() {
		return number;
	}
	public void setNumber(String number) {
		this.number = number;
	}
	public String getResName() {
		return resName;
	}
	public void setResName(String resName) {
		this.resName = resName;
	}
	public String getResDataName() {
		return resDataName;
	}
	public void setResDataName(String resDataName) {
		this.resDataName = resDataName;
	}
	public Integer getResCompanyId() {
		return resCompanyId;
	}
	public void setResCompanyId(Integer resCompanyId) {
		this.resCompanyId = resCompanyId;
	}

	public Integer getResGroupId() {
		return resGroupId;
	}
	public void setResGroupId(Integer resGroupId) {
		this.resGroupId = resGroupId;
	}
	public Integer getResFormat() {
		return resFormat;
	}
	public void setResFormat(Integer resFormat) {
		this.resFormat = resFormat;
	}
	public String getResPurpose() {
		return resPurpose;
	}
	public void setResPurpose(String resPurpose) {
		this.resPurpose = resPurpose;
	}
	public Integer getUpdateCycle() {
		return updateCycle;
	}
	public void setUpdateCycle(Integer updateCycle) {
		this.updateCycle = updateCycle;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	
}
