package com.govmade.service.system.information;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.DataFile;
import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.SearchLog;
import com.govmade.entity.system.information.Subscribe;
import com.govmade.repository.system.data.DataListDao;
import com.govmade.repository.system.dict.GovmadeDicDAO;
import com.govmade.repository.system.information.ApplicationDao;
import com.govmade.repository.system.information.DataFileDao;
import com.govmade.repository.system.information.InformationBusinessDao;
import com.govmade.repository.system.information.InformationResDao;
import com.govmade.repository.system.information.SearchLogDao;
import com.govmade.repository.system.information.SubscribeDao;
import com.govmade.service.base.GovmadeBaseServiceImp;
import com.govmade.service.system.dict.GovmadeDicService;





/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 信息资源订阅
* @date 2017年1月18日 下午1:57:34   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: SubscribeServiceImp.java
* @Package com.govmade.service.system.information
* @version V1.0   
*/
@Service("SubscribeService")
public class SubscribeServiceImp extends GovmadeBaseServiceImp<Subscribe> implements SubscribeService {
	@Autowired
	private SubscribeDao subscribeDao;
	
}
