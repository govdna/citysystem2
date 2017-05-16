package com.govmade.common.utils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.service.system.dict.GovmadeDicService;


public class DataHandlerFactory {
	private static GovmadeDicService govmadeDicService=(GovmadeDicService)ServiceUtil.getService("GovmadeDicService");
	private static Map<String,DataHandler> cache=new HashMap<String,DataHandler>();
	
	
	/** 
	* @Title: buildIntKeyHandler 
	* @Description: TODO(生成使用缓存速度更快的CachedDataHandler) 
	* @param @param serviceName 
	* @param @param po 供service find方法调用的对象
	* @param @param key 作为键的对象属性名，必须是Integer类型
	* @param @param value 作为值的对象属性名，必须是Integer类型
	* @param @return    设定文件 
	* @return DataHandler    返回类型 
	* 2017年5月15日    日期   
	*/ 
	public static DataHandler buildIntKeyHandler(final String serviceName,final Object po,final String key,final String value){
		return buildIntKeyHandler(serviceName, po, key, value,DataHandler.ADD_MODE);
	}
	
	/** 
	* @Title: buildDicHandler 
	* @Description: TODO(生成使用缓存速度更快的数据字典CachedDataHandler) 
	* @param @param dicNum 字典号
	* @param @return    设定文件 
	* @return DataHandler    返回类型 
	* 2017年5月15日    日期   
	*/ 
	public static DataHandler buildDicHandler(final String dicNum){
		return buildDicHandler(dicNum, DataHandler.ADD_MODE);
	}
	
	/** 
	* @Title: buildDicHandler 
	* @Description: TODO(生成使用缓存速度更快的数据字典CachedDataHandler) 
	* @param @param dicNum 字典号
	* @param @param mode
	* @param @return    设定文件 
	* @return DataHandler    返回类型 
	* 2017年5月15日    日期   
	*/ 
	public static DataHandler buildDicHandler(final String dicNum,final int mode){
		String cacheKey=dicNum+"|"+mode;
		DataHandler handler=cache.get(cacheKey);
		if(handler!=null){
			return handler;
		}
		 handler=new CachedDataHandler<String, String>() {

			@Override
			public Map<String, String> initCacheMap() {
				Map<String, String> map=new HashMap<String, String>();
				GovmadeDic dic=new GovmadeDic();
				dic.setDicNum(dicNum);
				List<GovmadeDic> list=govmadeDicService.getDicTreeList(dic);
				if(list!=null){
					for(GovmadeDic d:list){
						map.put(d.getDicKey(), d.getDicValue());
					}
				}
				return map;
			}

			@Override
			public Object doHandle(Object obj) {
				if(obj instanceof Integer) {
					return getCache(""+((Integer)obj));
				}
				return getCache(obj.toString());
			}

			@Override
			public int getMode() {
				return mode;
			}
		
		};
		cache.put(cacheKey, handler);
		return handler;
	}
	
	
	
	/** 
	* @Title: buildIntKeyHandler 
	* @Description: TODO(生成使用缓存速度更快的CachedDataHandler) 
	* @param @param serviceName
	* @param @param po 供service find方法调用的对象
	* @param @param key 作为键的对象属性名，必须是Integer类型
	* @param @param value 作为值的对象属性名，必须是Integer类型
	* @param @param mode DataHandler mode
	* @param @return    设定文件 
	* @return DataHandler    返回类型 
	* 2017年5月15日    日期   
	*/ 
	public static DataHandler buildIntKeyHandler(final String serviceName,final Object po,final String key,final String value,final int mode){
		String cacheKey=serviceName+"|"+key+"|"+value+"|"+mode;
		DataHandler handler=cache.get(cacheKey);
		if(handler!=null){
			return handler;
		}
		 handler=new CachedDataHandler<Integer, String>() {

			@Override
			public Map<Integer, String> initCacheMap() {
				Map<Integer, String> map=new HashMap<Integer, String>();
				List list=ServiceUtil.getService(serviceName).find(po);
				if(list!=null){
					for(Object c:list){
						map.put((Integer)ObjectUtil.getFieldValueByName(key, c),(String)ObjectUtil.getFieldValueByName(value, c));
					}
				}
				return map;
			}

			@Override
			public Object doHandle(Object obj) {
				if(obj instanceof String) {
					return getCache(Integer.valueOf((String)obj));
				}
				return getCache((Integer)obj);
			}

			@Override
			public int getMode() {
				return mode;
			}
		
		};
		cache.put(cacheKey, handler);
		return handler;
	}
}
