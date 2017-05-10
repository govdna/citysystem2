package com.govmade.service.system.organization;

import java.util.List;

import com.govmade.entity.system.organization.City;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.service.base.BaseService;

import net.sf.json.JSONArray;

public interface CityService extends BaseService<City>{
	public JSONArray getJqGridTreeJson(City c);//生成树json
}
