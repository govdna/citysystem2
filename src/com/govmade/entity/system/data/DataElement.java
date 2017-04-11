package com.govmade.entity.system.data;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.type.Alias;

import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.entity.base.IdBaseEntity;

/**   
* @author (作者) Chenlei 774329191@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月7日 上午8:55:34   
* @Title: DataElement.java  
*/
@Alias("DataElement")
public class DataElement  extends IdBaseEntity implements Cloneable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String identifier; // 内部标识符
	
	private String chName; // 中文名称
	
	private String egName; // 英文名称
	
	private String define; // 定义
	
	private Integer dataType; // 数据类型
	
	private String dataFormat; // 数据格式
	
	private Integer objectType; // 对象类型
	
	private String dataElementId; // 同意名称
	
	private Integer counts;//数据统计

	
	//private Integer companyId; // 公司	
	//private Integer groupId; // 部门
	

	/**
     * 类型
     * 表字段 : gov_rdata_element.type
     */
    private Integer type; // 1：自定义；2：来源模板

    
    //使用中属性----
    
    private Integer isShare;//是否共享 0共享1不共享
    
    /**
     * 原因
     * 表字段 : gov_rdata_element.reason
     */
    private String reason;

    /**
     * 状态
     * 表字段 : gov_rdata_element.status
     */
    private Integer status; // 0:审核通过数据元管理可看到数据；1、提出模板审核；2、自定义审核；3、拒绝加入；5、提出撤回；4、撤回成功；
                            //  6、数据元添加数据默认值供数据元管理里面模板选择使用管理
	
	
	private String notes;// 备注
	
	private Integer systemType; // 1 公共数据元
	private Integer classType;//判断数据元可看到数据 1:数据元可看到数据（资源架构）； 2来自自定义还没有进入到资源架构; 3、资源架构删除资源管理模板不出现
	//0为模版中的数据元 1为管理中的数据元
	
	private Integer imported;//是否被导入 1表示已导入
	
	private Integer sourceId;//由模版中的哪个数据元导入
	
	private Integer fatherId;//父数据元Id
	private Integer sourceType=0;//来源 0新增1模版导入2excel导入3表生成4数据库导入
	
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
	
	
    public Integer getSystemType() {
		return systemType;
	}

	public void setSystemType(Integer systemType) {
		this.systemType = systemType;
	}

	public Integer getImported() {
		return imported;
	}

	public void setImported(Integer imported) {
		this.imported = imported;
	}

	public Integer getSourceId() {
		return sourceId;
	}

	public void setSourceId(Integer sourceId) {
		this.sourceId = sourceId;
	}

	public Integer getFatherId() {
		return fatherId;
	}

	public void setFatherId(Integer fatherId) {
		this.fatherId = fatherId;
	}

	public Integer getCounts() {
		return counts;
	}

	public void setCounts(Integer counts) {
		this.counts = counts;
	}

	public String getDataElementId() {
		return dataElementId;
	}

	public void setDataElementId(String dataElementId) {
		this.dataElementId = StringUtil.toSQLArray(dataElementId);;
	}
	
	public String getNotes() {
		if(StringUtils.isEmpty(notes)){
			return value6;
		}
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public Integer getClassType() {
		return classType;
	}

	public void setClassType(Integer classType) {
		this.classType = classType;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
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

	public String getIdentifier() {
		return identifier;
	}

	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}

	public String getChName() {
		if(StringUtils.isEmpty(chName)){
			return value1;
		}
		return chName;
	}

	public void setChName(String chName) {
		this.chName = chName;
	}

	public String getEgName() {
		if(StringUtils.isEmpty(egName)){
			return value2;
		}
		return egName;
	}

	public void setEgName(String egName) {
		this.egName = egName;
	}

	public String getDefine() {
		if(StringUtils.isEmpty(define)){
			return value3;
		}
		return define;
	}

	public void setDefine(String define) {
		this.define = define;
	}

	public Integer getDataType() {
		if(dataType==null&&StringUtils.isNumeric(value4)){
			return Integer.valueOf(value4);
		}
		return dataType;
	}

	public void setDataType(Integer dataType) {
		this.dataType = dataType;
	}

	public String getDataFormat() {
		if(StringUtils.isEmpty(dataFormat)){
			return value7;
		}
		return dataFormat;
	}

	public void setDataFormat(String dataFormat) {
		this.dataFormat = dataFormat;
	}

	public Integer getObjectType() {
		if(objectType==null&&StringUtils.isNumeric(value5)){
			return Integer.valueOf(value5);
		}
		return objectType;
	}

	public void setObjectType(Integer objectType) {
		this.objectType = objectType;
	}

	public Integer getIsShare() {
		return isShare;
	}

	public void setIsShare(Integer isShare) {
		this.isShare = isShare;
	}

	public String getValue1() {
		if(StringUtils.isEmpty(value1)){
			return chName;
		}
		return value1;
	}

	public void setValue1(String value1) {
		this.value1 = value1;
	}

	public String getValue2() {
		if(StringUtils.isEmpty(value2)){
			return egName;
		}
		return value2;
	}

	public void setValue2(String value2) {
		this.value2 = value2;
	}

	public String getValue3() {
		if(StringUtils.isEmpty(value3)){
			return define;
		}
		return value3;
	}

	public void setValue3(String value3) {
		this.value3 = value3;
	}

	public String getValue4() {
		if(StringUtils.isEmpty(value4)&&dataType!=null){
			return dataType+"";
		}
		return value4;
	}

	public void setValue4(String value4) {
		this.value4 = value4;
	}

	public String getValue5() {
		if(StringUtils.isEmpty(value5)&&objectType!=null){
			return objectType+"";
		}
		return value5;
	}

	public void setValue5(String value5) {
		this.value5 = value5;
	}

	public String getValue6() {
		if(StringUtils.isEmpty(value6)){
			return notes;
		}
		return value6;
	}

	public void setValue6(String value6) {
		this.value6 = value6;
	}

	public String getValue7() {
		if(StringUtils.isEmpty(value7)){
			return dataFormat;
		}
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

	public String getValueByNo(int no){
		if(no>0&&no<=30){
			return (String) ObjectUtil.getFieldValueByName("value"+no, this);
		}
		return null;
	}
	
	public Object clone() throws CloneNotSupportedException {
	      return super.clone();
	}

	public Integer getSourceType() {
		return sourceType;
	}

	public void setSourceType(Integer sourceType) {
		this.sourceType = sourceType;
	}
}
