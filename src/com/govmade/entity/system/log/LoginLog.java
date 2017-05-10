package com.govmade.entity.system.log;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.BaseEntity;
import com.govmade.entity.base.IdBaseEntity;
@Alias("LoginLog")
public class LoginLog extends IdBaseEntity{

	private static final long serialVersionUID = 1L;
	
//	private String id;
	
	private String accountId;//登录ID
	
	private String loginIP;//登录IP
	
	private Date loginTime;//登录时间

	private String logName;//登录名
	
	private String msg;//登录说明
	
	//查询时关联字段
	private String endTime;
	
	private String keyWord;	
	
	private String beginTime;
	
	private String aName;
	
	public String getLogName() {
		return logName;
	}

	public void setLogName(String logName) {
		this.logName = logName;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public LoginLog(){}
	
	public LoginLog(String accountId, String logName, String loginIP,String msg) {
		super();
		this.accountId = accountId;
		this.logName = logName;
		this.loginIP = loginIP;
		this.msg = msg;
	}

//	public String getId() {
//		return id;
//	}
//
//	public void setId(String id) {
//		this.id = id;
//	}

	public String getAccountId() {
		return accountId;
	}

	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}

	public String getLoginIP() {
		return loginIP;
	}

	public void setLoginIP(String loginIP) {
		this.loginIP = loginIP;
	}

	public Date getLoginTime() {
		return loginTime;
	}

	public void setLoginTime(Date loginTime) {
		this.loginTime = loginTime;
	}

	public String getaName() {
		return aName;
	}

	public void setaName(String aName) {
		this.aName = aName;
	}

	public String getKeyWord() {
		return keyWord;
	}

	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}

	public String getBeginTime() {
		return beginTime;
	}

	public void setBeginTime(String beginTime) {
		this.beginTime = beginTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}



}
