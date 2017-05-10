package com.govmade.common.utils.poi;

import java.util.ArrayList;
import java.util.List;

import org.apache.poi.ss.usermodel.Sheet;


/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan 将entity导出excel 带合并单元格
* @date 2017年3月17日 上午9:17:40   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: Object2ExcelAdapter.java
* @Package com.govmade.common.utils.poi
* @version V1.0   
*/
public abstract class Object2ExcelComplexAdapter<T>{
	private List<T> list;
	public Object2ExcelComplexAdapter(List<T> list) {
		super();
		this.setList(list);
	}
	public abstract String [] getTitle();
	
	public abstract List<String[]> object2List(T t);
	public abstract void doAfterEveryTime(List<String[]> list,Sheet sheet,int startRow,int endRow);
	public List<T> getList() {
		return list;
	}
	public void setList(List<T> list) {
		this.list = list;
	}
	
}
