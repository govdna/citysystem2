package com.govmade.common.utils.poi;

import java.util.ArrayList;
import java.util.List;

/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem entity与excel每行数据适配器
* @date 2017年1月2日 下午11:37:15   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: ExcelAdapter.java
* @Package com.govmade.common.utils.poi
* @version V1.0   
*/
public abstract class ExcelAdapter<T>{
	private List<T> list;
	private StringBuffer errorMsg=new StringBuffer();
	private boolean isError=false;
	//获得列数
	/** 
	* @Title: getClumnSize 
	* @Description: TODO(每一行的列数) 
	* @param @return    设定文件 
	* @return int    返回类型 
	* 2017年1月2日    日期   
	*/ 
	public abstract int getClumnSize();
	public abstract int getStartRow();
	public List<T> getEntityList(){
		return list;
	}
	public void buildList(String [] clumns,int rowNum){
		if(list==null){
			list=new ArrayList<T>();
		}
		T t=doWithRowData(clumns,rowNum);
		if(t!=null){
			list.add(t);
		}
	}
	/** 
	* @Title: doWithRowData 
	* @Description: TODO(处理每行的数据) 
	* @param @param clumns    设定文件 
	* @return void    返回类型 
	* 2017年1月2日    日期   
	*/ 
	public abstract T doWithRowData(String [] clumns,int rowNum);

	public void appendMsg(String msg){
		errorMsg.append(msg);
	}
	
	public StringBuffer getErrorMsg() {
		return errorMsg;
	}
	public boolean isError() {
		return isError;
	}
	public void setError(boolean isError) {
		this.isError = isError;
	}
	

}
