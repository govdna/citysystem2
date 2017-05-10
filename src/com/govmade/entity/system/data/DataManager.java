/**   
* @author (作者) Yulei 117815986@qq.com   
* @date 2016年12月8日 下午1:10:51   
* @Title: DataManager.java
* @Package com.govmade.entity.system.data
* @version V1.0   
*/
package com.govmade.entity.system.data;

import com.govmade.entity.base.IdBaseEntity;

/**
 * @author (作者) Yulei 117815986@qq.com
 * @Description: CitySystem TODO
 * @date 2016年12月8日 下午1:10:51
 * @company (开发公司) 国脉海洋信息发展有限公司
 * @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
 * @since (该版本支持的JDK版本) 1.7
 * @Title: DataManager.java
 * @Package com.govmade.entity.system.data
 * @version V1.0
 */
public class DataManager extends IdBaseEntity {
	private String valueCase; // 取值实例
	private String note; // 注解
	private String shortName; // 短名
	private String ranges; // 值域
	private Integer dataType; // 数据类型
	private String egName; // 英文名称
	private String define; // 定义
	private String dataName; // 元素名称
	private Integer cataNumber; // 元数据类型子级 数据字典配置
	private Integer sortManagerId; // 元数据类型父级 数据字典配置
	private String inputType;//输入框类型
	private String inputValue;//输入框取值
	private String required;//是否必填
	private Integer valueNo;//对应信息资源的哪个字段
	private Integer listNo;//排序
	private Integer isShow;
	private Integer searchType;//0 不加入搜索 1 主要搜索 2 次要搜索
	public Integer getIsShow() {
		return isShow;
	}

	public void setIsShow(Integer isShow) {
		this.isShow = isShow;
	}

	public String getValueCase() {
		return valueCase;
	}

	public void setValueCase(String valueCase) {
		this.valueCase = valueCase;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public String getShortName() {
		return shortName;
	}

	public void setShortName(String shortName) {
		this.shortName = shortName;
	}


	public String getRanges() {
		return ranges;
	}

	public void setRanges(String ranges) {
		this.ranges = ranges;
	}

	public Integer getDataType() {
		return dataType;
	}

	public void setDataType(Integer dataType) {
		this.dataType = dataType;
	}

	public String getEgName() {
		return egName;
	}

	public void setEgName(String egName) {
		this.egName = egName;
	}

	public String getDefine() {
		return define;
	}

	public void setDefine(String define) {
		this.define = define;
	}

	public String getDataName() {
		return dataName;
	}

	public void setDataName(String dataName) {
		this.dataName = dataName;
	}

	public Integer getCataNumber() {
		return cataNumber;
	}

	public void setCataNumber(Integer cataNumber) {
		this.cataNumber = cataNumber;
	}

	public Integer getSortManagerId() {
		return sortManagerId;
	}

	public void setSortManagerId(Integer sortManagerId) {
		this.sortManagerId = sortManagerId;
	}

	public String getInputType() {
		return inputType;
	}

	public void setInputType(String inputType) {
		this.inputType = inputType;
	}

	public String getInputValue() {
		return inputValue;
	}

	public void setInputValue(String inputValue) {
		this.inputValue = inputValue;
	}

	public String getRequired() {
		return required;
	}

	public void setRequired(String required) {
		this.required = required;
	}

	public Integer getValueNo() {
		return valueNo;
	}

	public void setValueNo(Integer valueNo) {
		this.valueNo = valueNo;
	}

	public Integer getListNo() {
		return listNo;
	}

	public void setListNo(Integer listNo) {
		this.listNo = listNo;
	}

	public Integer getSearchType() {
		return searchType;
	}

	public void setSearchType(Integer searchType) {
		this.searchType = searchType;
	}


}
