package com.govmade.service.system.data;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.entity.base.BaseEntity;
import com.govmade.entity.system.customFields.DataElementFields;
import com.govmade.entity.system.customFields.SimpleFields;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.data.DataManager;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.repository.system.data.DataElementDao;
import com.govmade.repository.system.data.DataElementFieldsDao;
import com.govmade.repository.system.data.DataListDao;
import com.govmade.repository.system.simpleFields.SimpleFieldsDao;
import com.govmade.service.base.GovmadeBaseServiceImp;

import net.sf.json.JSONObject;

/**
 * @author (作者) Chenlei 774329191@qq.com
 * @Description: CitySystem TODO
 * @date 2016年12月7日 上午8:56:13
 * @Title: DataElementServiceImp.java
 */
@Service("DataElementService")
public class DataElementServiceImp extends GovmadeBaseServiceImp<DataElement> implements DataElementService {

	@Autowired
	private DataElementDao dataElementDao;
	@Autowired
	private DataListDao dataListDao;
	@Autowired
	private DataElementFieldsDao dataElementFieldsDao;
	@Autowired
	private SimpleFieldsDao simpleFieldsDao;
	
	
	private static String maxIdentifier0;
	
	private static String maxIdentifier1;
	
	private static List<SimpleFields> simpleFieldList=new ArrayList<SimpleFields>();
	private static long initTime=0;
	@Override
	public List<DataElement> getDataElementListByInforResId(Integer inforResId, Integer objectType, String chName) {
		return dataElementDao.getDataElementListByInforResId(inforResId, objectType, chName);
	}

	@Override
	public List<DataElement> getDataElementListByHouseModelId(Integer houseModelId) {
		return dataElementDao.getDataElementListByHouseModelId(houseModelId);
	}
	@Override
	public List<DataElement> getDElistByHouseModelId(DataList dataList) {
		return dataElementDao.getDElistByHouseModelId(dataList);
	}
	
	@Override
	public List<DataElement> getDataElementListByIds(String ids) {
		return dataElementDao.getDataElementListByIds(ids);
	}

	@Override
	public List<DataElement> getDataElementListByDataList(DataList dataList) {
		return dataElementDao.getDataElementListByDataList(dataList);
	}
	
	@Override
	public Page<DataElement> getDataElementListByDataListPage(DataElement dataElement,Integer informationResId,Integer dataManagerId,String objType,String chName,Page<DataElement> page) {
		page.setResults(dataElementDao.getDataElementListByDataListPage(dataElement, informationResId,dataManagerId,objType,chName,page));
		return page;
	}
	
	@Override
	public List<DataElement> getDataElementListByInforResId2(Integer inforResId, DataElement dataElement) {
		return dataElementDao.getDataElementListByInforResId2(inforResId, dataElement);
	}

	@Override
	public List<DataElement> echarts(DataElement d) {
		return dataElementDao.echarts(d);
	}

	@Override
	public String maxIdentifier(DataElement o) {
		if(o.getClassType()==0){
			if(maxIdentifier0==null){
				maxIdentifier0=dataElementDao.maxIdentifier(o);
			}
			return maxIdentifier0;
		}else if(o.getClassType()==1){
			if(maxIdentifier1==null){
				maxIdentifier1=dataElementDao.maxIdentifier(o);
			}
			return maxIdentifier1;
		}
		return dataElementDao.maxIdentifier(o);
	}
	
	@Override
	public Page<DataElement> findSingleDataElementByPage(DataElement o, Page<DataElement> page) {
		page.setResults(dataElementDao.findSingleDataElementByPage(o,page));
		return page;
	}
	
	@Override
	public Page<DataElement> getDataElementListByDataManagerId(Integer inforResourceId, Integer objectType,
			String chName, Page<DataElement> page) {
		page.setResults(dataElementDao.getDataElementListByDataManagerId(inforResourceId, objectType,
				 chName,page));
		return page;
	}

	@Override
	public void clearColumn(int no) {
		dataElementDao.clearColumn(no);
	}

	@Override
	public List<DataElement> getChild(DataElement dataElement) {
		DataElement d = new DataElement();
		d.setFatherId(dataElement.getId());
		return dataElementDao.find(d, null, null);
	}

