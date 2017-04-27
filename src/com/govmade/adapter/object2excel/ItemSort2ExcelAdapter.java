package com.govmade.adapter.object2excel;

import java.util.List;
import java.util.Map;

import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.poi.Object2ExcelAdapter;
import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.entity.system.customFields.SimpleFields;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.service.system.data.DataListService;
import com.govmade.service.system.item.ItemSortService;
import com.govmade.service.system.simpleFields.SimpleFieldsService;

public class ItemSort2ExcelAdapter extends Object2ExcelAdapter<ItemSort> {
	private ItemSortService service = (ItemSortService) ServiceUtil
			.getService("ItemSortService");
	private DataListService dataListservice = (DataListService) ServiceUtil
			.getService("DataListService");
	private String[] fields;
	private Map<String,DataHandler> map;
	public ItemSort2ExcelAdapter(List<ItemSort> list, String[] fields,Map<String,DataHandler> map) {
		super(list);
		this.fields = fields;
		this.map=map;
	}

	@Override
	public String[] getTitle() {
		String[] str = new String[fields.length];
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
			}else if(fields[i].equals("applicationMaterial")){
				str[i]="申请材料";
			}
		}
		return str;
	}

	public String getAapplicationMaterials(String name){
		String applicationMaterial="";
		ItemSort itemSort=new ItemSort();
		itemSort.setItemName(name);
		int id=service.find(itemSort).get(0).getId();
		DataList dataList=new DataList();
		dataList.setItemSortId(id);
		List<DataList> list=dataListservice.find(dataList);
		for(DataList dl:list){
			applicationMaterial+=dl.getApplicationMaterials()+",";
		}
		return StringUtil.toSQLArray(applicationMaterial);
	}
	@Override
	public String[] object2StrArray(ItemSort t) {
		String[] str = new String[fields.length];
		for(int i=0;i<fields.length;i++){
			if(fields[i].equals("applicationMaterial")){
				Object val=ObjectUtil.getFieldValueByName("itemName", t);
				str[i]=getAapplicationMaterials(val.toString());
			}else{
				DataHandler dh=map.get(fields[i]);
				Object val=ObjectUtil.getFieldValueByName(fields[i], t);
				if(dh!=null){
					if(val!=null&&dh.doHandle(val)!=null){
						str[i]=dh.doHandle(val).toString();
					}else{
						str[i]="";
					}
				}else{
					str[i]=val.toString();
				}
			}			
		}
		return str;
	}

}
