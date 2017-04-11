package com.govmade.jstl;

import java.io.IOException;

import javax.servlet.jsp.JspContext;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.JspFragment;
import javax.servlet.jsp.tagext.JspTag;
import javax.servlet.jsp.tagext.SimpleTag;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import com.govmade.service.system.dict.GovmadeDicService;

public class GovmadeDicTag implements SimpleTag,ApplicationContextAware{
	private static ApplicationContext applicationContext;
	@Override
	public void doTag() throws JspException, IOException {
		System.out.println(applicationContext.getBean("GovmadeDicService")+"---");
		//ServletContext application = ServletActionContext.getRequest().getSession().getServletContext();  
		// ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);  
		 //ActManager actManager = (ActManager)context.getBean("actManager"); 
	}

	@Override
	public JspTag getParent() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setJspBody(JspFragment arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setJspContext(JspContext arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setParent(JspTag arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setApplicationContext(ApplicationContext arg0) throws BeansException {
		applicationContext=arg0;
	}

}
