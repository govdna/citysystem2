/*
 * WARNING: DO NOT EDIT THIS FILE. This is a generated file that is synchronized
 * by MyEclipse Hibernate tool integration.
 *
 * Created Fri Aug 11 16:05:30 CST 2006 by MyEclipse Hibernate Tool.
 */
package com.govmade.entity.system.rbac;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;

/** 
* @ClassName: Role 
* @Description: TODO(角色) 
* @author Dongjie 154046519@qq.com 
* @date 2016年11月2日 下午1:39:31 
*  
*/
@Alias("Role")
public class Role extends IdBaseEntity {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 3568816715795600732L;

	private String name;

	private String note;

	private String validity;

	private List<Permission> permissions;
	
	public List<Permission> getPermissions() {
		return permissions;
	}

	public void setPermissions(List<Permission> permissions) {
		this.permissions = permissions;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public String getValidity() {
		return validity;
	}

	public void setValidity(String validity) {
		this.validity = validity;
	}
	
}
