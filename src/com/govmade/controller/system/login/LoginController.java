package com.govmade.controller.system.login;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.catalina.connector.Request;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.ExcessiveAttemptsException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.LockedAccountException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.govmade.common.utils.IPUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.SessionListener;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.common.utils.webpage.PageData;
import com.govmade.controller.base.BaseController;
import com.govmade.entity.system.account.Account;
import com.govmade.entity.system.log.LoginLog;
import com.govmade.service.system.account.AccountService;
import com.govmade.service.system.log.LoginLogService;


@Controller
public class LoginController extends BaseController<Object>{
	
	@Autowired
	private LoginLogService loginLogService;
	private  static Map<String, String> semap = new HashMap<String, String>();  
	/**
	 * 访问登录页
	 * @return
	 */
	@RequestMapping(value="/loginIndex")
	public ModelAndView toLogin()throws Exception{
		ModelAndView mv =  new ModelAndView();
		if(ServiceUtil.getThemeType(10)==6){
			mv.setViewName("system/login/login-6");
		}else if(ServiceUtil.getThemeType(10)==4){
			mv.setViewName("system/login/login-4");
		}else if(ServiceUtil.getThemeType(10)==7){
			mv.setViewName("system/login/login-7");
		}else if(ServiceUtil.getThemeType(10)==8){
			mv.setViewName("system/login/login-8");
		}else{
		mv.setViewName("system/login/login");
		}
		return mv;
	}
	
	/**
	 * 请求登录，验证用户
	 */
	@RequestMapping(value="/system_login" ,produces="application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> login(HttpServletRequest req,HttpServletResponse resp)throws Exception{
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = this.getPageData();
		String errInfo = "";
		String KEYDATA[] = pd.getString("KEYDATA").split(",jy,");
		String accountId="";
		String logName="";
		String sessionId = req.getSession().getId();
		if(null != KEYDATA && KEYDATA.length == 3){
			//shiro管理的session
			Subject currentUser = SecurityUtils.getSubject();  
			Session session = currentUser.getSession();
			String sessionCode = (String)session.getAttribute(Const.SESSION_SECURITY_CODE);		//获取session中的验证码		
			String code = KEYDATA[2];
			String username = KEYDATA[0];
			String password  = KEYDATA[1];			
			logName=username;//记录用户名
			if(null == code || "".equals(code)){
				errInfo = "nullcode"; //验证码为空
			}else if(StringUtils.isEmpty(username)||StringUtils.isEmpty(password)){
				errInfo = "nullup";	//缺少用户名或密码
			}else{
				if(StringUtils.isNotEmpty(sessionCode) && sessionCode.equalsIgnoreCase(code)){										
					// shiro加入身份验证
					UsernamePasswordToken token = new UsernamePasswordToken(username, password.toUpperCase());
					token.setRememberMe(true);
					try {
						//if (!currentUser.isAuthenticated()) {
							currentUser.login(token);
						//}		
						//记录登录日志
						accountId=AccountShiroUtil.getCurrentUser().getId()+"";
					} catch (UnknownAccountException uae) {
						errInfo = "usererror";// 用户名或密码有误
					} catch (IncorrectCredentialsException ice) {
						errInfo = "usererror"; // 密码错误
					} catch (LockedAccountException lae) {
						errInfo = "inactive";// 未激活
					} catch (ExcessiveAttemptsException eae) {
						errInfo = "attemptserror";// 错误次数过多
					} catch (AuthenticationException ae) {
						errInfo = "codeerror";// 验证未通过
					}
					// 验证是否登录成功
					if (!currentUser.isAuthenticated()) {
						token.clear();
					}
				}else{
					errInfo = "codeerror";				 	//验证码输入有误
				}
				if(StringUtils.isEmpty(errInfo)){
					errInfo = "success";					//验证成功
					session.removeAttribute(Const.SESSION_SECURITY_CODE);//移除SESSION的验证
				}				
			}
		}else{
			errInfo = "error";	//缺少参数
		}	       
		String loginIP=IPUtil.getIpAddr(getRequest());//获取用户登录IP
		LoginLog loginLog=new LoginLog(accountId,logName,loginIP,errInfo);
		loginLogService.insert(loginLog);
		Date date=new Date();
	    DateFormat format=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String time=format.format(date);
        req.getSession().setAttribute("accountId",accountId);
        req.getSession().setAttribute("time",time);
		if(accountId!=null&&accountId!=""){
			Integer accountid=Integer.parseInt(accountId);
			SessionListener.InfoToMap(accountid, time);
		}
		map.put("result", errInfo);
		return map;
	}		
	  /**
     * 帐号注销
     * @return
     */
    @RequestMapping("/system_logout")
    public static String logout(HttpServletRequest request,HttpSession session) {
        Subject currentUser = SecurityUtils.getSubject();
        currentUser.logout();
        session = request.getSession(true);
        session.removeAttribute(Const.SESSION_USER);
		session.removeAttribute(Const.SESSION_MENULIST);
        return "redirect:loginIndex.html";
    }

}
