package com.govmade.adapter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.ExcelAdapter;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.memorizer.GovMemorizer;
import com.govmade.entity.system.organization.Company;
import com.govmade.service.system.memorizer.GovMemorizerService;

public class MemorizerAdapter extends ExcelAdapter<GovMemorizer>{
	private Map<String,String> mbDics = new HashMap<String, String>();
	private Map<String,String> mtDics = new HashMap<String, String>();
	private Map<String,String> dutyCompanys = new HashMap<String, String>();
	private Map<String,String> belongComputer = new HashMap<String, String>();
	private GovMemorizerService service;	
	public MemorizerAdapter() {
		super();
	}
	private void initDic(){
		List<GovmadeDic> sbdic = ServiceUtil.getDicByDicNum("MEMORIZERBRAND");
		for(GovmadeDic d:sbdic){
			mbDics.put(d.getDicValue(), d.getDicKey());
		}
		List<GovmadeDic> stdic = ServiceUtil.getDicByDicNum("MEMORIZERTYPE");
		for(GovmadeDic d:stdic){
			mtDics.put(d.getDicValue(), d.getDicKey());
		}		
		if(service==null){
			service =(GovMemorizerService) ServiceUtil.getService("GovMemorizerService");
		}
		List<Company> company=(List<Company>)ServiceUtil.getService("CompanyService").find(ServiceUtil.buildBean("Company@isDeleted=0"));
		for(Company c:company){
			dutyCompanys.put(c.getCompanyName(), c.getId()+"");
		}	
		List<GovComputerRoom> crLiist=(List<GovComputerRoom>)ServiceUtil.getService("GovComputerRoomService").find(ServiceUtil.buildBean("GovComputerRoom@isDeleted=0"));
		for(GovComputerRoom c:crLiist){
			belongComputer.put(c.getValue1(), c.getId()+"");
		}	
	}
	@Override
	public int getClumnSize() {
		return 11;
	}
	@Override
	public int getStartRow() {
		return 1;
	}
	@Override
	public GovMemorizer doWithRowData(String[] clumns,int rowNum) {
		initDic();
		int realNum=rowNum+1;
		GovMemorizer de = new GovMemorizer();
		de.setValue1(clumns[0].trim());
		de.setIsDeleted(0);
		List<GovMemorizer> iss = service.find(de);
		if(iss!=null&&iss.size()>0){
			appendMsg("第"+realNum+"行存储器编号 "+clumns[0] +" 已有重复！");
			setError(true);
		}
		if(dutyCompanys.get(clumns[1].trim())==null){
			appendMsg("第"+realNum+"行责任部门，数据类型有误！");
			setError(true);
		}else{			
			de.setValue2(dutyCompanys.get(clumns[1].trim()));
		}
		if(clumns[2].trim().isEmpty()){
			appendMsg("第"+realNum+"行购买时间，数据类型有误！");
			setError(true);
		}else{			
			de.setValue3(clumns[2].trim());
		}
		if(mbDics.get(clumns[3].trim())==null){
			appendMsg("第"+realNum+"行存储器品牌，数据类型有误！");
			setError(true);
		}else{			
			de.setValue4(mbDics.get(clumns[3].trim()));
		}		
		if(clumns[4].trim().isEmpty()){
			appendMsg("第"+realNum+"行存储器型号，数据类型有误！");
			setError(true);
		}else{			
			de.setValue5(clumns[4].trim());
		}
		if(clumns[5].trim().isEmpty()){
			appendMsg("第"+realNum+"行存储器数量，数据类型有误！");
			setError(true);
		}else{			
			de.setValue6(clumns[5].trim());
		}
		if(mtDics.get(clumns[6].trim())==null){
			appendMsg("第"+realNum+"行存储器类型，数据类型有误！");
			setError(true);
		}else{			
			de.setValue7(mtDics.get(clumns[6].trim()));
		}	
		if(clumns[7].trim().isEmpty()){
			
		}else{			
				de.setValue8(clumns[7].trim());
		}
		if(clumns[8].trim().isEmpty()){
			
		}else{			
				de.setValue9(clumns[8].trim());
		}	
		if(belongComputer.get(clumns[9].trim())==null){
			appendMsg("第"+realNum+"行所在机房，数据类型有误！");
			setError(true);
		}else{			
			de.setValue10(belongComputer.get(clumns[9].trim()));
		}		
		if(clumns[10].trim().isEmpty()){
			
		}else{			
				de.setValue11(clumns[10].trim());
		}	
		de.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
		de.setGroupId(AccountShiroUtil.getCurrentUser().getGroupId());
		return de;
	}

}
