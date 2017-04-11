package com.govmade.service.system.model;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.model.HouseModel;
import com.govmade.repository.system.data.DataListDao;
import com.govmade.repository.system.model.HouseModelDao;
import com.govmade.service.base.GovmadeBaseServiceImp;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月8日 上午9:49:53   
* @Title: HouseModleServiceImp.java  
*/

@Service("HouseModleService")
public class HouseModelServiceImp extends GovmadeBaseServiceImp<HouseModel> implements HouseModelService {

	@Autowired
	private HouseModelDao houseModleDao;
	@Autowired
	private DataListDao dataListDao;
	
	public List<HouseModel> popTreeFirst(){
		return houseModleDao.popTreeFirst();
	}
	public List<HouseModel> popTreeSecond(){
		return houseModleDao.popTreeSecond();
	}
	
	public List<HouseModel> legalTree(){
		return houseModleDao.legalTree();
	}
	
	public List<HouseModel> creditTree(){
		return houseModleDao.creditTree();
	}
	
	public List<HouseModel> licenceTree(){
		return houseModleDao.licenceTree();
	}
	
	public List<HouseModel> customTree(Integer houseTypes){
		return houseModleDao.customTree(houseTypes);
	}
	
	@Override
	public void delete(HouseModel o) {
		baseDao.delete(o);
		DataList d=new DataList();
		d.setHouseModelId(o.getId());
		dataListDao.deleteByHouseModelId(d);
	}
}
