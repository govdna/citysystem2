package com.govmade.controller.system.backstage;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.govmade.common.ajax.AjaxRes;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.common.utils.tree.MenuTreeUtil;
import com.govmade.common.utils.webpage.PageData;
import com.govmade.controller.base.BaseController;
import com.govmade.entity.system.account.Account;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.resources.Resources;
import com.govmade.entity.system.theme.Theme;
import com.govmade.service.system.rbac.PermissionService;
import com.govmade.service.system.resources.ResourcesService;
import com.govmade.service.system.theme.ThemeService;

@Controller
@RequestMapping("/backstage/")
public class BackstageController extends BaseController<Object>{
	
	@Autowired
	public ResourcesService menuService;
	
	@Autowired
	public PermissionService permissionService;
	
	@Autowired
	public ThemeService themeService;
	
	/**
	 * 访问系统首页
	 */
	@RequestMapping("index")
	public String index(Model model){	
		//shiro获取用户信息
		Account currentAccount=AccountShiroUtil.getCurrentUser();
		model.addAttribute("currentAccount", currentAccount);
        Integer th=ServiceUtil.getThemeType(10);
        System.out.println("th="+th);
		Permission mm=new Permission();
		mm.setType(Permission.MENU);
		mm.setMenuType(Permission.MENUTYPE_STAGE);
		model.addAttribute("menu",permissionService.getPermissionsByRoleId(currentAccount.getRoleId(), mm));
		if(th==4){
			Permission p=new Permission();
			p.setType(Permission.MENU);
			List<Permission> list=permissionService.getPermissionsByRoleId(AccountShiroUtil.getCurrentUser().getRoleId(), p);	
		    Set<Integer> m = new HashSet<Integer>();
		    for(int x = 0; x < list.size(); x++){
		    	Permission per=list.get(x);
		    	if(per.getMenuType()==4||per.getMenuType()==7){	    		
		    	}else{
		    	m.add( per.getMenuType());	
		    	}
		    }
		    System.out.println(m.size()+"-----");
	        Theme the=new Theme();
		    Integer i =0;
	        Iterator<Integer> it=m.iterator();
	        Map<Integer,String> map= new HashMap<Integer,String>();
	        while(it.hasNext()){
		    	Integer it1=it.next();
		        the.setId(it1);
		        the.setTitleBig(ServiceUtil.getTitleBig(it1));
		        map.put(the.getId(), the.getTitleBig());
		        i++;     
	        }       
	        model.addAttribute("menuType",map);
		    if(m.size()==4){
		    	return "/system/index/index4/index4";
		    }else if(m.size()==5){
		    	return "/system/index/index4/index5";
		    }else if(m.size()==3){
		    	return "/system/index/index4/index3";
		    }
		}else if(th==6){
			Permission p=new Permission();
			p.setType(Permission.MENU);
			List<Permission> list=permissionService.getPermissionsByRoleId(AccountShiroUtil.getCurrentUser().getRoleId(), p);	
		    Set<Integer> m = new HashSet<Integer>();
		    for(int x = 0; x < list.size(); x++){
		    	Permission per=list.get(x);
		    	if(per.getMenuType()==4){	    		
		    	}else{
		    	m.add( per.getMenuType());	
		    	}
		    }
		    System.out.println(m.size()+"-----");
		      model.addAttribute("menuType1",m);
			return "/system/index/index6/index";
		}else if(th==7){
			Permission p=new Permission();
			p.setType(Permission.MENU);
			List<Permission> list=permissionService.getPermissionsByRoleId(AccountShiroUtil.getCurrentUser().getRoleId(), p);	
		    Set<Integer> m = new HashSet<Integer>();
		    for(int x = 0; x < list.size(); x++){
		    	Permission per=list.get(x);
		    	if(per.getMenuType()==4){	    		
		    	}else{
		    	m.add( per.getMenuType());	
		    	}
		    }
		    System.out.println(m.size()+"-----");
		      model.addAttribute("menuType1",m);
			return "/system/index/index7/index";
		}else if(th==8){
			Permission p=new Permission();
			p.setType(Permission.MENU);
			List<Permission> list=permissionService.getPermissionsByRoleId(AccountShiroUtil.getCurrentUser().getRoleId(), p);	
		    Set<Integer> m = new HashSet<Integer>();
		    for(int x = 0; x < list.size(); x++){
		    	Permission per=list.get(x);
		    	if(per.getMenuType()==4){	    		
		    	}else{
		    	m.add( per.getMenuType());	
		    	}
		    }
		    System.out.println(m.size()+"-----");
		      model.addAttribute("menuType1",m);
			return "/system/index/index8/index";
		}else{
			Permission p=new Permission();
			p.setType(Permission.MENU);
			List<Permission> list=permissionService.getPermissionsByRoleId(AccountShiroUtil.getCurrentUser().getRoleId(), p);	
		    Set<Integer> m = new HashSet<Integer>();
		    for(int x = 0; x < list.size(); x++){
		    	Permission per=list.get(x);
		    	if(per.getMenuType()==4){	    		
		    	}else{
		    	m.add( per.getMenuType());	
		    	}
		    }
		    System.out.println(m.size()+"-----");
		      model.addAttribute("menuType1",m);
			return "/system/index";
		}
		return null;

	}
	
