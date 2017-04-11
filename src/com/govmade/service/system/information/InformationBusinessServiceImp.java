package com.govmade.service.system.information;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.repository.system.dict.GovmadeDicDAO;
import com.govmade.repository.system.information.InformationBusinessDao;
import com.govmade.service.base.GovmadeBaseServiceImp;
import com.govmade.service.system.dict.GovmadeDicService;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月8日 上午9:49:53   
* @Title: InformationBusinessServiceImp.java  
*/

@Service("InformationBusinessService")
public class InformationBusinessServiceImp extends GovmadeBaseServiceImp<InformationBusiness> implements InformationBusinessService {

	@Autowired
	private InformationBusinessDao informationBusinessDao;

	@Override
	public void clearColumn(int no) {
		informationBusinessDao.clearColumn(no);
	}

}
