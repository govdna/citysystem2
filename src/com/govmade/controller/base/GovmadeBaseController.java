package com.govmade.controller.base;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.govmade.common.ajax.AjaxRes;
import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.DateUtil;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.base.UuidUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.common.utils.webpage.PageData;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.resources.Resources;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.resources.ResourcesService;

import net.sf.json.JSONObject;

public abstract class GovmadeBaseController<T> {
	protected Logger logger = LoggerFactory.getLogger(this.getClass());

	public abstract BaseService getService();

	public abstract String indexURL();

	@Autowired
	public ResourcesService resourcesService;

	

	@RequestMapping("index")
	public String index(Model model,HttpServletRequest req, HttpServletResponse res) {
		return indexURL();
	}

	/** 
	* @Title: doAfterInsertUpdate 
	* @Description: TODO(处理插入和修改之后的操作可以写在此方法) 
	* @param @param o    设定文件 
	* @return void    返回类型 
	* @throws 
	*/
	public void doAfterInsertUpdate(T o,HttpServletRequest req, HttpServletResponse res) {
	}
	//插入前处理
	public void doBeforeInsertUpdate(T o,HttpServletRequest req, HttpServletResponse res) {
     }
	
	//删除前处理
	public void doWithDelete(T o,HttpServletRequest req, HttpServletResponse res) {
	}
	//Ajax前处理
	public void doBeforeListAjax(T o,HttpServletRequest req, HttpServletResponse res) {
	}
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map = new HashMap<String, DataHandler>();
		// System.out.println("---father-------");
		map.put("id", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				return SecurityUtil.encrypt((int) obj);
			}

