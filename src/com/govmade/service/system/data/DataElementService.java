package com.govmade.service.system.data;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.govmade.common.mybatis.Page;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.service.base.BaseService;
import com.govmade.service.base.CanSimpleFields;

/**   
* @author (作者) Chenlei 774329191@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月7日 上午8:56:08   
* @Title: DataElementService.java  
*/
public interface DataElementService extends BaseService<DataElement>,CanSimpleFields{
	//public List<DataElement> getDataElementList(int id);
	public List<DataElement> getDataElementListByInforResId(Integer inforResId,Integer objectType,String chName);
	public Page<DataElement> getDataElementListByDataManagerId(Integer inforResourceId,Integer objectType,String chName,Page<DataElement> page);
	public List<DataElement> getDataElementListByHouseModelId(Integer houseModelId);
	public List<DataElement> getDElistByHouseModelId(DataList dataList);
	public List<DataElement> getDataElementListByIds(String ids);
	public List<DataElement> echarts(DataElement d);
	/** 
	* @Title: getDataElementListByDataList 
	* @Description: TODO(根据DataList获取DataElement) 
	* @param @param dataList
	* @param @return    设定文件 
	* @return List<DataElement>    返回类型 
	* 2016年12月22日    日期   
	*/ 
	public List<DataElement> getDataElementListByDataList(DataList dataList);
	
	public Page<DataElement> getDataElementListByDataListPage(DataElement dataElement,Integer informationResId,Integer dataManagerId,String objType,String chName,Page<DataElement> page);
	
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
	public List<DataElement> getDataElementListByInforResId2(Integer inforResId,DataElement dataElement);
	
	public String maxIdentifier(DataElement o);

	/** 
	* @Title: clearColumn 
	* @Description: TODO(清空某一行的数据) 
	* @param @param no    设定文件 
	* @return void    返回类型 
	* 2016年12月28日    日期   
	*/ 
	public void clearColumn(int no);

	/**
	 * @param id
	 * @param dataElement
	 * @return
	 */
	public List<DataElement> getByCustomizationId(Integer id, DataElement dataElement);

	/** 
	* @Title: getChild 
	* @Description: TODO(获得子数据元) 
	* @param @param dataElement
	* @param @return    设定文件 
	* @return List<DataElement>    返回类型 
	* 2017年2月4日    日期   
	*/ 
	public List<DataElement> getChild(DataElement dataElement);
	
	/** 
	* @Title: copyDataElement 
	* @Description: TODO(将模版中的导入到管理中) 
	* @param @param dataElement    设定文件 
	* @return void    返回类型 
	* 2017年2月4日    日期   
	*/ 
	public int copyDataElement(DataElement dataElement,Integer fatherId,Integer companyId,Integer groupId);
	
	
	public List<DataElement> countInfor(DataElement dataElement);
	
	public List<DataElement> countCom(DataElement dataElement);

	public void toStatus(DataElement o);
	
	public boolean volidate(DataElement dataElement);
	

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
	public Page<DataElement> findSingleDataElementByPage(DataElement o,Page<DataElement> page);
	
	
	/** 
	* @Title: setChild 
	* @Description: TODO(选择已有数据元当子集) 
	* @param @param dataElement
	* @param @param ids    设定文件 
	* @return void    返回类型 
	* 2017年2月6日    日期   
	*/ 
	public void setChild(DataElement dataElement,String ids);
	

	public String findInforx(DataElement dataElement);

	/** 
	* @Title: clearImported 
	* @Description: TODO(删除已导入的数据元后，清除已导入标识) 
	* @param @param dataElement    设定文件 
	* @return void    返回类型 
	* 2017年2月7日    日期   
	*/ 
	public void clearImported(DataElement dataElement);
	
	
	public void insertList(List<DataElement> list);
	
	public void insertList(List<DataElement> list,int classType);
	/** 
	* @Title: clearTable 
	* @Description: TODO(删除表) 
	* @param @param dataElement    设定文件 
	* @return void    返回类型 
	* 2017年2月13日    日期   
	*/ 
	public void cleanTable(DataElement dataElement);
	
	/** 
	* @Title: clearImported 
	* @Description: TODO(清除所有已导入标识) 
	* @param @param dataElement    设定文件 
	* @return void    返回类型 
	* 2017年2月7日    日期   
	*/ 
	public void clearAllImported();
	
	/** 
	* @Title: clearImported 
	* @Description: TODO(清除所有已导入标识) 
	* @param @param dataElement    设定文件 
	* @return void    返回类型 
	* 2017年2月7日    日期   
	*/ 
	public void clearAllImported(DataElement dataElement);
	
	public DataElement getDataElementByChName(DataElement dataElement);
	

	public List<DataElement> findByName(DataElement dataElement);
	public List<DataElement> findByName(DataElement dataElement,String orderBy,String sort);
	
	public Date latestTime(Integer cpId);
	/**
	 * 
	 */
	public void statusAll();
	/**
	 * @param id
	 */
	public void actualDelByInforId(Integer id);
	
	
	public void setIdentifier(DataElement dataElement);
	
	/** 
	* @Title: getDataElementListByTableId 
	* @Description: TODO(根据table Id获取数据元) 
	* @param @param table
	* @param @return    设定文件 
	* @return List<DataElement>    返回类型 
	* 2017年3月20日    日期   
	*/ 
	public List<DataElement> getDataElementListByTableId(GovTable table);
	
	
	public List<DataElement> findExactly(DataElement dataElement);
	
	/** 
	* @Title: getUseCount 
	* @Description: TODO(数据元使用频率) 
	* @param @return    设定文件 
	* @return List<DataElement>    返回类型 
	* 2017年4月11日    日期   
	*/ 
	public List<DataElement> getUseCount();
	
	public Map<String, Integer> getCompanyCount();
}
