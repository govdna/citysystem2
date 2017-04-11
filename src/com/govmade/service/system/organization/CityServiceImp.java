package com.govmade.service.system.organization;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.govmade.common.utils.SecurityUtil;
import com.govmade.entity.system.organization.City;
import com.govmade.entity.system.organization.City;
import com.govmade.repository.system.organization.CityDAO;
import com.govmade.service.base.GovmadeBaseServiceImp;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("CityService")
public class CityServiceImp extends GovmadeBaseServiceImp<City> implements CityService {

	@Autowired
	private CityDAO companyDAO;



	//是否是叶子节点
	private boolean isLeaf(City p,List<City> list){
		for(City pp:list){
			if(pp.getFatherId().intValue()==p.getId().intValue()){
				return false;
			}
		}
		return true;
	}
	
	@Override
	public JSONArray getJqGridTreeJson(City c) {
		List<City> list =sort(find(c,"level_s","asc"));
		if(list==null||list.size()==0){
			return null;
		}
		JSONArray re = new JSONArray();
		for (City p : list) {
			JSONObject menu=JSONObject.fromObject(p);
			menu.put("idForShow", SecurityUtil.encrypt(p.getId()));
			menu.put("isLeaf", isLeaf(p,list));
			menu.put("expanded", true);
			re.add(menu);
		}
		return re;
	}
	
	//对树进行排序
		public List<City> sort(List<City> list) {
			if(list==null||list.size()<=1){
				return list;
			}
			List<City> ps = new ArrayList<City>();
			for (City p : list) {
				if (p.getFatherId() == null || p.getFatherId() == 0) {
					ps.add(p);
					ps.addAll(getTreeChild(p, list));
				}
			}
			return ps;
		}

		public List<City> getTreeChild(City parent, List<City> list) {
			List<City> re = new ArrayList<City>();
			for (City p : list) {
				if (p.getFatherId().intValue() == parent.getId()) {
					re.add(p);
					List<City> ps = getTreeChild(p, list);
					if (ps.size() > 0) {
						re.addAll(ps);
					}
				}
			}
			return re;
		}

}
