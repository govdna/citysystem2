package com.govmade.controller.system.customization;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.customization.Customization;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.model.HouseModel;
import com.govmade.entity.system.organization.Company;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.customization.CustomizationService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.data.DataListService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.organization.CompanyService;

import net.sf.json.JSONObject;

@Controller
@RequestMapping("/backstage/customization/")
public class CustomizationController extends GovmadeBaseController<Customization>{

	@Autowired
	private CustomizationService service;
	@Autowired
	private DataListService dataListService;
	@Autowired
	private DataElementService dataElementService;
	@Autowired
	private CompanyService companyService;
	@Autowired
	private GovmadeDicService govmadeDicservice;
	
	@Override
	public String indexURL() {
		return "/system/customization/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}


	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String,DataHandler> map= super.getDataHandlers();
		
		map.put("id", new DataHandler() {
			@Override
			public int getMode() {
				return FREEDOM_MODE;
			}
			@Override
			public Object doHandle(Object obj) {
				return null;
			}
			@Override
			public void doHandle(Object bo, JSONObject jo) {
				Customization res=(Customization)bo;
				jo.put("id", res.getId());
				jo.put("idForShow", SecurityUtil.encrypt(res.getId()));
				//System.out.println("res.getId()= "+res.getId());
				DataList dl=new DataList();
				String dmids="";
				dl.setCustomizationId(res.getId());
				List<DataList> dmlist=dataListService.find(dl);
				for(DataList dm:dmlist){
					dmids=dmids+dm.getDataElementId()+",";
				}
				dmids=StringUtil.toSQLArray(dmids);
				//System.out.println("dmids= "+dmids);
				jo.put("dataElementIds", dmids.toString());
			}			
		});	
		
		return map;
	}
	
	@Override
	public void doAfterInsertUpdate(Customization o, HttpServletRequest req, HttpServletResponse res) {
		String str = StringUtil.toSQLArray(o.getDataElementId());
		int infoResId = o.getId();		
			String[] strs = str.split(",");
			DataList dl = new DataList();			
			dl.setCustomizationId(infoResId);
			dataListService.deleteByCustomizationId(dl);
			for (String ids: strs) {
				if(!StringUtil.is_Empty(ids)){
					dl.setDataElementId(Integer.valueOf(ids));
					dataListService.insert(dl);
				}				
			}
	}

}
