package com.govmade.entity.system.catalog;

import org.apache.ibatis.type.Alias;
import com.govmade.entity.base.IdBaseEntity;

/**   
* @author (作者) Chenlei 774329191@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月12日 下午16:55:34   
* @Title: CatalogManager.java  
*/
@Alias("CatalogManager")
public class CatalogManager  extends IdBaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Integer sortManagerId; // 细目编目类型
	
	private Integer cataNumber; // 流水号
	
	private String classValue; // 分类值
	
	private String classCode; // 分类代码
	
	public Integer getSortManagerId() {
		return sortManagerId;
	}

	public void setSortManagerId(Integer sortManagerId) {
		this.sortManagerId = sortManagerId;
	}

	public Integer getCataNumber() {
		return cataNumber;
	}

	public void setCataNumber(Integer cataNumber) {
		this.cataNumber = cataNumber;
	}

	public String getClassValue() {
		return classValue;
	}

	public void setClassValue(String classValue) {
		this.classValue = classValue;
	}

	public String getClassCode() {
		return classCode;
	}

	public void setClassCode(String classCode) {
		this.classCode = classCode;
	}
	
}
