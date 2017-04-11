package com.govmade.service.system.dict;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.common.utils.SecurityUtil;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.repository.system.dict.GovmadeDicDAO;
import com.govmade.repository.system.organization.CompanyDAO;
import com.govmade.service.base.GovmadeBaseServiceImp;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("GovmadeDicService")
public class GovmadeDicServiceImp extends GovmadeBaseServiceImp<GovmadeDic> implements GovmadeDicService {

	@Autowired
	private GovmadeDicDAO govmadeDicDAO;
	
	private static Map<Integer,List<GovmadeDic>> cache=new HashMap<Integer,List<GovmadeDic>>();
	private static Map<String,Integer> idMap=new HashMap<String,Integer>();
	private long initedTime=0;
	
	
	private  synchronized void initDicCache(){
		if(System.currentTimeMillis()-initedTime<1000){
			return;
		}
		initedTime=System.currentTimeMillis();
		System.out.println("-------建立数据字典缓存-------");
		cache.clear();
		idMap.clear();
		List<GovmadeDic> list =find(new GovmadeDic(),"level_s,list_no","asc");
		for(GovmadeDic dic:list){
			if(dic.getLevel().intValue()==1){
				idMap.put(dic.getDicNum(), dic.getId());
			}else{
				putDicToCache(dic);
			}
		}
	}
	
	@Override
	public void insert(GovmadeDic o) {
		// TODO Auto-generated method stub
		super.insert(o);
		initDicCache();
	}

	@Override
	public void delete(GovmadeDic o) {
		// TODO Auto-generated method stub
		super.delete(o);
		initDicCache();
	}

	@Override
	public void deleteBatch(List<GovmadeDic> os) {
		// TODO Auto-generated method stub
		super.deleteBatch(os);
		initDicCache();
	}

	@Override
	public void update(GovmadeDic o) {
		// TODO Auto-generated method stub
		super.update(o);
		initDicCache();
	}

	@Override
	public void deletePhysically(GovmadeDic o) {
		// TODO Auto-generated method stub
		super.deletePhysically(o);
		initDicCache();
	}

	@Override
	public void deleteBatchPhysically(List<GovmadeDic> os) {
		// TODO Auto-generated method stub
		super.deleteBatchPhysically(os);
		initDicCache();
	}

	private void putDicToCache(GovmadeDic dic){
		if(dic==null||dic.getRootId()==null){
			return;
		}
		List<GovmadeDic> list=cache.get(dic.getRootId());
		if(list==null){
			list=new ArrayList<GovmadeDic>();
		}
		list.add(dic);
		cache.put(dic.getRootId(), list);
	}
	
	
	
	@Override
	public JSONArray getJqGridTreeJson(GovmadeDic g) {
		List<GovmadeDic> list =sort(find(g,"level_s,list_no","asc"),g);
		if(list==null||list.size()==0){
			return new JSONArray();
		}
		JSONArray re = new JSONArray();
		for (GovmadeDic p : list) {
			JSONObject menu=JSONObject.fromObject(p);
			menu.put("idForShow", SecurityUtil.encrypt(p.getId()));
			menu.put("isLeaf", isLeaf(p,list));
			menu.put("expanded", true);
			re.add(menu);
		}
		return re;
	}
	
	@Override
	public JSONArray getSonJson(GovmadeDic g) {
		List<GovmadeDic> list =sort(getDicList(g),g);
		if(list==null||list.size()==0){
			return new JSONArray();
		}
		JSONArray re = new JSONArray();
		for (GovmadeDic p : list) {
			JSONObject menu=JSONObject.fromObject(p);
			re.add(menu);
		}
		return re;
	}

	//是否是叶子节点
	private boolean isLeaf(GovmadeDic p,List<GovmadeDic> list){
		for(GovmadeDic pp:list){
			if(pp.getFatherId().intValue()==p.getId().intValue()){
				return false;
			}
		}
		return true;
	}
	
	
	
	//对树进行排序
		public List<GovmadeDic> sort(List<GovmadeDic> list,GovmadeDic g) {
			if(list==null||list.size()<=1){
				return list;
			}
			List<GovmadeDic> ps = new ArrayList<GovmadeDic>();
			for (GovmadeDic p : list) {
				if(g.getRootId()!=null){
					if(p.getFatherId() == null || p.getFatherId().intValue()== g.getRootId().intValue()){
						ps.add(p);
						ps.addAll(getTreeChild(p, list));
					}
					
				}else{
					if(p.getFatherId() == null || p.getFatherId() == 0){
						ps.add(p);
						ps.addAll(getTreeChild(p, list));
					}
					
				}
					
			}
			return ps;
		}

		public List<GovmadeDic> getTreeChild(GovmadeDic parent, List<GovmadeDic> list) {
			List<GovmadeDic> re = new ArrayList<GovmadeDic>();
			for (GovmadeDic p : list) {
				if (p.getFatherId().intValue() == parent.getId()) {
					re.add(p);
					List<GovmadeDic> ps = getTreeChild(p, list);
					if (ps.size() > 0) {
						re.addAll(ps);
					}
				}
			}
			return re;
		}

		@Override
		public List<GovmadeDic> getDicList(GovmadeDic g) {
			if(g.getDicNum()!=null&&g.getDicKey()!=null){
				Integer id=idMap.get(g.getDicNum());
				if(id==null){
					initDicCache();
				}
				List<GovmadeDic> list=cache.get(id);
				if(list!=null&&list.size()>0){
					List<GovmadeDic> result=new ArrayList<GovmadeDic>();
					for(GovmadeDic dic:list){
						if(dic.getDicKey().equals(g.getDicKey())){
							result.add(dic);
						}
					}
					if(result.size()>0){
						return result;
					}
				}
			}
			return govmadeDicDAO.getDicList(g);
		}

		@Override
		public List<GovmadeDic> getDicTreeList(GovmadeDic g) {
			return govmadeDicDAO.getDicTreeList(g);
		}

		@Override
		public List<GovmadeDic> getDicByNumKey(GovmadeDic g) {
			return govmadeDicDAO.getDicByNumKey(g);
		}

}
