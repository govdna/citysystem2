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
import com.govmade.service.system.computer.GovComputerRoomService;

public class ComputerAdapter extends ExcelAdapter<GovComputerRoom>{
	private Map<String,String> hasornoDics = new HashMap<String, String>();
	private Map<String,String> dutyCompanys = new HashMap<String, String>();
	private GovComputerRoomService service;	
	public ComputerAdapter() {
		super();
	}
	private void initDic(){
		List<GovmadeDic> dic = ServiceUtil.getDicByDicNum("HASORNO");
		for(GovmadeDic d:dic){
			hasornoDics.put(d.getDicValue(), d.getDicKey());
		}
		if(service==null){
			service =(GovComputerRoomService) ServiceUtil.getService("GovComputerRoomService");
		}
		List<Company> company=(List<Company>)ServiceUtil.getService("CompanyService").find(ServiceUtil.buildBean("Company@isDeleted=0"));
		for(Company c:company){
			dutyCompanys.put(c.getCompanyName(), c.getId()+"");
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
	public GovComputerRoom doWithRowData(String[] clumns,int rowNum) {
		initDic();
		int realNum=rowNum+1;
		GovComputerRoom de = new GovComputerRoom();
		de.setValue1(clumns[0].trim());
		de.setIsDeleted(0);
		List<GovComputerRoom> iss = service.find(de);
		if(iss!=null&&iss.size()>0){
			appendMsg("第"+realNum+"行中文名称 "+clumns[0] +" 已有重复！");
			setError(true);
		}
		if(dutyCompanys.get(clumns[1].trim())==null){
			appendMsg("第"+realNum+"行责任部门，数据类型有误！");
			setError(true);
		}else{			
			de.setValue3(dutyCompanys.get(clumns[1].trim()));
		}
		if(clumns[2].trim().isEmpty()){
			appendMsg("第"+realNum+"行机房面积，数据类型有误！");
			setError(true);
		}else{			
			de.setValue2(clumns[2].trim());
		}
		if(clumns[3].trim().isEmpty()){
			appendMsg("第"+realNum+"行UPS型号，数据类型有误！");
			setError(true);
		}else{			
			de.setValue4(clumns[3].trim());
		}
		if(clumns[4].trim().isEmpty()){
			appendMsg("第"+realNum+"行备电，数据类型有误！");
			setError(true);
		}else{			
			de.setValue5(clumns[4].trim());
		}
		if(clumns[5].trim().isEmpty()){
			appendMsg("第"+realNum+"行供电功率，数据类型有误！");
			setError(true);
		}else{			
			de.setValue6(clumns[5].trim());
		}
		if(clumns[6].trim().isEmpty()){
			
		}else{
			if(hasornoDics.get(clumns[6].trim())==null){
				appendMsg("第"+realNum+"行精密空调，数据类型有误！");
				setError(true);
			}else{
				de.setValue7(hasornoDics.get(clumns[6].trim()));
			}			
		}
		if(clumns[7].trim().isEmpty()){
			appendMsg("第"+realNum+"行空调数量，数据类型有误！");
			setError(true);
		}else{			
			de.setValue8(clumns[7].trim());
		}
		if(clumns[8].trim().isEmpty()){
			
		}else{
			if(hasornoDics.get(clumns[8].trim())==null){
				appendMsg("第"+realNum+"行防雷接地设施，数据类型有误！");
				setError(true);
			}else{
				de.setValue9(hasornoDics.get(clumns[8].trim()));
			}			
		}
		if(clumns[9].trim().isEmpty()){
			
		}else{
			if(hasornoDics.get(clumns[9].trim())==null){
				appendMsg("第"+realNum+"行监控设施，数据类型有误！");
				setError(true);
			}else{
				de.setValue10(hasornoDics.get(clumns[9].trim()));
			}			
		}
		if(clumns[10].trim().isEmpty()){
			
		}else{
			if(hasornoDics.get(clumns[10].trim())==null){
				appendMsg("第"+realNum+"行消防报警系统，数据类型有误！");
				setError(true);
			}else{
				de.setValue11(hasornoDics.get(clumns[10].trim()));
			}			
		}
		if(clumns[11].trim().isEmpty()){
			
		}else{
			de.setValue12(clumns[11].trim());
		}
		de.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
		de.setGroupId(AccountShiroUtil.getCurrentUser().getGroupId());
		return de;
	}

}
