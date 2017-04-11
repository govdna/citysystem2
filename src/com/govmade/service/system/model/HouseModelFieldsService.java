package com.govmade.service.system.model;

import com.govmade.entity.system.model.HouseModelFields;
import com.govmade.service.base.BaseService;

import net.sf.json.JSONArray;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2017年2月14日 下午1:31:12   
* @Title: HouseModelFieldsService.java  
*/
public interface HouseModelFieldsService extends BaseService<HouseModelFields>{

	public JSONArray getJqGridTreeJson(HouseModelFields c);
}
