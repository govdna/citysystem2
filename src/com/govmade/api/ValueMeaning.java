package com.govmade.api;

public class ValueMeaning {
private String fieldName;
private String meaning;
public String getFieldName() {
	return fieldName;
}
public void setFieldName(String fieldName) {
	this.fieldName = fieldName;
}
public String getMeaning() {
	return meaning;
}
public void setMeaning(String meaning) {
	this.meaning = meaning;
}
public ValueMeaning(String fieldName, String meaning) {
	super();
	this.fieldName = fieldName;
	this.meaning = meaning;
}

}
