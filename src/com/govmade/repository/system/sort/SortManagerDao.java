package com.govmade.repository.system.sort;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;

/**   
* @author (作者) Chenlei 774329191@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月8日 上午11:06:57   
* @Title: SortManagerDao.java  
*/
@MYBatis
public interface SortManagerDao extends GovmadeBaseDao<SortManager>{
	
	public List<SortManager> getSortList(SortManager sm);

	public  void delete1(SortManager o);
	/**
	 * 更新一个对象
	 * @param o 对象       
	 */
	public List<SortManager> validateName(@Param("param")SortManager sm);
	
	
}
