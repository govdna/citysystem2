package com.govmade.api;

import java.io.IOException;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

import com.govmade.common.utils.HttpUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.entity.system.api.ApiAccount;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.service.system.api.ApiAccountService;

public class PushUtil{
	private static PushThread thread=new PushThread();
	
	public PushUtil() {
		super();
		thread.start();
	}

	public static void pushInformation(InformationResource infor){
		PushThread.addInformation(infor);
	}
}
