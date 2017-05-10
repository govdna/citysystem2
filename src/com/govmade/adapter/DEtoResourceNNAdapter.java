package com.govmade.adapter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;

import com.govmade.common.utils.ChineseTo;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.ExcelAdapter;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.organization.Company;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.information.InformationResService;
import com.govmade.service.system.information.InformationResourceService;


public class DEtoResourceNNAdapter extends ExcelAdapter<DataElement>{
	private Map<String,String> dataTypeDic=new HashMap<String, String>();
	private Map<String,String> objectType=new HashMap<String, String>();
	private Map<String,String> companyname=new HashMap<String, String>();
	private Map<String,String> dicCompany=new HashMap<String, String>();
	private DataElementService service;
	private InformationResourceService informationResourceService;
	private Map<String,InformationResource> inforMap=new HashMap<String, InformationResource>();
	private void initDic(){
		if(dataTypeDic.size()!=0){
			return;
		}
		if(informationResourceService==null){
			informationResourceService=(InformationResourceService) ServiceUtil.getService("InformationResourceService");
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
		return 8;
	}

	private InformationResource getInfor(String name){
		if(inforMap.get(name)==null){
			InformationResource infor=new InformationResource();
			infor.setValue1(name);
			List<InformationResource> inforlist=informationResourceService.find(infor);
			if(inforlist!=null&&inforlist.size()>0){
				inforMap.put(name, inforlist.get(0));
				return inforlist.get(0);
			}
		}else{
			return inforMap.get(name);
		}
		return null;
	}
	@Override
	public int getStartRow() {
		return 1;
	}

	private boolean validateName(String name,String company){
		for(DataElement d:getEntityList()){
			if(d.getValue8()!=null){
				if(d.getChName().equals(name) && d.getValue8().equals(company)){
					return false;
				}
			}
		}
		return true;
	}
	private boolean validateName(String name){
		for(DataElement d:getEntityList()){
			if(d.getChName().equals(name)){
				return false;
			}
		}
		return true;
	}

	@Override
	public DataElement doWithRowData(String[] clumns,int rowNum) {
		int realNum=rowNum+1;
		initDic();

		DataElement de=new DataElement();
		
		//临时存放对应信息资源ID
		InformationResource infor=getInfor(clumns[0]);
		if(infor==null){
			appendMsg("表二 第"+realNum+"行第1列，信息资源名称不存在！");
			setError(true);
		}else{
			de.setCounts(infor.getId());
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
		de.setClassType(1);
		
		if(!StringUtils.isEmpty(clumns[7])){
			if(companyname.get(clumns[7])==null){
				appendMsg("第"+realNum+"行第8列 不存在该部门");
				setError(true);
			}else{
				de.setCompanyId(Integer.valueOf(companyname.get(clumns[7])));
				de.setValue8(companyname.get(clumns[7]));
				
				if(!de.getValue8().equals(AccountShiroUtil.getCurrentUser().getCompanyId()+"")){
					System.out.println("validateName");
					if(validateName(de.getChName(),de.getValue8())){
						de.setValue30("1");
					}else{
						de.setValue30("0");
					}
					return de;
				}

			}
		}

		if(validateName(de.getChName())){
			de.setValue30("1");
		}else{
			de.setValue30("0");
		}


		return de;
	}

}
