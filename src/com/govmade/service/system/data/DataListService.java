/**   
* @author (作者) Yulei 117815986@qq.com   
* @date 2016年12月8日 下午2:29:48   
* @Title: DataManagerService.java
* @Package com.govmade.service.system.data
* @version V1.0   
*/
package com.govmade.service.system.data;

import java.util.List;
import com.govmade.entity.system.data.DataList;
import com.govmade.service.base.BaseService;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月8日 上午9:49:53   
* @Title: DataListServiceImp.java  
*/
public interface DataListService  extends BaseService<DataList>{

	public void deleteByInformationResId(DataList o);
	public void deleteByHouseModelId(DataList o);
	public void deleteByDataManagerId(DataList o);
	public void deleteByItemSortId(DataList o);
	public void deleteByDataElementId(DataList o);

	public void deleteByCustomizationId(DataList o);
	public void insertList(List<DataList> list);
}
