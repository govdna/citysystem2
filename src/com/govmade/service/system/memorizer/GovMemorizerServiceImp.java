package com.govmade.service.system.memorizer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.system.memorizer.GovMemorizer;
import com.govmade.repository.system.memorizer.GovMemorizerDAO;
import com.govmade.service.base.GovmadeBaseServiceImp;

@Service("GovMemorizerService")
public class GovMemorizerServiceImp extends GovmadeBaseServiceImp<GovMemorizer> implements GovMemorizerService {

	@Autowired
	private GovMemorizerDAO govMemorizerDAO;
	
	@Override
	public void clearColumn(int no) {
		govMemorizerDAO.clearColumn(no);
	}

}


