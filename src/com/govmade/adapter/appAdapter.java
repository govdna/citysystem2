package com.govmade.adapter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.ExcelAdapter;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.organization.Company;
import com.govmade.service.system.application.GovApplicationSystemService;

public class appAdapter extends ExcelAdapter<GovApplicationSystem>{
	private Map<String,String> nwDics = new HashMap<String, String>();
	private Map<String,String> dutyCompanys = new HashMap<String, String>();
	private GovApplicationSystemService service;	
	public appAdapter() {
		super();
	}
	private void initDic(){
		List<GovmadeDic> sbdic = ServiceUtil.getDicByDicNum("NETWORK");
		for(GovmadeDic d:sbdic){
			nwDics.put(d.getDicValue(), d.getDicKey());
		}		
		if(service==null){
			service =(GovApplicationSystemService) ServiceUtil.getService("GovApplicationSystemService");
		}
		List<Company> company=(List<Company>)ServiceUtil.getService("CompanyService").find(ServiceUtil.buildBean("Company@isDeleted=0"));
		for(Company c:company){
			dutyCompanys.put(c.getCompanyName(), c.getId()+"");
		}		
	}
	@Override
	public int getClumnSize() {
		return 4;
	}
	@Override
	public int getStartRow() {
		return 1;
	}
	@Override
	public GovApplicationSystem doWithRowData(String[] clumns,int rowNum) {
		initDic();
		int realNum=rowNum+1;
		GovApplicationSystem de = new GovApplicationSystem();
		de.setValue1(clumns[0].trim());
		de.setIsDeleted(0);
		List<GovApplicationSystem> iss = service.find(de);
		if(iss!=null&&iss.size()>0){
			appendMsg("第"+realNum+"行应用系统编号 "+clumns[0] +" 已有重复！");
			setError(true);
		}
		de.setValue2(clumns[1].trim());
		List<GovApplicationSystem> isss = service.find(de);
		if(isss!=null&&isss.size()>0){
			appendMsg("第"+realNum+"行应用系统名称 "+clumns[1] +" 已有重复！");
			setError(true);
		}
		if(dutyCompanys.get(clumns[2].trim())==null){
			appendMsg("第"+realNum+"行责任部门，数据类型有误！");
			setError(true);
		}else{			
			de.setValue3(dutyCompanys.get(clumns[2].trim()));
		}		
		if(nwDics.get(clumns[3].trim())==null){
			appendMsg("第"+realNum+"行所在网络，数据类型有误！");
			setError(true);
		}else{			
			de.setValue4(nwDics.get(clumns[3].trim()));
		}			
		de.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
		de.setGroupId(AccountShiroUtil.getCurrentUser().getGroupId());
		return de;
	}

}
