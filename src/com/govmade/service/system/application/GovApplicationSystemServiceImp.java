package com.govmade.service.system.application;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.repository.system.application.GovApplicationSystemDAO;
import com.govmade.service.base.GovmadeBaseServiceImp;

@Service("GovApplicationSystemService")
public class GovApplicationSystemServiceImp extends GovmadeBaseServiceImp<GovApplicationSystem> implements GovApplicationSystemService {

	@Autowired
	private GovApplicationSystemDAO govApplicationSystemDAO;

	@Override
	public List<GovApplicationSystem> getAppSysList(GovApplicationSystem i) {
		// TODO Auto-generated method stub
		return govApplicationSystemDAO.getAppSysList(i);
	}
	
	@Override
	public void clearColumn(int no) {
		govApplicationSystemDAO.clearColumn(no);
	}
	
	public  void deleteRelation(GovApplicationSystem o){
		govApplicationSystemDAO.deleteRelation(o);
	}

}


