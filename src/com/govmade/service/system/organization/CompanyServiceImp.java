package com.govmade.service.system.organization;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.govmade.common.utils.SecurityUtil;
import com.govmade.entity.system.organization.Company;
import com.govmade.repository.system.organization.CompanyDAO;
import com.govmade.service.base.GovmadeBaseServiceImp;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("CompanyService")
public class CompanyServiceImp extends GovmadeBaseServiceImp<Company> implements CompanyService {
	private long initedTime=0;
	private static Map<Integer,Company> cache=new HashMap<Integer,Company>();
	@Override
	public Company findById(Company o) {
		initMap();
		if(cache.containsKey(o.getId())){
			return cache.get(o.getId());
		}
		return super.findById(o);
	}
	
	@Override
	public void insert(Company o) {
		// TODO Auto-generated method stub
		super.insert(o);
		cache.put(o.getId(), o);
	}

	@Override
	public void update(Company o) {
		// TODO Auto-generated method stub
		super.update(o);
		cache.put(o.getId(), o);
	}

	private synchronized void initMap(){
		if(System.currentTimeMillis()-initedTime>90000){
			initedTime=System.currentTimeMillis();
			List<Company> list=find(new Company());
			cache.clear();
			for(Company c:list){
				cache.put(c.getId(), c);
			}
		}
	}
}
