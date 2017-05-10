package com.govmade.service.system.dict;

import java.util.List;

import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.service.base.BaseService;

import net.sf.json.JSONArray;

public interface GovmadeDicService extends BaseService<GovmadeDic>{
	public JSONArray getJqGridTreeJson(GovmadeDic g);
	public List<GovmadeDic> getDicList(GovmadeDic g);
	public List<GovmadeDic> getDicTreeList(GovmadeDic g);
	public JSONArray getSonJson(GovmadeDic g);
	public List<GovmadeDic> getDicByNumKey(GovmadeDic g);
}
