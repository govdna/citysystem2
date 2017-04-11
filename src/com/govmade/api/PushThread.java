package com.govmade.api;

import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import org.apache.commons.lang3.StringUtils;
import com.govmade.common.utils.HttpUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.entity.system.api.ApiAccount;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.service.system.api.ApiAccountService;

public class PushThread extends Thread {
	private static Queue<InformationResource> queue = new LinkedList<InformationResource>();
	private static ApiAccountService apiAccountService = (ApiAccountService) ServiceUtil
			.getService("ApiAccountService");

	public static void addInformation(InformationResource infor) {
		queue.offer(infor);
	}

	@Override
	public void run() {
		super.run();
		InformationResource infor = queue.poll();
		if (infor != null) {
			while (infor != null) {
				List<ApiAccount> list = apiAccountService.find(new ApiAccount());
				for (ApiAccount api : list) {
					if (StringUtils.isNotEmpty(api.getListenerUrl())) {
						try {
							HttpUtil.post(api.getListenerUrl(), "id=" + infor.getId(), false);
						} catch (Exception e) {
							queue.offer(infor);
						}
					}
				}
				infor = queue.poll();
			}

		}

		try {
			sleep(60000);
			run();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

	}

}
