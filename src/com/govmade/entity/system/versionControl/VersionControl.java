package com.govmade.entity.system.versionControl;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;

/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan 版本控制
* @date 2017年3月6日 下午1:36:42   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: VersionControl.java
* @Package com.govmade.entity.system.versionControl
* @version V1.0   
*/
@Alias("VersionControl")
public class VersionControl extends IdBaseEntity{
	private Integer sourceId;//对应的记录id
	private String newVersion;//新版本object json
	private String actionType;//操作类型 create update remove 
	private Integer accountId;//操作帐号
	private String className;//类
	public Integer getSourceId() {
		return sourceId;
	}
	public void setSourceId(Integer sourceId) {
		this.sourceId = sourceId;
	}
	public String getNewVersion() {
		return newVersion;
	}
	public void setNewVersion(String newVersion) {
		this.newVersion = newVersion;
	}
	public String getClassName() {
		return className;
	}
	public void setClassName(String className) {
		this.className = className;
	}
	public String getActionType() {
		return actionType;
	}
	public void setActionType(String actionType) {
		this.actionType = actionType;
	}
	public Integer getAccountId() {
		return accountId;
	}
	public void setAccountId(Integer accountId) {
		this.accountId = accountId;
	}

	
}
