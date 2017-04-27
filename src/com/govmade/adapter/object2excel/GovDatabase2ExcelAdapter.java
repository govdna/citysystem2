package com.govmade.adapter.object2excel;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.poi.ss.usermodel.Sheet;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.Object2ExcelComplexAdapter;
import com.govmade.entity.system.customFields.SimpleFields;
import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.service.system.simpleFields.SimpleFieldsService;

public class GovDatabase2ExcelAdapter extends Object2ExcelComplexAdapter<GovDatabase> {
	private SimpleFieldsService simpleFieldsService = (SimpleFieldsService) ServiceUtil
			.getService("SimpleFieldsService");
	private String[] dbFields;
	private String[] tbFields;
	private String[] fdFields;
	private List<GovTable> tbList;
	private List<GovTableField> tfList;
	private Map<String,List<GovTableField>> tableFieldMap=new HashMap<String,List<GovTableField>>();
	private Map<String,List<GovTable>> tableMap=new HashMap<String,List<GovTable>>();
	private Map<String,DataHandler> dbMap;
	private Map<String,DataHandler> tbMap;
	private Map<String,DataHandler> tfMap;
	public String[] getDbFields() {
		return dbFields;
	}

	public void setDbFields(String[] dbFields) {
		this.dbFields = dbFields;
	}

	public String[] getTbFields() {
		return tbFields;
	}

	public void setTbFields(String[] tbFields) {
		this.tbFields = tbFields;
	}

	public String[] getFdFields() {
		return fdFields;
	}

	public void setFdFields(String[] fdFields) {
		this.fdFields = fdFields;
	}

	public List<GovTable> getTbList() {
		return tbList;
	}

	public void setTbList(List<GovTable> tbList) {
		this.tbList = tbList;
	}

	public List<GovTableField> getTfList() {
		return tfList;
	}

	public void setTfList(List<GovTableField> tfList) {
		this.tfList = tfList;
	}
	
	private void putTable(GovTable tb){
		List<GovTable> list;
		if(tableMap.containsKey(tb.getValue3())){
			list=tableMap.get(tb.getValue3());
		}else{
			list=new ArrayList<GovTable>();
		}
		list.add(tb);
		tableMap.put(tb.getValue3(), list);
	}
	
	private void putTableFiled(GovTableField tb){
		List<GovTableField> list;
		if(tableFieldMap.containsKey(tb.getValue3())){
			list=tableFieldMap.get(tb.getValue3());
		}else{
			list=new ArrayList<GovTableField>();
		}
		list.add(tb);
		tableFieldMap.put(tb.getValue3(), list);
	}

	public GovDatabase2ExcelAdapter(List<GovDatabase> dbList,List<GovTable> tbList,List<GovTableField> tfList,String[] dbFields, String[] tbFields, String[] fdFields) {
		super(dbList);
		this.tbList=tbList;
		if(tbList!=null){
			for(GovTable gt:tbList){
				putTable(gt);
			}
		}
		
		this.tfList=tfList;
		if(tfList!=null){
			for(GovTableField gt:tfList){
				putTableFiled(gt);
			}
		}
		this.dbFields=dbFields;
		this.tbFields=tbFields;
		this.fdFields=fdFields;
		dbMap=DataHandlerUtil.buildSimpleFieldsDataHandlers(new HashMap<String,DataHandler>(), GovDatabase.class, true);
		tbMap=DataHandlerUtil.buildSimpleFieldsDataHandlers(new HashMap<String,DataHandler>(), GovTable.class, true);
		tfMap=DataHandlerUtil.buildSimpleFieldsDataHandlers(new HashMap<String,DataHandler>(), GovTableField.class, true);
	}

	@Override
	public String[] getTitle() {
		List<String> titleList=new ArrayList<String>();
		SimpleFields sf=new SimpleFields();
		sf.setClassName(GovDatabase.class.getSimpleName());
		List<SimpleFields> dbfList=simpleFieldsService.find(sf);
		for(String fd:dbFields){
			for(SimpleFields sfs:dbfList){
				if(fd.equals("value"+sfs.getValueNo())){
					titleList.add(sfs.getName());
				}
			}
		}
		
		sf.setClassName(GovTable.class.getSimpleName());
		dbfList=simpleFieldsService.find(sf);
		for(String fd:tbFields){
			for(SimpleFields sfs:dbfList){
				if(fd.equals("value"+sfs.getValueNo())){
					titleList.add(sfs.getName());
				}
			}
		}
		sf.setClassName(GovTableField.class.getSimpleName());
		dbfList=simpleFieldsService.find(sf);
		for(String fd:fdFields){
			for(SimpleFields sfs:dbfList){
				if(fd.equals("value"+sfs.getValueNo())){
					titleList.add(sfs.getName());
				}
			}
		}
		String[] temp=new String [dbFields.length+tbFields.length+fdFields.length];
		return titleList.toArray(temp);
	}

