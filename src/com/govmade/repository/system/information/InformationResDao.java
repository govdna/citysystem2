package com.govmade.repository.system.information;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;
import com.govmade.service.base.CanSimpleFields;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月8日 上午9:45:01   
* @Title: InformationResDao.java  
*/
@MYBatis
public interface InformationResDao extends GovmadeBaseDao<InformationRes>,CanSimpleFields {

	public String getMaxCode(InformationRes o);
	
	/** 
	* @Title: getInformationResByLog 
	* @Description: TODO(获取最近操作的信息资源) 
	* @param @return    设定文件 
	* @return List<InformationRes>    返回类型 
	* 2017年2月9日    日期   
	*/ 
	public  List<InformationRes> getInformationResByLog(@Param("accountId")Integer accountId);
	
	
	/** 
	* @Title: truncateTable 
	* @Description: TODO(清空表) 
	* @param     设定文件 
	* @return void    返回类型 
	* 2017年2月13日    日期   
	*/ 
	public void truncateTable();

	public  List<InformationRes> countValue2(InformationRes infor);
	public  List<InformationRes> countInforTypes(InformationRes infor);
	public  List<InformationRes> countInforTypes2(InformationRes infor);
	public  List<InformationRes> countInforTypes3(InformationRes infor);
}
