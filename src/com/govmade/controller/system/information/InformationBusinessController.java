package com.govmade.controller.system.information;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.account.Account;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.organization.Groups;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.account.AccountService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.InformationBusinessService;
import com.govmade.service.system.organization.GroupsService;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月8日 上午9:54:39   
* @Title: InformationController.java  
*/

@Controller
@RequestMapping("/backstage/information/business/")
public class InformationBusinessController extends GovmadeBaseController<InformationBusiness>{

	@Autowired
	private InformationBusinessService service;
	@Autowired
	private GroupsService groupsservice;
	@Autowired
	private AccountService accountService;
	@Autowired
	private GovmadeDicService govmadeDicService;
	
	@Override
	public String indexURL() {
		return "/system/information/business/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public void doBeforeInsertUpdate(InformationBusiness o,HttpServletRequest req, HttpServletResponse res) {
		if(StringUtils.isEmpty(o.getBusNumber())){
			String loginName=AccountShiroUtil.getCurrentUser().getLoginName();
			Account account = new Account();
			account.setLoginName(loginName);
			int accountId = accountService.find(account).get(0).getGroupId();
			Groups g=new Groups();
			g.setId(accountId);
			String gs=groupsservice.find(g).get(0).getNumber();
			String i=service.count(null)+1+"";
			while(i.length()<3){
				i="0"+i;
			}
			/*
			 * 部门编号（groups number）+对象分类（dic dicNum)+
			 * 服务内容分类（dic dicNum）+序列号（001-999）
			 */
			String number=gs+o.getObjectTypes()+o.getObjectContents()+i;
			o.setBusNumber(number);
		}
	}
	
	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String,DataHandler> map= super.getDataHandlers();
		map=DataHandlerUtil.buildSimpleFieldsDataHandlers(map, InformationBusiness.class);
		map.put("objectTypes", new DataHandler() {

				@Override
				public Object doHandle(Object obj) {
					GovmadeDic g=new GovmadeDic();
					g.setDicNum("FWDX");
					g.setDicKey((int)obj+"");
					List<GovmadeDic> list= govmadeDicService.getDicTreeList(g);
					if(list!=null&&list.size()>0){
						return list.get(0).getDicValue();
					}
					return null;
				}

				@Override
				public int getMode() {
					return ADD_MODE;
				}
		});
		return map;
	}
	
	//验证名称重复
	@RequestMapping(value="validation")
	public String validation(InformationBusiness o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");		
		InformationBusiness in=new InformationBusiness();
		String inname=o.getValue1();
		in.setValue1(inname);
		String results = "";
		if (o.getId() == null) {
			if (!service.find(in).isEmpty()&&StringUtils.isNotEmpty(o.getValue1())) {
				results = "1";
			}
	} else {

			if(service.find(in).size()!=0&&StringUtils.isNotEmpty(o.getValue1())){
				if ((int) service.find(in).get(0).getId() != (int) o.getId()) {
					results = "1";
				}
     	}
	}
		if(results==""){
			results = "0";
		}	
		String str="{\"results\":["+ results +"]}";
		res.getWriter().write(str);
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}	
	
}
