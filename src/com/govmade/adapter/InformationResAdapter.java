package com.govmade.adapter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.ExcelAdapter;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.InformationResService;
import com.govmade.service.system.information.InformationResourceService;

public class InformationResAdapter extends ExcelAdapter<InformationRes>{

	private Map<String,String> sortManager=new HashMap<String, String>(); // 信息资源分类
	private Map<String,String> companyname=new HashMap<String, String>();
	private Map<String,String> inforProviders=new HashMap<String, String>();
	private Map<String,String> informationBuss=new HashMap<String, String>();
	private InformationResService service;
	private DataElementService dataElementService;
	private void initDic(){
		if(service==null){
			service=(InformationResService) ServiceUtil.getService("InformationResService");
		}else{
			return;
		}
		if(dataElementService==null){
			dataElementService=(DataElementService) ServiceUtil.getService("DataElementService");
		}
		
		SortManager sm=new SortManager();
		sm.setType(3);
		List<SortManager> xxzyfl=(List<SortManager>) ServiceUtil.getService("SortManagerService").find(sm); // 信息资源分类
		for(SortManager d:xxzyfl){
			sortManager.put(d.getSortName(), d.getId()+"");
		}
		List<GovmadeDic> dic=ServiceUtil.getDicByDicNum("ZYTGF");
		for(GovmadeDic d:dic){
			inforProviders.put(d.getDicValue(), d.getDicKey());
		}
		DataElement de=new DataElement();
		
		Company com=new Company();
		List<Company> company=(List<Company>)ServiceUtil.getService("CompanyService").find(com);
		for(Company c:company){
			companyname.put(c.getCompanyName(), c.getId()+"");
		}
		InformationBusiness ib=new InformationBusiness();
		List<InformationBusiness> ibl=(List<InformationBusiness>) ServiceUtil.getService("InformationBusinessService").find(ib); // 数据元
		for(InformationBusiness d:ibl){
			informationBuss.put(d.getBusName(), d.getId()+"");
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
	public InformationRes doWithRowData(String[] clumns,int rowNum) {
		int realNum=rowNum+1;
		initDic();
		InformationRes de=new InformationRes();

		de.setValue1(clumns[4].trim()); 		// 信息资源名称
		if(service.find(de).size()>0){
			appendMsg("第"+realNum+"行第5列，信息资源名称  有误！");
			setError(true);
		}

		if(sortManager.get(clumns[0])==null){
			appendMsg("第"+realNum+"行第1列，(信息资源分类)类 有误！");
			setError(true);
		}else{			
			de.setInforTypes(Integer.valueOf(sortManager.get(clumns[0]))+"");
		}
		
		if(sortManager.get(clumns[1])==null){
			appendMsg("第"+realNum+"行第2列，(信息资源分类) 项 有误！");
			setError(true);
		}else{			
			de.setInforTypes2(Integer.valueOf(sortManager.get(clumns[1])));
		}
		
		if(clumns[2]!=null&&clumns[2]!=""&&clumns[2].length()>0){
			if(sortManager.get(clumns[2])==null){
				appendMsg("第"+realNum+"行第3列，(信息资源分类) 目 有误！");
				setError(true);
			}else{			
				de.setInforTypes3(Integer.valueOf(sortManager.get(clumns[2])));
			}
		}

		if(clumns[3]!=null&&clumns[3]!=""&&clumns[3].length()>0){
			if(sortManager.get(clumns[3])==null){
				appendMsg("第"+realNum+"行第4列，(信息资源分类) 细目 有误！");
				setError(true);
			}else{			
				de.setInforTypes4(Integer.valueOf(sortManager.get(clumns[3])));
			}
		}
		
		if(clumns[5]!=null&&clumns[5]!=""&&clumns[5].length()>0){
			if(inforProviders.get(clumns[5])==null){
				appendMsg("第"+realNum+"行第6列，信息资源提供方 有误！");
				setError(true);
			}else{			
				de.setValue2(Integer.valueOf(inforProviders.get(clumns[5]))+"");
			}
		}

		if(clumns[6]!=null&&clumns[6]!=""&&clumns[6].length()>0){
			if(informationBuss.get(clumns[6])==null){
				appendMsg("第"+realNum+"行第7列，关联业务 有误！");
				setError(true);
			}else{			
				de.setValue3(Integer.valueOf(informationBuss.get(clumns[6]))+"");
			}
		}

		de.setValue4(clumns[7]);		
		
/*		
		if(companyname.get(clumns[9])==null){
			de.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
		}else{
			de.setCompanyId(Integer.valueOf(companyname.get(clumns[9])));
		}
*/		
		return de;
	}


}
