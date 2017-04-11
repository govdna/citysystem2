package com.govmade.service.base;

import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.govmade.common.mybatis.Page;
import com.govmade.entity.base.BaseEntity;
import com.govmade.entity.system.resources.Resources;
import com.govmade.repository.base.GovmadeBaseDao;

import net.sf.json.JSONArray;


public class GovmadeBaseServiceImp<T> implements BaseService<T>{

	protected Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	protected GovmadeBaseDao<T> baseDao;

	@Override
	public void insert(T o) {
		if(o instanceof BaseEntity){
			if(((BaseEntity)o).getTimeCreate()==null){
				((BaseEntity)o).setTimeCreate(new Date());
			}
			if(((BaseEntity)o).getTimeModified()==null){
				((BaseEntity)o).setTimeModified(new Date());
			}
		}
		baseDao.insert(o);
	}

	@Override
	public void delete(T o) {
		baseDao.delete(o);
	}
	
	@Override
	public void deleteBatch(List<T> os){
		baseDao.deleteBatch(os);
	}

	@Override
	public void update(T o) {
		if(o instanceof BaseEntity){
			if(((BaseEntity)o).getTimeModified()==null){
				((BaseEntity)o).setTimeModified(new Date());
			}
		}
		baseDao.update(o);
	}

	@Override
	public List<T> find(T o) {
		return baseDao.find(o,null,null);
	}
	
	
	public T findById(T o) {
		List<T> t =baseDao.find(o,null,null);		
		if(t!=null&&t.size()>0){
			return  t.get(0);
		}
		return o;
	}
	
	@Override
	public Page<T> findByPage(T o, Page<T> page) {
		page.setResults(baseDao.findByPage(o, page,null,null));
		return page;
	}

	@Override
	public int count(T o) {
		return baseDao.count(o);
	}

	@Override
	public List<T> find(T o, String orderBy, String sort) {
		return  baseDao.find(o,orderBy,sort);
	}

	@Override
	public List<T> findByPage(T o, String orderBy, String sort) {
		return  baseDao.findByPage(o,orderBy,sort);
	}
	
	@Override
	public Page<T> findByPage(T o, Page<T> page, String orderBy, String sort) {
		page.setResults(baseDao.findByPage(o,page,orderBy,sort));
		return  page;
	}

	@Override
	public void deletePhysically(T o) {
		baseDao.deletePhysically(o);
	}

	@Override
	public void deleteBatchPhysically(List<T> os) {
		baseDao.deleteBatchPhysically(os);
	}
}
