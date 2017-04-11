package com.govmade.interceptor.springmvc;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class PermissionInterceptor  extends HandlerInterceptorAdapter{

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		 String url=request.getRequestURI();
		 if(StringUtils.isNotEmpty(request.getQueryString())){
				url+="?"+request.getQueryString();
			}
		 request.getSession().setAttribute("url", url);
		 return true;     
	}

}
