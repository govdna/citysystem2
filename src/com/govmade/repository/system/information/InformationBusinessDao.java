package com.govmade.repository.system.information;

import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;
import com.govmade.service.base.CanSimpleFields;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月8日 上午9:45:01   
* @Title: InformationBusinessDao.java  
*/
@MYBatis
public interface InformationBusinessDao extends GovmadeBaseDao<InformationBusiness>,CanSimpleFields {

}
