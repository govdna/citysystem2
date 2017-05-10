package com.govmade.adapter;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;

import com.govmade.common.utils.DateUtils;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.ExcelAdapter;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.InformationResourceService;

public class InformationResourceAdapter extends ExcelAdapter<InformationResource>{

	private Map<String,String> sortManager=new HashMap<String, String>(); // 信息资源分类
	private Map<String,String> itemSort=new HashMap<String, String>(); // 涉及业务
	private Map<String,String> SHARETYPE=new HashMap<String, String>(); // 共享类型
	private Map<String,String> SHAREMETHOD=new HashMap<String, String>(); // 共享方式
	private Map<String,String> ISPUBLIC=new HashMap<String, String>(); // 是否向社会开放
	private Map<String,String> UPDATECYCLE=new HashMap<String, String>(); // 更新周期
	private Map<String,String> INFORMATIONFORMAT=new HashMap<String, String>(); // 信息资源格式
	private Map<String,String> companyname=new HashMap<String, String>();
	private InformationResourceService service;
	private DataElementService dataElementService;
	
	private void initDic(){
		if(service==null){
			service=(InformationResourceService) ServiceUtil.getService("InformationResourceService");
		}else{
			return;
		}
		if(dataElementService==null){
			dataElementService=(DataElementService) ServiceUtil.getService("DataElementService");
		}
		SortManager sm=new SortManager();
		sm.setBelong(2);
		List<SortManager> xxzyfl=(List<SortManager>) ServiceUtil.getService("SortManagerService").find(sm); // 信息资源分类
		for(SortManager d:xxzyfl){
			sortManager.put(d.getSortName(), d.getId()+"");
		}
		
		ItemSort is=new ItemSort();
		List<ItemSort> sjyw=(List<ItemSort>) ServiceUtil.getService("ItemSortService").find(is); // 涉及业务
		for(ItemSort d:sjyw){
			itemSort.put(d.getItemName(), d.getId()+"");
		}
		
		List<GovmadeDic> gxlxdic=ServiceUtil.getDicByDicNum("SHARETYPE"); // 共享类型
		for(GovmadeDic d:gxlxdic){
			SHARETYPE.put(d.getDicValue(), d.getDicKey());
		}
		List<GovmadeDic> gxfsdic=ServiceUtil.getDicByDicNum("SHAREMETHOD"); // 共享方式
		for(GovmadeDic d:gxfsdic){
			SHAREMETHOD.put(d.getDicValue(), d.getDicKey());
		}
		List<GovmadeDic> shkfdic=ServiceUtil.getDicByDicNum("ISPUBLIC"); // 是否向社会开放
		for(GovmadeDic d:shkfdic){
			ISPUBLIC.put(d.getDicValue(), d.getDicKey());
		}
		List<GovmadeDic> uxzqdic=ServiceUtil.getDicByDicNum("UPDATECYCLE"); // 更新周期
		for(GovmadeDic d:uxzqdic){
			UPDATECYCLE.put(d.getDicValue(), d.getDicKey());
		}
		List<GovmadeDic> xxzygsdic=ServiceUtil.getDicByDicNum("INFORMATIONFORMAT"); // 信息资源格式
		for(GovmadeDic d:xxzygsdic){
			INFORMATIONFORMAT.put(d.getDicValue(), d.getDicKey());
		}
		
		
		Company com=new Company();
		List<Company> company=(List<Company>)ServiceUtil.getService("CompanyService").find(com);
		for(Company c:company){
			companyname.put(c.getCompanyName(), c.getId()+"");
		}
	}
	@Override
	public int getClumnSize() {
		return 17;
	}

	@Override
	public int getStartRow() {
		return 1;
	}

