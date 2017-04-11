package com.govmade.service.system.server;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.system.server.GovServer;
import com.govmade.repository.system.server.GovServerDAO;
import com.govmade.service.base.GovmadeBaseServiceImp;

@Service("GovServerService")
public class GovServerServiceImp extends GovmadeBaseServiceImp<GovServer> implements GovServerService {

	@Autowired
	private GovServerDAO govServerDAO;
	
	@Override
	public void clearColumn(int no) {
		govServerDAO.clearColumn(no);
	}
	
	/**
	 * 统计
	 */
	@Override
	public List<GovServer> syslist(GovServer gs){
		return govServerDAO.syslist(gs);
	};
	@Override
	public List<GovServer> tblist(GovServer gs){
		return govServerDAO.tblist(gs);
	};
	@Override
	public List<GovServer> fllist(GovServer gs){
		return govServerDAO.fllist(gs);
	};

}


