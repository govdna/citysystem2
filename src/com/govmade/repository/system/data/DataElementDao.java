package com.govmade.repository.system.data;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.govmade.common.mybatis.Page;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;


/**   
* @author (作者) Chenlei 774329191@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月7日 上午8:55:51   
* @Title: DataElementDao.java  
*/
/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem TODO
* @date 2017年2月4日 下午2:54:50   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: DataElementDao.java
* @Package com.govmade.repository.system.data
* @version V1.0   
*/
@MYBatis
public interface DataElementDao  extends GovmadeBaseDao<DataElement> {
	//public List<DataElement> getDataElementList(DataElement d);
	public List<DataElement> echarts(DataElement d);
	public List<DataElement> getDataElementListByInforResId(@Param("inforResId")Integer inforResId,@Param("objectType")Integer objectType,@Param("chName")String chName);
	public List<DataElement> getDataElementListByDataManagerId(@Param("inforResourceId")Integer inforResourceId,@Param("objectType")Integer objectType,@Param("chName")String chName,Page<DataElement> page);
	public List<DataElement> getDataElementListByHouseModelId(@Param("houseModelId")Integer houseModelId);
	public List<DataElement> getDElistByHouseModelId(@Param("param")DataList dataList);
	public List<DataElement> getDataElementListByIds(@Param("ids")String ids);
	/** 
	* @Title: getDataElementListByDataList 
	* @Description: TODO(根据DataList获取DataElement) 
	* @param @param dataList
	* @param @return    设定文件 
	* @return List<DataElement>    返回类型 
	* 2016年12月22日    日期   
	*/ 
	public List<DataElement> getDataElementListByDataList(@Param("param")DataList dataList);
	
	public List<DataElement> getDataElementListByDataListPage(@Param("param")DataElement dataElement,
			@Param("informationResId")Integer informationResId,@Param("dataManagerId")Integer dataManagerId,@Param("objectType")String objectType,@Param("chName")String chName,Page<DataElement> page);
	
	/** 
	* @Title: getDataElementListByInforResId 
	* @Description: TODO(根据InforResId,DataElement获取DataElement) 
	* @param @param inforResId
	* @param @param objectType
	* @param @param chName
	* @param @return    设定文件 
	* @return List<DataElement>    返回类型 
	* 2016年12月26日    日期   
	*/ 
	public List<DataElement> getDataElementListByInforResId2(@Param("inforResId")Integer inforResId,@Param("param")DataElement dataElement);
	
	public abstract String maxIdentifier(DataElement o);

	public void toStatus(DataElement o);
	
	/** 
	* @Title: clearColumn 
	* @Description: TODO(清空某一行的数据) 
	* @param @param no    设定文件 
	* @return void    返回类型 
	* 2016年12月28日    日期   
	*/ 
	public void clearColumn(@Param("valueNo")int no);


	public List<DataElement> getByCustomizationId(@Param("customizationId")Integer id, DataElement dataElement);
	

	public List<DataElement> countInfor(DataElement dataElement);
	
	public List<DataElement> countCom(DataElement dataElement);


	/** 
	* @Title: volidate 
	* @Description: TODO(验证名字重复等) 
	* @param @param dataElement
	* @param @return    设定文件 
	* @return List<DataElement>    返回类型 
	* 2017年2月4日    日期   
	*/ 
	public List<DataElement> volidate(@Param("param")DataElement dataElement);
	

	public String findInforx(DataElement dataElement);

	/** 
	* @Title: updateChildIdentifier 
	* @Description: TODO(根据父类更新子类的标识符) 
	* @param @param dataElement    设定文件 
	* @return void    返回类型 
	* 2017年2月6日    日期   
	*/ 
	public void updateChildIdentifier(@Param("param")DataElement dataElement);
	
	/** 
	* @Title: findByPage 
	* @Description: TODO(获得没有父级和子集的数据元) 
	* @param @param o
	* @param @param page
	* @param @return    设定文件 
	* @return List<DataElement>    返回类型 
	* 2017年2月6日    日期   
	*/ 
	public List<DataElement> findSingleDataElementByPage(@Param("param")DataElement o,Page<DataElement> page);
	
	
	/** 
	* @Title: setChild 
	* @Description: TODO(选择已有数据元当子集) 
	* @param @param dataElement
	* @param @param ids    设定文件 
	* @return void    返回类型 
	* 2017年2月6日    日期   
	*/ 
	public void setChild(@Param("param")DataElement dataElement,@Param("ids")String ids);
	
	/** 
	* @Title: clearImported 
	* @Description: TODO(删除已导入的数据元后，清除已导入标识) 
	* @param @param dataElement    设定文件 
	* @return void    返回类型 
	* 2017年2月7日    日期   
	*/ 
	public void clearImported(@Param("param")DataElement dataElement);
	
	/** 
	* @Title: clearTable 
	* @Description: TODO(删除表) 
	* @param @param dataElement    设定文件 
	* @return void    返回类型 
	* 2017年2月13日    日期   
	*/ 
	public void cleanTable(@Param("param")DataElement dataElement);
	
	/** 
	* @Title: clearImported 
	* @Description: TODO(清除所有已导入标识) 
	* @param @param dataElement    设定文件 
	* @return void    返回类型 
	* 2017年2月13日    日期   
	*/ 
	public void clearAllImported(DataElement dataElement);
	
	public List<DataElement> findByName(@Param("param")DataElement dataElement);
	public List<DataElement> findByName(@Param("param")DataElement dataElement,@Param("sort")String orderBy,@Param("orderBy")String sort);
	
	public Date latestTime(@Param("cpId")Integer cpId);
	/**
	 * 
	 */
	public void statusAll();
	/**
	 * @param id
	 */
	public void actualDelByInforId(Integer id);
	
	/** 
	* @Title: getDataElementListByTableId 
	* @Description: TODO(根据table Id获取数据元) 
	* @param @param table
	* @param @return    设定文件 
	* @return List<DataElement>    返回类型 
	* 2017年3月20日    日期   
	*/ 
	public List<DataElement> getDataElementListByTableId(@Param("param")GovTable table);
	
	/** 
	* @Title: findExactly 
	* @Description: TODO(精确查找) 
	* @param @param dataElement
	* @param @return    设定文件 
	* @return List<DataElement>    返回类型 
	* 2017年3月31日    日期   
	*/ 
	public List<DataElement> findExactly(@Param("param")DataElement dataElement);
	
	
	/** 
	* @Title: getUseCount 
	* @Description: TODO(数据元使用频率) 
	* @param @return    设定文件 
	* @return List<DataElement>    返回类型 
	* 2017年4月11日    日期   
	*/ 
	public List<DataElement> getUseCount();
	
	/** 
	* @Title: getCompanyCount 
	* @Description: TODO(各个机构所属的数据元数量) 
	* @param @return    设定文件 
	* @return List<DataElement>    返回类型 
	* 2017年4月20日    日期   
	*/ 
	public List<DataElement> getCompanyCount();
	
}
