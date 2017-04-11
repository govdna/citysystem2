package com.govmade.entity.system.information;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;

/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 资源共享申请表
* @date 2017年1月11日 上午9:01:16   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: Application.java
* @Package com.govmade.entity.system.information
* @version V1.0   
*/
@Alias("Application")
public class Application  extends IdBaseEntity {
	private Integer informationId;//资源id
	private Integer informationCompany;//资源方单位
	private Integer applyCompany;//申请者单位
	private String applyReason;//申请理由
	private String refuseReason;//拒绝理由
	private Integer status;//流程状态 0审核通过 1 待审核 2 审核不通过
	public Integer getInformationCompany() {
		return informationCompany;
	}
	public void setInformationCompany(Integer informationCompany) {
		this.informationCompany = informationCompany;
	}
	public Integer getApplyCompany() {
		return applyCompany;
	}
	public void setApplyCompany(Integer applyCompany) {
		this.applyCompany = applyCompany;
	}
	public String getApplyReason() {
		return applyReason;
	}
	public void setApplyReason(String applyReason) {
		this.applyReason = applyReason;
	}
	public String getRefuseReason() {
		return refuseReason;
	}
	public void setRefuseReason(String refuseReason) {
		this.refuseReason = refuseReason;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public Integer getInformationId() {
		return informationId;
	}
	public void setInformationId(Integer informationId) {
		this.informationId = informationId;
	}
	
}
