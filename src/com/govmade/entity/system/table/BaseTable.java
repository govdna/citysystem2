package com.govmade.entity.system.table;

import java.io.Serializable;
import java.util.List;
import java.util.Set;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;


@Alias("BaseTable")
public class BaseTable extends IdBaseEntity{
	private String field1;
	private String field2;
	private String field3;
	private String field4;
	private String field5;
	private String longField1;
	private String longField2;
	private String longField3;
	private String longField4;
	private String longField5;
	
	
	public String getField1() {
		return field1;
	}
	public void setField1(String field1) {
		this.field1 = field1;
	}
	public String getField2() {
		return field2;
	}
	public void setField2(String field2) {
		this.field2 = field2;
	}
	public String getField3() {
		return field3;
	}
	public void setField3(String field3) {
		this.field3 = field3;
	}
	public String getField4() {
		return field4;
	}
	public void setField4(String field4) {
		this.field4 = field4;
	}
	public String getField5() {
		return field5;
	}
	public void setField5(String field5) {
		this.field5 = field5;
	}
	public String getLongField1() {
		return longField1;
	}
	public void setLongField1(String longField1) {
		this.longField1 = longField1;
	}
	public String getLongField2() {
		return longField2;
	}
	public void setLongField2(String longField2) {
		this.longField2 = longField2;
	}
	public String getLongField3() {
		return longField3;
	}
	public void setLongField3(String longField3) {
		this.longField3 = longField3;
	}
	public String getLongField4() {
		return longField4;
	}
	public void setLongField4(String longField4) {
		this.longField4 = longField4;
	}
	public String getLongField5() {
		return longField5;
	}
	public void setLongField5(String longField5) {
		this.longField5 = longField5;
	}
	
}
