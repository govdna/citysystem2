package com.govmade.service.system.information;

import java.util.List;
import java.util.Map;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.service.base.BaseService;
import com.govmade.service.base.CanSimpleFields;

public interface InformationResService extends BaseService<InformationRes>,CanSimpleFields{

	public String getMaxCode(InformationRes o);
	/** 
	* @Title: getInformationResByLog 
	* @Description: TODO(获取最近操作的信息资源) 
	* @param @return    设定文件 
	* @return List<InformationRes>    返回类型 
	* 2017年2月9日    日期   
	*/ 
	public  List<InformationRes> getInformationResByLog(Integer accountId);
	
	/** 
	* @Title: truncateTable 
	* @Description: TODO(清空表) 
	* @return void    返回类型 
	* 2017年2月13日    日期   
	*/ 
	public void truncateTable();
	
	/** 
	* @Title: countInforTypes 
	* @Description: TODO(统计每个大类下的信息资源数量) 
	* @param @param info
	* @param @return    设定文件 
	* @return List<InformationResource>    返回类型 
	* 2017年4月11日    日期   
	*/ 
	public Map<Integer,Integer> countInforTypes(InformationRes info);
	public Map<String,Integer> countValue2(InformationRes info);
}
