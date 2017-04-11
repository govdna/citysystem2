package com.govmade.controller.system.dict;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.sort.SortManagerService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/backstage/govmadeDic/")
public class GovmadeDicController extends GovmadeBaseController<GovmadeDic>{

	@Autowired
	private GovmadeDicService service;
	@Autowired
	private SortManagerService sortManagerService;
	
	@Override
	public String indexURL() {
		return "/system/dic/index";
	}
	@RequestMapping(value = "zytgf")
	public String zytgfURL() {
		return "/system/dic/zytgf/index";
	}
	
	@Override
	public BaseService getService() {
		return service;
	}
	

	@RequestMapping(value = "jqGridTreeJson")
	public String jqGridTreeJson(GovmadeDic g,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		res.getWriter().write(service.getJqGridTreeJson(g).toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
	
	@RequestMapping(value = "sonJson")
	public String sonJson(GovmadeDic g,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		res.getWriter().write(service.getSonJson(g).toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
	
	
	/** 
	* @Title: getDicList 
	* @Description: TODO(用于ajax加载下拉) 
	* @param @param g
	* @param @return
	* @param @throws Exception    设定文件 
	* @return String    返回类型 
	* 2016年12月13日    日期   
	*/ 
	@RequestMapping(value = "getDicList")
	public String getDicList(GovmadeDic g,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		res.getWriter().write(service.getDicList(g).toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
	
	@RequestMapping(value = "matchSearch")
	public void matchSearch(GovmadeDic g,SortManager s,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");  
		res.setCharacterEncoding("utf-8");
		Integer type = Integer.valueOf(req.getParameter("type"));
		JSONArray ja = new JSONArray();
		JSONObject ar = new JSONObject();
		switch(type){
		  case 1:
			  g.setDicNum("ZYTGF");
			  g.setIsDeleted(0);
			  List<GovmadeDic> dl = service.getDicList(g);
			  for(GovmadeDic d : dl){
				  ar.put("name", d.getDicValue());
				  ar.put("id", d.getDicKey());
				  ja.add(ar);
			  }
		  break;
		  case 2:
			  s.setSortId(126);
			  s.setType(null);
			  List<SortManager> dl1 = sortManagerService.find(s);
			 // System.out.println(dl1);
			  for(SortManager d : dl1){
				  ar.put("name", d.getSortName());
				  ar.put("id", d.getId());
				  ja.add(ar);
			  }
		  break;
		  case 3:
			  s.setSortId(134);
			  s.setType(null);
			  List<SortManager> dll1 = sortManagerService.find(s);
			  for(SortManager d : dll1){
				  ar.put("name", d.getSortName());
				  ar.put("id", d.getId());
				  ja.add(ar);
			  }
		  break;		 
		  default:
			  ja.add(ar);
		}
		res.getWriter().write(ja.toString());
		res.getWriter().flush();
		res.getWriter().close();
	}
}
