package com.govmade.controller.system.information;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.Version;
import com.google.gson.JsonObject;
import com.govmade.adapter.DEtoResourceNNAdapter;
import com.govmade.adapter.DataElementNNAdapter;
import com.govmade.adapter.InformationResourceAdapter;
import com.govmade.adapter.object2excel.DataElement2ExcelAdapter;
import com.govmade.adapter.object2excel.InformationResource2ExcelAdapter;
import com.govmade.api.PushUtil;
import com.govmade.common.ajax.AjaxRes;
import com.govmade.common.utils.ChineseTo;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.HttpUtil;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.poi.ExcelUtil;
import com.govmade.common.utils.poi.Object2ExcelComplexUtil;
import com.govmade.common.utils.poi.Object2ExcelUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.api.ApiAccount;
import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.entity.system.customFields.DataElementFields;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.data.DataManager;
import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.Application;
import com.govmade.entity.system.information.DataFile;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.information.Notice;
import com.govmade.entity.system.information.SearchLog;
import com.govmade.entity.system.information.Subscribe;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.memorizer.GovMemorizer;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.organization.Groups;
import com.govmade.entity.system.server.GovServer;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.entity.system.versionControl.VersionControl;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.api.ApiAccountService;
import com.govmade.service.system.application.GovApplicationSystemService;
import com.govmade.service.system.computer.GovComputerRoomService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.data.DataListService;
import com.govmade.service.system.data.DataManagerService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.ApplicationService;
import com.govmade.service.system.information.DataFileService;
import com.govmade.service.system.information.InformationResourceService;
import com.govmade.service.system.information.NoticeService;
import com.govmade.service.system.information.SearchLogService;
import com.govmade.service.system.information.SubscribeService;
import com.govmade.service.system.item.ItemSortService;
import com.govmade.service.system.memorizer.GovMemorizerService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.organization.GroupsService;
import com.govmade.service.system.server.GovServerService;
import com.govmade.service.system.sort.SortManagerService;
import com.govmade.service.system.table.GovTableService;
import com.govmade.service.system.versionControl.VersionControlService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * @author (作者) Dong Jie 154046519@qq.com
 * @Description: CitySystem 资源管理下的信息资源管理
 * @date 2016年12月22日 上午9:16:57
 * @company (开发公司) 国脉海洋信息发展有限公司
 * @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
 * @since (该版本支持的JDK版本) 1.7
 * @Title: InformationResourceController.java
 * @Package com.govmade.controller.system.information
 * @version V1.0
 */
@Controller
@RequestMapping("/backstage/information/resource/")
public class InformationResourceController extends GovmadeBaseController<InformationResource> {

	@Autowired
	private InformationResourceService service;

	@Autowired
	private DataListService dataListService;
	@Autowired
	private DataElementService dataElementService;
	@Autowired
	private ItemSortService itemSortService;

	@Autowired
	private GovApplicationSystemService govApplicationSystemService;

	@Autowired
	private GovMemorizerService govMemorizerService;

	@Autowired
	private GovServerService govServerService;

	@Autowired
	private GovComputerRoomService govComputerRoomService;

	@Autowired
	private GovmadeDicService govmadeDicService;

	@Autowired
	private CompanyService companyService;

	@Autowired
	private GroupsService groupsService;

	@Autowired
	private SortManagerService sortManagerService;

	@Autowired
	private SearchLogService searchLogService;

	@Autowired
	private ApplicationService applicationService;

	@Autowired
	private SubscribeService subscribeService;

	@Autowired
	private NoticeService noticeService;

	@Autowired
	private DataFileService dataFileService;

	@Autowired
	private VersionControlService versionControlService;

	@Autowired
	private GovTableService govTableService;

	@Autowired
	private DataManagerService dataManagerService;

	@Autowired
	private ApiAccountService apiAccountService;

	@Override
	public String indexURL() {
		return "/system/information/resource/index";
	}

	@Override
	public String index(Model model, HttpServletRequest req, HttpServletResponse res) {
		model.addAttribute("status", req.getParameter("status"));
		return super.index(model, req, res);
	}

	@RequestMapping(value = "waitToDo")
	public String waitToDo() {
		return "/system/waitToDo/resource/index";
	}

	@RequestMapping(value = "dataFile")
	public String dataFile(Model model, HttpServletRequest req, HttpServletResponse res) {
		return "/system/information/dataFile/index";
	}

	// 资源查询
	@RequestMapping(value = "searchIndex")
	public String searchIndex(Model model) {
		model.addAttribute("hotKeyWord", searchLogService.getHotKeyWord());
		model.addAttribute("companyCount", service.getInforResGroupByCompany());
		Integer theme = ServiceUtil.getThemeType(10);
		model.addAttribute("theme", theme);
		System.out.println("theme=" + theme);
		return "/system/information/search/index";
	}

	@RequestMapping(value = "depart")
	public String departDirectory() {
		return "/system/informationResource/depart/index";
	}

