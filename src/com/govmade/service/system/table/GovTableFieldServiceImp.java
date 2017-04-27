package com.govmade.service.system.table;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.repository.system.table.GovTableDAO;
import com.govmade.repository.system.table.GovTableFieldDAO;
import com.govmade.service.base.GovmadeBaseServiceImp;

@Service("GovTableFieldService")
public class GovTableFieldServiceImp extends GovmadeBaseServiceImp<GovTableField> implements GovTableFieldService {

	@Autowired
	private GovTableFieldDAO govTableField;
	
	@Override
	public void clearColumn(int no) {
		govTableField.clearColumn(no);
	}
	@Transactional(rollbackFor = Exception.class)  
	@Override
	public void insertList(List<GovTableField> list) {
		for(GovTableField gf:list){
			insert(gf);
		}
	}
	@Override
	public List<GovTableField> findByGovTable(List<GovTable> list) {
		return govTableField.findByGovTable(list);
	}

}


