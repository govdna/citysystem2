package com.govmade.entity.base;

import java.io.Serializable;
import java.util.Date;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;
/**
 * 实体类基础表
 */
public class IdBaseEntity extends BaseEntity {
	/**   
	* @Title: IdBaseEntity.java 
	* @Package com.govmade.entity.base 
	* @Description: TODO(用一句话描述该文件做什么) 
	* @author Yulei 117815986@qq.com  
	* @date 2016年12月29日 下午1:20:08 
	* @version V1.0   
	*/
	private static final long serialVersionUID = 1L;
	private Integer id;
	private Integer companyId;//政府机构ID
	
	private Integer groupId;//所属部门ID
	
	
	public Integer getCompanyId() {
		return companyId;
	}

	public void setCompanyId(Integer companyId) {
		this.companyId = companyId;
	}

	public Integer getGroupId() {
		return groupId;
	}

	public void setGroupId(Integer groupId) {
		this.groupId = groupId;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	
}
