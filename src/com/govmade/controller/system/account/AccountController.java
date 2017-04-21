package com.govmade.controller.system.account;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.govmade.common.ajax.AjaxRes;
import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.common.utils.security.CipherUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.account.Account;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.organization.Groups;
import com.govmade.entity.system.rbac.Role;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.account.AccountService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.organization.GroupsService;
import com.govmade.service.system.rbac.RoleService;

@Controller
@RequestMapping("/backstage/account/")
public class AccountController extends GovmadeBaseController<Account>{

	@Autowired
	private AccountService service;
	@Autowired
	private CompanyService companyService;
	@Autowired
	private GroupsService groupsService;
	@Autowired
	private RoleService roleService;
	
	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public String indexURL() {
		return "/system/account/index";
	}
	
	//插入数据库前生成盐和密码加密
	@Override
	public void doBeforeInsertUpdate(Account o,HttpServletRequest req, HttpServletResponse res){
		if(null!=o.getPassword()&&""!=o.getPassword()){
			String salt=CipherUtil.createSalt();
			String pwrsMD5=CipherUtil.generatePassword(o.getPassword());		
			o.setPassword(CipherUtil.createPwdEncrypt(o.getLoginName(),pwrsMD5,salt));	
			o.setSalt(salt);
		}
	}
	
	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map= super.getDataHandlers();
		//根据政府机构ID从政府机构中取出政府机构名字
		map.put("companyId", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				Company c=new Company();
				c.setId((Integer)obj);	
				List<Company> l=companyService.find(c);		
				if(l!=null&&l.size()>0){
					return l.get(0).getCompanyName();
				}
				return "";
			}
			@Override
			public int getMode() {
				return ADD_MODE;
			}			
		});	
		//根据业务处室ID从业务处室中取出业务处室名字
		map.put("groupId", new DataHandler() {
				@Override
				public Object doHandle(Object obj) {
					Groups g=new Groups();
					g.setId((Integer)obj);	
					List<Groups> l=groupsService.find(g);		
					if(l!=null&&l.size()>0){
						return l.get(0).getName();
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
	
	@RequestMapping(value="findByPage", method=RequestMethod.POST)
	@ResponseBody
	public AjaxRes findByPage(Page<Account> page,Account o,HttpServletRequest req, HttpServletResponse res){
		AjaxRes ar=getAjaxRes();
		if(ar.setNoAuth(doSecurityIntercept(Const.RESOURCES_TYPE_MENU,"/backstage/account/index"))){
			try {
				Page<Account> accounts=service.findByPage(o, page);
				Map<String, Object> p=new HashMap<String, Object>();
				p.put("permitBtn",getPermitBtn(Const.RESOURCES_TYPE_BUTTON,req));
				p.put("list",accounts);		
				ar.setSucceed(p);
			} catch (Exception e) {
				logger.error(e.toString(),e);
				ar.setFailMsg(Const.DATA_FAIL);
			}
		}	
		return ar;
	}

	//跳到修改密码页面
	@RequestMapping("psd")
	public String psd(){
		return "/system/account/password/index";
	}
	
	//验证密码是否相同
	@RequestMapping(value="samepsd")
	public String samepsd(Account o,HttpServletRequest req, HttpServletResponse res) throws Exception{
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");	
        o.setSalt(AccountShiroUtil.getCurrentUser().getSalt());
		String psd=req.getParameter("oldpsd");
		String results = "";
		if(null!=psd&&""!=psd){
			String salt=o.getSalt();
			String pwrsMD5=CipherUtil.generatePassword(psd);		
			psd=CipherUtil.createPwdEncrypt(AccountShiroUtil.getCurrentUser().getLoginName(),pwrsMD5,salt);	
			System.out.println("psd="+psd);
			if(psd.equals(AccountShiroUtil.getCurrentUser().getPassword())){
				results = "0";
			}
			if(results==""){
				results = "1";
			}
	}	
		res.getWriter().write(results);
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	//修改密码
	@RequestMapping(value="updatepsd")
	public String updatepsd(Account o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		o=AccountShiroUtil.getCurrentUser();
		String newpsd=req.getParameter("newpsd");
		if(null!=newpsd&&""!=newpsd){
			String salt=CipherUtil.createSalt();
			String pwrsMD5=CipherUtil.generatePassword(newpsd);		
			o.setPassword(CipherUtil.createPwdEncrypt(AccountShiroUtil.getCurrentUser().getLoginName(),pwrsMD5,salt));	
			o.setSalt(salt);
		}
		getService().update(o);	
		return null;
	}
	
	//验证名称重复
	@RequestMapping(value="validation")
	public String validation(Account o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");		
		Account c=new Account();
		String acc=o.getLoginName();
		c.setLoginName(acc);
		String results = "";
		if (o.getId() == null) {
			if (!service.find(c).isEmpty()&&StringUtils.isNotEmpty(o.getLoginName())) {
				results = "1";
			}
	} else {

			if(service.find(c).size()!=0&&StringUtils.isNotEmpty(o.getLoginName())){
				if ((int) service.find(c).get(0).getId() != (int) o.getId()) {
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
