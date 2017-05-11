package com.govmade.adapter.object2excel;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;

import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.Object2ExcelAdapter;
import com.govmade.common.utils.poi.Object2ExcelComplexAdapter;
import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.entity.system.customFields.DataElementFields;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.data.DataManager;
import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.memorizer.GovMemorizer;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.server.GovServer;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.service.system.data.DataElementFieldsService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.data.DataManagerService;

public class InformationResource2ExcelAdapter extends Object2ExcelComplexAdapter<InformationResource> {
	private DataManagerService service = (DataManagerService) ServiceUtil
			.getService("DataManagerService");
	private DataElementFieldsService dataElementFieldsService = (DataElementFieldsService) ServiceUtil
			.getService("DataElementFieldsService");
	private DataElementService dataElementService= (DataElementService) ServiceUtil
			.getService("DataElementService");
	
	private String[] fields;
	private String[] deFields;//数据元字段
	private Map<String,DataHandler> map;
	private Map<String,DataHandler> deMap;
	
	public InformationResource2ExcelAdapter(List<InformationResource> list, String[] fields,String[] deFields,Map<String,DataHandler> map) {
		super(list);
		this.fields = fields;
		this.deFields = deFields;
		this.map=map;
		this.deMap=getExcelHandler();
	}
	
	private Map<String, DataHandler> getExcelHandler() {
		Map<String, DataHandler> map = new HashMap<String, DataHandler>();
		List<DataElementFields> list = dataElementFieldsService.find(new DataElementFields());
		for (final DataElementFields sf : list) {
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

	@Override
	public String[] getTitle() {
		List<DataManager> list = service.find(new DataManager());
		List<DataElementFields> deList = dataElementFieldsService.find(new DataElementFields());
		String[] str = new String[fields.length+deFields.length];
		for (int i=0;i<fields.length;i++) {
			for (DataManager def : list) {

				if (("value" + def.getValueNo()).equals(fields[i])) {
					str[i]=def.getDataName();
				}else if(fields[i].equals("inforTypes")){
					str[i]="类";
				}else if(fields[i].equals("inforTypes2")){
					str[i]="项";
				}else if(fields[i].equals("inforTypes3")){
					str[i]="目";
				}else if(fields[i].equals("inforTypes4")){
					str[i]="细目";
				}

			}
		}
		for (int i=0;i<deFields.length;i++) {
			for (DataElementFields def : deList) {
				if (("value" + def.getValueNo()).equals(deFields[i])) {
					str[i+fields.length]=def.getName();
				}
			}
		}
		return str;
	}

	
	public String[] object2StrArray(InformationResource t) {
		String[] str = new String[fields.length];
		for(int i=0;i<fields.length;i++){
			DataHandler dh=map.get(fields[i]);
			Object val=ObjectUtil.getFieldValueByName(fields[i], t);
			if(dh!=null){
				Object o=dh.doHandle(val);
				if(val!=null&&o!=null){
					str[i]=o.toString();
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
	public List<String[]> object2List(InformationResource t) {
		DataList dataList=new DataList();
		dataList.setDataManagerId(t.getId());
		List<DataElement> list = dataElementService.getDataElementListByDataList(dataList);
		List<String[]> rList=new ArrayList<String[]>();
		String [] infor=object2StrArray(t);
		
		if(list!=null&&deFields.length>0){
			for(DataElement dataElement:list){
				String [] row=new String[fields.length+deFields.length];
				for(int i=0;i<infor.length;i++){
					row[i]=infor[i];
				}
				rList.add(dataElement2StrArray(dataElement,row));
			}
		}else{
			rList.add(infor);
		}
		return rList;
	}

	
	public String[] dataElement2StrArray(DataElement t,String [] str) {
		for(int i=0;i<deFields.length;i++){
			DataHandler dh=deMap.get(deFields[i]);
			Object val=ObjectUtil.getFieldValueByName(deFields[i], t);
			if(dh!=null){
				Object o=dh.doHandle(val);
				if(val!=null&&o!=null){
					str[i+fields.length]=o.toString();
				}else{
					str[i+fields.length]="";
				}
			}else{
				if(val==null){
					str[i+fields.length]="";
				}else{
					str[i+fields.length]=val.toString();
				}
				
			}
		}
		
		return str;
	}
	
	
	
	
	@Override
	public void doAfterEveryTime(List<String[]> list, Sheet sheet, int startRow, int endRow) {
		if(list.size()>1){
			for(int i=0;i<fields.length;i++){
				CellRangeAddress cra=new CellRangeAddress(startRow, endRow, i, i);
				sheet.addMergedRegion(cra);
			}
		}
	}

	public String[] getDeFields() {
		return deFields;
	}

	public void setDeFields(String[] deFields) {
		this.deFields = deFields;
	}

}
