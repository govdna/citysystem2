package com.govmade.service.system.data;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.govmade.common.mybatis.Page;
import com.govmade.entity.system.data.CleanDataElement;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.data.SameDataElementConfig;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.service.base.BaseService;


/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan 数据元池
* @date 2017年3月23日 下午2:25:38   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: CleanDataElementService.java
* @Package com.govmade.service.system.data
* @version V1.0   
*/
public interface CleanDataElementService extends BaseService<CleanDataElement>{
		//批量插入
		public abstract void insertList(List<CleanDataElement> list);
		public abstract void insert(DataElement dataElement);
		/** 
		* @Title: getRepeat 
		* @Description: TODO(获得重复的数据元名字与次数) 
		* @param @return    设定文件 
		* @return List<CleanDataElement>    返回类型 
		* 2017年3月24日    日期   
		*/ 
		public abstract List<CleanDataElement> getRepeat();
		/** 
		* @Title: getRepeat 
		* @Description: TODO(获得该名字的数据元) 
		* @param @return    设定文件 
		* @return List<CleanDataElement>    返回类型 
		* 2017年3月24日    日期   
		*/ 
		public abstract List<CleanDataElement> findRepeatList(CleanDataElement dataElement);
		
		/** 
		* @Title: findBySameConfig 
		* @Description: TODO(根据同义词获得数据元) 
		* @param @param list
		* @param @return    设定文件 
		* @return List<CleanDataElement>    返回类型 
		* 2017年3月27日    日期   
		*/ 
		public abstract List<CleanDataElement> findBySameConfig(List<SameDataElementConfig> list);
		
		/** 
		* @Title: findByIds 
		* @Description: TODO(根据id数组获取数据元) 
		* @param @param list
		* @param @return    设定文件 
		* @return List<CleanDataElement>    返回类型 
		* 2017年3月27日    日期   
		*/ 
		public abstract List<CleanDataElement> findByIds(Integer [] list);
		
		
		public abstract Map<String,Integer> compareList(List<CleanDataElement> dataElement,int valueNo );
		
		
		public String maxIdentifier(CleanDataElement o);
		
		public void setIdentifier(CleanDataElement dataElement);
		
		public void deleteByName(CleanDataElement dataElement);
		
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
		public abstract void transferByIds(CleanDataElement o,String ids);
		/** 
		* @Title: transferFather 
		* @Description: TODO(将ids的数据元成为id数据元的子集) 
		* @param @param o    设定文件 
		* @return void    返回类型 
		* 2017年3月28日    日期   
		*/ 
		public abstract void setFatherIdByIds(CleanDataElement o,String ids);
		
		/** 
		* @Title: deleteByNameInIds 
		* @Description: TODO(删除同义词数据元处理) 
		* @param @param dataElement
		* @param @param ids    设定文件 
		* @return void    返回类型 
		* 2017年3月28日    日期   
		*/ 
		public abstract void deleteByNameInIds(CleanDataElement dataElement,String ids);
		
		
		/** 
		* @Title: findByPage 
		* @Description: TODO(获得没有父级和子集的数据元) 
		* @param @param o
		* @param @param page
		* @param @return    设定文件 
		* @return List<DataElement>    返回类型 
		* 2017年2月6日    日期   
		*/ 
		public Page<CleanDataElement> findSingleDataElementByPage(CleanDataElement o,Page<CleanDataElement> page);
		
		/** 
		* @Title: importList 
		* @Description: TODO(批量导入) 
		* @param @param list    设定文件 
		* @return void    返回类型 
		* 2017年3月29日    日期   
		*/ 
		public void importList(List<DataElement> list);
		
		
		/** 
		* @Title: getUseCount 
		* @Description: TODO(统计使用频率) 
		* @param @return    设定文件 
		* @return List<CleanDataElement>    返回类型 
		* 2017年3月30日    日期   
		*/ 
		public Page<CleanDataElement> findUseCountByPage(CleanDataElement o,Page<CleanDataElement> page);
		

		/** 
		* @Title: updateSystemType 
		* @Description: TODO(批量设置公共数据元) 
		* @param @param systemType
		* @param @param ids    设定文件 
		* @return void    返回类型 
		* 2017年3月30日    日期   
		*/ 
		public void updateSystemType(Integer systemType,Integer [] ids);
		
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
		public Page<CleanDataElement> findDataElementByResId(CleanDataElement dataElement,Page<CleanDataElement> page);
}
