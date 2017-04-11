
package com.govmade.entity.system.sort;

import java.io.Serializable;
import java.util.List;
import java.util.Set;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;

/**   
* @author (作者) Chenlei 774329191@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月8日 上午11:03:23   
* @Title: SortManager.java  
*/
@Alias("SortManager")
public class SortManager extends IdBaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String sortCode; // 代码
	
	private String sortName; // 名称
	
	private Integer level; // 有上下级关系   层级
	
	private Integer sortId; // 父级ID
	
	private String fatherCode;//父级代码
	
	private Integer type; // 适用类型
	
	private Integer belong; // 属于哪个部分

	private List<SortManager> childrens;//子集
	
	public Integer getBelong() {
		return belong;
	}

	public void setBelong(Integer belong) {
		this.belong = belong;
	}

	public SortManager() {
		super();
	}

	public SortManager(Integer id) {
		super();
		setId(id);
	}
	
	public String getSortCode() {
		return sortCode;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public void setSortCode(String sortCode) {
		this.sortCode = sortCode;
	}

	public String getSortName() {
		return sortName;
	}

	public void setSortName(String sortName) {
		this.sortName = sortName;
	}

	public Integer getLevel() {
		return level;
	}

	public void setLevel(Integer level) {
		this.level = level;
	}

	public Integer getSortId() {
		return sortId;
	}

	public void setSortId(Integer sortId) {
		this.sortId = sortId;
	}

	public String getFatherCode() {
		return fatherCode;
	}

	public void setFatherCode(String fatherCode) {
		this.fatherCode = fatherCode;
	}

	public List<SortManager> getChildrens() {
		return childrens;
	}

	public void setChildrens(List<SortManager> childrens) {
		this.childrens = childrens;
	}
	
}
