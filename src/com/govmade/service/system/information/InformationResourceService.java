package com.govmade.service.system.information;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.information.Subscribe;
import com.govmade.entity.system.organization.Company;
import com.govmade.service.base.BaseService;

public interface InformationResourceService extends BaseService<InformationResource>{
	/** 
	* @Title: clearColumn 
	* @Description: TODO(清空某一行的数据) 
	* @param @param no    设定文件 
	* @return void    返回类型 
	* 2016年12月28日    日期   
	*/ 
	public void clearColumn(int no);
	public void updateStatus(InformationResource info);

	/** 
	* @Title: getInforResGroupByCompany 
	* @Description: TODO(获取每个company下的信息资源数量) 
	* @param @return    设定文件 
	* @return List<Company>    返回类型 
	* 2017年1月12日    日期   
	*/ 
	public List<Company> getInforResGroupByCompany();

	
	public String getMaxCode(InformationResource o);

	public InformationResource tree(InformationResource info);

	/** 
	* @Title: getInformationResourceBySubscribe 
	* @Description: TODO(获取订阅的信息资源) 
	* @param @param s
	* @param @return    设定文件 
	* @return List<InformationResource>    返回类型 
	* 2017年1月18日    日期   
	*/ 
	public List<InformationResource> getInformationResourceBySubscribe(Subscribe s);

	
	public List<InformationResource> cpcount(InformationResource info);
	
	public int datacount(InformationResource info);
	public int sharecount(InformationResource info);
	/** 
	* @Title: truncateTable 
	* @Description: TODO(清空表) 
	* @return void    返回类型 
	* 2017年2月13日    日期   
	*/ 
	public void truncateTable();

	public Date latestTime(Integer cpId);
	
	/** 
	* @Title: allPass 
	* @Description: TODO(全部审核通过) 
	* @param     设定文件 
	* @return void    返回类型 
	* 2017年2月15日    日期   
	*/ 
	public void allPass();
	
	/** 
	* @Title: getInforResByDataElementIds 
	* @Description: TODO(根据数据元id获得引用该数据元的信息资源) 
	* @param @param ids
	* @param @return    设定文件 
	* @return List<InformationResource>    返回类型 
	* 2017年3月31日    日期   
	*/ 
	public List<InformationResource> getInforResByDataElementIds(String ids);
	
	/** 
	* @Title: findExactly 
	* @Description: TODO(精确查询) 
	* @param @param informationResource
	* @param @return    设定文件 
	* @return List<InformationResource>    返回类型 
	* 2017年4月6日    日期   
	*/ 
	public List<InformationResource> findExactly(InformationResource informationResource);
	
	/** 
	* @Title: countInforTypes 
	* @Description: TODO(统计每个大类下的信息资源数量) 
	* @param @param info
	* @param @return    设定文件 
	* @return List<InformationResource>    返回类型 
	* 2017年4月11日    日期   
	*/ 
	public Map<Integer,Integer> countInforTypes(InformationResource info);
	
	
	public Map<String,Integer> countValue3(InformationResource info);
	
	public Map<String,Integer> getCompanyCount();
	
}
