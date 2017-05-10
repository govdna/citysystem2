package com.govmade.controller.system.simpleFields;

import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.WebApplicationContext;

import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.customFields.DataElementFields;
import com.govmade.entity.system.customFields.SimpleFields;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataManager;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.service.base.BaseService;
import com.govmade.service.base.CanSimpleFields;
import com.govmade.service.system.data.DataElementFieldsService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.data.DataManagerService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.InformationResourceService;
import com.govmade.service.system.simpleFields.SimpleFieldsService;

import net.sf.json.JSONObject;



/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan 通用自定义
* @date 2017年3月1日 上午10:36:09   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: SimpleFieldsController.java
* @Package com.govmade.controller.system.simpleFields
* @version V1.0   
*/
@Controller
@RequestMapping("/backstage/simpleFields/")
public class SimpleFieldsController extends GovmadeBaseController<SimpleFields>{

	@Autowired
	private SimpleFieldsService service;
	
	
	
	@RequestMapping(value = "{className}/index")
	public String index(@PathVariable("className") String className,Model model, HttpServletRequest req, HttpServletResponse res) {
		model.addAttribute("className", className);
		return index(model, req, res);
	}

	
	@RequestMapping(value = "{className}/detailAjax")
	public String detailAjax(@PathVariable("className") String className,SimpleFields o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		o.setClassName(className);
		return super.detailAjax(o, req, res);
	}


	@RequestMapping(value = "{className}/deleteAjax")
	public String deleteAjax(@PathVariable("className") String className,SimpleFields o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		o.setClassName(className);
		return super.deleteAjax(o, req, res);
	}


	@RequestMapping(value = "{className}/insertAjax")
	public String insertAjax(@PathVariable("className") String className,SimpleFields o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		o.setClassName(className);
		return super.insertAjax(o, req, res);
	}


	@RequestMapping(value = "{className}/listAjax")
	public String listAjax(@PathVariable("className") String className,SimpleFields o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		o.setClassName(className);
		return super.listAjax(o, req, res);
	}


	@Override
	public void doBeforeInsertUpdate(SimpleFields o, HttpServletRequest req, HttpServletResponse res) {
		if(o.getValueNo()!=null){
			return;
		}
		SimpleFields sm=new SimpleFields();
		sm.setClassName(o.getClassName().trim());
		List<SimpleFields> dmList=service.find(sm);
		//前十个字段留着
		for(int i=10;i<=30;i++){
			boolean used=false;
			for(SimpleFields dm:dmList){
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
	public void doWithDelete(SimpleFields o, HttpServletRequest req, HttpServletResponse res) {
		SimpleFields dm=service.findById(o);
		ServletContext servletContext=req.getSession().getServletContext();
		WebApplicationContext webApplicationContext = (WebApplicationContext)servletContext.getAttribute(WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
		CanSimpleFields sv=(CanSimpleFields)webApplicationContext.getBean(dm.getClassName()+"Service");
		if(dm.getValueNo()!=null&&sv!=null){
			sv.clearColumn(dm.getValueNo());
		}
	}



	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public String indexURL() {
		return "/system/simpleFields/index";
	}
	
	
}