	public String[] object2StrArray(GovDatabase t) {
		String[] str = new String[dbFields.length];
		for(int i=0;i<dbFields.length;i++){
			DataHandler dh=dbMap.get(dbFields[i]);
			Object val=ObjectUtil.getFieldValueByName(dbFields[i], t);
			if(dh!=null){
				if(val!=null&&dh.doHandle(val)!=null){
					str[i]=dh.doHandle(val).toString();
				}else{
					str[i]="";
				}
			}else{
				if(val==null){
					str[i]="";
				}else{
					str[i]=val.toString();
				}
			}
			
		}
		return str;
	}
	
	public String[] object2StrArray(GovTable t) {
		String[] str = new String[tbFields.length];
		for(int i=0;i<tbFields.length;i++){
			DataHandler dh=tbMap.get(tbFields[i]);
			Object val=ObjectUtil.getFieldValueByName(tbFields[i], t);
			if(dh!=null){
				if(val!=null&&dh.doHandle(val)!=null){
					str[i]=dh.doHandle(val).toString();
				}else{
					str[i]="";
				}
			}else{
				if(val==null){
					str[i]="";
				}else{
					str[i]=val.toString();
				}
			}
		}
		
		return str;
	}
	
	public String[] object2StrArray(GovTableField t) {
		String[] str = new String[fdFields.length];
		for(int i=0;i<fdFields.length;i++){
			DataHandler dh=tfMap.get(fdFields[i]);
			Object val=ObjectUtil.getFieldValueByName(fdFields[i], t);
			if(dh!=null){
				if(val!=null&&dh.doHandle(val)!=null){
					str[i]=dh.doHandle(val).toString();
				}else{
					str[i]="";
				}
			}else{
				if(val==null){
					str[i]="";
				}else{
					str[i]=val.toString();
				}
			}
			
		}
		return str;
	}

	@Override
	public List<String[]> object2List(GovDatabase t) {
		List<String[]> list=new ArrayList<String[]>();
		String[] dbStr=object2StrArray(t);
		List<GovTable> tableList=tableMap.get(t.getId()+"");
		if(tableList!=null&&(fdFields.length>0||tbFields.length>0)){
			for(GovTable gt:tableList){
				String[] tbStr=object2StrArray(gt);
				List<GovTableField> fieldList=tableFieldMap.get(gt.getId()+"");
				if(fieldList!=null&&fdFields.length>0){
					
					for(GovTableField filed:fieldList){
						String[] tfStr=object2StrArray(filed);
						List<String> temp=new ArrayList<String>();
						for(String str:dbStr){
							temp.add(str);
						}
						for(String str:tbStr){
							temp.add(str);
						}
						for(String str:tfStr){
							temp.add(str);
						}
						String[] tempArr=new String [dbFields.length+tbFields.length+fdFields.length];
						list.add(temp.toArray(tempArr));
					}
					
					
				}else{
					List<String> temp=new ArrayList<String>();
					for(String str:dbStr){
						temp.add(str);
					}
					for(String str:tbStr){
						temp.add(str);
					}
					String[] tempArr=new String [dbFields.length+tbFields.length+fdFields.length];
					list.add(temp.toArray(tempArr));
				}
				
			}
		}else{
			List<String> temp=new ArrayList<String>();
			for(String str:dbStr){
				temp.add(str);
			}
			String[] tempArr=new String [dbFields.length+tbFields.length+fdFields.length];
			list.add(temp.toArray(tempArr));
		}
		return list;
	}

	@Override
	public void doAfterEveryTime(List<String[]> list, Sheet sheet, int startRow, int endRow) {
		
		
	}

	public Map<String,DataHandler> getDbMap() {
		return dbMap;
	}

	public void setDbMap(Map<String,DataHandler> dbMap) {
		this.dbMap = dbMap;
	}

	public Map<String,DataHandler> getTbMap() {
		return tbMap;
	}

	public void setTbMap(Map<String,DataHandler> tbMap) {
		this.tbMap = tbMap;
	}

	public Map<String,DataHandler> getTfMap() {
		return tfMap;
	}

	public void setTfMap(Map<String,DataHandler> tfMap) {
		this.tfMap = tfMap;
	}

	

}
