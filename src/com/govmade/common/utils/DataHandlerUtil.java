package com.govmade.common.utils;

import java.util.List;
import java.util.Map;

import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.entity.system.customFields.DataElementFields;
import com.govmade.entity.system.customFields.SimpleFields;
import com.govmade.entity.system.data.DataManager;
import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.memorizer.GovMemorizer;
import com.govmade.entity.system.model.HouseModelFields;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.server.GovServer;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.service.system.data.DataElementFieldsService;
import com.govmade.service.system.data.DataManagerService;
import com.govmade.service.system.model.HouseModelFieldsService;
import com.govmade.service.system.simpleFields.SimpleFieldsService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class DataHandlerUtil {
	public static final String JSON_FOR_SHOW = "ForShow";
	private static SimpleFieldsService service;
	private static HouseModelFieldsService houseModelFieldsService;
	private static DataElementFieldsService dataElementFieldsService;
	private static DataManagerService dataManagerService;
	
	public static SimpleFieldsService getService() {
		if(service==null){
			service=(SimpleFieldsService) ServiceUtil.getService("SimpleFieldsService");
		}
		return service;
	}
	public static DataElementFieldsService getDataElementFieldsService() {
		if(dataElementFieldsService==null){
			dataElementFieldsService=(DataElementFieldsService) ServiceUtil.getService("DataElementFieldsService");
		}
		return dataElementFieldsService;
	}
	public static DataManagerService getDataManagerService() {
		if(dataManagerService==null){
			dataManagerService=(DataManagerService) ServiceUtil.getService("DataManagerService");
		}
		return dataManagerService;
	}
	public static HouseModelFieldsService getHouseModelFieldsService() {
		if(houseModelFieldsService==null){
			houseModelFieldsService=(HouseModelFieldsService) ServiceUtil.getService("HouseModelFieldsService");
		}
		return houseModelFieldsService;
	}

	public static JSONArray buildJson(List list, Map<String, DataHandler> maps, boolean isFilter) {

		JSONArray ja = new JSONArray();
		if (list != null) {

			for (Object obj : list) {
				ja.add(dataFilter(obj, maps, isFilter));
			}

		}
		return ja;
	}

	public static JSONObject dataFilter(Object obj, Map<String, DataHandler> maps, boolean isFilter) {
		if (obj == null) {
			return null;
		}
		String[] fileds = ObjectUtil.getFiledName(obj);
		JSONObject jo = new JSONObject();
		for (String filed : fileds) {
			Object value = ObjectUtil.getFieldValueByName(filed, obj);
			if (isFilter) {
				if (maps.get(filed) != null) {
					DataHandler handler = maps.get(filed);
					if (handler.getMode() == DataHandler.ADD_MODE) {
						if (value != null) {
							jo.put(filed + JSON_FOR_SHOW, handler.doHandle(value));
						} else {
							jo.put(filed + JSON_FOR_SHOW, "");

						}
						jo.put(filed, value == null ? "" : value);
					} else if (handler.getMode() == DataHandler.REPLACE_MODE) {
						jo.put(filed, handler.doHandle(value));
					} else if (handler.getMode() == DataHandler.REPLACE_NEWNAME_MODE) {
						jo.put(filed + JSON_FOR_SHOW, handler.doHandle(value));
					} else if (handler.getMode() == DataHandler.FREEDOM_MODE) {
						handler.doHandle(obj, jo);
					}
				} else {
					jo.put(filed, value == null ? "" : value);
				}
			} else {
				jo.put(filed, value == null ? "" : value);
			}
		}
		return jo;
	}

	
	public static Map<String, DataHandler> buildSimpleFieldsDataHandlers(Map<String, DataHandler> map,Class c) {
		return buildSimpleFieldsDataHandlers(map,c,false);
	}
	/** 
	* @Title: getDataHandlers 
	* @Description: TODO(自定义字段生成DataHandlers) 
	* @param @param map
	* @param @return    设定文件 
	* @return Map<String,DataHandler>    返回类型 
	* 2017年3月1日    日期   
	*/ 
	public static Map<String, DataHandler> buildSimpleFieldsDataHandlers(Map<String, DataHandler> map,Class c,boolean isShowAll) {
		String className=c.getSimpleName();
		SimpleFields sp=new SimpleFields();
		sp.setClassName(className);
		List<SimpleFields> list=getService().find(sp);
		for(final SimpleFields sf:list){
			if(isShowAll||(sf.getIsShow()!=null&&sf.getIsShow().intValue()==1)){
				map.put("value"+sf.getValueNo(), new DataHandler() {
					
					@Override
					public int getMode() {
						return ADD_MODE;
					}
					
					@Override
					public Object doHandle(Object obj) {
						if(sf.getInputType().equals("2")){
							return ServiceUtil.getDicValue(sf.getInputValue(), (String)obj);
						}else if(sf.getInputType().equals("3")){
							List<ItemSort> ls=ServiceUtil.getService("ItemSortService").find(ServiceUtil.buildBean("ItemSort@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getItemName();
							}
						}else if(sf.getInputType().equals("5")){
							List<Company> ls=ServiceUtil.getService("CompanyService").find(ServiceUtil.buildBean("Company@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getCompanyName();
							}
						}else if(sf.getInputType().equals("7")){
							List<GovServer> ls=ServiceUtil.getService("GovServerService").find(ServiceUtil.buildBean("GovServer@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("8")){
							List<GovMemorizer> ls=ServiceUtil.getService("GovMemorizerService").find(ServiceUtil.buildBean("GovMemorizer@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("9")){
							List<GovComputerRoom> ls=ServiceUtil.getService("GovComputerRoomService").find(ServiceUtil.buildBean("GovComputerRoom@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("10")){
							List<GovApplicationSystem> ls=ServiceUtil.getService("GovApplicationSystemService").find(ServiceUtil.buildBean("GovApplicationSystem@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("12")){
							List<GovDatabase> ls=ServiceUtil.getService("GovDatabaseService").find(ServiceUtil.buildBean("GovDatabase@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue2();
							}
						}else if(sf.getInputType().equals("13")){
							List<GovTable> ls=ServiceUtil.getService("GovTableService").find(ServiceUtil.buildBean("GovTable@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("14")){
							List<GovTableField> ls=ServiceUtil.getService("GovTableFieldService").find(ServiceUtil.buildBean("GovTableField@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}
						return obj;
					}
				});
			}
		}
		return map;
	}

	public static Map<String, DataHandler> buildModelDataHandlers(Map<String, DataHandler> map,Integer type ) {
		
		HouseModelFields houseModelFields=new HouseModelFields();
		houseModelFields.setModelType(type);
		List<HouseModelFields> list=getHouseModelFieldsService().find(houseModelFields);
		
		for(final HouseModelFields sf:list){
			if(sf.getIsShow()!=null&&sf.getIsShow()==1){
				map.put("value"+sf.getValueNo(), new DataHandler() {					
					@Override
					public int getMode() {
						return ADD_MODE;
					}					
					@Override
					public Object doHandle(Object obj) {
						if(sf.getInputType().equals("2")){
							return ServiceUtil.getDicValue(sf.getInputValue(), (String)obj);
						}else if(sf.getInputType().equals("3")){
							List<ItemSort> ls=ServiceUtil.getService("ItemSortService").find(ServiceUtil.buildBean("ItemSort@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getItemName();
							}
						}else if(sf.getInputType().equals("5")){
							List<Company> ls=ServiceUtil.getService("CompanyService").find(ServiceUtil.buildBean("Company@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getCompanyName();
							}
						}else if(sf.getInputType().equals("7")){
							List<GovServer> ls=ServiceUtil.getService("GovServerService").find(ServiceUtil.buildBean("GovServer@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("8")){
							List<GovMemorizer> ls=ServiceUtil.getService("GovMemorizerService").find(ServiceUtil.buildBean("GovMemorizer@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("9")){
							List<GovComputerRoom> ls=ServiceUtil.getService("GovComputerRoomService").find(ServiceUtil.buildBean("GovComputerRoom@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("10")){
							List<GovApplicationSystem> ls=ServiceUtil.getService("GovApplicationSystemService").find(ServiceUtil.buildBean("GovApplicationSystem@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("12")){
							List<GovDatabase> ls=ServiceUtil.getService("GovDatabaseService").find(ServiceUtil.buildBean("GovDatabase@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue2();
							}
						}else if(sf.getInputType().equals("13")){
							List<GovTable> ls=ServiceUtil.getService("GovTableService").find(ServiceUtil.buildBean("GovTable@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("14")){
							List<GovTableField> ls=ServiceUtil.getService("GovTableFieldService").find(ServiceUtil.buildBean("GovTableField@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}
						return null;
					}
				});
			}
		}
		return map;
	}
	
	public static Map<String, DataHandler> buildRdataElementDataHandlers(Map<String, DataHandler> map) {
		//String className=c.getSimpleName();
		DataElementFields sp=new DataElementFields();
		//sp.setClassName(className);
		List<DataElementFields> list=getDataElementFieldsService().find(sp);
		for(final DataElementFields sf:list){
			if(sf.getIsShow()!=null&&sf.getIsShow().intValue()==1){
				map.put("value"+sf.getValueNo(), new DataHandler() {
					
					@Override
					public int getMode() {
						return ADD_MODE;
					}
					
					@Override
					public Object doHandle(Object obj) {
						if(sf.getInputType().equals("2")){
							return ServiceUtil.getDicValue(sf.getInputValue(), (String)obj);
						}else if(sf.getInputType().equals("3")){
							List<ItemSort> ls=ServiceUtil.getService("ItemSortService").find(ServiceUtil.buildBean("ItemSort@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getItemName();
							}
						}else if(sf.getInputType().equals("5")){
							List<Company> ls=ServiceUtil.getService("CompanyService").find(ServiceUtil.buildBean("Company@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getCompanyName();
							}
						}else if(sf.getInputType().equals("7")){
							List<GovServer> ls=ServiceUtil.getService("GovServerService").find(ServiceUtil.buildBean("GovServer@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("8")){
							List<GovMemorizer> ls=ServiceUtil.getService("GovMemorizerService").find(ServiceUtil.buildBean("GovMemorizer@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("9")){
							List<GovComputerRoom> ls=ServiceUtil.getService("GovComputerRoomService").find(ServiceUtil.buildBean("GovComputerRoom@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("10")){
							List<GovApplicationSystem> ls=ServiceUtil.getService("GovApplicationSystemService").find(ServiceUtil.buildBean("GovApplicationSystem@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("12")){
							List<GovDatabase> ls=ServiceUtil.getService("GovDatabaseService").find(ServiceUtil.buildBean("GovDatabase@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue2();
							}
						}else if(sf.getInputType().equals("13")){
							List<GovTable> ls=ServiceUtil.getService("GovTableService").find(ServiceUtil.buildBean("GovTable@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("14")){
							List<GovTableField> ls=ServiceUtil.getService("GovTableFieldService").find(ServiceUtil.buildBean("GovTableField@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}
						return null;
					}
				});
			}
		}
		return map;
	}
	
	public static Map<String, DataHandler> buildDataManagerDataHandlers(Map<String, DataHandler> map) {
		List<DataManager> list = getDataManagerService().find(new DataManager());
		for (final DataManager sf : list) {
			map.put("value" + sf.getValueNo(), new DataHandler() {
				@Override
				public int getMode() {
					return ADD_MODE;
				}
				@Override
				public Object doHandle(Object obj) {
					if (sf.getInputType().equals("2")) {
						return ServiceUtil.getDicValue(sf.getInputValue(), (String) obj);
					} else if (sf.getInputType().equals("3")) {
						List<ItemSort> ls = ServiceUtil.getService("ItemSortService")
								.find(ServiceUtil.buildBean("ItemSort@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getItemName();
						}
					} else if (sf.getInputType().equals("5")) {
						List<Company> ls = ServiceUtil.getService("CompanyService")
								.find(ServiceUtil.buildBean("Company@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getCompanyName();
						}
					} else if (sf.getInputType().equals("7")) {
						List<GovServer> ls = ServiceUtil.getService("GovServerService")
								.find(ServiceUtil.buildBean("GovServer@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					} else if (sf.getInputType().equals("8")) {
						List<GovMemorizer> ls = ServiceUtil.getService("GovMemorizerService")
								.find(ServiceUtil.buildBean("GovMemorizer@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					} else if (sf.getInputType().equals("9")) {
						List<GovComputerRoom> ls = ServiceUtil.getService("GovComputerRoomService")
								.find(ServiceUtil.buildBean("GovComputerRoom@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					} else if (sf.getInputType().equals("10")) {
						List<GovApplicationSystem> ls = ServiceUtil.getService("GovApplicationSystemService")
								.find(ServiceUtil.buildBean("GovApplicationSystem@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					} else if (sf.getInputType().equals("12")) {
						List<GovDatabase> ls = ServiceUtil.getService("GovDatabaseService")
								.find(ServiceUtil.buildBean("GovDatabase@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue2();
						}
					} else if (sf.getInputType().equals("13")) {
						List<GovTable> ls = ServiceUtil.getService("GovTableService")
								.find(ServiceUtil.buildBean("GovTable@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					} else if (sf.getInputType().equals("14")) {
						List<GovTableField> ls = ServiceUtil.getService("GovTableFieldService")
								.find(ServiceUtil.buildBean("GovTableField@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					}
					return obj;
				}
			});
		}
		return map;
	}
	
}
