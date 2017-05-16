package com.govmade.common.utils;


import java.util.Map;

public abstract class CachedDataHandler<K,V> extends DataHandler{
	private Map<K,V> cache=initCacheMap();
	public abstract Map<K,V> initCacheMap();
	public V getCache(K key){
		return cache.get(key);
	}
}
