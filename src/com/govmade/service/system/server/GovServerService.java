package com.govmade.service.system.server;

import java.util.List;

import com.govmade.entity.system.server.GovServer;
import com.govmade.service.base.BaseService;
import com.govmade.service.base.CanSimpleFields;

public interface GovServerService extends BaseService<GovServer>,CanSimpleFields{
	/**
	 * 统计
	 */
	public List<GovServer> syslist(GovServer gs);
	public List<GovServer> tblist(GovServer gs);
	public List<GovServer> fllist(GovServer gs);
	public List<GovServer> cplist(GovServer gs);
	public List<GovServer> applist(int[] sar);
}

