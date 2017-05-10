package com.govmade.entity.system.information;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.type.Alias;

import com.govmade.common.utils.ObjectUtil;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.data.DataElement;

/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 资源管理下的信息资源
* @date 2016年12月22日 上午8:43:47   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: InformationResource.java
* @Package com.govmade.entity.system.information
* @version V1.0   
*/
@Alias("InformationResource")
public class InformationResource extends IdBaseEntity{
	private String value1;//字段值
	private String value2;
	private String value3;
	private String value4;
	private String value5;
	private String value6;
	private String value7;
	private String value8;
	private String value9;
	private String value10;
	private String value11;
	private String value12;
	private String value13;
	private String value14;
	private String value15;
	private String value16;
	private String value17;
	private String value18;
	private String value19;
	private String value20;
	private String value21;
	private String value22;
	private String value23;
	private String value24;
	private String value25;
	private String value26;
	private String value27;
	private String value28;
	private String value29;
	private String value30;
	private Integer inforTypes;
	private Integer inforTypes2;
	private Integer inforTypes3;
	private Integer inforTypes4;
	private Integer binforTypes;
	private Integer binforTypes2;
	private Integer binforTypes3;
	private Integer binforTypes4;
	
	private String dataElementId;// 一对多数据元
	private String reason;//审核不通过理由
   /* 0、审核通过，已发布
	1、待审核 （可撤回）
	2、审核不通过 （可修改，删除）
	3、撤回成功 （可修改，删除）
	4、注销待审核
	5、已注销'*/
	private Integer status; 
	private Integer sourceType=0;//来源 0新增1模版导入2excel导入3表生成4数据库导入
	private List<DataElement> dataElementList;
	   
	public Integer getBinforTypes() {
		return binforTypes;
	}
	public void setBinforTypes(Integer binforTypes) {
		this.binforTypes = binforTypes;
	}
	public Integer getBinforTypes2() {
		return binforTypes2;
	}
	public void setBinforTypes2(Integer binforTypes2) {
		this.binforTypes2 = binforTypes2;
	}
	public Integer getBinforTypes3() {
		return binforTypes3;
	}
	public void setBinforTypes3(Integer binforTypes3) {
		this.binforTypes3 = binforTypes3;
	}
	public Integer getBinforTypes4() {
		return binforTypes4;
	}
	public void setBinforTypes4(Integer binforTypes4) {
		this.binforTypes4 = binforTypes4;
	}
	public String getValue1() {
		return value1;
	}
	public void setValue1(String value1) {
		this.value1 = value1;
	}
	public String getValue2() {
		return value2;
	}
	public void setValue2(String value2) {
		this.value2 = value2;
	}
	public String getValue3() {
		return value3;
	}
	public void setValue3(String value3) {
		this.value3 = value3;
	}
	public String getValue4() {
		return value4;
	}
	public void setValue4(String value4) {
		this.value4 = value4;
	}
	public String getValue5() {
		return value5;
	}
	public void setValue5(String value5) {
		this.value5 = value5;
	}
	public String getValue6() {
		return value6;
	}
	public void setValue6(String value6) {
		this.value6 = value6;
	}
	public String getValue7() {
		return value7;
	}
	public void setValue7(String value7) {
		this.value7 = value7;
	}
	public String getValue8() {
		return value8;
	}
	public void setValue8(String value8) {
		this.value8 = value8;
	}
	public String getValue9() {
		return value9;
	}
	public void setValue9(String value9) {
		this.value9 = value9;
	}
	public String getValue10() {
		return value10;
	}
	public void setValue10(String value10) {
		this.value10 = value10;
	}
	public String getValue11() {
		return value11;
	}
	public void setValue11(String value11) {
		this.value11 = value11;
	}
	public String getValue12() {
		return value12;
	}
	public void setValue12(String value12) {
		this.value12 = value12;
	}
	public String getValue13() {
		return value13;
	}
	public void setValue13(String value13) {
		this.value13 = value13;
	}
	public String getValue14() {
		return value14;
	}
	public void setValue14(String value14) {
		this.value14 = value14;
	}
	public String getValue15() {
		return value15;
	}
	public void setValue15(String value15) {
		this.value15 = value15;
	}
	public String getValue16() {
		return value16;
	}
	public void setValue16(String value16) {
		this.value16 = value16;
	}
	public String getValue17() {
		return value17;
	}
	public void setValue17(String value17) {
		this.value17 = value17;
	}
	public String getValue18() {
		return value18;
	}
	public void setValue18(String value18) {
		this.value18 = value18;
	}
	public String getValue19() {
		return value19;
	}
	public void setValue19(String value19) {
		this.value19 = value19;
	}
	public String getValue20() {
		return value20;
	}
	public void setValue20(String value20) {
		this.value20 = value20;
	}
	public String getValue21() {
		return value21;
	}
	public void setValue21(String value21) {
		this.value21 = value21;
	}
	public String getValue22() {
		return value22;
	}
	public void setValue22(String value22) {
		this.value22 = value22;
	}
	public String getValue23() {
		return value23;
	}
	public void setValue23(String value23) {
		this.value23 = value23;
	}
	public String getValue24() {
		return value24;
	}
	public void setValue24(String value24) {
		this.value24 = value24;
	}
	public String getValue25() {
		return value25;
	}
	public void setValue25(String value25) {
		this.value25 = value25;
	}
	public String getValue26() {
		return value26;
	}
	public void setValue26(String value26) {
		this.value26 = value26;
	}
	public String getValue27() {
		return value27;
	}
	public void setValue27(String value27) {
		this.value27 = value27;
	}
	public String getValue28() {
		return value28;
	}
	public void setValue28(String value28) {
		this.value28 = value28;
	}
	public String getValue29() {
		return value29;
	}
	public void setValue29(String value29) {
		this.value29 = value29;
	}
	public String getValue30() {
		return value30;
	}
	public void setValue30(String value30) {
		this.value30 = value30;
	}
	public String getDataElementId() {
		return dataElementId;
	}
	public void setDataElementId(String dataElementId) {
		this.dataElementId = dataElementId;
	}
	public String getReason() {
		return reason;
	}
	public void setReason(String reason) {
		this.reason = reason;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public Integer getInforTypes() {
		return inforTypes;
	}
	public void setInforTypes(Integer inforTypes) {
		this.inforTypes = inforTypes;
	}
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
	
	public String getValueByNo(int no){
		if(no>0&&no<=30){
			return (String) ObjectUtil.getFieldValueByName("value"+no, this);
		}
		return null;
	}
	
	public boolean equals(InformationResource obj,int no) {
		if(StringUtils.isEmpty(this.getValueByNo(no))&&StringUtils.isEmpty(obj.getValueByNo(no))){
			return true;
		}
		return this.getValueByNo(no).equals(obj.getValueByNo(no));
	}
	public List<DataElement> getDataElementList() {
		return dataElementList;
	}
	public void setDataElementList(List<DataElement> dataElementList) {
		this.dataElementList = dataElementList;
	}
	public Integer getSourceType() {
		return sourceType;
	}
	public void setSourceType(Integer sourceType) {
		this.sourceType = sourceType;
	}
	
	
}
