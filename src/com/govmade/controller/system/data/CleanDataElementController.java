package com.govmade.controller.system.data;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

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
import com.govmade.common.ajax.AjaxRes;
import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.ChineseTo;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.poi.ExcelUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.data.CleanDataElement;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.data.SameDataElementConfig;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.organization.Company;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.CleanDataElementService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.data.DataListService;
import com.govmade.service.system.data.SameDataElementConfigService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.InformationResourceService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.organization.GroupsService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * @author (作者) Dong Jie 154046519@qq.com
 * @Description: citysystem_hainan 数据元池
 * @date 2017年3月23日 下午4:05:35
 * @company (开发公司) 国脉海洋信息发展有限公司
 * @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
 * @since (该版本支持的JDK版本) 1.7
 * @Title: CleanDataElementController.java
 * @Package com.govmade.controller.system.data
 * @version V1.0
 */
@Controller
@RequestMapping("/backstage/cleanDataElement/")
public class CleanDataElementController extends GovmadeBaseController<CleanDataElement> {

	@Autowired
	private CleanDataElementService service;

	@Autowired
	private CompanyService companyService;

	@Autowired
	private GroupsService groupsService;

	@Autowired
	private GovmadeDicService govmadeDicservice;

	@Autowired
	private DataElementService dataElementService;

