package com.govmade.controller.system.catalog;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.utils.DataHandler;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.catalog.CatalogManager;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.catalog.CatalogManagerService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.sort.SortManagerService;

/**   
* @author (作者) Chenlei 774329191@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月12日 下午5:17:42   
* @Title: CatalogManagerController.java  
*/
@Controller
@RequestMapping("/backstage/catalogManager/")
public class CatalogManagerController extends GovmadeBaseController<CatalogManager>{

	@Autowired
	private CatalogManagerService service;
	
	
	@Autowired
	private GovmadeDicService govmadeDicservice;
	
	@Autowired
	private SortManagerService sortManagerservice;

	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map= super.getDataHandlers();
		map.put("cataNumber", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic=new GovmadeDic();
				dic.setDicNum("CATANUMBER");
				dic.setDicKey((Integer)obj+"");			
				List<GovmadeDic> l=govmadeDicservice.getDicList(dic);		
				if(l!=null&&l.size()>0){
					return l.get(0).getDicValue();
				}
				return "";
			}

			@Override
			public int getMode() {
				return ADD_MODE;
			}
			
		});
		return map;
	}
	
	@Override
	public BaseService getService() {
		// TODO Auto-generated method stub
		return service;
	}

	@Override
	public String indexURL() {
		// TODO Auto-generated method stub
       return "/system/catalog/index";
	}

}
