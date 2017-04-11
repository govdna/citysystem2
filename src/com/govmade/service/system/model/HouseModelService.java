package com.govmade.service.system.model;

import java.util.List;

import com.govmade.entity.system.model.HouseModel;
import com.govmade.service.base.BaseService;

public interface HouseModelService extends BaseService<HouseModel>{
	public List<HouseModel> popTreeFirst();
	public List<HouseModel> popTreeSecond();
	public List<HouseModel> legalTree();
	public List<HouseModel> creditTree();
	public List<HouseModel> licenceTree();
	public List<HouseModel> customTree(Integer houseTypes);
}
