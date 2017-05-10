package com.govmade.adapter.object2excel;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;

import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.poi.Object2ExcelAdapter;
import com.govmade.common.utils.poi.Object2ExcelComplexAdapter;
import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.entity.system.customFields.DataElementFields;
import com.govmade.entity.system.customFields.SimpleFields;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.service.system.data.DataListService;
import com.govmade.service.system.item.ItemSortService;
import com.govmade.service.system.simpleFields.SimpleFieldsService;

public class ItemSort2ExcelAdapter extends Object2ExcelComplexAdapter<ItemSort> {
	private ItemSortService service = (ItemSortService) ServiceUtil
			.getService("ItemSortService");
	private DataListService dataListservice = (DataListService) ServiceUtil
			.getService("DataListService");
	private String[] fields;
	private String[] deFields;
	private Map<String,DataHandler> map;
	private Map<String,DataHandler> deMap;
	public ItemSort2ExcelAdapter(List<ItemSort> list, String[] fields,String[] deFields,Map<String,DataHandler> map) {
		super(list);
		this.fields = fields;
		this.map=map;
		this.deFields = deFields;
		this.deMap=map;
	}

	@Override
	public String[] getTitle() {
		int l=0;
		if(deFields!=null){
			l=fields.length+1;
		}else{
			l=fields.length;
		}		
		String[] str = new String[l];
		
		for (int i=0;i<fields.length;i++) {
			if(fields[i].equals("itemName")){
				str[i]="事项名称";
			}else if(fields[i].equals("serObjSort")){
				str[i]="服务对象分类";
			}else if(fields[i].equals("serContent")){
				str[i]="服务内容";
			}else if(fields[i].equals("preApprovalMatter")){
				str[i]="前置审批事项";
			}else if(fields[i].equals("deadline")){
				str[i]="时限";
			}else if(fields[i].equals("companyId")){
				str[i]="责任部门";
			}else if(fields[i].equals("certificateName")){
				str[i]="所需证件名称";
			}else if(fields[i].equals("fileType")){
				str[i]="办件结果文件类型";
			}else if(fields[i].equals("fileName")){
				str[i]="办件结果文件名称";
			}else if(fields[i].equals("yesorno")){
				str[i]="是否有应用系统支撑";
			}else if(fields[i].equals("busSystem")){
				str[i]="业务应用系统名称";
			}
		}
		if(deFields!=null){
			str[fields.length]="申请材料";
		}

		return str;
	}

	public String[] object2StrArray(ItemSort t) {
		String[] str = new String[fields.length];
		for(int i=0;i<fields.length;i++){
			DataHandler dh=map.get(fields[i]);
			Object val=ObjectUtil.getFieldValueByName(fields[i], t);
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
	public List<String[]> object2List(ItemSort t) {
		DataList dataList=new DataList();
		dataList.setItemSortId(t.getId());
		List<DataList> list = dataListservice.find(dataList);
		List<String[]> rList=new ArrayList<String[]>();
		String [] infor=object2StrArray(t);
		
		if(list!=null&&deFields!=null){
			if(list.size()>0){
				for(DataList dl:list){
					String [] row=new String[fields.length+deFields.length];
					for(int i=0;i<infor.length;i++){
						row[i]=infor[i];
					}
					rList.add(dataElement2StrArray(dl.getApplicationMaterials(),row));
				}
			}else{
				String [] row=new String[fields.length+deFields.length];
				for(int i=0;i<infor.length;i++){
					row[i]=infor[i];
				}
				rList.add(dataElement2StrArray("",row));
			}
		}else{
			rList.add(infor);
		}
		return rList;
	}

	public String[] dataElement2StrArray(String t,String [] str) {
		if(t!=null && t!=""){
			str[fields.length]=t;		
		}else{
			str[fields.length]="";
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
