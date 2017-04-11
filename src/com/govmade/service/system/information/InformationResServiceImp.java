package com.govmade.service.system.information;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.repository.system.data.DataListDao;
import com.govmade.repository.system.dict.GovmadeDicDAO;
import com.govmade.repository.system.information.InformationBusinessDao;
import com.govmade.repository.system.information.InformationResDao;
import com.govmade.service.base.GovmadeBaseServiceImp;
import com.govmade.service.system.dict.GovmadeDicService;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月8日 上午9:49:53   
* @Title: InformationResServiceImp.java  
*/

@Service("InformationResService")
public class InformationResServiceImp extends GovmadeBaseServiceImp<InformationRes> implements InformationResService {

	@Autowired
	private InformationResDao informationResDao;
	@Autowired
	private DataListDao dataListDao;
	
	@Override
	public void delete(InformationRes  o){
		baseDao.delete(o);
		DataList d=new DataList();
		d.setInformationResId(o.getId());
		dataListDao.deleteByInformationResId(d);
	}
	
	@Override
	public String getMaxCode(InformationRes o) {
		return informationResDao.getMaxCode(o);
	}

	@Override
	public List<InformationRes> getInformationResByLog(Integer accountId) {
		return informationResDao.getInformationResByLog(accountId);
	}

	@Override
	public void truncateTable() {
		 informationResDao.truncateTable();
	}

	@Override
	public void clearColumn(int no) {
		informationResDao.clearColumn(no);
	}

	@Override
	public Map<Integer, Integer> countInforTypes(InformationRes info) {
		List<InformationRes> list2=informationResDao.countInforTypes2(info);
		List<InformationRes> list3=informationResDao.countInforTypes3(info);
		Map<Integer, Integer> map=new HashMap<Integer, Integer>();
		for(InformationRes inf:list2){
			map.put(inf.getInforTypes2(), inf.getBusinessId());
		}
		for(InformationRes inf:list3){
			map.put(inf.getInforTypes3(), inf.getBusinessId());
		}
		return map;
	}

	@Override
	public Map<String, Integer> countValue2(InformationRes info) {
		List<InformationRes> list2=informationResDao.countValue2(info);
		Map<String, Integer> map=new HashMap<String, Integer>();
		for(InformationRes inf:list2){
			map.put(inf.getValue2(), inf.getBusinessId());
		}
		return map;
	}

}
