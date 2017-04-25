package com.govmade.entity.system.base;

import com.govmade.entity.base.IdBaseEntity;


/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem TODO自定义字段父类
* @date 2017年1月29日 下午7:45:05   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: CustomField.java
* @Package com.govmade.entity.system.base
* @version V1.0   
*/
public class CustomField extends IdBaseEntity {
	private String name;//字段名字
	private String inputType;//输入框类型
	private String inputValue;//输入框取值
	private String required;//是否必填
	private Integer valueNo;//对应哪个字段
	private Integer listNo;//排序
	private Integer isShow;//是否列表显示字段
	private String titleText;//鼠标浮上去显示文字
	private Integer searchType;//0 不加入搜索 1 主要搜索 2 次要搜索
	
	public Integer getSearchType() {
		return searchType;
	}
	public void setSearchType(Integer searchType) {
		this.searchType = searchType;
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
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getIsShow() {
		return isShow;
	}
	public void setIsShow(Integer isShow) {
		this.isShow = isShow;
	}
	public String getTitleText() {
		return titleText;
	}
	public void setTitleText(String titleText) {
		this.titleText = titleText;
	}
	
}
