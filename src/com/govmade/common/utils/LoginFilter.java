package com.govmade.common.utils;

import java.io.IOException;
import com.govmade.common.utils.security.AccountShiroUtil;
import javax.servlet.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.govmade.controller.system.login.LoginController;

/**   
* @author (作者) Chenlei 774329191@qq.com   
* @Description: citysystem_hainan TODO
* @date 2017年3月31日 上午10:20:47   
* @Title: LoginFilter.java  
*/

public class LoginFilter implements Filter {
//	private HashMap<Integer, String> sessionMap=new HashMap<Integer,String>();
	protected FilterConfig filterConfig = null;
	protected String redirectURL = null;
    private String url = "/system_login";
	
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
			HttpServletRequest req = (HttpServletRequest) request;
			HttpServletResponse resp = (HttpServletResponse) response;
			StringBuffer requestUrl = req.getRequestURL();		
			if(ServiceUtil.OnlyOne(10)==1){
			if(requestUrl.indexOf(url) < 0){
				if(req.getSession().getAttribute("accountId")!=null){
					 Integer accountid = Integer.parseInt((String) req.getSession().getAttribute("accountId"));		
				if(SessionListener.getTime(accountid) != null&&req.getSession().getAttribute("time")!=null){
					String time = (String) req.getSession().getAttribute("time");
					Integer result = SessionListener.getTime(accountid).compareTo(time);
					if(result<0){       	  				
						System.out.println("时间覆盖");		
				  	    SessionListener.InfoToMap(accountid, time);
					}else if(result==0){
						System.out.println("不做处理");
					}else if(result>0){
						if(result>0){
							System.out.println("要到登录页");
							LoginController.logout(req, req.getSession());	
						}					
					}
				}				
			}		
			}
			}	
			chain.doFilter(request, response);    
    }  

	@Override
	public void destroy() {
		filterConfig = null;
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		filterConfig = arg0;
		redirectURL = filterConfig.getInitParameter("redirectURL");
	}

}

