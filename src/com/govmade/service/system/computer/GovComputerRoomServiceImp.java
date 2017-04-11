package com.govmade.service.system.computer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.system.computer.GovComputerRoom;

import com.govmade.repository.system.computer.GovComputerRoomDAO;

import com.govmade.service.base.GovmadeBaseServiceImp;

@Service("GovComputerRoomService")
public class GovComputerRoomServiceImp extends GovmadeBaseServiceImp<GovComputerRoom> implements GovComputerRoomService {

	@Autowired
	private GovComputerRoomDAO govComputerRoomDAO;

	@Override
	public void clearColumn(int no) {
		 govComputerRoomDAO.clearColumn(no);
	}

}