	@RequestMapping(value = "basis")
	public String basisDirectory(InformationResource o, HttpServletResponse res, Model model) {
		SortManager sm = new SortManager();
		SortManager sms = new SortManager();
		SortManager sm2 = new SortManager();
		Company cp = new Company();
		InformationResource p = new InformationResource();
		JSONObject uson = new JSONObject();
		JSONArray uarray = new JSONArray();
		sm.setIsDeleted(0);
		sm.setLevel(1);
		sm.setBelong(2);
		sms.setIsDeleted(0);
		sm2.setIsDeleted(0);
		sm2.setBelong(2);
		o.setIsDeleted(0);
		o.setStatus(0);
		p.setIsDeleted(0);
		p.setStatus(0);
		cp.setIsDeleted(0);
		List<Company> cpList = companyService.find(cp);
		Map<String, Integer> value3Map = service.countValue3(p);
		if (cpList.size() > 0) {
			JSONObject unitJson = new JSONObject();
			JSONArray unitArray = new JSONArray();
			InformationResource ir = new InformationResource();
			ir.setIsDeleted(0);
			uson.put("name", "部门类");
			for (Company cps : cpList) {

				unitJson.put("name", cps.getCompanyName());
				unitJson.put("id", cps.getId());
				unitJson.put("tp", 1);
				unitJson.put("count", value3Map.get(cps.getId() + ""));
				unitArray.add(unitJson);
			}
			uson.put("children", unitArray);
			uarray.add(uson);
		}
		List<SortManager> smList = sortManagerService.find(sm);
		Map<Integer, Integer> map = service.countInforTypes(p);
		if (smList.size() > 0) {
			JSONObject unitJson = new JSONObject();
			for (SortManager smsm : smList) {
				JSONArray unitArray = new JSONArray();
				sms.setSortId(smsm.getId());
				sms.setBelong(2);
				List<SortManager> smsList = sortManagerService.find(sms);
				if (smsList.size() > 0) {
					for (SortManager smsms : smsList) {
						unitJson.put("name", smsms.getSortName());
						unitJson.put("id", smsms.getId());
						unitJson.put("count", map.get(smsms.getId()));
						unitJson.put("tp", 2);
						sm2.setSortId(smsms.getId());
						unitArray.add(unitJson);
						List<SortManager> sms2List = sortManagerService.find(sm2);
						for (SortManager smsms2 : sms2List) {
							unitJson.put("name", smsms2.getSortName());
							unitJson.put("id", smsms2.getId());
							unitJson.put("tp", 3);
							unitJson.put("count", map.get(smsms2.getId()));
							unitArray.add(unitJson);
						}
					}
				}
				uson.put("name", smsm.getSortName());
				uson.put("children", unitArray);
				uarray.add(uson);
			}
		}
		model.addAttribute("uson", uarray);
		return "/system/informationResource/basis/index";
	}

	@RequestMapping(value = "theme")
	public String themeDirectory() {
		return "/system/informationResource/theme/index";
	}

	@RequestMapping(value = "shares")
	public String shares() {
		return "/system/informationResource/shares/index";
	}

	@RequestMapping(value = "mainbasis")
	public String mainbasis(InformationResource o, HttpServletResponse res, Model model) {
		SortManager sm = new SortManager();
		SortManager sms = new SortManager();
		SortManager sm2 = new SortManager();
		InformationResource p = new InformationResource();
		JSONObject uson = new JSONObject();
		JSONArray uarray = new JSONArray();
		sm.setIsDeleted(0);
		sm.setLevel(1);
		sm.setBelong(2);
		sms.setIsDeleted(0);
		sm2.setIsDeleted(0);
		sm2.setBelong(2);
		;
		o.setIsDeleted(0);
		o.setStatus(0);
		p.setIsDeleted(0);
		p.setStatus(0);
		List<SortManager> smList = sortManagerService.find(sm);

		Map<Integer, Integer> countMap = service.countInforTypes(p);
		if (smList.size() > 0) {
			JSONObject unitJson = new JSONObject();
			for (SortManager smsm : smList) {
				JSONArray unitArray = new JSONArray();
				sms.setSortId(smsm.getId());
				sms.setBelong(2);
				List<SortManager> smsList = sortManagerService.find(sms);
				if (smsList.size() > 0) {
					for (SortManager smsms : smsList) {
						unitJson.put("name", smsms.getSortName());
						unitJson.put("id", smsms.getId());
						unitJson.put("count", countMap.get(smsms.getId()));
						unitJson.put("tp", 2);
						sm2.setSortId(smsms.getId());
						unitArray.add(unitJson);
						List<SortManager> sms2List = sortManagerService.find(sm2);
						for (SortManager smsms2 : sms2List) {
							unitJson.put("name", smsms2.getSortName());
							unitJson.put("id", smsms2.getId());
							unitJson.put("tp", 3);
							unitJson.put("count", countMap.get(smsms2.getId()));
							unitArray.add(unitJson);
						}
					}
				}
				uson.put("name", smsm.getSortName());
				uson.put("children", unitArray);
				uarray.add(uson);
			}
		}
		model.addAttribute("uson", uarray);
		return "/system/information/mainbasis/index";
	}

