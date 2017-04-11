package com.govmade.service.system.customization;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.govmade.entity.system.customization.Customization;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.model.HouseModel;
import com.govmade.repository.system.customization.CustomizationDao;
import com.govmade.repository.system.data.DataListDao;
import com.govmade.service.base.GovmadeBaseServiceImp;

@Service("CustomizationService")
public class CustomizationServiceImp extends GovmadeBaseServiceImp<Customization> implements CustomizationService{

	@Autowired
	private CustomizationDao customizationDao;
	@Autowired
	private DataListDao dataListDao;
	
	@Override
	public void delete(Customization o) {
		baseDao.delete(o);
		DataList d=new DataList();
		d.setHouseModelId(o.getId());
		dataListDao.deleteByCustomizationId(d);
	}

}