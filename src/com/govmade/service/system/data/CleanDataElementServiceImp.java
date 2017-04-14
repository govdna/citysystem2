package com.govmade.service.system.data;


import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.govmade.common.mybatis.Page;
import com.govmade.entity.base.BaseEntity;
import com.govmade.entity.system.data.CleanDataElement;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.SameDataElementConfig;
import com.govmade.repository.system.data.CleanDataElementDao;
import com.govmade.repository.system.data.DataElementDao;
import com.govmade.service.base.GovmadeBaseServiceImp;



/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan 数据元池
* @date 2017年3月23日 下午2:26:40   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: CleanDataElementServiceImp.java
* @Package com.govmade.service.system.data
* @version V1.0   
*/
@Service("CleanDataElementService")
public class CleanDataElementServiceImp extends GovmadeBaseServiceImp<CleanDataElement> implements  CleanDataElementService {

	@Autowired
	private CleanDataElementDao cleanDataElementDao;

	@Autowired
	private DataElementDao dataElementDao;
	
	
	@Override
	public void insertList(List<CleanDataElement> list) {
		for(CleanDataElement d:list){
			insert(d);
		}
	}

	@Override
	public void insert(DataElement dataElement) {
		
			if(dataElement.getTimeCreate()==null){
				dataElement.setTimeCreate(new Date());
			}
			if(dataElement.getTimeModified()==null){
				dataElement.setTimeModified(new Date());
			}
	
			cleanDataElementDao.insertDataElement(dataElement);
	}

	@Override
	public List<CleanDataElement> getRepeat() {
		return cleanDataElementDao.getRepeat();
	}

	@Override
	public List<CleanDataElement> findRepeatList(CleanDataElement dataElement) {
		return  cleanDataElementDao.findRepeatList(dataElement);
	}

	@Override
	public Map<String,Integer> compareList(List<CleanDataElement> dataElement, int valueNo) {
		Map<String,Integer> map=new HashMap<String,Integer>();
		for(CleanDataElement d:dataElement){
			String s=d.getValueByNo(valueNo);
			if(StringUtils.isNotEmpty(s)){
				Integer cs=map.get(s);
				if(cs==null){
					map.put(s, 1);
				}else{
					map.put(s, cs+1);
				}
			}
		}
		return map;
	}

	@Override
	public String maxIdentifier(CleanDataElement o) {
		return cleanDataElementDao.maxIdentifier(o);
	}

	@Override
	public void setIdentifier(CleanDataElement dataElement) {
		String i = maxIdentifier(dataElement);
		if (i != null && i != "") {
			i = Integer.valueOf(i) + 1 + "";
			while (i.length() < 7) {
				i = "0" + i;
			}
		} else {
			i = "0000001";
		}
		dataElement.setIdentifier(i);
	}

	@Override
	public void deleteByName(CleanDataElement name) {
		cleanDataElementDao.deleteByName(name);
	}

	@Override
	public List<CleanDataElement> findBySameConfig(List<SameDataElementConfig> list) {
		return cleanDataElementDao.findBySameConfig(list);
	}

	@Override
	public List<CleanDataElement> findByIds(Integer[] list) {
		return cleanDataElementDao.findByIds(list);
	}

	@Override
	public void transferFather(CleanDataElement o) {
		cleanDataElementDao.transferFather(o);
	}

	@Override
	public void transferByIds(CleanDataElement o, String ids) {
		cleanDataElementDao.transferByIds(o, ids);
	}

	@Override
	public void setFatherIdByIds(CleanDataElement o, String ids) {
		cleanDataElementDao.setFatherIdByIds(o, ids);
	}

	@Override
	public void deleteByNameInIds(CleanDataElement dataElement, String ids) {
		cleanDataElementDao.deleteByNameInIds(dataElement, ids);
	}

	@Override
	public Page<CleanDataElement> findSingleDataElementByPage(CleanDataElement o, Page<CleanDataElement> page) {
		page.setResults(cleanDataElementDao.findSingleDataElementByPage(o,page));
		return page;
	}
	@Transactional(rollbackFor = Exception.class)  
	@Override
	public void importList(List<DataElement> list) {
		for (DataElement d : list) {
			d.setImported(1);
			dataElementDao.update(d);
			d.setImported(0);
			d.setSourceId(d.getId());
			cleanDataElementDao.insertDataElement(d);
		}
	}

	@Override
	public Page<CleanDataElement> findUseCountByPage(CleanDataElement o, Page<CleanDataElement> page) {
		page.setResults(cleanDataElementDao.findUseCountByPage(o,page));
		return page;
	}

	@Override
	public void updateSystemType(Integer systemType, Integer[] ids) {
		cleanDataElementDao.updateSystemType(systemType, ids);
	}

	@Override
	public void deleteAll() {
		cleanDataElementDao.deleteAll();
	}


	@Override
	public Page<CleanDataElement> findDataElementByResId(CleanDataElement dataElement, Page<CleanDataElement> page) {
		page.setResults(cleanDataElementDao.findDataElementByResId(dataElement, page));
		return page;
	}

	

}

