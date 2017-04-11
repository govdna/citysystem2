package com.govmade.repository.system.information;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.information.Subscribe;
import com.govmade.entity.system.organization.Company;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;


/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 资源管理下的信息资源
* @date 2016年12月22日 上午8:57:52   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: InformationResourceDao.java
* @Package com.govmade.repository.system.information
* @version V1.0   
*/
@MYBatis
public interface InformationResourceDao extends GovmadeBaseDao<InformationResource> {
	
	/** 
	* @Title: clearColumn 
	* @Description: TODO(清空某一行的数据) 
	* @param @param no    设定文件 
	* @return void    返回类型 
	* 2016年12月28日    日期   
	*/ 
	public void clearColumn(@Param("valueNo")int no);
	/** 
	* @Title: updateStatus 
	* @Description: TODO(流程状态) 
	* @param @param info    设定文件 
	* @return void    返回类型 
	* 2016年12月30日    日期   
	*/ 
	public void updateStatus(InformationResource info);

	/** 
	* @Title: getInforResGroupByCompany 
	* @Description: TODO(获取每个company下的信息资源数量) 
	* @param @return    设定文件 
	* @return List<Company>    返回类型 
	* 2017年1月12日    日期   
	*/ 
	public List<Company> getInforResGroupByCompany();

	public abstract String getMaxCode(InformationResource o);
	

	/** 
	* @Title: tree 
	* @Description: 用于树形数据获取 
	* @param @param info
	* @param @return    设定文件 
	* @return InformationResource    返回类型 
	* @throws 
	*/
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

	
	/**
	 * @Title: cpcount 
	 * @Description: 用于主题/基础统计部门数 
	 * @param info
	 * @return
	 */
	public List<InformationResource> cpcount(InformationResource info);
	
	/**
	 * @Title: datacount 
	 * @Description: 用于无条件共享/条件共享/不共享的信息资源信息项数量
	 * @param info
	 * @return
	 */
	public int datacount(InformationResource info);
	
	public int sharecount(InformationResource info);
	

	/** 
	* @Title: truncateTable 
	* @Description: TODO(清空表) 
	* @param     设定文件 
	* @return void    返回类型 
	* 2017年2月13日    日期   
	*/ 
	public void truncateTable();
	
	public Date latestTime(@Param("cpId")Integer cpId);
	
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
	public List<InformationResource> getInforResByDataElementIds(@Param("ids")String ids);
	
	
	/** 
	* @Title: findExactly 
	* @Description: TODO(精确查询) 
	* @param @param informationResource
	* @param @return    设定文件 
	* @return List<InformationResource>    返回类型 
	* 2017年4月6日    日期   
	*/ 
	public List<InformationResource> findExactly(@Param("param")InformationResource informationResource);
	
	/** 
	* @Title: countInforTypes 
	* @Description: TODO(统计每个大类下的信息资源数量) 
	* @param @param info
	* @param @return    设定文件 
	* @return List<InformationResource>    返回类型 
	* 2017年4月11日    日期   
	*/ 
	public List<InformationResource> countInforTypes(InformationResource info);
	
	/** 
	* @Title: countInforTypes 
	* @Description: TODO(统计每个项下的信息资源数量) 
	* @param @param info
	* @param @return    设定文件 
	* @return List<InformationResource>    返回类型 
	* 2017年4月11日    日期   
	*/ 
	public List<InformationResource> countInforTypes2(InformationResource info);
	
	/** 
	* @Title: countInforTypes 
	* @Description: TODO(统计每个目下的信息资源数量) 
	* @param @param info
	* @param @return    设定文件 
	* @return List<InformationResource>    返回类型 
	* 2017年4月11日    日期   
	*/ 
	public List<InformationResource> countInforTypes3(InformationResource info);
	
	
	public  List<InformationResource> countValue3(InformationResource infor);
	
}
