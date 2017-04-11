package com.govmade.repository.system.model;

import com.govmade.entity.system.model.HouseModelFields;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2017年2月14日 上午11:16:18   
* @Title: HouseModelFieldsDao.java  
*/
@MYBatis
public interface HouseModelFieldsDao extends GovmadeBaseDao<HouseModelFields> {

	public void deleteByFatherId(HouseModelFields o);

}
