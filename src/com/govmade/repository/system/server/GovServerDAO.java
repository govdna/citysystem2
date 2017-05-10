package com.govmade.repository.system.server;

import java.util.List;

import com.govmade.entity.system.server.GovServer;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;
import com.govmade.service.base.CanSimpleFields;

@MYBatis
public interface GovServerDAO  extends GovmadeBaseDao<GovServer>,CanSimpleFields {
	/**
	 * 统计
	 */
	public List<GovServer> syslist(GovServer gs);
	public List<GovServer> tblist(GovServer gs);
	public List<GovServer> fllist(GovServer gs);
	public List<GovServer> cplist(GovServer gs);
	public List<GovServer> applist(int[] sar);
}

