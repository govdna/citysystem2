package com.govmade.service.system.information;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.Application;
import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.SearchLog;
import com.govmade.repository.system.data.DataListDao;
import com.govmade.repository.system.dict.GovmadeDicDAO;
import com.govmade.repository.system.information.ApplicationDao;
import com.govmade.repository.system.information.InformationBusinessDao;
import com.govmade.repository.system.information.InformationResDao;
import com.govmade.repository.system.information.InformationResourceDao;
import com.govmade.service.base.GovmadeBaseServiceImp;
import com.govmade.service.system.dict.GovmadeDicService;




/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem TODO
* @date 2017年1月11日 上午9:08:17   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: ApplicationServiceImp.java
* @Package com.govmade.service.system.information
* @version V1.0   
*/
@Service("ApplicationService")
public class ApplicationServiceImp extends GovmadeBaseServiceImp<Application> implements ApplicationService {
	@Autowired
	private ApplicationDao applicationDao;
	
	@Override
	public void updateStatus(Application app) {
		applicationDao.updateStatus(app);
	}


}
