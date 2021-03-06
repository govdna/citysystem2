/*
 * WARNING: DO NOT EDIT THIS FILE. This is a generated file that is synchronized
 * by MyEclipse Hibernate tool integration.
 *
 * Created Fri Aug 11 16:05:30 CST 2006 by MyEclipse Hibernate Tool.
 */
package com.govmade.entity.system.rbac;

import java.io.Serializable;
import java.util.List;
import java.util.Set;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;

/** 
* @ClassName: Permission 
* @Description: TODO(权限) 
* @author Dongjie 154046519@qq.com 
* @date 2016年11月2日 下午1:39:43 
*  
*/
@Alias("Permission")
public class Permission extends IdBaseEntity{

	private static final long serialVersionUID = -6018699681193635264L;
	public final static Integer MENU = 0;
	public final static Integer PERMISSION = 1;
	public final static Integer RESOURCES = 2;
	public final static Integer URL = 3;
	public final static Integer LABEL = 4;
	public final static Integer MENUTYPE_MANAGE = 0;//后台管理菜单
	public final static Integer MENUTYPE_STAGE = 1;//桌面菜单
	public final static Integer OPENMETHOD_IFRAME = 0;//用iframe打开
	public final static Integer OPENMETHOD_WINDOW = 1;//用layer UI打开
	private Integer type;// 类型MENU、PERMISSION、RESOURCES、URL
	private Integer menuType;//菜单属于哪个模块
	private Integer openMethod;//url打开方式 仅针对桌面菜单
	private String code;
	private String parentCode;
	private String nodeName;
	private String note;
	private Integer parent;
	private Integer level;
	private String url;
	private String icon;
	private Integer listNo;
	private String validity;
	private List<Scope> scopes;
	private List<Permission> children;
	private Integer isChecked;
	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getNodeName() {
		return nodeName;
	}

	public void setNodeName(String nodeName) {
		this.nodeName = nodeName;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public Integer getParent() {
		return parent;
	}

	public void setParent(Integer parent) {
		this.parent = parent;
	}

	public Integer getLevel() {
		return level;
	}

	public void setLevel(Integer level) {
		this.level = level;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}

	public Integer getListNo() {
		return listNo;
	}

	public void setListNo(Integer listNo) {
		this.listNo = listNo;
	}

	public String getValidity() {
		return validity;
	}

	public void setValidity(String validity) {
		this.validity = validity;
	}

	

	public String getParentCode() {
		return parentCode;
	}

	public void setParentCode(String parentCode) {
		this.parentCode = parentCode;
	}

	public List<Scope> getScopes() {
		return scopes;
	}

	public void setScopes(List<Scope> scopes) {
		this.scopes = scopes;
	}

	public Integer getIsSelected() {
		return isChecked;
	}

	public void setIsSelected(Integer isSelected) {
		this.isChecked = isSelected;
	}

	public Integer getIsChecked() {
		return isChecked;
	}

	public void setIsChecked(Integer isChecked) {
		this.isChecked = isChecked;
	}

	public List<Permission> getChildren() {
		return children;
	}

	public void setChildren(List<Permission> children) {
		this.children = children;
	}

	public Integer getMenuType() {
		return menuType;
	}

	public void setMenuType(Integer menuType) {
		this.menuType = menuType;
	}

	public Integer getOpenMethod() {
		return openMethod;
	}

	public void setOpenMethod(Integer openMethod) {
		this.openMethod = openMethod;
	}

	

}
