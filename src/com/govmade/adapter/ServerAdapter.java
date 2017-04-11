package com.govmade.adapter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.ExcelAdapter;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.server.GovServer;
import com.govmade.service.system.server.GovServerService;

public class ServerAdapter extends ExcelAdapter<GovServer>{
	private Map<String,String> sbDics = new HashMap<String, String>();
	private Map<String,String> stDics = new HashMap<String, String>();
	private Map<String,String> osDics = new HashMap<String, String>();
	private Map<String,String> dutyCompanys = new HashMap<String, String>();
	private Map<String,String> belongComputer = new HashMap<String, String>();
	private GovServerService service;	
	public ServerAdapter() {
		super();
	}
	private void initDic(){
		List<GovmadeDic> sbdic = ServiceUtil.getDicByDicNum("SERVERBRAND");
		for(GovmadeDic d:sbdic){
			sbDics.put(d.getDicValue(), d.getDicKey());
		}
		List<GovmadeDic> stdic = ServiceUtil.getDicByDicNum("SERVERTYPE");
		for(GovmadeDic d:stdic){
			stDics.put(d.getDicValue(), d.getDicKey());
		}
		List<GovmadeDic> osdic = ServiceUtil.getDicByDicNum("OPSYSTEM");
		for(GovmadeDic d:osdic){
			osDics.put(d.getDicValue(), d.getDicKey());
		}
		if(service==null){
			service =(GovServerService) ServiceUtil.getService("GovServerService");
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
		return 10;
	}
	@Override
	public int getStartRow() {
		return 1;
	}
	@Override
	public GovServer doWithRowData(String[] clumns,int rowNum) {
		initDic();
		int realNum=rowNum+1;
		GovServer de = new GovServer();
		de.setValue1(clumns[0].trim());
		de.setIsDeleted(0);
		List<GovServer> iss = service.find(de);
		if(iss!=null&&iss.size()>0){
			appendMsg("第"+realNum+"行服务器编号 "+clumns[0] +" 已有重复！");
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
		if(sbDics.get(clumns[3].trim())==null){
			appendMsg("第"+realNum+"行服务器品牌，数据类型有误！");
			setError(true);
		}else{			
			de.setValue4(sbDics.get(clumns[3].trim()));
		}		
		if(clumns[4].trim().isEmpty()){
			appendMsg("第"+realNum+"行服务器型号，数据类型有误！");
			setError(true);
		}else{			
			de.setValue5(clumns[4].trim());
		}
		if(clumns[5].trim().isEmpty()){
			appendMsg("第"+realNum+"行服务器数量，数据类型有误！");
			setError(true);
		}else{			
			de.setValue6(clumns[5].trim());
		}
		if(stDics.get(clumns[6].trim())==null){
			appendMsg("第"+realNum+"行服务器类型，数据类型有误！");
			setError(true);
		}else{			
			de.setValue7(stDics.get(clumns[6].trim()));
		}	
		if(osDics.get(clumns[7].trim())==null){
			appendMsg("第"+realNum+"行操作系统，数据类型有误！");
			setError(true);
		}else{			
			de.setValue8(osDics.get(clumns[7].trim()));
		}
		if(belongComputer.get(clumns[8].trim())==null){
			appendMsg("第"+realNum+"行所在机房，数据类型有误！");
			setError(true);
		}else{			
			de.setValue9(belongComputer.get(clumns[8].trim()));
		}		
		if(clumns[9].trim().isEmpty()){
			
		}else{			
				de.setValue10(clumns[9].trim());
		}		
		de.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
		de.setGroupId(AccountShiroUtil.getCurrentUser().getGroupId());
		return de;
	}

}