			@Override
			public int getMode() {
				return ADD_MODE;
			}
		});

		// 创建时间获得字符串时间类型 timeCreate;

		map.put("timeCreate", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				if(obj==null){
					return "";
				}
				return DateUtil.dateFormateObject((Date) obj);
			}

			@Override
			public int getMode() {
				return REPLACE_MODE;
			}
		});
		// 更新时间获得字符串类型 timeModified;
		map.put("timeModified", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				if(obj==null){
					return "";
				}
				return DateUtil.dateFormateObject((Date) obj);
			}

			@Override
			public int getMode() {
				return REPLACE_MODE;
			}
		});
		return map;
	}

	@RequestMapping(value = "detailAjax")
	public String detailAjax(T o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			if (o instanceof IdBaseEntity && StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
				int id = Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow")));
				((IdBaseEntity) o).setId(id);
			}
			List l = getService().find(o);
			if (l != null && l.size() > 0) {
				ar.put("code", Const.SUCCEED);
				ar.put("data", DataHandlerUtil.dataFilter(l.get(0), getDataHandlers(), true));
			}
		} catch (Exception e) {
			ar.put("code", Const.FAIL);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	@RequestMapping(value = "deleteAjax")
	public String deleteAjax(T o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		if (o instanceof IdBaseEntity && StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
			((IdBaseEntity) o).setId(Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow"))));
		}
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			if(StringUtils.isNotEmpty(req.getParameter("ids"))){
				String ids=req.getParameter("ids");
				String [] is=ids.split(",");
				List<T> list=new ArrayList<T>();
				for(int i=0;i<is.length;i++){
					if(StringUtils.isNotEmpty(is[i])&&StringUtils.isNumeric(is[i])){
						((IdBaseEntity) o).setId(Integer.valueOf(is[i]));
						doWithDelete(o,req,res);
						getService().delete(o);
					}
					
				}
			}else{
				doWithDelete(o,req,res);
				getService().delete(o);
			}
			
			ar.put("code", Const.SUCCEED);
			ar.put("msg", Const.DEL_SUCCEED);
		} catch (Exception e) {
			ar.put("code", Const.FAIL);
			ar.put("msg", Const.DEL_FAIL);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	//拦截insertAjax true表示拦截 不运行插入更新操作
	public boolean insertAjaxIntercept(T o,HttpServletRequest req, HttpServletResponse res){
		return false;
	}
	
	@RequestMapping(value = "insertAjax", method = RequestMethod.POST)
	public String insertAjax(T o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		if (o instanceof IdBaseEntity && StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
			((IdBaseEntity) o).setId(Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow"))));
		}
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		doBeforeInsertUpdate(o,req,res);//插入前处理
		//拦截insertAjax true表示拦截 不运行插入更新操作
		if(insertAjaxIntercept(o,req,res)){
			return null;
		}
		if (o instanceof IdBaseEntity && ((IdBaseEntity) o).getId() == null && ((IdBaseEntity) o).getCompanyId() == null) {
			Integer companyId = AccountShiroUtil.getCurrentUser().getCompanyId();
			((IdBaseEntity) o).setCompanyId(companyId);
		}
		if (o instanceof IdBaseEntity && ((IdBaseEntity) o).getId() == null && ((IdBaseEntity) o).getGroupId() == null) {
			Integer groupId = AccountShiroUtil.getCurrentUser().getGroupId();
			((IdBaseEntity) o).setGroupId(groupId);	
		}

		JSONObject ar = new JSONObject();
		try {
			if (o instanceof IdBaseEntity && ((IdBaseEntity) o).getId() != null) {
				getService().update(o);
				ar.put("msg", Const.UPDATE_SUCCEED);
			} else {
				ar.put("msg", Const.SAVE_SUCCEED);
				getService().insert(o);
			}
			doAfterInsertUpdate(o,req,res);
			ar.put("code", Const.SUCCEED);
		} catch (Exception e) {
			ar.put("msg", Const.SAVE_FAIL);
			ar.put("code", Const.FAIL);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	@RequestMapping(value = "listAjax")
	public String listAjax(T o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		doBeforeListAjax(o,req,res);
		JSONObject ar = new JSONObject();
		try {
			if (StringUtils.isNotEmpty(req.getParameter("all"))) {
				List p = getService().find(o,req.getParameter("sort"), req.getParameter("order"));
				res.getWriter().write(DataHandlerUtil.buildJson(p, getDataHandlers(), true).toString());
				res.getWriter().flush();
				res.getWriter().close();
			} else {
				Page<T> page = new Page<T>();
				if (StringUtils.isNotEmpty(req.getParameter("page"))) {
					page.setPageNum(Integer.valueOf(req.getParameter("page")));
				}
				if (StringUtils.isNotEmpty(req.getParameter("rows"))) {
					page.setPageSize(Integer.valueOf(req.getParameter("rows")));
				}
				Page p = getService().findByPage(o, page,req.getParameter("sort"), req.getParameter("order"));
				ar.put("rows", DataHandlerUtil.buildJson(p.getResults(), getDataHandlers(), true));
				ar.put("total", p.getTotalRecord());

			}
			ar.put("code", Const.SUCCEED);
		} catch (Exception e) {
			ar.put("code", Const.FAIL);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	/**
	 * 得到PageData
	 */
	public PageData getPageData(HttpServletRequest request) {
		return new PageData(request);
	}

	/**
	 * 得到ModelAndView
	 */
	public ModelAndView getModelAndView() {
		return new ModelAndView();
	}

	public AjaxRes getAjaxRes() {
		return new AjaxRes();
	}

	/**
	 * 得到32位的uuid
	 * 
	 * @return
	 */
	public String get32UUID() {
		return UuidUtil.get32UUID();
	}

	/**
	 * 得到分页列表的信息
	 * 
	 * @param <T>
	 */
	@SuppressWarnings("hiding")
	public <T> Page<T> getPage() {
		return new Page<T>();
	}

	public static void logBefore(Logger logger, String interfaceName) {
		logger.info("");
		logger.info("start");
		logger.info(interfaceName);
	}

	public static void logAfter(Logger logger) {
		logger.info("end");
		logger.info("");
	}

	/**
	 * 资源的权限（显示级别）
	 * 
	 * @param type
	 *            资源类别
	 * @return
	 */
	public List<Resources> getPermitBtn(String type,HttpServletRequest req) {
		List<Resources> perBtns = new ArrayList<Resources>();
		try {
			String menu = getPageData(req).getString("menu");
			if (StringUtils.isNotBlank(menu)) {
				String menuNum = menu.replaceAll("menu", "");
				String userId = AccountShiroUtil.getCurrentUser().getId()+"";
				perBtns = resourcesService.findBtn(type, menuNum, userId);
			}
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return perBtns;
	}

	/**
	 * 资源的权限（URl级别）
	 * 
	 * @param type
	 *            资源类别(优化速度)
	 * @return
	 */
	protected boolean doSecurityIntercept(String type,HttpServletRequest req, HttpServletResponse res) {
		try {
			String servletPath = req.getServletPath();
			servletPath = StringUtils.substringBeforeLast(servletPath, ".");// 去掉后面的后缀
			String userId = AccountShiroUtil.getCurrentUser().getId()+"";
			List<Resources> authorized = resourcesService.resAuthorized(userId, type);
			for (Resources r : authorized) {
				if (r != null && StringUtils.isNotBlank(r.getResUrl())) {
					if (StringUtils.equals(r.getResUrl(), servletPath)) {
						return true;
					}
				}

			}
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return false;
	}

	/**
	 * 资源的权限（URl级别,拥有第一级资源权限，这资源才能访问）
	 * 
	 * @param type
	 *            资源类别(优化速度)
	 * @param url
	 *            第一级资源
	 * @return
	 */
	protected boolean doSecurityIntercept(String type, String url) {
		try {
			String userId = AccountShiroUtil.getCurrentUser().getId()+"";
			List<Resources> authorized = resourcesService.resAuthorized(userId, type);
			for (Resources r : authorized) {
				if (r != null && StringUtils.isNotBlank(r.getResUrl())) {
					if (StringUtils.equals(r.getResUrl(), url)) {
						return true;
					}
				}
			}
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return false;
	}
}
