package com.govmade.entity.system.tablex;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.system.base.SimpleFieldsValues;


/** 
* @ClassName: GovTable 
* @Description: GovTable PO value1 代码/value2 名称/value3 所属数据库
* @author Dearest
* @date 2016/12/09 13:14
*  
*/
@Alias("GovTable")
public class GovTable  extends SimpleFieldsValues{
	//value1 代码
	//value2 名称
	//value3 所属数据库
	private Integer inforResId;//对应信息资源id
	private List<GovTableField> fieldList;//表下的字段
	
	public void addGovTableField(GovTableField field){
		if(fieldList==null){
			fieldList=new ArrayList<GovTableField>();
		}
		fieldList.add(field);
	}
	public Integer getInforResId() {
		return inforResId;
	}

	public void setInforResId(Integer inforResId) {
		this.inforResId = inforResId;
	}

	public List<GovTableField> getFieldList() {
		return fieldList;
	}

	public void setFieldList(List<GovTableField> fieldList) {
		this.fieldList = fieldList;
	}
}
