package com.govmade.service.system.table;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.repository.system.table.GovTableDAO;
import com.govmade.service.base.GovmadeBaseServiceImp;

@Service("GovTableService")
public class GovTableServiceImp extends GovmadeBaseServiceImp<GovTable> implements GovTableService {

	@Autowired
	private GovTableDAO govTableDAO;
	
	@Override
	public void clearColumn(int no) {
		govTableDAO.clearColumn(no);
	}
	@Transactional(rollbackFor = Exception.class)  
	@Override
	public void insertList(List<GovTable> list) {
		for(GovTable gt:list){
			insert(gt);
		}
	}
	@Override
	public List<GovTable> findByGovDatabase(List<GovDatabase> list) {
		return govTableDAO.findByGovDatabase(list);
	}

}


