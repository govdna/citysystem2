package com.govmade.common.utils;

import net.sf.json.JSONObject;

public abstract class DataHandler {
	public static final int ADD_MODE=0;
	public static final int REPLACE_MODE=1;
	public static final int DELETE_MODE=2;
	public static final int REPLACE_NEWNAME_MODE=3;//替换并且变更属性名
	public static final int FREEDOM_MODE=4;//自定义模式
	public abstract Object doHandle(Object obj);
	public abstract int getMode();
	public void doHandle(Object bo,JSONObject jo){
		
	}
}
