package com.govmade.service.system.sort;

import java.util.List;

import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.service.base.BaseService;
import net.sf.json.JSONArray;

/**   
* @author (作者) Chenlei 774329191@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月8日 上午11:08:35   
* @Title: SortManagerService.java  
*/

public interface SortManagerService extends BaseService<SortManager>{

	public JSONArray getJqGridTreeJson(SortManager c); // 生成树json
	
	public List<SortManager> getSortList(SortManager s);
	
	public JSONArray getSearch(SortManager c);
	
	public void delete1(SortManager o);
	
	/**
	 * 物理删除
	 * @param o  对象
	 */
	
	
	public boolean validateName(SortManager sm);
	
	public String importList(List<SortManager> list);

	/**
	 * @param sm1
	 * @return
	 */

}
