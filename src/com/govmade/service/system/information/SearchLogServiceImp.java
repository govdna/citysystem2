package com.govmade.service.system.information;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.SearchLog;
import com.govmade.repository.system.data.DataListDao;
import com.govmade.repository.system.dict.GovmadeDicDAO;
import com.govmade.repository.system.information.ApplicationDao;
import com.govmade.repository.system.information.InformationBusinessDao;
import com.govmade.repository.system.information.InformationResDao;
import com.govmade.repository.system.information.SearchLogDao;
import com.govmade.service.base.GovmadeBaseServiceImp;
import com.govmade.service.system.dict.GovmadeDicService;



/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem TODO
* @date 2017年1月10日 下午4:36:52   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: SearchLogServiceImp.java
* @Package com.govmade.service.system.information
* @version V1.0   
*/
@Service("SearchLogService")
public class SearchLogServiceImp extends GovmadeBaseServiceImp<SearchLog> implements SearchLogService {
	@Autowired
	private SearchLogDao searchLogDao;
	
	@Override
	public void insert(SearchLog o) {
		if(find(o).size()>0){
			update(o);
		}
		super.insert(o);
	}

	@Override
	public List<SearchLog> getHotKeyWord() {
		return searchLogDao.getHotKeyWord();
	}
	
	@Override
	public List<SearchLog> hotres() {
		return searchLogDao.hotres();
	}


}
