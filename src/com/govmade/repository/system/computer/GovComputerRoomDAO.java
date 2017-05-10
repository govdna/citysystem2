package com.govmade.repository.system.computer;

import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;
import com.govmade.service.base.CanSimpleFields;

@MYBatis
public interface GovComputerRoomDAO  extends GovmadeBaseDao<GovComputerRoom> ,CanSimpleFields{
	
}

