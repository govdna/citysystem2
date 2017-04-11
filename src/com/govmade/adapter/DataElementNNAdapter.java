package com.govmade.adapter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;



import com.govmade.common.utils.ChineseTo;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.ExcelAdapter;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.organization.Company;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.information.InformationResService;


public class DataElementNNAdapter extends ExcelAdapter<DataElement>{
	private Map<String,String> dataTypeDic=new HashMap<String, String>();
	private Map<String,String> objectType=new HashMap<String, String>();
	private Map<String,String> companyname=new HashMap<String, String>();
	private Map<String,String> dicCompany=new HashMap<String, String>();
	private DataElementService service;
	private InformationResService informationResService;
	
	private void initDic(){
		if(dataTypeDic.size()!=0){
			return;
		}
		if(informationResService==null){
			informationResService=(InformationResService) ServiceUtil.getService("InformationResService");
		}
		List<GovmadeDic> dic=ServiceUtil.getDicByDicNum("DATATYPE");
		for(GovmadeDic d:dic){
			dataTypeDic.put(d.getDicValue(), d.getDicKey());
		}
		List<GovmadeDic> odic=ServiceUtil.getDicByDicNum("OBJECTTYPE");
		for(GovmadeDic d:odic){
			objectType.put(d.getDicValue(), d.getDicKey());
		}
		if(service==null){
			service=(DataElementService) ServiceUtil.getService("DataElementService");
		}
		Company com=new Company();
		List<Company> company=(List<Company>)ServiceUtil.getService("CompanyService").find(com);
		for(Company c:company){
			companyname.put(c.getCompanyName(), c.getId()+"");
		}
		
		List<GovmadeDic> dicc=ServiceUtil.getDicByDicNum("ZYTGF");
		for(GovmadeDic d:dicc){
			dicCompany.put(d.getDicValue(), d.getDicKey());
		}
	}
	@Override
	public int getClumnSize() {
		return 7;
	}

	@Override
	public int getStartRow() {
		return 1;
	}

	@Override
	public DataElement doWithRowData(String[] clumns,int rowNum) {
		int realNum=rowNum+1;
		initDic();

		DataElement de=new DataElement();
		
		//临时存放对应信息资源ID
		InformationRes infor=new InformationRes();
		infor.setValue1(clumns[0]);
		List<InformationRes> inforlist=informationResService.find(infor);
		if(inforlist.size()==0){
			appendMsg("表二 第"+realNum+"行第1列，信息资源名称不存在！");
			setError(true);
		}else{
			de.setValue30(inforlist.get(0).getId()+"");
		}
		
		de.setChName(clumns[1]);
		de.setEgName(ChineseTo.getPinYinHeadChar(clumns[1]).toUpperCase());		
		
		if(clumns[2].trim()!=null&&clumns[2].trim()!=""){
			if(dataTypeDic.get(clumns[2])==null){
				appendMsg("表二 第"+realNum+"行第3列，数据类型有误！");
				setError(true);
			}else{			
				de.setDataType(Integer.valueOf(dataTypeDic.get(clumns[2])));
			}
		}
		
		if(clumns[3].trim()!=null&&clumns[3].trim()!=""){
			if(objectType.get(clumns[3])==null){
				appendMsg("表二 第"+realNum+"行第4列，对象类型有误！");
				setError(true);
			}else{
				de.setObjectType(Integer.valueOf(objectType.get(clumns[3])));
			}
		}
		
		de.setDataFormat(clumns[4]);
		de.setDefine(clumns[5]);
		de.setNotes(clumns[6]);

		return de;
	}

}
