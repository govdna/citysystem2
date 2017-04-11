package com.govmade.repository.system.data;

import com.govmade.entity.system.data.DataList;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月8日 上午9:45:01   
* @Title: InformationBusinessDao.java  
*/
@MYBatis
public interface DataListDao extends GovmadeBaseDao<DataList> {
	public void deleteByInformationResId(DataList o);
	public void deleteByHouseModelId(DataList o);
	public void deleteByDataManagerId(DataList o);
	public void deleteByItemSortId(DataList o);

	public void deleteByDataElementId(DataList o);

	public void deleteByCustomizationId(DataList o);
	
}
