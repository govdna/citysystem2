package com.govmade.repository.system.data;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.govmade.common.mybatis.Page;
import com.govmade.entity.system.data.CleanDataElement;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.data.SameDataElementConfig;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;



/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan 数据元池
* @date 2017年3月23日 下午2:19:53   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: CleanDataElementDao.java
* @Package com.govmade.repository.system.data
* @version V1.0   
*/
@MYBatis
public interface CleanDataElementDao  extends GovmadeBaseDao<CleanDataElement> {
	public abstract void insertDataElement(DataElement dataElement);
	
	/** 
	* @Title: getRepeat 
	* @Description: TODO(获得重复的数据元名字与次数) 
	* @param @return    设定文件 
	* @return List<CleanDataElement>    返回类型 
	* 2017年3月24日    日期   
	*/ 
	public abstract List<CleanDataElement> getRepeat(@Param("param")CleanDataElement o,@Param("sort")String orderBy,@Param("orderBy")String sort);
	
	
	/** 
	* @Title: getRepeat 
	* @Description: TODO(获得该名字的数据元) 
	* @param @return    设定文件 
	* @return List<CleanDataElement>    返回类型 
	* 2017年3月24日    日期   
	*/ 
	public abstract List<CleanDataElement> findRepeatList(@Param("param")CleanDataElement dataElement);
	
	/** 
	* @Title: findBySameConfig 
	* @Description: TODO(根据同义词获得数据元) 
	* @param @param list
	* @param @return    设定文件 
	* @return List<CleanDataElement>    返回类型 
	* 2017年3月27日    日期   
	*/ 
	public abstract List<CleanDataElement> findBySameConfig(@Param("list")List<SameDataElementConfig> list);
	
	
	/** 
	* @Title: findByIds 
	* @Description: TODO(根据id数组获取数据元) 
	* @param @param list
	* @param @return    设定文件 
	* @return List<CleanDataElement>    返回类型 
	* 2017年3月27日    日期   
	*/ 
	public abstract List<CleanDataElement> findByIds(@Param("list")Integer [] list);
	
	
	public abstract String maxIdentifier(CleanDataElement o);
	
	public abstract void deleteByName(CleanDataElement o);
	
	/** 
	* @Title: transferFather 
	* @Description: TODO(将重复数据元下的子数据元转到id下数据元) 
	* @param @param o    设定文件 
	* @return void    返回类型 
	* 2017年3月28日    日期   
	*/ 
	public abstract void transferFather(CleanDataElement o);
	/** 
	* @Title: transferFather 
	* @Description: TODO(将ids数据元下的子数据元转到id下数据元) 
	* @param @param o    设定文件 
	* @return void    返回类型 
	* 2017年3月28日    日期   
	*/ 
	public abstract void transferByIds(@Param("param")CleanDataElement dataElement,@Param("ids")String ids);
	/** 
	* @Title: transferFather 
	* @Description: TODO(将ids的数据元成为id数据元的子集) 
	* @param @param o    设定文件 
	* @return void    返回类型 
	* 2017年3月28日    日期   
	*/ 
	public abstract void setFatherIdByIds(@Param("param")CleanDataElement dataElement,@Param("ids")String ids);
	
	/** 
	* @Title: deleteByNameInIds 
	* @Description: TODO(删除同义词数据元处理) 
	* @param @param dataElement
	* @param @param ids    设定文件 
	* @return void    返回类型 
	* 2017年3月28日    日期   
	*/ 
	public abstract void deleteByNameInIds(@Param("param")CleanDataElement dataElement,@Param("ids")String ids);
	
	/** 
	* @Title: findByPage 
	* @Description: TODO(获得没有父级和子集的数据元) 
	* @param @param o
	* @param @param page
	* @param @return    设定文件 
	* @return List<DataElement>    返回类型 
	* 2017年2月6日    日期   
	*/ 
	public List<CleanDataElement> findSingleDataElementByPage(@Param("param")CleanDataElement o,Page<CleanDataElement> page);
	
	/** 
	* @Title: getUseCount 
	* @Description: TODO(统计使用频率) 
	* @param @return    设定文件 
	* @return List<CleanDataElement>    返回类型 
	* 2017年3月30日    日期   
	*/ 
	public List<CleanDataElement> findUseCountByPage(@Param("param")CleanDataElement o,Page<CleanDataElement> page);
	
	
	/** 
	* @Title: updateSystemType 
	* @Description: TODO(批量设置公共数据元) 
	* @param @param systemType
	* @param @param ids    设定文件 
	* @return void    返回类型 
	* 2017年3月30日    日期   
	*/ 
	public void updateSystemType(@Param("systemType")Integer systemType,@Param("list")Integer [] ids);
	
	
	/** 
	* @Title: deleteAll 
	* @Description: TODO(清空全部) 
	* @param     设定文件 
	* @return void    返回类型 
	* 2017年3月31日    日期   
	*/ 
	public void deleteAll();
	
	
	/** 
	* @Title: findDataElementByResId 
	* @Description: TODO(根据信息资源获得标准化的数据元) 
	* @param @param dataElement
	* @param @return    设定文件 
	* @return List<CleanDataElement>    返回类型 
	* 2017年4月1日    日期   
	*/ 
	public List<CleanDataElement> findDataElementByResId(@Param("param")CleanDataElement dataElement,Page<CleanDataElement> page);
	

	/** 
	* @Title: findExactly 
	* @Description: TODO(根据名字精确查找) 
	* @param @param dataElement
	* @param @return    设定文件 
	* @return List<CleanDataElement>    返回类型 
	* 2017年4月24日    日期   
	*/ 
	public List<CleanDataElement> findExactly(@Param("param")CleanDataElement o,Page<CleanDataElement> page);
	
}