	/**
	 * 访问系统首页
	 */
	@RequestMapping("manage")
	public String manage(Model model){	
		//shiro获取用户信息
		Account currentAccount=AccountShiroUtil.getCurrentUser();
		model.addAttribute("currentAccount", currentAccount);
	    Integer th=ServiceUtil.getThemeType(10);
		Permission mm=new Permission();
		mm.setType(Permission.MENU);
		mm.setMenuType(Permission.MENUTYPE_MANAGE);
		 if(th==6){
				if(StringUtils.isNotEmpty(getRequest().getParameter("menuType"))){
					mm.setMenuType(Integer.valueOf(getRequest().getParameter("menuType")));
				}
				model.addAttribute("menuHtml", MenuTreeUtil.buildMenuHtml(getRequest().getContextPath(),permissionService.getPermissionsByRoleId(currentAccount.getRoleId(), mm)));
				model.addAttribute("menuType",mm.getMenuType());
				model.addAttribute("rurl",getRequest().getParameter("rurl"));
				return "/system/manageIndex/manageIndex6";
			}
		if(StringUtils.isNotEmpty(getRequest().getParameter("menuType"))){
			mm.setMenuType(Integer.valueOf(getRequest().getParameter("menuType")));
		}
		model.addAttribute("menuHtml", MenuTreeUtil.buildMenuHtml(getRequest().getContextPath(),permissionService.getPermissionsByRoleId(currentAccount.getRoleId(), mm)));
		model.addAttribute("menuType",mm.getMenuType());
		model.addAttribute("rurl",getRequest().getParameter("rurl"));
		return "/system/manageIndex";
	}
	
	@RequestMapping("iframeIndex")
	public String iframeIndex(Model model){	
		String index=getRequest().getParameter("index");
		return "/system/iframeIndex/index"+index;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="menu/getMenu", method=RequestMethod.POST)
	@ResponseBody
	public AjaxRes getMenu(){	
		AjaxRes ar=getAjaxRes();
		List<Resources> menus =new ArrayList<Resources>();
		PageData pd = this.getPageData();
		String ref=pd.getString("ref");
		String layer=pd.getString("layer");
		Object menu_o=null;
		try {
			//shiro获取用户信息,shiro管理的session
			Session session=SecurityUtils.getSubject().getSession();
			//获得用户
			Account acount=(Account) session.getAttribute(Const.SESSION_USER);
			//获得用户Id
			String userId=acount.getId()+"";
			if(!"y".equals(ref)){	
				menu_o=session.getAttribute(Const.SESSION_MENULIST);
			}
			menus=(List<Resources>)menu_o;
			if(menus==null){
				if(StringUtils.isBlank(layer))layer="1";
				menus=menuService.findMenuTree(userId,layer);
				session.setAttribute(Const.SESSION_MENULIST, menus);
			}
			if(menus!=null){
				//将对象处理成树
				String html=MenuTreeUtil.buildTreeHtml(menus);			
				ar.setSucceed(html);
			}
		} catch (Exception e) {
			logger.error(e.toString(),e);
			ar.setFailMsg("获取菜单失败");
		}			
		return ar;
	}
	
	@RequestMapping("adv")
	public String advUI(Model model) {	
		return "/system/adv/adv";
	}
	
	@RequestMapping("404")
	public String errorlistUI(Model model){	
		return "/system/error/404";
	}
	/**
	 * 没权限页面
	 * @param model
	 * @return
	 */
	@RequestMapping("noAuthorized")
	public String noAuthorizedUI(Model model){	
		return Const.NO_AUTHORIZED_URL;
	}
}
