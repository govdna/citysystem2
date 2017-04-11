package com.govmade.repository.system.model;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.govmade.entity.system.model.HouseModel;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月12日 上午10:07:22   
* @Title: HouseManagerDao.java  
*/

@MYBatis
public interface HouseModelDao extends GovmadeBaseDao<HouseModel> {
	public List<HouseModel> popTreeFirst();
	public List<HouseModel> popTreeSecond();
	public List<HouseModel> legalTree();
	public List<HouseModel> creditTree();
	public List<HouseModel> licenceTree();
	public List<HouseModel> customTree(@Param("houseTypes")Integer houseTypes);
}