	@Override
	public InformationResource doWithRowData(String[] clumns,int rowNum) {
		int realNum=rowNum+1;
		initDic();
		InformationResource de=new InformationResource();

		de.setValue1(clumns[4].trim()); 		// 信息资源名称
		if(service.find(de).size()>0){
			appendMsg("第"+realNum+"行第5列，信息资源名称  已存在！");
			setError(true);
		}
		
		if(sortManager.get(clumns[0])==null){
			appendMsg("第"+realNum+"行第1列，(信息资源分类)类 有误！");
			setError(true);
		}else{			
			de.setInforTypes(Integer.valueOf(sortManager.get(clumns[0])));
		}
		
		if(sortManager.get(clumns[1])==null){
			appendMsg("第"+realNum+"行第2列，(信息资源分类) 项 有误！");
			setError(true);
		}else{			
			de.setInforTypes2(Integer.valueOf(sortManager.get(clumns[1])));
		}
		
		if(clumns[2]!=null&&clumns[2]!=""){
			if(sortManager.get(clumns[2])==null){
				appendMsg("第"+realNum+"行第3列，(信息资源分类) 目 有误！");
				setError(true);
			}else{			
				de.setInforTypes3(Integer.valueOf(sortManager.get(clumns[2])));
			}
		}

		if(clumns[3]!=null&&clumns[3]!=""){
			if(sortManager.get(clumns[3])==null){
				appendMsg("第"+realNum+"行第4列，(信息资源分类) 细目 有误！");
				setError(true);
			}else{			
				de.setInforTypes4(Integer.valueOf(sortManager.get(clumns[3])));
			}
		}
		
		de.setValue5(clumns[5]); 		// 信息资源摘要

		if(clumns[6]!=null&&clumns[6]!=""){
			if(itemSort.get(clumns[6])==null){
				appendMsg("第"+realNum+"行第7列，涉及业务 有误！");
				setError(true);
			}else{			
				de.setValue6(Integer.valueOf(itemSort.get(clumns[6]))+"");
			}
		}
		
		if(SHARETYPE.get(clumns[7])==null){
			appendMsg("第"+realNum+"行第8列，共享类型 有误！");
			setError(true);
		}else{			
			de.setValue8(Integer.valueOf(SHARETYPE.get(clumns[7]))+"");
		}
		
		de.setValue9(clumns[8]); 		// 共享条件

		if(SHAREMETHOD.get(clumns[9])==null){
			appendMsg("第"+realNum+"行第10列，共享方式  有误！");
			setError(true);
		}else{			
			de.setValue10(Integer.valueOf(SHAREMETHOD.get(clumns[9]))+"");
		}
		
		if(ISPUBLIC.get(clumns[10])==null){
			appendMsg("第"+realNum+"行第11列 是否向社会开放有误！");
			setError(true);
		}else{			
			de.setValue11(Integer.valueOf(ISPUBLIC.get(clumns[10]))+"");
		}
		
		de.setValue12(clumns[11]); 		// 开放条件

		if(UPDATECYCLE.get(clumns[12])==null){
			appendMsg("第"+realNum+"行第13列，跟新周期  有误！");
			setError(true);
		}else{			
			de.setValue15(Integer.valueOf(UPDATECYCLE.get(clumns[12]))+"");
		}
		
		if(INFORMATIONFORMAT.get(clumns[13])==null){
			appendMsg("第"+realNum+"行第14列 信息资源格式 有误！");
			setError(true);
		}else{			
			de.setValue7(Integer.valueOf(INFORMATIONFORMAT.get(clumns[13]))+"");
		}
		
			// 信息资源发布日期
		if(clumns[14]!=null&&clumns[14]!=""){
			if(!DateUtils.isValidDate(clumns[14])){
				appendMsg("第"+realNum+"行第15列 发布日期 格式有误！");
				setError(true);				
			}	
			de.setValue14(clumns[14]); 
		}else{
			de.setValue14(DateUtils.formatDate(new Date(), null)); 	
		}
		
		Integer companyId=AccountShiroUtil.getCurrentUser().getCompanyId();
		if(StringUtils.isEmpty(clumns[15])){
			de.setCompanyId(companyId);
		}else{
			if(companyname.get(clumns[15])==null){
				appendMsg("第"+realNum+"行第16列 不存在该机构");
				setError(true);
			}else{
				de.setCompanyId(Integer.valueOf(companyname.get(clumns[15])));
				de.setValue3(companyname.get(clumns[15]));
			}
		}

		return de;
	}


}
