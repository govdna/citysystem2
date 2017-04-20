package com.govmade.adapter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.ExcelAdapter;
import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.organization.Company;
import com.govmade.service.system.item.ItemSortService;

public class ItemSortAdapter extends ExcelAdapter<ItemSort>{
	private Map<String,String> serObjDics = new HashMap<String, String>();
	private Map<String,String> serContentDics = new HashMap<String, String>();
	private Map<String,String> itemSortFront = new HashMap<String, String>();
	private Map<String,String> deadLineDics = new HashMap<String, String>();
	private Map<String,String> dutyCompanys = new HashMap<String, String>();
	private Map<String,String> fileTypeDics = new HashMap<String, String>();
	private Map<String,String> apps = new HashMap<String, String>();
	private ItemSortService service;	
	public ItemSortAdapter() {
		super();
	}
	private void initDic(){
		if(serObjDics.size()!=0){
			return;
		}
		List<GovmadeDic> dic = ServiceUtil.getDicByDicNum("SEROBJSORT");
		for(GovmadeDic d:dic){
			serObjDics.put(d.getDicValue(), d.getDicKey());
		}
		List<GovmadeDic> odic = ServiceUtil.getDicByDicNum("SERCONTENT");
		for(GovmadeDic d:odic){
			serContentDics.put(d.getDicValue(), d.getDicKey());
		}
		if(service==null){
			service =(ItemSortService) ServiceUtil.getService("ItemSortService");
		}
		ItemSort item = new ItemSort();
		List<ItemSort> itemSorts=(List<ItemSort>)ServiceUtil.getService("ItemSortService").find(item);
		for(ItemSort c:itemSorts){
			itemSortFront.put(c.getItemName(), c.getId()+"");
		}
		List<GovmadeDic> ddic = ServiceUtil.getDicByDicNum("DEADLINE");
		for(GovmadeDic d:ddic){
			deadLineDics.put(d.getDicValue(), d.getDicKey());
		}
		Company com = new Company();
		List<Company> company=(List<Company>)ServiceUtil.getService("CompanyService").find(com);
		for(Company c:company){
			dutyCompanys.put(c.getCompanyName(), c.getId()+"");
		}
		GovApplicationSystem govApplicationSystem = new GovApplicationSystem();
		List<GovApplicationSystem> companyapp=(List<GovApplicationSystem>)ServiceUtil.getService("GovApplicationSystemService").find(govApplicationSystem);
		for(GovApplicationSystem c:companyapp){
			apps.put(c.getValue2(), c.getId()+"");
		}
		List<GovmadeDic> fdic = ServiceUtil.getDicByDicNum("FILETYPE");
		for(GovmadeDic d:fdic){
			fileTypeDics.put(d.getDicValue(), d.getDicKey());
		}
	}
	@Override
	public int getClumnSize() {
		return 12;
	}
	@Override
	public int getStartRow() {
		return 1;
	}
	@Override
	public ItemSort doWithRowData(String[] clumns,int rowNum) {
		initDic();
		int realNum=rowNum+1;
		ItemSort de = new ItemSort();
		de.setItemName(clumns[0]);
		de.setIsDeleted(0);
		List<ItemSort> iss = service.find(de);
		if(iss.size()>0){
			appendMsg("第"+realNum+"行第1列 中文名称 "+clumns[0] +" 已有重复！");
			setError(true);
		}
		if(serObjDics.get(clumns[1])==null){
			appendMsg("第"+realNum+"行第2列，数据类型有误！");
			setError(true);
		}else{			
			de.setSerObjSort(Integer.valueOf(serObjDics.get(clumns[1])));
		}
		if(serContentDics.get(clumns[2])==null){
			appendMsg("第"+realNum+"行第3列，数据类型有误！");
			setError(true);
		}else{			
			de.setSerContent(Integer.valueOf(serContentDics.get(clumns[2])));
		}
		if(!clumns[3].trim().isEmpty()){
			if(itemSortFront.get(clumns[3])==null){
				appendMsg("第"+realNum+"行第4列，数据类型有误！");
				setError(true);
			}else{			
				de.setPreApprovalMatter(Integer.valueOf(itemSortFront.get(clumns[3])));
			}
		}		
		if(deadLineDics.get(clumns[4])==null){
			appendMsg("第"+realNum+"行第5列，数据类型有误！");
			setError(true);
		}else{			
			de.setDeadline(Integer.valueOf(deadLineDics.get(clumns[4])));
		}
		if(dutyCompanys.get(clumns[5])==null){
			appendMsg("第"+realNum+"行第6列，数据类型有误！");
			setError(true);
		}else{			
			de.setCompanyId(Integer.valueOf(dutyCompanys.get(clumns[5])));
		}
		de.setCertificateName(clumns[6]);
		if(fileTypeDics.get(clumns[7])==null){
			appendMsg("第"+realNum+"行第8列，数据类型有误！");
			setError(true);
		}else{			
			de.setFileType(Integer.valueOf(fileTypeDics.get(clumns[7])));
		}
		de.setFileName(clumns[8]);
		if(clumns[9].equals("是")){
			de.setYesorno(1);
			if(apps.get(clumns[10])==null){
				appendMsg("第"+realNum+"行第10列，数据类型有误！");
				setError(true);
			}else{			
				de.setBusSystem(Integer.valueOf(apps.get(clumns[10])));
			}
		}else{
			de.setYesorno(0);
		}
		
		if(!clumns[11].trim().isEmpty()){
			de.setApplicationMaterial(clumns[11]);		
		}		
		return de;
	}

}