	@Autowired
	private SameDataElementConfigService sameDataElementConfigService;

	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map = super.getDataHandlers();
		map.put("dataType", new DataHandler() {
			// 数据类型（datatype）根据数据字典配置，通过ID读取后dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic = new GovmadeDic();
				dic.setDicNum("DATATYPE");
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

		map.put("objectType", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic = new GovmadeDic();
				dic.setDicNum("OBJECTTYPE");
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
		map.put("status", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic = new GovmadeDic();
				dic.setDicNum("DATAELEMENTSTATUS");
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

		map.put("value8", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				String id = (String) obj;
				if (StringUtils.isNotEmpty(id)) {
					Company c = new Company();
					c.setId(Integer.valueOf(id));
					c = companyService.findById(c);
					return c.getCompanyName();
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

	@Override
	public void doAfterInsertUpdate(CleanDataElement o, HttpServletRequest req, HttpServletResponse res) {
		String name = req.getParameter("sameName");
		if (StringUtils.isNotEmpty(name)) {
			// 清洗重复数据元
			/**
			 * 将要删除的数据元下面的子集全部转移到新的数据元 然后在删除
			 **/
			o.setValue1(name);
			service.transferFather(o);
			service.deleteByName(o);
		}

		String dataElementIds = req.getParameter("dataElementIds");
		if (StringUtils.isNotEmpty(dataElementIds)) {
			// 清洗近义词数据元
			/**
			 * 将近义词数据元下面的子集全部转移到新的数据元统一数据长度等字段 将近义词数据元成为新数据元子集统一数据长度等字段
			 **/
			service.transferByIds(o, StringUtil.toSQLArray(dataElementIds));
			service.setFatherIdByIds(o, StringUtil.toSQLArray(dataElementIds));
			service.deleteByNameInIds(o, StringUtil.toSQLArray(dataElementIds));
		}

		// 保存时候同步更新子集
		if (StringUtils.isEmpty(dataElementIds) && StringUtils.isEmpty(name)) {
			service.transferByIds(o, o.getId() + "");
		}
	}

	@Override
	public String index(Model model, HttpServletRequest req, HttpServletResponse res) {
		model.addAttribute("pubDE", req.getParameter("pubDE"));
		return super.index(model, req, res);
	}

	@Override
	public void doBeforeInsertUpdate(CleanDataElement o, HttpServletRequest req, HttpServletResponse res) {
		if (o.getId() == null) {
			service.setIdentifier(o);
		}
	}

	@RequestMapping(value = "detail")
	public String detail(CleanDataElement o, HttpServletRequest req, HttpServletResponse res, Model m)
			throws Exception {

		if (o instanceof IdBaseEntity && StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
			int id = Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow")));
			((IdBaseEntity) o).setId(id);
		}
		o = service.findById(o);
		m.addAttribute("dataElement", o);
		if (o.getFatherId() != null) {
			CleanDataElement d = new CleanDataElement();
			d.setId(o.getFatherId());
			m.addAttribute("father", service.findById(d));
		} else {
			CleanDataElement d = new CleanDataElement();
			d.setFatherId(o.getId());
			m.addAttribute("childList", service.find(d));
		}
		return "/system/cleanDataElement/detail";
	}

	/***
	 * @Description: 数据源子集分析
	 * @author Dearest
	 * @date 2017年2月7日上午9:43:46
	 */
	@RequestMapping(value = "childrenAna")
	public void childrenAna(CleanDataElement o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject echartjson = new JSONObject();
		CleanDataElement da = service.find(o).get(0);
		JSONObject dashow = DataHandlerUtil.dataFilter(da, getDataHandlers(), true);
		String pname = da.getChName();
		o.setFatherId(o.getId());
		o.setIsDeleted(0);
		o.setId(null);
		List<CleanDataElement> dal = service.find(o);
		if (dal != null && dal.size() > 0) {
			int leng = dal.size();
			String[] chiDataArray = new String[leng];
			JSONArray nodeArray = new JSONArray();
			JSONArray linkArray = new JSONArray();
			JSONObject unitjson = new JSONObject();
			JSONObject linkjson = new JSONObject();
			unitjson.put("category", 0);
			unitjson.put("name", pname);
			unitjson.put("value", 10);
			unitjson.put("info", dashow);
			nodeArray.add(unitjson);
			int index = 0;
			for (CleanDataElement d : dal) {
				Random random = new Random();
				int s = random.nextInt(6) % (6 - 2 + 1) + 2;
				JSONObject dshow = DataHandlerUtil.dataFilter(d, getDataHandlers(), true);
				unitjson.put("category", 1);
				unitjson.put("name", d.getChName());
				unitjson.put("value", s);
				unitjson.put("info", dshow);
				chiDataArray[index] = d.getChName();
				nodeArray.add(unitjson);
				linkjson.put("source", d.getChName());
				linkjson.put("target", pname);
				linkjson.put("weight", s);
				linkjson.put("name", "子集");
				linkArray.add(linkjson);
				index++;
			}
			for (int i = 0; i < (leng - 1); i++) {
				Random random = new Random();
				int s = random.nextInt(6) % (6 - 2 + 1) + 2;
				linkjson.put("source", chiDataArray[i]);
				linkjson.put("target", chiDataArray[i + 1]);
				linkjson.put("weight", s);
				linkjson.put("name", "兄弟集");
				linkArray.add(linkjson);
			}
			echartjson.put("node", nodeArray);
			echartjson.put("link", linkArray);
		} else {
			echartjson.put("status", 0);
		}
		res.getWriter().write(echartjson.toString());
		res.getWriter().flush();
		res.getWriter().close();
	}

	// 勾选数据元成为公共数据元
	@RequestMapping(value = "updateSystemType")
	public String updateSystemType(Integer[] publicDE, HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			if (publicDE != null) {
				service.updateSystemType(1, publicDE);
			}
			ar.put("msg", "操作成功!");
			ar.put("code", Const.SUCCEED);
		} catch (Exception e) {
			ar.put("msg", "操作失败！");
			ar.put("code", Const.FAIL);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	// 清空数据元
	@RequestMapping(value = "deleteAll")
	public String deleteAll(HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			service.deleteAll();
			DataElement d = new DataElement();
			d.setClassType(1);
			dataElementService.clearAllImported(d);
			ar.put("msg", "操作成功!");
			ar.put("code", Const.SUCCEED);
		} catch (Exception e) {
			ar.put("msg", "操作失败！");
			ar.put("code", Const.FAIL);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	// 导入数据元
	@RequestMapping(value = "importList")
	public String importList(Integer[] importDE, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			for (Integer id : importDE) {
				DataElement d = new DataElement();
				d.setId(id);
				d = dataElementService.findById(d);
				d.setImported(1);
				dataElementService.update(d);
				d.setImported(0);
				d.setSourceId(d.getId());
				service.insert(d);
			}
			ar.put("msg", "导入成功!");
			ar.put("code", Const.SUCCEED);
		} catch (Exception e) {
			ar.put("msg", "导入失败！");
			ar.put("code", Const.FAIL);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	// 解除子父数据元关系
	@RequestMapping(value = "unLink")
	public String unLink(CleanDataElement dataElement, HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		if (StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
			int id = Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow")));
			dataElement.setId(id);
		}

		JSONObject ar = new JSONObject();
		try {
			dataElement = service.findById(dataElement);
			dataElement.setFatherId(null);
			service.setIdentifier(dataElement);
			service.update(dataElement);
			ar.put("msg", "解除成功!");
			ar.put("code", Const.SUCCEED);
		} catch (Exception e) {
			ar.put("msg", "解除失败！");
			ar.put("code", Const.FAIL);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	// 导入数据元
	@RequestMapping(value = "importAll")
	public String importAll(DataElement dataElement, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			if (StringUtils.isEmpty(req.getParameter("sourceType"))) {
				dataElement.setSourceType(99);
			}
			dataElement.setClassType(1);
			Page<DataElement> page = new Page<DataElement>();
			int pageNum = 1;
			page.setPageNum(pageNum);
			page.setPageSize(1000);
			long time = System.currentTimeMillis();
			Page p = dataElementService.findByPage(dataElement, page);
			while (p.getResults() != null && p.getResults().size() > 0) {
				List<DataElement> list = p.getResults();
				service.importList(list);

				list.clear();
				page.setResults(null);
				p.setResults(null);
				p = dataElementService.findByPage(dataElement, page);
			}
			System.out.println(System.currentTimeMillis() - time);
			ar.put("code", Const.SUCCEED);
			ar.put("msg", "导入成功!");
		} catch (Exception e) {
			ar.put("code", Const.FAIL);
			ar.put("msg", "导入失败！");
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	// 数据元近义词清洗
	@RequestMapping(value = "sameFilter")
	public String sameFilter(Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {

		return "/system/cleanDataElement/sameFilter";
	}

	// 数据元近义词清洗
	@RequestMapping(value = "sameFilterAjax")
	public String sameFilterAjax(SameDataElementConfig sdconfig, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			List<SameDataElementConfig> sdc = sameDataElementConfigService.getTreeList(sdconfig);
			List<SameDataElementConfig> list = new ArrayList<SameDataElementConfig>();
			for (SameDataElementConfig config : sdc) {
				if((StringUtils.isNotEmpty(sdconfig.getName())&&config.getName().contains(sdconfig.getName()))||StringUtils.isEmpty(sdconfig.getName())){
					if (config.getChildList() != null && config.getChildList().size() > 0) {
						List<CleanDataElement> dl = service.findBySameConfig(config.getChildList());
						if (dl != null && dl.size() > 1) {
							config.setCounts(dl.size());
							list.add(config);
						}
					}
				}
			}
			//排序
			if(StringUtils.isNotEmpty(req.getParameter("order"))&&req.getParameter("order").equals("asc")){
				Collections.sort(list);
			}else{
				Collections.reverse(list);
			}
			ar.put("rows", DataHandlerUtil.buildJson(list, getDataHandlers(), true));
			ar.put("total", list.size());
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

	// 数据元近义词清洗
	@RequestMapping(value = "sameList")
	public String sameList(Integer[] checkDEId, Model model, HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		List<CleanDataElement> list = service.findByIds(checkDEId);
		CleanDataElement dm = new CleanDataElement();
		Map<String, Map<String, Integer>> notSame = new HashMap<String, Map<String, Integer>>();
		for (int i = 1; i <= 30; i++) {
			Map<String, Integer> map = service.compareList(list, i);
			if (map.size() == 1) {
				String name = null;
				for (String s : map.keySet()) {
					name = s;
					break;
				}
				ObjectUtil.setValue(dm, "value" + i, name);
			} else if (map.size() > 1) {
				notSame.put("value" + i, map);
			}
		}
		model.addAttribute("dataElementList", list);
		model.addAttribute("map", notSame);
		model.addAttribute("dataElement", dm);
		return "/system/cleanDataElement/repeatList";
	}

	@RequestMapping(value = "getListByConfig")
	public String getListByConfig(SameDataElementConfig config, HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			List<SameDataElementConfig> sdc = sameDataElementConfigService.find(config);
			List<CleanDataElement> list = service.findBySameConfig(sdc);
			ar.put("rows", DataHandlerUtil.buildJson(list, getDataHandlers(), true));
			ar.put("total", list.size());
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

	// 数据元重复清洗
	@RequestMapping(value = "repeatFilter")
	public String repeatFilter(Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {

		return "/system/cleanDataElement/repeatFilter";
	}

	// 数据元重复清洗
	@RequestMapping(value = "repeatFilterAjax")
	public String repeatFilterAjax(CleanDataElement o, HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			List<CleanDataElement> list = service.getRepeat(o, req.getParameter("sort"), req.getParameter("order"));
			ar.put("rows", DataHandlerUtil.buildJson(list, getDataHandlers(), true));
			ar.put("total", list.size());
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

	// 数据元重复清洗
	@RequestMapping(value = "repeatList")
	public String repeatList(CleanDataElement dataElement, Model model, HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		List<CleanDataElement> list = service.findRepeatList(dataElement);
		CleanDataElement dm = new CleanDataElement();
		Map<String, Map<String, Integer>> notSame = new HashMap<String, Map<String, Integer>>();
		for (int i = 1; i <= 30; i++) {
			Map<String, Integer> map = service.compareList(list, i);
			if (map.size() == 1) {
				String name = null;
				for (String s : map.keySet()) {
					name = s;
					break;
				}
				ObjectUtil.setValue(dm, "value" + i, name);
			} else if (map.size() > 1) {
				notSame.put("value" + i, map);
			}
		}
		model.addAttribute("dataElementList", list);
		model.addAttribute("map", notSame);
		model.addAttribute("dataElement", dm);
		return "/system/cleanDataElement/repeatList";
	}

	// 显示无父级和子集的数据元
	@RequestMapping(value = "listSingle")
	public String listSingle(CleanDataElement o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			Page<CleanDataElement> page = new Page<CleanDataElement>();
			if (StringUtils.isNotEmpty(req.getParameter("page"))) {
				page.setPageNum(Integer.valueOf(req.getParameter("page")));
			}
			if (StringUtils.isNotEmpty(req.getParameter("rows"))) {
				page.setPageSize(Integer.valueOf(req.getParameter("rows")));
			}
			Page p = service.findSingleDataElementByPage(o, page);
			ar.put("rows", DataHandlerUtil.buildJson(p.getResults(), getDataHandlers(), true));
			ar.put("total", p.getTotalRecord());
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

	// 显示数据元频率
	@RequestMapping(value = "listUseCount")
	public String listUseCount(CleanDataElement o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			Page<CleanDataElement> page = new Page<CleanDataElement>();
			if (StringUtils.isNotEmpty(req.getParameter("page"))) {
				page.setPageNum(Integer.valueOf(req.getParameter("page")));
			}
			if (StringUtils.isNotEmpty(req.getParameter("rows"))) {
				page.setPageSize(Integer.valueOf(req.getParameter("rows")));
			}
			Page p = service.findUseCountByPage(o, page);
			ar.put("rows", DataHandlerUtil.buildJson(p.getResults(), getDataHandlers(), true));
			ar.put("total", p.getTotalRecord());
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

	@RequestMapping(value = "setChild")
	public String setChild(CleanDataElement o, HttpServletRequest req, HttpServletResponse res, Model m)
			throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		if (o instanceof IdBaseEntity && StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
			int id = Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow")));
			((IdBaseEntity) o).setId(id);
		}
		JSONObject ar = new JSONObject();
		try {
			o = service.findById(o);
			String ids = req.getParameter("ids");
			service.setFatherIdByIds(o, StringUtil.toSQLArray(ids));
			ar.put("msg", Const.SAVE_SUCCEED);
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

	@RequestMapping(value = "findDataElementByResId")
	public String findDataElementByResId(CleanDataElement dataElement, HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		Page<CleanDataElement> page = new Page<CleanDataElement>();
		if (StringUtils.isNotEmpty(req.getParameter("page"))) {
			page.setPageNum(Integer.valueOf(req.getParameter("page")));
		}
		if (StringUtils.isNotEmpty(req.getParameter("rows"))) {
			page.setPageSize(Integer.valueOf(req.getParameter("rows")));
		}
		page = service.findDataElementByResId(dataElement, page);
		try {
			ar.put("rows", DataHandlerUtil.buildJson(page.getResults(), getDataHandlers(), true));
			ar.put("total", page.getTotalRecord());
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

	@RequestMapping(value = "findExactly")
	public String findExactly(CleanDataElement dataElement, HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		Page<CleanDataElement> page = new Page<CleanDataElement>();
		if (StringUtils.isNotEmpty(req.getParameter("page"))) {
			page.setPageNum(Integer.valueOf(req.getParameter("page")));
		}
		if (StringUtils.isNotEmpty(req.getParameter("rows"))) {
			page.setPageSize(Integer.valueOf(req.getParameter("rows")));
		}
		page = service.findExactly(dataElement, page);

		try {
			ar.put("rows", DataHandlerUtil.buildJson(page.getResults(), getDataHandlers(), true));
			ar.put("total", page.getTotalRecord());
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

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public String indexURL() {
		return "/system/cleanDataElement/index";
	}

}
