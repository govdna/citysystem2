package com.govmade.controller.system.data;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.customFields.DataElementFields;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataManager;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.DataElementFieldsService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.data.DataManagerService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.InformationResourceService;

import net.sf.json.JSONObject;


/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 数据元自定义字段
* @date 2017年2月1日 下午9:30:59   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: DataElementFieldsController.java
* @Package com.govmade.controller.system.data
* @version V1.0   
*/
@Controller
@RequestMapping("/backstage/dataElementFields/")
public class DataElementFieldsController extends GovmadeBaseController<DataElementFields>{

	@Autowired
	private DataElementFieldsService service;
	
	@Autowired
	private DataElementService dataElementService;
	
	@Override
	public void doBeforeInsertUpdate(DataElementFields o, HttpServletRequest req, HttpServletResponse res) {
		if(o.getValueNo()!=null){
			return;
		}
		List<DataElementFields> dmList=service.find(new DataElementFields());
		//前十个字段留着
		for(int i=10;i<=30;i++){
			boolean used=false;
			for(DataElementFields dm:dmList){
				if(dm.getValueNo()!=null&&dm.getValueNo().intValue()==i){
					used=true;
					break;
				}
			}
			if(!used){
				o.setValueNo(i);
				return;
			}
		}
	}

	
	@Override
	public void doWithDelete(DataElementFields o, HttpServletRequest req, HttpServletResponse res) {
		DataElementFields dm=service.findById(o);
		if(dm.getValueNo()!=null){
			dataElementService.clearColumn(dm.getValueNo());
		}
	}



	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public String indexURL() {
		return "/system/dataElementFields/index";
	}
	
	
}
