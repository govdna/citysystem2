package com.govmade.service.base;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.govmade.common.mybatis.Page;
import com.govmade.repository.base.BaseDao;


public class BaseServiceImp<T> implements BaseService<T>{

	protected Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	protected BaseDao<T> baseDao;

	@Override
	public void insert(T o) {
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
		baseDao.update(o);
	}

	@Override
	public List<T> find(T o) {
		return baseDao.find(o);
	}

	
	public T findById(T o) {
		List<T> t =baseDao.find(o,null,null);		
		if(t!=null&&t.size()>0){
		 return	t.get(0);
		}
		return o;
	}

	
	@Override
	public Page<T> findByPage(T o, Page<T> page) {
		page.setResults(baseDao.findByPage(o, page));
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

	/* (non-Javadoc)
	 * @see com.govmade.service.base.BaseService#findByPage(java.lang.Object, java.lang.String, java.lang.String)
	 */
	@Override
	public List<T> findByPage(T o, String orderBy, String sort) {
		// TODO Auto-generated method stub
	 return baseDao.findByPage(o,orderBy,sort);
	}


}
