package com.govmade.service.base;

import java.util.List;

import com.govmade.common.mybatis.Page;

public interface BaseService<T> {
	/**
	 * 保存一个对象
	 * @param o 对象
	 * @return 对象的ID
	 */
	public void insert(T o);	
	/**
	 * 逻辑删除
	 * @param o  对象
	 */
	public void delete(T o);
	
	/**
	 * 物理删除
	 * @param o  对象
	 */
	public void deletePhysically(T o);
	 
	/**
	 * 批量删除一个对象
	 * @param s (主键)数组
	 */
	public void deleteBatch(List<T> os);
	
	/**
	 * 批量删除一个对象
	 * @param s (主键)数组
	 */
	public void deleteBatchPhysically(List<T> os);
	/**
	 * 更新一个对象
	 * @param o 对象       
	 */
	public void update(T o);
	/**
	 * 获得对象列表
	 * @param o 对象       
	 * @return List
	 */
	public List<T> find(T o);	
	/**
	 * 获得对象列表
	 * @param o 对象       
	 * @param page 分页对象
	 * @return 根据唯一值查找一条信息
	 */
	public T findById(T o);	
	/**
	 * 获得对象列表
	 * @param o 对象       
	 * @param page 分页对象
	 * @return List
	 */
	
	public Page<T> findByPage(T o,Page<T> page);	
	/**
	 * 统计数目
	 * @param o 对象      
	 * @return long
	 */
	public List<T> find(T o,String orderBy,String sort);	
	/**
	 * 获得对象列表
	 * @param o 对象       
	 * @param page 分页对象
	 * @return List
	 */
	public Page<T> findByPage(T o,Page<T> page,String orderBy,String sort);	
	
	
	public int count(T o);
	/**
	 * @param o
	 * @param orderBy
	 * @param sort
	 * @return
	 */
	public List<T> findByPage(T o,String orderBy, String sort);
}
