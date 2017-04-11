package com.govmade.service.system.information;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.information.Subscribe;
import com.govmade.entity.system.model.HouseModel;
import com.govmade.entity.system.organization.Company;
import com.govmade.repository.system.data.DataListDao;
import com.govmade.repository.system.dict.GovmadeDicDAO;
import com.govmade.repository.system.information.InformationBusinessDao;
import com.govmade.repository.system.information.InformationResDao;
import com.govmade.repository.system.information.InformationResourceDao;
import com.govmade.service.base.GovmadeBaseServiceImp;
import com.govmade.service.system.dict.GovmadeDicService;



/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月22日 上午9:00:08   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: InformationResourceServiceImp.java
* @Package com.govmade.service.system.information
* @version V1.0   
*/
@Service("InformationResourceService")
public class InformationResourceServiceImp extends GovmadeBaseServiceImp<InformationResource> implements InformationResourceService {
	@Autowired
	private InformationResourceDao informationResourceDao;
	@Autowired
	private DataListDao dataListDao;
	
	@Override
	public void clearColumn(int no) {
		informationResourceDao.clearColumn(no);
	}
	
	@Override
	public void updateStatus(InformationResource info) {
		informationResourceDao.updateStatus(info);
	}
	@Override
	public InformationResource tree(InformationResource info){
		return informationResourceDao.tree(info);
	}

	@Override
	public String getMaxCode(InformationResource o) {
		return informationResourceDao.getMaxCode(o);
	}
	@Override
	public List<InformationResource> cpcount(InformationResource info){
		return informationResourceDao.cpcount(info);
	}
	@Override
	public int datacount(InformationResource info){
		return informationResourceDao.datacount(info);
	}
	@Override
	public int sharecount(InformationResource info){
		return informationResourceDao.sharecount(info);
	}
	@Override
	public List<Company> getInforResGroupByCompany() {
		return informationResourceDao.getInforResGroupByCompany();
	}

	@Override
	public void delete(InformationResource o) {
		baseDao.delete(o);
		DataList d=new DataList();
		d.setDataManagerId(o.getId());
		dataListDao.deleteByDataManagerId(d);
	}

	@Override
	public List<InformationResource> getInformationResourceBySubscribe(Subscribe s) {
		return informationResourceDao.getInformationResourceBySubscribe(s);
	}

	@Override
	public void truncateTable() {
		informationResourceDao.truncateTable();
	}
	
	@Override
	public Date latestTime(Integer cpId){
		return informationResourceDao.latestTime(cpId);
	}

	@Override
	public void allPass() {
		informationResourceDao.allPass();
	}

	@Override
	public List<InformationResource> getInforResByDataElementIds(String ids) {
		return informationResourceDao.getInforResByDataElementIds(ids);
	}

	@Override
	public List<InformationResource> findExactly(InformationResource informationResource) {
		return informationResourceDao.findExactly(informationResource);
	}

	@Override
	public Map<Integer, Integer> countInforTypes(InformationResource info) {
		List<InformationResource> list2= informationResourceDao.countInforTypes2(info);
		List<InformationResource> list3= informationResourceDao.countInforTypes3(info);
		
		Map<Integer, Integer> map=new HashMap<Integer, Integer>();
		for(InformationResource infor:list2){
			map.put(infor.getInforTypes2(), infor.getStatus());
		}
		
		for(InformationResource infor:list3){
			map.put(infor.getInforTypes3(), infor.getStatus());
		}
		return map;
	}

	@Override
	public Map<String, Integer> countValue3(InformationResource info) {
		List<InformationResource> list2= informationResourceDao.countValue3(info);
		Map<String, Integer> map=new HashMap<String, Integer>();
		for(InformationResource infor:list2){
			map.put(infor.getValue3(), infor.getStatus());
		}
		return map;
	}

	
}