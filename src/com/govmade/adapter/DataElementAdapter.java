package com.govmade.adapter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;



import com.govmade.common.utils.ChineseTo;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.ExcelAdapter;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.organization.Company;
import com.govmade.service.system.data.DataElementService;


public class DataElementAdapter extends ExcelAdapter<DataElement>{
	private Integer classType;
	private Map<String,String> dataTypeDic=new HashMap<String, String>();
	private Map<String,String> objectType=new HashMap<String, String>();
	private Map<String,String> companyname=new HashMap<String, String>();
	private Map<String,String> dicCompany=new HashMap<String, String>();
	private DataElementService service;
	
	public DataElementAdapter(Integer classType) {
		super();
		this.classType = classType;
	}
	private void initDic(){
		if(dataTypeDic.size()!=0){
			return;
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
		
		if(classType==0){
			if(clumns[6].trim().equals("")||clumns[6]==null){
				de.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
			}else{
				if(dicCompany.get(clumns[6])==null){
					appendMsg("第"+realNum+"行第7列，"+clumns[6]+"，不存在该来源部门！");
					setError(true);
				}else{
					de.setValue8(dicCompany.get(clumns[6]));
				}
			}
			
		}else{
			if(clumns[6].trim().equals("")||clumns[6]==null){
				de.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
				de.setValue8(AccountShiroUtil.getCurrentUser().getCompanyId()+"");
			}else{
				if(companyname.get(clumns[6])==null){
					appendMsg("第"+realNum+"行第7列，"+clumns[6]+"，不存在该来源部门！");
					setError(true);
				}else{
					de.setValue8(companyname.get(clumns[6]));
					de.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
				}
			}
		}
		
		
		de.setChName(clumns[0]);
		de.setIsDeleted(0);
		de.setClassType(classType);
		if(!service.volidate(de)){
			appendMsg("第"+realNum+"行第1列 中文名称 "+de.getChName() +" 已有重复！");
			setError(true);
		}
		
		//de.setEgName(clumns[1]);
		de.setDefine(clumns[1]);
		if(dataTypeDic.get(clumns[2])==null){
			appendMsg("第"+realNum+"行第3列，数据类型有误！");
			setError(true);
		}else{
			
			de.setDataType(Integer.valueOf(dataTypeDic.get(clumns[2])));
		}
		
		de.setDataFormat(clumns[3]);
		if(objectType.get(clumns[4])==null){
			appendMsg("第"+realNum+"行第5列，对象类型有误！");
			setError(true);
		}else{
			de.setObjectType(Integer.valueOf(objectType.get(clumns[4])));
		}
		de.setNotes(clumns[5]);
		

		
		de.setEgName(ChineseTo.getPinYinHeadChar(clumns[0]).toUpperCase());
		
		return de;
	}
	public Integer getClassType() {
		return classType;
	}
	public void setClassType(Integer classType) {
		this.classType = classType;
	}


}
