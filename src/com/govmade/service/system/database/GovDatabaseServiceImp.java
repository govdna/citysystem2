package com.govmade.service.system.database;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.system.database.GovDatabase;
import com.govmade.repository.system.database.GovDatabaseDAO;
import com.govmade.service.base.GovmadeBaseServiceImp;

@Service("GovDatabaseService")
public class GovDatabaseServiceImp extends GovmadeBaseServiceImp<GovDatabase> implements GovDatabaseService {

	@Autowired
	private GovDatabaseDAO govDatabaseDAO;
	
	@Override
	public void clearColumn(int no) {
		govDatabaseDAO.clearColumn(no);
	}

	@Override
	public void insertList(List<GovDatabase> list) {
		for(GovDatabase db:list){
			insert(db);
		}
	}

}


