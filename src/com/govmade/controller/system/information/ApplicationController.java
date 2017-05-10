package com.govmade.controller.system.information;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.information.Application;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.organization.Company;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.information.ApplicationService;
import com.govmade.service.system.information.InformationResourceService;
import com.govmade.service.system.organization.CompanyService;

import net.sf.json.JSONObject;

/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 资源申请
* @date 2017年1月11日 上午9:44:03   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: ApplicationController.java
* @Package com.govmade.controller.system.information
* @version V1.0   
*/
@Controller
@RequestMapping("/backstage/application/")
public class ApplicationController extends GovmadeBaseController<Application>{

	@Autowired
	private ApplicationService service;
	
	@Autowired
	private InformationResourceService informationResourceService;
	
	@Autowired
	private CompanyService companyService;
	
	
	@Override
	public String indexURL() {
		return "/system/information/application/index";
	}


	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map= super.getDataHandlers();
		map.put("informationId", new DataHandler() {
			
			@Override
			public int getMode() {
				return ADD_MODE;
			}
			
			@Override
			public Object doHandle(Object obj) {
				InformationResource info=new InformationResource();
				info.setId((Integer)(obj));
				info=informationResourceService.findById(info);
				if(info!=null){
					return info.getValue1();
				}
				return null;
			}
		});
		map.put("applyCompany", new DataHandler() {
			
			@Override
			public int getMode() {
				return ADD_MODE;
			}
			
			@Override
			public Object doHandle(Object obj) {
				Company com=new Company();
				com.setId((Integer)obj);
				com=companyService.findById(com);
				if(com!=null){
					return com.getCompanyName();
				}
				return null;
			}
		});
		
		map.put("informationCompany", new DataHandler() {
			
			@Override
			public int getMode() {
				return ADD_MODE;
			}
			
			@Override
			public Object doHandle(Object obj) {
				Company com=new Company();
				com.setId((Integer)obj);
				com=companyService.findById(com);
				if(com!=null){
					return com.getCompanyName();
				}
				return null;
			}
		});
		
		
		
		return map;
	}


	@Override
	public BaseService getService() {
		return service;
	}


	@Override
	public void doBeforeInsertUpdate(Application o, HttpServletRequest req, HttpServletResponse res) {
		o.setStatus(1);
		if(o.getApplyCompany()==null){
			o.setApplyCompany(AccountShiroUtil.getCurrentUser().getCompanyId());
		}
	}


	@Override
	public boolean insertAjaxIntercept(Application o, HttpServletRequest req, HttpServletResponse res) {
		if(o.getId()!=null){
			return false;
		}
		try {
			Application ap=new Application();
			ap.setInformationId(o.getInformationId());
			ap.setApplyCompany(o.getApplyCompany());
			List<Application> list=service.find(ap);
			if(list!=null&&list.size()>0){
				for(Application a:list){
					if(a.getStatus()==0||a.getStatus()==1){
						JSONObject ar = new JSONObject();
						ar.put("msg", "已申请共享！");
						ar.put("code", Const.FAIL);
						res.getWriter().write(ar.toString());
						res.getWriter().flush();
						res.getWriter().close();
						return true;
					}
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return false;
	}


	@Override
	public void doBeforeListAjax(Application o, HttpServletRequest req, HttpServletResponse res) {
		if(o.getCompanyId()==null){
			o.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
		}
	}


	@RequestMapping(value = "updateStatus")
	public String updateStatus(Application o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		if (o instanceof IdBaseEntity && StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
			((IdBaseEntity) o).setId(Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow"))));
		}
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			service.updateStatus(o);
			ar.put("code", Const.SUCCEED);
			ar.put("msg", Const.ACTION_SUCCEED);
		} catch (Exception e) {
			ar.put("code", Const.FAIL);
			ar.put("msg", Const.ACTION_FAIL);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	
	
}
