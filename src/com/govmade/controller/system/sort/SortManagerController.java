package com.govmade.controller.system.sort;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.govmade.adapter.DataElementAdapter;
import com.govmade.adapter.SortManagerAdapter;
import com.govmade.common.ajax.AjaxRes;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.poi.ExcelUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.sort.SortManagerService;

import net.sf.json.JSONObject;

/**
 * @author (作者) Chenlei 774329191@qq.com
 * @Description: CitySystem TODO
 * @date 2016年12月8日 上午11:18:50
 * @Title: SortManagerController.java
 */

@Controller
@RequestMapping("/backstage/sortManager/")
public class SortManagerController extends GovmadeBaseController<SortManager> {

	@Autowired
	private SortManagerService service;

	@Autowired
	private GovmadeDicService govmadeDicservice;

	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map = super.getDataHandlers();
		map.put("level", new DataHandler() {
			// s数据字典中读取数据类型
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic = new GovmadeDic();
				dic.setDicNum("LEVEL");
				dic.setDicKey((Integer) obj + "");
				List<GovmadeDic> l = govmadeDicservice.getDicList(dic);
				if (l != null && l.size() > 0) {
					return l.get(0).getDicValue();
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




	@RequestMapping("index")
	public String index(Model model, HttpServletRequest req, HttpServletResponse res) {
		String url = null;
		// 根据type分成三个页面
		if (req.getParameter("type").equals("1")) {
			url = "/system/sortManager/gov/index";
		} else if (req.getParameter("type").equals("2")) {
			url = "/system/sortManager/data/index";
		} else if (req.getParameter("type").equals("3")) {
			url = "/system/sortManager/sort/index";
		}
		// System.out.println(url);
		return url;
	}

	@Override
	public String indexURL() {
		return "/system/sortManager/data/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public void doBeforeInsertUpdate(SortManager o, HttpServletRequest req, HttpServletResponse res) {

	}

	@RequestMapping(value = "jqGridTreeJson")
	public String jqGridTreeJson(SortManager sm, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		List<SortManager> smlist = service.find(sm);
		if (smlist != null && smlist.size() > 0) {
			res.getWriter().write(service.getJqGridTreeJson(sm).toString());
			res.getWriter().flush();
			res.getWriter().close();
		}
		return null;
	}
	
	
	@RequestMapping(value = "search1")
	public String search1(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//获得前端传过来的sortN（名称）放入sn
	    String sn = new String(req.getParameter("sortN").getBytes("iso8859-1"), "utf-8");
		System.out.println("sn="+sn);
		if (StringUtils.isNotEmpty(sn)) {
			SortManager sm1=new SortManager();
			sm1.setType(3);
			sm1.setSortName(sn);
			res.getWriter().write(service.getSearch(sm1).toString());
			res.getWriter().flush();
			res.getWriter().close();
		}
		  else{
		    SortManager sm=new SortManager();
		    sm.setType(3);
			res.getWriter().write(service.getJqGridTreeJson(sm).toString());
			res.getWriter().flush();
			res.getWriter().close();
		        }
		return null;
	}

	@RequestMapping(value = "search2")
	public String search2(HttpServletRequest req, HttpServletResponse res) throws Exception {
		//获得前端传过来的sortN（名称）放入sn
	    String sn = new String(req.getParameter("sortN").getBytes("iso8859-1"), "utf-8");
		System.out.println("sn="+sn);
		if (StringUtils.isNotEmpty(sn)) {
			SortManager sm2=new SortManager();
			sm2.setBelong(2);
			sm2.setSortName(sn);
			res.getWriter().write(service.getSearch(sm2).toString());
			res.getWriter().flush();
			res.getWriter().close();
		}
		  else{
		    SortManager sm=new SortManager();
		    sm.setBelong(2);
			res.getWriter().write(service.getJqGridTreeJson(sm).toString());
			res.getWriter().flush();
			res.getWriter().close();
		        }
		return null;
	}
	
	public String insertListRepeat(int id){		
		SortManager sort1 = new SortManager();		
		sort1.setId(id);
		
		SortManager sort = new SortManager();
		sort.setBelong(2);
		sort.setSortName(service.findById(sort1).getSortName());
		if(service.validateName(sort)){
			return insertListRepeatSon(id);
		}else{
			return "父级名称重复";
		}		
	}
	public String insertListRepeatSon(int id){
		SortManager sort = new SortManager();

		sort.setSortId(id);
		sort.setIsDeleted(0);
		sort.setBelong(1);
		List<SortManager> list=service.find(sort);
		
		for(SortManager sm:list){
			SortManager sort1 = new SortManager();
			sort1.setSortName(sm.getSortName());
			sort1.setBelong(2);
			sort1.setIsDeleted(0);
			if(service.validateName(sort1)){
				return insertListRepeatSon(sm.getId());
			}else{
				return "子级名称重复";
			}
		}
		return null;		
	}
	@RequestMapping(value = "insertList", method = RequestMethod.POST)
	public String insertList(HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		Integer companyId = AccountShiroUtil.getCurrentUser().getCompanyId();
		Integer groupId = AccountShiroUtil.getCurrentUser().getGroupId();
		String ids = StringUtil.toSQLArray(req.getParameter("ids"));
		JSONObject ar = new JSONObject();
		if (StringUtils.isNotEmpty(ids)) {
			SortManager g = new SortManager();
			String[] id = ids.split(",");
			for (String i : id) {
				
				if(insertListRepeat(Integer.valueOf(i)) != null){
					ar.put("ftips", insertListRepeat(Integer.valueOf(i)));		
					res.getWriter().write(ar.toString());
					res.getWriter().flush();
					res.getWriter().close();
					return null;
				}
				
				// 层级更新第二级更新
				g.setSortId(Integer.valueOf(i));
				List<SortManager> sortList2 = service.find(g);
				for (int x = 0; x < sortList2.size(); x++) {
					SortManager sort2 = new SortManager();
					sort2.setId(sortList2.get(x).getId());
					SortManager upsort2 = service.findById(sort2);
					if (upsort2.getId() != null) {
						upsort2.setBelong(2);
						upsort2.setCompanyId(companyId);
						upsort2.setGroupId(groupId);
						service.update(upsort2);

						// new 出一个对象获得二级下面三级数据
						SortManager sort2By3 = new SortManager();
						sort2By3.setSortId(sortList2.get(x).getId());
						// 层级更新第三级更新
						List<SortManager> sortList3 = service.find(sort2By3);
						for (int y = 0; y < sortList3.size(); y++) {
							SortManager sort3 = new SortManager();
							sort3.setId(sortList3.get(y).getId());
							SortManager upsort3 = service.findById(sort3);
							if (upsort3.getId() != null) {
								upsort3.setBelong(2);
								upsort3.setCompanyId(companyId);
								upsort3.setGroupId(groupId);
								service.update(upsort3);
								// new 出一个对象获得三级下面四级数据
								SortManager sort3By4 = new SortManager();
								sort3By4.setSortId(sortList3.get(y).getId());
								// 层级更新第四级更新
								List<SortManager> sortList4 = service.find(sort3By4);
								for (int z = 0; z < sortList4.size(); z++) {
									SortManager sort4 = new SortManager();
									sort4.setId(sortList4.get(z).getId());
									SortManager upsort4 = service.findById(sort4);
									if (upsort4.getId() != null) {
										upsort4.setBelong(2);
										upsort4.setCompanyId(companyId);
										upsort4.setGroupId(groupId);
										service.update(upsort4);
									}
								}
							}
						}
					}
				}
				// 层级更新第一级更新
				for (String j : id) {
					SortManager sort1 = new SortManager();
					sort1.setId(Integer.valueOf(j));
					sort1.setBelong(2);
					sort1.setCompanyId(companyId);
					sort1.setGroupId(groupId);
					service.update(sort1);
				}
			}
			ar.put("stips", "导入成功");
		} else {
			ar.put("ftips", "导入失败！");
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	// 验证名称重复
	@RequestMapping(value = "validation")
	public String validation(SortManager o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		String results = "0";
		//代码不为空时验证是否有重复
		if(StringUtils.isNotEmpty(o.getSortCode())){		
			if (!service.validateName(o)) {
				results = "1";
			}
		}
		//名称不为空时验证是否有重复
		if(StringUtils.isNotEmpty(o.getSortName())){		
			if (!service.validateName(o)) {
				results = "1";
			}
		}
		String str = "{\"results\":[" + results + "]}";
		res.getWriter().write(str);
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	// 验证名称重复
		@RequestMapping(value = "validation1")
		public String validation1(SortManager o, HttpServletRequest req, HttpServletResponse res) throws Exception {
			res.setContentType("text/html;charset=utf-8");
			res.setCharacterEncoding("utf-8");
			String results = "0";
			//代码不为空时验证是否有重复
			if(StringUtils.isNotEmpty(o.getSortCode())){		
				if (!service.validateName(o)) {
					results = "1";
				}
			}
			//名称不为空时验证是否有重复
			if(StringUtils.isNotEmpty(o.getSortName())){		
				if (!service.validateName(o)) {
					results = "1";
				}
			}
			String str = "{\"results\":[" + results + "]}";
			res.getWriter().write(str);
			res.getWriter().flush();
			res.getWriter().close();
			return null;
		}
		
	@RequestMapping(value = "delete1Ajax")
	public String delete1Ajax(SortManager o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		if (o instanceof IdBaseEntity && StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
			((IdBaseEntity) o).setId(Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow"))));
		}
		SortManager sort = service.findById(o);
		List<SortManager> sortList = service.find(o);
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			if (StringUtils.isNotEmpty(req.getParameter("ids"))) {
				String ids = req.getParameter("ids");
				String[] is = ids.split(",");
				List<SortManager> list = new ArrayList<SortManager>();
				for (int i = 0; i < is.length; i++) {
					if (StringUtils.isNotEmpty(is[i]) && StringUtils.isNumeric(is[i])) {
						((IdBaseEntity) o).setId(Integer.valueOf(is[i]));
						doWithDelete1(o, req, res);
						service.delete1(o);
					}
				}
			} else {
				doWithDelete1(o, req, res);
				service.delete1(o);
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

	@RequestMapping("doWithDelete1")
	public void doWithDelete1(SortManager o, HttpServletRequest req, HttpServletResponse res) {
		// 层级更新第二级更新
		SortManager sort = service.findById(o);
		Integer id = sort.getId();
		SortManager g = new SortManager();
		g.setSortId(Integer.valueOf(id));
		List<SortManager> sortList2 = service.find(g);
		for (int x = 0; x < sortList2.size(); x++) {
			SortManager sort2 = new SortManager();
			sort2.setId(sortList2.get(x).getId());
			SortManager upsort2 = service.findById(sort2);
			System.out.println("upsort2=" + upsort2);
			if (upsort2.getId() != null) {
				if (upsort2.getType() == 1) {
					upsort2.setIsDeleted(1);
					System.out.println("upsort2的Type=" + upsort2.getType());
				} else if (upsort2.getType() == 3) {
					upsort2.setIsDeleted(0);
					upsort2.setBelong(1);
				}
				service.update(upsort2);

				// new 出一个对象获得二级下面三级数据
				SortManager sort2By3 = new SortManager();
				sort2By3.setSortId(sortList2.get(x).getId());
				// 层级更新第三级更新
				List<SortManager> sortList3 = service.find(sort2By3);
				for (int y = 0; y < sortList3.size(); y++) {
					SortManager sort3 = new SortManager();
					sort3.setId(sortList3.get(y).getId());
					SortManager upsort3 = service.findById(sort3);
					System.out.println("upsort3=" + upsort3);
					if (upsort3.getId() != null) {
						if (upsort3.getType() == 1) {
							upsort3.setIsDeleted(1);
							System.out.println("upsort3的Type=" + upsort3.getType());
						} else if (upsort3.getType() == 1) {
							upsort3.setIsDeleted(0);
							upsort3.setBelong(1);
						}
						service.update(upsort3);
						// new 出一个对象获得三级下面四级数据
						SortManager sort3By4 = new SortManager();
						sort3By4.setSortId(sortList3.get(y).getId());
						// 层级更新第四级更新
						List<SortManager> sortList4 = service.find(sort3By4);
						for (int z = 0; z < sortList4.size(); z++) {
							SortManager sort4 = new SortManager();
							sort4.setId(sortList4.get(z).getId());
							SortManager upsort4 = service.findById(sort4);
							System.out.println("upsort4=" + upsort4);
							if (upsort4.getId() != null) {
								if (upsort4.getType() == 1) {
									upsort4.setIsDeleted(1);
									System.out.println("upsort4的Type=" + upsort4.getType());
								} else if (upsort4.getType() == 1) {
									upsort4.setIsDeleted(0);
									upsort4.setBelong(1);
								}
								service.update(upsort4);
							}
						}
					}
				}
			}
		}
		// 层级更新第一级更新
		SortManager sort1 = new SortManager();
		sort1.setId(Integer.valueOf(id));
		SortManager sort11 = service.findById(sort1);
		if (sort11.getId() != null) {
			if (sort11.getType() == 1) {
				sort11.setIsDeleted(1);
			} else if (sort11.getType() == 3) {
				sort11.setBelong(1);
			}
			service.update(sort11);
		}
		System.out.println("sort11的Type=" + sort.getType());
		service.update(sort1);

	}

	@Override
	public void doWithDelete(SortManager o, HttpServletRequest req, HttpServletResponse res) {
		// 层级更新第二级更新
		SortManager sort = service.findById(o);
		Integer id = sort.getId();
		SortManager g = new SortManager();
		g.setSortId(Integer.valueOf(id));
		List<SortManager> sortList2 = service.find(g);
		for (int x = 0; x < sortList2.size(); x++) {
			SortManager sort2 = new SortManager();
			sort2.setId(sortList2.get(x).getId());
			SortManager upsort2 = service.findById(sort2);
			if (upsort2.getId() != null) {
				upsort2.setIsDeleted(1);
				service.update(upsort2);

				// new 出一个对象获得二级下面三级数据
				SortManager sort2By3 = new SortManager();
				sort2By3.setSortId(sortList2.get(x).getId());
				// 层级更新第三级更新
				List<SortManager> sortList3 = service.find(sort2By3);
				for (int y = 0; y < sortList3.size(); y++) {
					SortManager sort3 = new SortManager();
					sort3.setId(sortList3.get(y).getId());
					SortManager upsort3 = service.findById(sort3);
					if (upsort3.getId() != null) {
						upsort3.setIsDeleted(1);
						service.update(upsort3);
						// new 出一个对象获得三级下面四级数据
						SortManager sort3By4 = new SortManager();
						sort3By4.setSortId(sortList3.get(y).getId());
						// 层级更新第四级更新
						List<SortManager> sortList4 = service.find(sort3By4);
						for (int z = 0; z < sortList4.size(); z++) {
							SortManager sort4 = new SortManager();
							sort4.setId(sortList4.get(z).getId());
							SortManager upsort4 = service.findById(sort4);
							if (upsort4.getId() != null) {
								upsort4.setIsDeleted(1);
								service.update(upsort4);
							}
						}
					}
				}
			}
		}
		// 层级更新第一级更新

		SortManager sort1 = new SortManager();
		sort1.setId(Integer.valueOf(id));
		sort1.setIsDeleted(1);
		service.update(sort1);
	}

	@RequestMapping("importData")
	@ResponseBody
	public AjaxRes importData(@RequestParam(value = "file", required = false) MultipartFile file, Model model,
			HttpServletRequest request) {
		AjaxRes ar = getAjaxRes();
		try {

			String path = request.getSession().getServletContext().getRealPath("upload/excel");
			String fileName = file.getOriginalFilename().trim();
			String icon = System.currentTimeMillis() + "/";
			File targetFile = new File(path + "/" + icon, fileName);
			if (!targetFile.exists()) {
				targetFile.mkdirs();
			}
			String belong = request.getParameter("belong");
			if (StringUtils.isEmpty(belong) || !StringUtils.isNumeric(belong)) {
				ar.setRes(Const.FAIL);
			} else {
				SortManagerAdapter adapter = new SortManagerAdapter(Integer.valueOf(belong));
				file.transferTo(targetFile);
				ExcelUtil excelUtil = new ExcelUtil(adapter);
				excelUtil.excelToList(targetFile.getAbsolutePath(),0);
				if (adapter.isError()) {
					ar.setRes(Const.FAIL);
				} else {
					try {
						service.importList(adapter.getEntityList());
						ar.setRes(Const.SUCCEED);
					} catch (Exception e) {
						ar.setRes(Const.FAIL);
						ar.setResMsg(Const.ACTION_FAIL);
						e.printStackTrace();
					}
				}
				ar.setResMsg(adapter.getErrorMsg().toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			ar.setFailMsg(Const.DATA_FAIL);
		}

		return ar;
	}
}
