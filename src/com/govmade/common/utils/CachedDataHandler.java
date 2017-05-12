package com.govmade.common.utils;


import java.util.Map;

public abstract class CachedDataHandler extends DataHandler{
	private Map<Object,Object> cache=initCacheMap();
	public abstract Map<Object,Object> initCacheMap();
	public Object getCache(Object key){
		return cache.get(key);
	}
}
