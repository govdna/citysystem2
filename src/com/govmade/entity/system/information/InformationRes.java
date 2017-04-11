package com.govmade.entity.system.information;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.type.Alias;

import com.govmade.common.utils.StringUtil;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.base.SimpleFieldsValues;

/**
 * @author (作者) Zhanglu 274059078@qq.com
 * @Description: CitySystem TODO
 * @date 2016年12月8日 下午1:21:27
 * @Title: InformationRes.java
 */

@Alias("InformationRes")
public class InformationRes extends SimpleFieldsValues {


	/**
	 * 
	 */
	private static final long serialVersionUID = -45640943760472480L;
	private String inforName;// 信息资源名称
	private String inforCode;// 信息资源代码
	private String inforTypes;// 信息资源分类
	private String inforProvider;// 信息资源提供方
	private String inforRemark;// 信息资源摘要
	private String dataElementId;// 服务对象分类  一对多元数据
	private Integer businessId;// 关联业务名称
	private Integer inforTypes2;
	private Integer inforTypes3;
	private Integer inforTypes4;

	public Integer getInforTypes2() {
		return inforTypes2;
	}

	public void setInforTypes2(Integer inforTypes2) {
		this.inforTypes2 = inforTypes2;
	}

	public Integer getInforTypes3() {
		return inforTypes3;
	}

	public void setInforTypes3(Integer inforTypes3) {
		this.inforTypes3 = inforTypes3;
	}

	public Integer getInforTypes4() {
		return inforTypes4;
	}

	public void setInforTypes4(Integer inforTypes4) {
		this.inforTypes4 = inforTypes4;
	}

	public String getInforName() {
		if(StringUtils.isEmpty(inforName)){
			return getValue1();
		}
		return inforName;
	}

	public void setInforName(String inforName) {
		this.inforName = inforName;
	}

	public String getInforCode() {
		return inforCode;
	}

	public void setInforCode(String inforCode) {
		this.inforCode = inforCode;
	}

	public String getInforTypes() {
		return inforTypes;
	}

	public void setInforTypes(String inforTypes) {
		this.inforTypes = inforTypes;
	}

	public String getInforProvider() {
		return inforProvider;
	}

	public void setInforProvider(String inforProvider) {
		this.inforProvider = inforProvider;
	}

	public String getInforRemark() {
		return inforRemark;
	}

	public void setInforRemark(String inforRemark) {
		this.inforRemark = inforRemark;
	}

	public String getDataElementId() {
		return StringUtil.toSQLArray(dataElementId);
	}

	public void setDataElementId(String dataElementId) {
		this.dataElementId = StringUtil.toSQLStr(dataElementId);
	}

	public Integer getBusinessId() {
		return businessId;
	}

	public void setBusinessId(Integer businessId) {
		this.businessId = businessId;
	}

	
}
