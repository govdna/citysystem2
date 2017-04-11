package com.govmade.entity.base;

import java.io.Serializable;
import java.util.Date;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;
/**
 * 实体类基础表
 */
public class BaseEntity implements Serializable {
	
	private static final long serialVersionUID = 1L;
	private Integer isDeleted = 0;   
	
	private Date timeModified;

	private Date timeCreate;

	private Integer lastUpdatedDate;

	private Integer createdDate;
	
	public Integer getIsDeleted() {
		return isDeleted;
	}

	public void setIsDeleted(Integer isDeleted) {
		this.isDeleted = isDeleted;
	}

	public Date getTimeModified() {
		return timeModified;
	}

	public void setTimeModified(Date timeModified) {
		this.timeModified = timeModified;
	}

	public Date getTimeCreate() {
		return timeCreate;
	}

	public void setTimeCreate(Date timeCreate) {
		this.timeCreate = timeCreate;
	}

	public Integer getLastUpdatedDate() {
		return lastUpdatedDate;
	}

	public void setLastUpdatedDate(Integer lastUpdatedDate) {
		this.lastUpdatedDate = lastUpdatedDate;
	}

	public Integer getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Integer createdDate) {
		this.createdDate = createdDate;
	}

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this,
				ToStringStyle.MULTI_LINE_STYLE).toString();
	}
}
