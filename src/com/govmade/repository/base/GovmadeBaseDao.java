package com.govmade.repository.base;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.govmade.common.mybatis.Page;


public interface  GovmadeBaseDao<T> {
	/**
	 * 保存一个对象
	 * @param o 对象
	 * @return 对象的ID
	 */
	public  void insert(T o);
	/**
	 * 删除一个对象
	 * @param o  对象
	 */
	public  void delete(T o);
	/**
	 * 更新一个对象
	 * @param o 对象       
	 */
	public  void update(T o);
	/**
	 * 
	 * @param s (主键)数组
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
	
	public abstract List<T> find(@Param("param")T o,@Param("sort")String orderBy,@Param("orderBy")String sort);	
	public abstract List<T> findByPage(@Param("param")T o,@Param("sort")String orderBy,@Param("orderBy")String sort);	
	/**
	 * 获得对象列表
	 * @param o 对象       
	 * @param page 分页对象
	 * @return List
	 */
	public abstract List<T> findByPage(@Param("param")T o,Page<T> page,@Param("sort")String orderBy,@Param("orderBy")String sort);
	
	/**
	 * 统计数目
	 * @param o 对象      
	 * @return long
	 */
	public abstract int count(T o);
}