	private void initSimpleFieldsList(){
		if(System.currentTimeMillis()<initTime+1000){
			return;
		}
		initTime=System.currentTimeMillis();
		List<DataElementFields> dmList=dataElementFieldsDao.find(new DataElementFields(),null,null);
		SimpleFields field=new SimpleFields();
		field.setClassName(DataElement.class.getSimpleName());
		List<SimpleFields> sfList=simpleFieldsDao.find(field,null,null);
		simpleFieldList.clear();
		for(DataElementFields d:dmList){
			for(SimpleFields s:sfList){
				if(d.getName().equals(s.getName())&&d.getInputType().equals(s.getInputType())){
					SimpleFields sf=new SimpleFields();
					sf.setInputType(s.getInputType());
					sf.setCompanyId(d.getValueNo());
					sf.setGroupId(s.getValueNo());
					simpleFieldList.add(sf);
				}
			}
		}
		
	}
	private  DataElement cloneDataElement(DataElement d) throws Exception{
		initSimpleFieldsList();
		DataElement dataElement=new DataElement();
		for(SimpleFields s:simpleFieldList){
			String value=d.getValueByNo(s.getGroupId());
			ObjectUtil.setValue(dataElement, "value"+s.getCompanyId(), value);
		}
		return dataElement;
	}
	@Override
	public int copyDataElement(DataElement dataElement,Integer fatherId,Integer companyId,Integer groupId) {

		int fid;
		try {
			DataElement d = null;
			d = cloneDataElement(dataElement);
			d.setId(null);
			d.setSourceId(dataElement.getId());
			d.setClassType(1);
			d.setSystemType(dataElement.getSystemType());
			if(fatherId!=null){
				d.setFatherId(fatherId);
			}
			if(companyId!=null){
				d.setCompanyId(companyId);
				d.setValue8(companyId+"");
			}
			if(groupId!=null){
				d.setGroupId(groupId);
			}
			d.setStatus(0);
			d.setSourceType(1);
			setIdentifier(d);
			dataElementDao.insert(d);
			fid = dataElement.getId();
			dataElement.setImported(1);
			dataElementDao.update(dataElement);
			return d.getId();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}


	@Override
	public List<DataElement> getByCustomizationId(Integer id, DataElement dataElement) {
		return dataElementDao.getByCustomizationId(id,dataElement);
	}

	@Override
	public List<DataElement> countInfor(DataElement dataElement){
		return dataElementDao.countInfor(dataElement);
	}
	@Override
	public List<DataElement> countCom(DataElement dataElement){
		return dataElementDao.countCom(dataElement);
	}


	@Override
	public void toStatus(DataElement o) {
		dataElementDao.toStatus(o);
	}
	

	@Override
	public boolean volidate(DataElement dataElement) {
		List<DataElement> list=dataElementDao.volidate(dataElement);
		if(list!=null&&list.size()>0){
			return false;
		}
		return true;
	}


	@Override
	public void updateChildIdentifier(DataElement dataElement) {
		dataElementDao.updateChildIdentifier(dataElement);
	}



	@Override
	public void setChild(DataElement dataElement, String ids) {
		ids=StringUtil.toSQLArray(ids);
		if(StringUtils.isNotEmpty(ids)){
			dataElementDao.setChild(dataElement, ids);
		}
	}
	
	

	
	@Override
	public String findInforx(DataElement dataElement){
		return dataElementDao.findInforx(dataElement);
	}

	@Override
	public void clearImported(DataElement dataElement) {
		dataElementDao.clearImported(dataElement);
	}

	@Transactional(rollbackFor = Exception.class)  
	@Override
	public void insertList(List<DataElement> list) {
		for(DataElement d:list){
			dataElementDao.insert(d);
		}
	}

	@Override
	public void cleanTable(DataElement dataElement) {
		maxIdentifier0=null;
		maxIdentifier1=null;
		dataElementDao.cleanTable(dataElement);
	}

	@Override
	public void clearAllImported() {
		DataElement d=new DataElement();
		d.setClassType(0);
		dataElementDao.clearAllImported(d);
	}

	@Override
	public List<DataElement> findByName(DataElement dataElement) {
		return dataElementDao.findByName(dataElement,null,null);
	}
	@Override
	public List<DataElement> findByName(DataElement dataElement,String orderBy,String sort) {
		return dataElementDao.findByName(dataElement,orderBy,sort);
	}
	
	@Override
	public Date latestTime(Integer cpId){
		return dataElementDao.latestTime(cpId);
	}

	@Override
	public void statusAll() {
		dataElementDao.statusAll();
	}

	@Override
	public void actualDelByInforId(Integer id) {
		dataElementDao.actualDelByInforId(id);
	}

	@Override
	public DataElement getDataElementByChName(DataElement dataElement) {
		List<DataElement> list=dataElementDao.volidate(dataElement);
		return list.size()>0?list.get(0):null;
	}

	@Override
	public synchronized void setIdentifier(DataElement dataElement) {
	
		String i = maxIdentifier(dataElement);
		if (i != null && i != "") {
			i=String.format("%07d", Integer.valueOf(i) + 1);
		} else {
			i = "0000001";
		}
		if(dataElement.getClassType()==0){
			maxIdentifier0=i;
		}else if(dataElement.getClassType()==1){
			maxIdentifier1=i;
		}
		if (dataElement.getId() == null) {
			dataElement.setIdentifier(i);
		} 
	}

	@Override
	public List<DataElement> getDataElementListByTableId(GovTable table) {
		return dataElementDao.getDataElementListByTableId(table);
	}

	@Override
	public List<DataElement> findExactly(DataElement dataElement) {
		return dataElementDao.findExactly(dataElement);
	}

	@Override
	public void clearAllImported(DataElement dataElement) {
		dataElementDao.clearAllImported(dataElement);
	}

	@Override
	public List<DataElement> getUseCount() {
		return dataElementDao.getUseCount();
	}
	
	
	@Transactional(rollbackFor = Exception.class)  
	@Override
	public  void insertList(List<DataElement> list, int classType) {
		for (DataElement dm :list) {
			dm.setClassType(classType);
			dm.setSourceType(2);
			setIdentifier(dm);
			dm.setTimeCreate(new Date());
			dm.setTimeModified(new Date());
			dataElementDao.insert(dm);
		}
	}

	@Override
	public Map<String, Integer> getCompanyCount() {
		Map<String, Integer> map=new HashMap<String, Integer>();
		List<DataElement> list= dataElementDao.getCompanyCount();
		if(list!=null){
			for(DataElement de:list){
				map.put(de.getValue8(), de.getCounts());
			}
		}
		return map;
	}


}