	@RequestMapping(value = "maintheme")
	public String theme() {
		return "/system/information/maintheme/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@RequestMapping(value = "resRelation")
	public String resShow() {
		return "/system/information/resRelation/index";
	}

	@RequestMapping(value = "muindex")
	public String muindex() {
		return "/system/information/resource/index2";
	}

	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map = super.getDataHandlers();
		map = DataHandlerUtil.buildDataManagerDataHandlers(map);
		map.put("sourceType", new DataHandler() {
			// 数据类型（datatype）根据数据字典配置，通过ID读取后dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic = new GovmadeDic();
				dic.setDicNum("SOURCETYPE");
				dic.setDicKey((Integer) obj + "");
				List<GovmadeDic> l = govmadeDicService.getDicList(dic);
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

		map.put("value3", new DataHandler() {

			@Override
			public int getMode() {

				return FREEDOM_MODE;
			}

			@Override
			public void doHandle(Object bo, JSONObject jo) {
				String val = (String) ObjectUtil.getFieldValueByName("value3", bo);
				Integer id = (Integer) ObjectUtil.getFieldValueByName("id", bo);
				Subscribe ss = new Subscribe();
				ss.setAccountId(AccountShiroUtil.getCurrentUser().getId());
				ss.setInformationResourceId(id);
				List l = subscribeService.find(ss);
				if (l != null && l.size() > 0) {
					jo.put("subscribe", 0);
				} else {
					jo.put("subscribe", 1);
				}
				if (StringUtils.isNotEmpty(val) && StringUtils.isNumeric(val)) {
					int value = Integer.valueOf(val);
					jo.put("value3", value);
					Company c = new Company();
					c.setId(value);
					c = companyService.findById(c);
					jo.put("value3ForShow", c.getCompanyName());
					jo.put("value4ForShow", c.getCompanyCode());
				}

			}

			@Override
			public Object doHandle(Object obj) {
				// TODO Auto-generated method stub
				return null;
			}
		});

		map.put("value2", new DataHandler() {

			@Override
			public int getMode() {

				return ADD_MODE;
			}

			@Override
			public Object doHandle(Object obj) {
				// TODO Auto-generated method stub
				return obj;
			}
		});

		map.put("value8", new DataHandler() {

			@Override
			public int getMode() {

				return FREEDOM_MODE;
			}

			@Override
			public void doHandle(Object bo, JSONObject jo) {
				String v8 = (String) ObjectUtil.getFieldValueByName("value8", bo);
				Integer id = (Integer) ObjectUtil.getFieldValueByName("id", bo);

				jo.put("value8", v8);
				if (v8 != null && !v8.equals("1")) {
					Application ap = new Application();
					ap.setInformationId(id);
					ap.setApplyCompany(AccountShiroUtil.getCurrentUser().getCompanyId());
					List<Application> l = applicationService.find(ap);
					if (l != null && l.size() > 0) {
						for (Application a : l) {
							if (a.getStatus().intValue() == 0) {
								jo.put("applicationStatus", 0);
								return;
							}
							if (a.getStatus().intValue() == 1) {
								jo.put("applicationStatus", 1);
								return;
							}
						}
						jo.put("applicationStatus", 2);

					} else {
						jo.put("applicationStatus", 10);
					}
				}

			}

			@Override
			public Object doHandle(Object obj) {

				return obj;
			}
		});

		map.put("id", new DataHandler() {
			@Override
			public int getMode() {
				return FREEDOM_MODE;
			}

			@Override
			public Object doHandle(Object obj) {
				return null;
			}

			@Override
			public void doHandle(Object bo, JSONObject jo) {
				int id = (int) ObjectUtil.getFieldValueByName("Id", bo);
				jo.put("id", id);
				jo.put("idForShow", SecurityUtil.encrypt(id));
				DataFile df = new DataFile();
				df.setInformationResourceId(id);
				List list = dataFileService.find(df);
				if (list != null && list.size() > 0) {
					jo.put("hasFile", 1);
				}
				DataList dl = new DataList();
				String dmids = "";
				dl.setDataManagerId(id);
				// List<DataElement> delist =
				// dataElementService.getDataElementListByDataList(dl);
				// jo.put("dataElementList", DataHandlerUtil.buildJson(delist,
				// getDataHandlers(), true).toString());
				List<DataList> dmlist = dataListService.find(dl);
				for (DataList dm : dmlist) {
					dmids = dmids + dm.getDataElementId() + ",";
				}
				dmids = StringUtil.toSQLArray(dmids);
				// System.out.println("dmids= "+dmids);
				jo.put("dataElementIds", dmids.toString());
			}
		});

		return map;
	}

	private Map<String, DataHandler> getExcelHandler() {
		Map<String, DataHandler> map = new HashMap<String, DataHandler>();
		List<DataManager> list = dataManagerService.find(new DataManager());
		for (final DataManager sf : list) {
			map.put("value" + sf.getValueNo(), new DataHandler() {
				@Override
				public int getMode() {
					return ADD_MODE;
				}

				@Override
				public Object doHandle(Object obj) {
					if (sf.getInputType().equals("2")) {
						return ServiceUtil.getDicValue(sf.getInputValue(), (String) obj);
					} else if (sf.getInputType().equals("3")) {
						List<ItemSort> ls = ServiceUtil.getService("ItemSortService")
								.find(ServiceUtil.buildBean("ItemSort@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getItemName();
						}
					} else if (sf.getInputType().equals("5")) {
						List<Company> ls = ServiceUtil.getService("CompanyService")
								.find(ServiceUtil.buildBean("Company@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getCompanyName();
						}
					} else if (sf.getInputType().equals("7")) {
						List<GovServer> ls = ServiceUtil.getService("GovServerService")
								.find(ServiceUtil.buildBean("GovServer@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					} else if (sf.getInputType().equals("8")) {
						List<GovMemorizer> ls = ServiceUtil.getService("GovMemorizerService")
								.find(ServiceUtil.buildBean("GovMemorizer@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					} else if (sf.getInputType().equals("9")) {
						List<GovComputerRoom> ls = ServiceUtil.getService("GovComputerRoomService")
								.find(ServiceUtil.buildBean("GovComputerRoom@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					} else if (sf.getInputType().equals("10")) {
						List<GovApplicationSystem> ls = ServiceUtil.getService("GovApplicationSystemService")
								.find(ServiceUtil.buildBean("GovApplicationSystem@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					} else if (sf.getInputType().equals("12")) {
						List<GovDatabase> ls = ServiceUtil.getService("GovDatabaseService")
								.find(ServiceUtil.buildBean("GovDatabase@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue2();
						}
					} else if (sf.getInputType().equals("13")) {
						List<GovTable> ls = ServiceUtil.getService("GovTableService")
								.find(ServiceUtil.buildBean("GovTable@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					} else if (sf.getInputType().equals("14")) {
						List<GovTableField> ls = ServiceUtil.getService("GovTableFieldService")
								.find(ServiceUtil.buildBean("GovTableField@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					}
					return obj;
				}
			});
		}

		map.put("value3", new DataHandler() {

			@Override
			public int getMode() {
				return ADD_MODE;
			}

			@Override
			public Object doHandle(Object obj) {
				if (obj == null) {
					return "";
				}
				Company c = new Company();
				c.setId(Integer.valueOf((String) obj));
				c = companyService.findById(c);
				return c.getCompanyName();
			}

		});

		map.put("inforTypes", new DataHandler() {
			// 数据类型（datatype）根据数据字典配置，通过ID读取后dicvalue
			@Override
			public Object doHandle(Object obj) {
				SortManager dic = new SortManager();
				dic.setId((Integer) obj);
				dic = sortManagerService.findById(dic);
				if (dic.getSortName() != null) {
					return dic.getSortName();
				}
				return "";
			}

			@Override
			public int getMode() {
				return ADD_MODE;
			}

		});
		map.put("inforTypes2", new DataHandler() {
			// 数据类型（datatype）根据数据字典配置，通过ID读取后dicvalue
			@Override
			public Object doHandle(Object obj) {
				SortManager dic = new SortManager();
				dic.setId((Integer) obj);
				dic = sortManagerService.findById(dic);
				if (dic.getSortName() != null) {
					return dic.getSortName();
				}
				return "";
			}

			@Override
			public int getMode() {
				return ADD_MODE;
			}

		});

		map.put("inforTypes3", new DataHandler() {
			// 数据类型（datatype）根据数据字典配置，通过ID读取后dicvalue
			@Override
			public Object doHandle(Object obj) {
				SortManager dic = new SortManager();
				dic.setId((Integer) obj);
				dic = sortManagerService.findById(dic);
				if (dic.getSortName() != null) {
					return dic.getSortName();
				}
				return "";
			}

			@Override
			public int getMode() {
				return ADD_MODE;
			}

		});
		map.put("inforTypes4", new DataHandler() {
			// 数据类型（datatype）根据数据字典配置，通过ID读取后dicvalue
			@Override
			public Object doHandle(Object obj) {
				SortManager dic = new SortManager();
				dic.setId((Integer) obj);
				dic = sortManagerService.findById(dic);
				if (dic.getSortName() != null) {
					return dic.getSortName();
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

	@RequestMapping(value = "updateStatus")
	public String updateStatus(InformationResource o, HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		if (o instanceof IdBaseEntity && StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
			((IdBaseEntity) o).setId(Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow"))));
		}
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			if (StringUtils.isNotEmpty(req.getParameter("ids"))) {
				String ids = req.getParameter("ids");
				String[] is = ids.split(",");
				for (int i = 0; i < is.length; i++) {
					if (StringUtils.isNotEmpty(is[i]) && StringUtils.isNumeric(is[i])) {
						o.setId(Integer.valueOf(is[i]));
						service.updateStatus(o);
						if (o.getStatus() == 0) {
							Notice notice = new Notice();
							notice.setInformationResourceId(o.getId());
							notice.setMsg("更新了信息资源！");
							notice.setNoticeType(0);
							notice.setNoticeId(o.getId());
							noticeService.sendNotice(notice);
							// 版本控制
							InformationResource ir = service.findById(o);
							DataList dl = new DataList();
							dl.setDataManagerId(o.getId());
							ir.setDataElementList(dataElementService.getDataElementListByDataList(dl));
							VersionControl vc = new VersionControl();
							vc.setSourceId(o.getId());
							vc.setClassName(InformationResource.class.getSimpleName());
							vc.setNewVersion(JSONObject.fromObject(ir).toString());
							versionControlService.insert(vc);
						}
					}
				}
			} else {
				service.updateStatus(o);
			}
			ar.put("code", Const.SUCCEED);
			ar.put("msg", Const.ACTION_SUCCEED);
			if (o.getStatus() == 0) {
				Notice notice = new Notice();
				notice.setInformationResourceId(o.getId());
				notice.setMsg("更新了信息资源！");
				notice.setNoticeType(0);
				notice.setNoticeId(o.getId());
				noticeService.sendNotice(notice);
				// 版本控制
				InformationResource ir = service.findById(o);
				DataList dl = new DataList();
				dl.setDataManagerId(o.getId());
				ir.setDataElementList(dataElementService.getDataElementListByDataList(dl));
				VersionControl vc = new VersionControl();
				vc.setSourceId(o.getId());
				vc.setClassName(InformationResource.class.getSimpleName());
				vc.setNewVersion(JSONObject.fromObject(ir).toString());
				versionControlService.insert(vc);

			}
		} catch (Exception e) {
			ar.put("code", Const.FAIL);
			ar.put("msg", Const.ACTION_FAIL);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	/**
	 * @Title: relation @Description: 资源关系分析数据获取 @param @param o @param @param
	 *         req @param @param res @param @return @param @throws Exception
	 *         设定文件 @return String 返回类型 @throws
	 */
	@RequestMapping(value = "relation")
	public String relation(InformationResource o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		InformationResource informationResource = service.find(o).get(0);
		String[] fileds = ObjectUtil.getFiledName(informationResource);
		JSONObject jo = new JSONObject();
		GovmadeDic dic = new GovmadeDic();
		Company company = new Company();
		for (String filed : fileds) {
			Object value = ObjectUtil.getFieldValueByName(filed, informationResource);
			jo.put(filed, value);
		}
		// Relation to ItemSort
		ItemSort itemSortForSearch = new ItemSort();
		if (informationResource.getValue6() != null && !informationResource.getValue6().isEmpty()) {
			itemSortForSearch.setId(Integer.valueOf(informationResource.getValue6()));
			ItemSort itemSort = itemSortService.find(itemSortForSearch).get(0);
			fileds = ObjectUtil.getFiledName(itemSort);
			for (String filed : fileds) {
				Object value = ObjectUtil.getFieldValueByName(filed, itemSort);
				if (filed == "serObjSort") {
					dic.setDicNum("SEROBJSORT");
					dic.setDicKey(value + "");
					value = govmadeDicService.getDicList(dic).get(0).getDicValue();
				}
				if (filed == "serContent") {
					dic.setDicNum("SERCONTENT");
					dic.setDicKey(value + "");
					value = govmadeDicService.getDicList(dic).get(0).getDicValue();
				}
				if (filed == "deadline") {
					dic.setDicNum("DEADLINE");
					dic.setDicKey(value + "");
					value = govmadeDicService.getDicList(dic).get(0).getDicValue();
				}
				jo.put(filed, value);
			}
			// Relation to GovApplicationSystem
			if (itemSort.getBusSystem() != null) {
				GovApplicationSystem govApplicationSystemForSearch = new GovApplicationSystem();
				govApplicationSystemForSearch.setId(Integer.valueOf(itemSort.getBusSystem()));
				GovApplicationSystem govApplicationSystem = govApplicationSystemService
						.find(govApplicationSystemForSearch).get(0);
				fileds = ObjectUtil.getFiledName(govApplicationSystem);
				for (String filed : fileds) {
					Object value = ObjectUtil.getFieldValueByName(filed, govApplicationSystem);
					if (filed == "companyId") {
						company.setId((Integer) value);
						value = companyService.find(company).get(0).getCompanyName();
						filed = "acompanyId";
					}
					if (filed == "network") {
						dic.setDicNum("NETWORK");
						dic.setDicKey(value + "");
						value = govmadeDicService.getDicList(dic).get(0).getDicValue();
					}
					jo.put(filed, value);
				}
				// Relation to GovMemorizer
				GovMemorizer govMemorizerForSearch = new GovMemorizer();
				govMemorizerForSearch.setId(Integer.valueOf(govApplicationSystem.getBelongMemorizerId()));
				GovMemorizer govMemorizer = govMemorizerService.find(govMemorizerForSearch).get(0);
				fileds = ObjectUtil.getFiledName(govMemorizer);
				for (String filed : fileds) {
					Object value = ObjectUtil.getFieldValueByName(filed, govMemorizer);
					if (filed == "companyId") {
						company.setId((Integer) value);
						value = companyService.find(company).get(0).getCompanyName();
						filed = "mcompanyId";
					}
					if (filed == "memorizerBrand") {
						dic.setDicNum("MEMORIZERBRAND");
						dic.setDicKey(value + "");
						value = govmadeDicService.getDicList(dic).get(0).getDicValue();
					}
					jo.put(filed, value);
				}
				// Relation to GovComputerRoom
				GovComputerRoom govComputerRoomForSearch = new GovComputerRoom();
				govComputerRoomForSearch.setId(Integer.valueOf(govMemorizer.getBelongCproomId()));
				GovComputerRoom govComputerRoom = govComputerRoomService.find(govComputerRoomForSearch).get(0);
				fileds = ObjectUtil.getFiledName(govComputerRoom);
				for (String filed : fileds) {
					Object value = ObjectUtil.getFieldValueByName(filed, govComputerRoom);
					if (filed == "companyId") {
						company.setId((Integer) value);
						value = companyService.find(company).get(0).getCompanyName();
						filed = "ccompanyId";
					}
					jo.put(filed, value);
				}
				// Relation to GovServer
				GovServer govServerForSearch = new GovServer();
				govServerForSearch.setId(Integer.valueOf(govApplicationSystem.getBelongServerId()));
				GovServer govServer = govServerService.find(govServerForSearch).get(0);
				fileds = ObjectUtil.getFiledName(govServer);
				for (String filed : fileds) {
					Object value = ObjectUtil.getFieldValueByName(filed, govServer);
					if (filed == "companyId") {
						company.setId((Integer) value);
						value = companyService.find(company).get(0).getCompanyName();
						filed = "scompanyId";
					}
					if (filed == "serverBrand") {
						dic.setDicNum("SERVERBRAND");
						dic.setDicKey(value + "");
						value = govmadeDicService.getDicList(dic).get(0).getDicValue();
					}
					jo.put(filed, value);
				}
			}

		}

		res.getWriter().write(jo.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	@Override
	public void doBeforeInsertUpdate(InformationResource o, HttpServletRequest req, HttpServletResponse res) {
		o.setStatus(1);

		String tinfor = sortManagerService.findById(new SortManager(o.getInforTypes())).getSortCode();
		String tinfor2 = sortManagerService.findById(new SortManager(o.getInforTypes2())).getSortCode();
		String tinfor3 = "000";
		if (o.getInforTypes3() != null) {
			tinfor3 = sortManagerService.findById(new SortManager(o.getInforTypes3())).getSortCode();
		}
		String tinfor4 = "0000";
		if (o.getInforTypes4() != null) {
			tinfor4 = sortManagerService.findById(new SortManager(o.getInforTypes3())).getSortCode();
		}
		String i = "";
		i = service.getMaxCode(o);
		// System.out.println("getMaxCode=============== "+i);
		if (i != null && i != "") {
			i = Integer.valueOf(i.substring(i.length() - 4, i.length())) + 1 + "";
			while (i.length() < 4) {
				i = "0" + i;
			}
		} else {
			i = "0001";
		}
		String code = tinfor + tinfor2 + tinfor3 + tinfor4 + "/" + i;

		if (o.getId() == null) {
			o.setValue2(code);
		} else {
			String[] c = o.getValue2().split("/");
			if (!c[0].equals(tinfor + tinfor2 + tinfor3 + tinfor4)) {
				// System.out.println("c[0]= "+c[0]);
				// System.out.println("tinfor + tinfor2 + tinfor3 + tinfor4=
				// "+tinfor + tinfor2 + tinfor3 + tinfor4);
				o.setValue2(code);
			}
		}

		if (StringUtils.isEmpty(o.getValue3())) {
			o.setValue3(AccountShiroUtil.getCurrentUser().getCompanyId() + "");
		} else {
			Company c = new Company();
			c.setId(Integer.valueOf(o.getValue3()));
			c = companyService.findById(c);
			o.setValue4(c.getCompanyCode());
		}
		if (StringUtils.isEmpty(o.getValue4())) {
			Company c = new Company();
			c.setId(AccountShiroUtil.getCurrentUser().getCompanyId());
			c = companyService.findById(c);
			o.setValue4(c.getCompanyCode());
		}

		String tableId = req.getParameter("tableId");
		if (StringUtils.isNotEmpty(tableId) && StringUtils.isNumeric(tableId)) {
			o.setSourceType(3);
		}
	}

	@Override
	public void doAfterInsertUpdate(InformationResource o, HttpServletRequest req, HttpServletResponse res) {
		int infoResId = o.getId();
		String tableId = req.getParameter("tableId");
		if (StringUtils.isNotEmpty(tableId) && StringUtils.isNumeric(tableId)) {
			GovTable table = new GovTable();
			table.setId(Integer.valueOf(tableId));
			table = govTableService.findById(table);
			table.setInforResId(infoResId);
			govTableService.update(table);
		}
		String str = StringUtil.toSQLArray(o.getDataElementId());
		StringBuffer sb = new StringBuffer(",");
		if (req.getParameterValues("shareCheckBox") != null) {
			String[] shareStrs = req.getParameterValues("shareCheckBox");
			for (String s : shareStrs) {
				sb.append(s).append(",");
			}
		}
		String ss = sb.toString();
		if (str != null && str != "") {
			String[] strs = str.split(",");
			DataList dl = new DataList();
			dl.setDataManagerId(infoResId);

			dataListService.deleteByDataManagerId(dl);
			for (String ids : strs) {
				if (StringUtils.isNotEmpty(ids) && StringUtils.isNumeric(ids)) {
					dl.setDataElementId(Integer.valueOf(ids));
					if (ss.contains("," + ids + ",")) {
						dl.setIsShare(0);
					} else {
						dl.setIsShare(1);
					}
					dataListService.insert(dl);
				}

			}
		}
		PushUtil.pushInformation(o);

	}

	/**
	 * 
	 * @param ja
	 *            json数组
	 * @param field
	 *            要排序的key
	 * @param isAsc
	 *            是否升序
	 */
	private static void sort(JSONArray ja, final String field, boolean isAsc) {
		Collections.sort(ja, new Comparator<JSONObject>() {
			@Override
			public int compare(JSONObject o1, JSONObject o2) {
				Object f1 = o1.get(field);
				Object f2 = o2.get(field);
				if (f1 instanceof Number && f2 instanceof Number) {
					return ((Number) f1).intValue() - ((Number) f2).intValue();
				} else {
					return f1.toString().compareTo(f2.toString());
				}
			}
		});
		if (!isAsc) {
			Collections.reverse(ja);
		}
	}

	@RequestMapping(value = "basicEcharts")
	public String basicEcharts(InformationResource o, HttpServletResponse res, HttpServletRequest req)
			throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONArray unitArray = new JSONArray();
		JSONObject unitJson = new JSONObject();
		SortManager som = new SortManager();
		som.setSortId(42);
		List<SortManager> basicList = sortManagerService.find(som);
		int count = 0;
		if (basicList.size() > 0) {
			for (SortManager d : basicList) {
				o.setInforTypes2(d.getId());
				o.setStatus(0);
				int counts = service.count(o);
				count = count + counts;
			}
			for (SortManager d : basicList) {
				o.setInforTypes2(d.getId());
				o.setStatus(0);
				int counts = service.count(o);
				unitJson.put("name", d.getSortName());
				if (count > 0) {
					DecimalFormat df = new DecimalFormat("#.0");
					unitJson.put("value", df.format(counts * 100 / (double) count));
				} else {
					unitJson.put("value", 0);
				}
				unitArray.add(unitJson);
			}
		}
		sort(unitArray, "value", false);
		res.getWriter().write(unitArray.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	@RequestMapping(value = "themeEcharts")
	public String themeEcharts(InformationResource o, HttpServletResponse res, HttpServletRequest req)
			throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONArray unitArray = new JSONArray();
		JSONObject unitJson = new JSONObject();
		SortManager som = new SortManager();
		som.setSortId(133);
		List<SortManager> basicList = sortManagerService.find(som);
		int count = 0;
		if (basicList.size() > 0) {
			for (SortManager d : basicList) {
				o.setInforTypes2(d.getId());
				o.setStatus(0);
				int counts = service.count(o);
				count = count + counts;
			}
			for (SortManager d : basicList) {
				o.setInforTypes2(d.getId());
				o.setStatus(0);
				int counts = service.count(o);
				unitJson.put("name", d.getSortName());
				if (count > 0) {
					DecimalFormat df = new DecimalFormat("#.0");
					unitJson.put("value", df.format(counts * 100 / (double) count));
				} else {
					unitJson.put("value", 0);
				}
				unitArray.add(unitJson);
			}
		}
		sort(unitArray, "value", false);
		res.getWriter().write(unitArray.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	@Override
	public void doBeforeListAjax(InformationResource o, HttpServletRequest req, HttpServletResponse res) {
		String keyword = req.getParameter("keyword");
		if (StringUtils.isNotEmpty(keyword)) {
			if (StringUtils.isNumeric(keyword)) {
				o.setValue2(keyword);
			} else {
				o.setValue5(keyword);
			}
			SearchLog sl = new SearchLog();
			sl.setKeyWord(keyword);
			sl.setAccountId(AccountShiroUtil.getCurrentUser().getId());
			searchLogService.insert(sl);
		}
	}

	// 验证名称重复
	@RequestMapping(value = "validation")
	public String validation(InformationResource o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		InformationResource in = new InformationResource();
		String inname = o.getValue1();
		in.setValue1(inname);
		String results = "";
		if (o.getId() == null) {
			if (!service.find(in).isEmpty() && StringUtils.isNotEmpty(o.getValue1())) {
				results = "1";
			}
		} else {

			if (service.find(in).size() != 0 && StringUtils.isNotEmpty(o.getValue1())) {
				if ((int) service.find(in).get(0).getId() != (int) o.getId()) {
					results = "1";
				}
			}
		}
		if (results == "") {
			results = "0";
		}

		String str = "{\"results\":[" + results + "]}";
		res.getWriter().write(str);
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	@RequestMapping("importDataElement")
	@ResponseBody
	public AjaxRes importDataElement(@RequestParam(value = "file", required = false) MultipartFile file, Model model,
			HttpServletRequest request) {
		String t = request.getParameter("t");
		AjaxRes ar = getAjaxRes();
		try {

			String path = request.getSession().getServletContext().getRealPath("upload/excel");
			String fileName = file.getOriginalFilename().trim();
			String icon = System.currentTimeMillis() + "/";
			File targetFile = new File(path + "/" + icon, fileName);
			if (!targetFile.exists()) {
				targetFile.mkdirs();
			}
			file.transferTo(targetFile);
			InformationResourceAdapter adapter = new InformationResourceAdapter();
			ExcelUtil excelUtil = new ExcelUtil(adapter);
			excelUtil.excelToList(targetFile.getAbsolutePath(), 0);

			if (adapter.isError()) {
				ar.setRes(Const.FAIL);
			} else {
				try {
					if (adapter.getEntityList() != null) {
						for (InformationResource dm : adapter.getEntityList()) {
							dm.setStatus(1);
							dm.setSourceType(2);
							// dm.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
							dm.setGroupId(AccountShiroUtil.getCurrentUser().getGroupId());
							doBeforeInsertUpdate(dm, request, null);
							service.insert(dm);
						}
						ar.setRes(Const.SUCCEED);
					}
				} catch (Exception e) {
					ar.setRes(Const.FAIL);
					e.printStackTrace();
				}
			}
			ar.setResMsg(adapter.getErrorMsg().toString());

			DEtoResourceNNAdapter nnadapter = new DEtoResourceNNAdapter();
			DataElement dataElement = new DataElement();
			dataElement.setClassType(1);
			ExcelUtil nnexcelUtil = new ExcelUtil(nnadapter);
			nnexcelUtil.excelToList(targetFile.getAbsolutePath(), 1);
			DataList dl = new DataList();
			if (nnadapter.isError() || adapter.isError()) {
				ar.setRes(Const.FAIL);
			} else {
				try {
					if (nnadapter.getEntityList() != null) {
						for (DataElement de : nnadapter.getEntityList()) {

							dataElementService.setIdentifier(de);
							de.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
							de.setGroupId(AccountShiroUtil.getCurrentUser().getGroupId());
							dl.setDataManagerId(Integer.valueOf(de.getValue30()));
							de.setValue30(null);
							de.setIsShare(0);
							de.setSourceType(2);
							dataElement.setChName(de.getValue1());
							List<DataElement> list = dataElementService.findByName(dataElement,
									" case when t.source_type=2 then -1 end ", "asc");
							if (list != null && list.size() != 0) {
								dl.setDataElementId(list.get(0).getId());
							} else {
								dataElementService.insert(de);
								dl.setDataElementId(de.getId());
							}
							dl.setIsShare(0);
							dataListService.insert(dl);
						}
						ar.setRes(Const.SUCCEED);
					}
				} catch (Exception e) {
					ar.setRes(Const.FAIL);
					e.printStackTrace();
				}
			}
			ar.setResMsg(adapter.getErrorMsg().toString() + "\n" + nnadapter.getErrorMsg().toString());

		} catch (Exception e) {
			e.printStackTrace();
			ar.setFailMsg(Const.DATA_FAIL);
		}

		return ar;
	}

	/**
	 * @Title: treeAjax @Description: 首页树形展现 @param @param o @param @param
	 *         req @param @param res @param @throws Exception 设定文件 @return void
	 *         返回类型 @throws
	 */
	@RequestMapping(value = "treeAjax")
	public void treeAjax(InformationResource o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject tree = new JSONObject();
		JSONArray treeChild = new JSONArray();
		SortManager som = new SortManager();
		som.setLevel(1);
		som.setBelong(2);
		som.setIsDeleted(0);
		List<SortManager> basicList = sortManagerService.find(som);
		for (SortManager sm : basicList) {
			JSONObject secondTree = new JSONObject();
			secondTree.put("name", sm.getSortName());
			JSONArray streeChild = new JSONArray();
			SortManager somc = new SortManager();
			somc.setSortId(sm.getId());
			somc.setBelong(2);
			somc.setIsDeleted(0);
			List<SortManager> bList = sortManagerService.find(somc);
			for (SortManager smc : bList) {
				JSONObject thirdTree = new JSONObject();
				thirdTree.put("name", smc.getSortName());
				o.setInforTypes2(smc.getId());
				InformationResource informationResource = service.tree(o);
				if (null != informationResource) {
					String value1s = informationResource.getValue1();
					String[] strArray = value1s.split(",");
					List<String> list = new LinkedList<String>();
					for (int i = 0; i < strArray.length; i++) {
						if (!list.contains(strArray[i])) {
							list.add(strArray[i]);
						}
					}
					String[] newArray = list.toArray(new String[list.size()]);
					JSONArray ttreeChild = new JSONArray();
					JSONObject forthTree = new JSONObject();
					for (String unis : newArray) {
						if (!StringUtils.isEmpty(unis)) {
							forthTree.put("name", unis);
						} else {
							forthTree.put("name", "未定义");
						}
						ttreeChild.add(forthTree);
					}
					thirdTree.put("children", ttreeChild);
				}
				streeChild.add(thirdTree);
			}
			secondTree.put("children", streeChild);
			treeChild.add(secondTree);
		}
		tree.put("name", "基础目录");
		tree.put("children", treeChild);
		res.getWriter().write(tree.toString());
		res.getWriter().flush();
		res.getWriter().close();
	}

	@RequestMapping(value = "subscribeList")
	public String subscribeList(Subscribe sub, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		if (sub.getAccountId() == null) {
			sub.setAccountId(AccountShiroUtil.getCurrentUser().getId());
		}
		JSONObject ar = new JSONObject();
		try {
			List<InformationResource> inforList = service.getInformationResourceBySubscribe(sub);
			ar.put("rows", DataHandlerUtil.buildJson(inforList, getDataHandlers(), true));
			ar.put("total", inforList.size());
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

	@RequestMapping(value = "getInforResByDataElementIds")
	public String getInforResByDataElementIds(String ids, HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");

		JSONObject ar = new JSONObject();
		try {
			if (StringUtils.isNotEmpty(ids)) {
				List<InformationResource> inforList = service.getInforResByDataElementIds(StringUtil.toSQLArray(ids));
				ar.put("rows", DataHandlerUtil.buildJson(inforList, getDataHandlers(), true));
				ar.put("total", inforList.size());
				ar.put("code", Const.SUCCEED);
			} else {
				ar.put("code", Const.FAIL);
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

	// 清空表
	@RequestMapping(value = "cleanTable")
	public String cleanTable(HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			service.truncateTable();
			ar.put("code", Const.SUCCEED);
			ar.put("msg", Const.ACTION_SUCCEED);
		} catch (Exception e) {
			ar.put("code", Const.FAIL);
			ar.put("msg", Const.ACTION_FAIL);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	// 全部审核通过
	@RequestMapping(value = "allPass")
	public String allPass(HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			service.allPass();
			ar.put("code", Const.SUCCEED);
			ar.put("msg", Const.ACTION_SUCCEED);
		} catch (Exception e) {
			ar.put("code", Const.FAIL);
			ar.put("msg", Const.ACTION_FAIL);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	// 信息资源查看
	@RequestMapping(value = "detail")
	public String detail(InformationResource o, HttpServletRequest req, HttpServletResponse res, Model m)
			throws Exception {

		if (o instanceof IdBaseEntity && StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
			int id = Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow")));
			((IdBaseEntity) o).setId(id);
		}
		o = service.findById(o);
		if (o.getInforTypes() == null) {
			o.setInforTypes(0);
		}
		if (o.getInforTypes2() == null) {
			o.setInforTypes2(0);
		}
		if (o.getInforTypes3() == null) {
			o.setInforTypes3(0);
		}
		if (o.getInforTypes4() == null) {
			o.setInforTypes4(0);
		}
		if (o.getBinforTypes() == null) {
			o.setBinforTypes(0);
		}
		if (o.getBinforTypes2() == null) {
			o.setBinforTypes2(0);
		}
		if (o.getBinforTypes3() == null) {
			o.setBinforTypes3(0);
		}
		if (o.getBinforTypes4() == null) {
			o.setBinforTypes4(0);
		}
		DataList dl = new DataList();
		dl.setDataManagerId(o.getId());
		m.addAttribute("dataElementList", dataElementService.getDataElementListByDataList(dl));
		m.addAttribute("informationResource", o);
		VersionControl vc = new VersionControl();
		vc.setClassName(InformationResource.class.getSimpleName());
		vc.setSourceId(o.getId());
		List<VersionControl> list = versionControlService.find(vc);
		if (list != null && list.size() > 0) {
			JSONObject jo = JSONObject.fromObject(list.get(0).getNewVersion());
			InformationResource old = (InformationResource) JSONObject.toBean(jo, InformationResource.class);
			JSONArray jsonArray = jo.getJSONArray("dataElementList");
			List<DataElement> oldDataElementList = (List) JSONArray.toCollection(jsonArray, DataElement.class);
			m.addAttribute("oldDataElementList", oldDataElementList);
			m.addAttribute("oldVersion", old);
			m.addAttribute("versionList", list);
		}
		return "/system/information/resource/detail";
	}

	@RequestMapping("downloadData")
	public ResponseEntity<byte[]> downloadData(String[] xlsFields, String[] deFields, HttpServletRequest req,
			HttpServletResponse response) throws Exception {
		if (xlsFields == null) {
			xlsFields = new String[0];
		}
		if (deFields == null) {
			deFields = new String[0];
		}

		InformationResource de = new InformationResource();
		InformationResource2ExcelAdapter adapter = new InformationResource2ExcelAdapter(service.find(de), xlsFields,
				deFields, getExcelHandler());
		Object2ExcelComplexUtil util = new Object2ExcelComplexUtil(adapter);
		String path = req.getSession().getServletContext().getRealPath("upload/excel");
		String fileName = "导出数据.xls";
		String icon = System.currentTimeMillis() + "/";
		String fullPath = path + "/" + icon + fileName;
		File targetFile = new File(path + "/" + icon);
		if (!targetFile.exists()) {
			targetFile.mkdirs();
		}
		util.object2Excel(fullPath);
		HttpHeaders headers = new HttpHeaders();
		String fn = new String(fileName.getBytes("UTF-8"), "iso-8859-1");// 为了解决中文名称乱码问题
		headers.setContentDispositionFormData("attachment", fn);
		headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
		return new ResponseEntity<byte[]>(FileUtils.readFileToByteArray(new File(fullPath)), headers,
				HttpStatus.CREATED);
	}

}
