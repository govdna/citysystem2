package com.govmade.service.system.data;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.govmade.entity.system.data.DataList;
import com.govmade.repository.system.data.DataListDao;
import com.govmade.service.base.GovmadeBaseServiceImp;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月8日 上午9:49:53   
* @Title: DataListServiceImp.java  
*/
@Service("DataListService")
public class DataListServiceImp extends GovmadeBaseServiceImp<DataList> implements DataListService{

	@Autowired
	private DataListDao dataListDao;

	@Override
	public void deleteByInformationResId(DataList o) {
		dataListDao.deleteByInformationResId(o);
	}

	@Override
	public void deleteByHouseModelId(DataList o) {
		dataListDao.deleteByHouseModelId(o);
	}

	@Override
	public void deleteByDataManagerId(DataList o) {
		dataListDao.deleteByDataManagerId(o);
	}


	@Override
	public void deleteByItemSortId(DataList o) {
	
			dataListDao.deleteByItemSortId(o);
	}


	@Override
	public void deleteByDataElementId(DataList o) {
		// TODO Auto-generated method stub
		dataListDao.deleteByDataElementId(o);
		
	}


	@Override
	public void deleteByCustomizationId(DataList o) {
		dataListDao.deleteByCustomizationId(o);
	}
	
	@Transactional(rollbackFor = Exception.class)  
	@Override
	public void insertList(List<DataList> list) {
		for(DataList dl:list){
			insert(dl);
		}
	}

}