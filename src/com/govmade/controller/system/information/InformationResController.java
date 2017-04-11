package com.govmade.controller.system.information;

import java.io.File;
import java.text.DecimalFormat;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
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

import com.govmade.adapter.DataElementNNAdapter;
import com.govmade.adapter.InformationResAdapter;
import com.govmade.adapter.object2excel.Computer2ExcelAdapter;
import com.govmade.adapter.object2excel.InformationRes2ExcelAdapter;
import com.govmade.common.ajax.AjaxRes;
import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.ChineseTo;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.poi.ExcelUtil;
import com.govmade.common.utils.poi.Object2ExcelUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.entity.system.customFields.SimpleFields;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.DataFile;
import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.memorizer.GovMemorizer;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.server.GovServer;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.data.DataListService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.DataFileService;
import com.govmade.service.system.information.InformationBusinessService;
import com.govmade.service.system.information.InformationResService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.simpleFields.SimpleFieldsService;
import com.govmade.service.system.sort.SortManagerService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * @author (浣滆��) Zhanglu 274059078@qq.com
 * @Description: CitySystem TODO
 * @date 2016骞�12鏈�8鏃� 涓婂崍9:54:39
 * @Title: InformationResController.java
 */

@Controller
@RequestMapping("/backstage/information/res/")
public class InformationResController extends GovmadeBaseController<InformationRes> {

	@Autowired
	private InformationResService service;
	@Autowired
	private DataListService dataListService;
	@Autowired
	private GovmadeDicService govmadeDicService;
	@Autowired
	private DataElementService dataElementService;
	@Autowired
	private SortManagerService sortManagerService;
	@Autowired
	private InformationBusinessService informationBusinessService;
	@Autowired
	private DataFileService dataFileService;
	@Autowired
	private CompanyService companyService;
	@Autowired
	private SimpleFieldsService simpleFieldsService;
	
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

	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map = super.getDataHandlers();
		map=DataHandlerUtil.buildSimpleFieldsDataHandlers(map, InformationRes.class);
		map.put("inforTypes", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {

				return null;
			}

			@Override
			public void doHandle(Object bo, JSONObject jo) {
				String inforTypes = (String) ObjectUtil.getFieldValueByName("inforTypes", bo);
				Integer inforTypes2 = (Integer) ObjectUtil.getFieldValueByName("inforTypes2", bo);
				Integer inforTypes3 = (Integer) ObjectUtil.getFieldValueByName("inforTypes3", bo);
				Integer inforTypes4 = (Integer) ObjectUtil.getFieldValueByName("inforTypes4", bo);
				StringBuffer sb = new StringBuffer();
				if (StringUtils.isNotEmpty(inforTypes) && StringUtils.isNumeric(inforTypes)) {
					SortManager sm = new SortManager();
					sm.setId(Integer.valueOf(inforTypes));
					sm = sortManagerService.findById(sm);
					;
					sb.append(sm.getSortName());
					if (inforTypes2 != null) {
						sm = new SortManager();
						sm.setId(Integer.valueOf(inforTypes2));
						sm = sortManagerService.findById(sm);
						;
						sb.append("-").append(sm.getSortName());
						if (inforTypes3 != null) {
							sm = new SortManager();
							sm.setId(Integer.valueOf(inforTypes3));
							sm = sortManagerService.findById(sm);
							;
							sb.append("-").append(sm.getSortName());
							if (inforTypes4 != null) {
								sm = new SortManager();
								sm.setId(Integer.valueOf(inforTypes4));
								sm = sortManagerService.findById(sm);
								;
								sb.append("-").append(sm.getSortName());

							}
						}
					}
				}
				jo.put("inforTypes", inforTypes);
				jo.put("inforTypesName", sb.toString());

			}

			@Override
			public int getMode() {
				return FREEDOM_MODE;
			}
		});

		map.put("inforProvider", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				GovmadeDic g = new GovmadeDic();
				g.setDicNum("ZYTGF");
				g.setDicKey((String) obj);
				List<GovmadeDic> list = govmadeDicService.getDicTreeList(g);
				if (list != null && list.size() > 0) {
					return list.get(0).getDicValue();
				}
				return null;
			}

			@Override
			public int getMode() {
				return ADD_MODE;
			}
		});
		map.put("businessId", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				InformationBusiness informationBusiness = new InformationBusiness();
				informationBusiness.setId((Integer) obj);
				List<InformationBusiness> list = informationBusinessService.find(informationBusiness);
				if (list != null && list.size() > 0) {
					return list.get(0).getBusName();
				}
				return null;
			}

			@Override
			public int getMode() {
				return ADD_MODE;
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
				int id=(int) ObjectUtil.getFieldValueByName("Id", bo);
				jo.put("id", id);
				jo.put("idForShow", SecurityUtil.encrypt(id));
				DataList dl = new DataList();
				String dmids = "";
				dl.setInformationResId(id);
				List<DataList> dmlist = dataListService.find(dl);
				for (DataList dm : dmlist) {
					dmids = dmids + dm.getDataElementId() + ",";
				}
				dmids = StringUtil.toSQLArray(dmids);
				jo.put("dataElementIds", dmids.toString());
			}
		});

		return map;
	}

	
	private Map<String, DataHandler> getExcelHandler() {
		Map<String, DataHandler> map = new HashMap<String, DataHandler>();
		SimpleFields sfs = new SimpleFields();
		sfs.setIsDeleted(0);
		sfs.setClassName("InformationRes");
		List<SimpleFields> list = simpleFieldsService.find(sfs);
		for (final SimpleFields sf : list) {
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
		return map;
	}
	
	
	@Override
	public String indexURL() {
		return "/system/information/res/index";
	}

	@RequestMapping(value = "resShow")
	public String resShow() {
		return "/system/information/resShow/index";
	}

	@RequestMapping(value = "depart")
	public String depart() {
		return "/system/information/depart/index";
	}

	@RequestMapping(value = "basis")
	public String basis(InformationRes o, HttpServletResponse res,Model model) {		
		SortManager sm = new SortManager();
		SortManager sms = new SortManager();
		SortManager sm2 = new SortManager();
		InformationRes p = new InformationRes();
		JSONObject uson = new JSONObject();
		JSONArray uarray = new JSONArray();
		sm.setIsDeleted(0);
		sm.setLevel(1);
		sm.setType(3);
		sms.setIsDeleted(0);
		sm2.setIsDeleted(0);
		sm2.setType(3);
		o.setIsDeleted(0);
		p.setIsDeleted(0);
		List<GovmadeDic> cpList = ServiceUtil.getDicByDicNum("ZYTGF");
		Map<String,Integer> value2Map=service.countValue2(o);
		
		if(cpList.size()>0){
			JSONObject unitJson = new JSONObject();
			JSONArray unitArray = new JSONArray();
			uson.put("name", "部门类");
			for(GovmadeDic cps : cpList){
				unitJson.put("name", cps.getDicValue());
				unitJson.put("id", cps.getDicKey());
				unitJson.put("tp", 1);
				unitJson.put("count", value2Map.get(cps.getDicKey()));
				unitArray.add(unitJson);
			}
			uson.put("children", unitArray);
			uarray.add(uson);
		}		
		List<SortManager> smList = sortManagerService.find(sm);
		Map<Integer,Integer> countMap=service.countInforTypes(o);
				
		if(smList.size()>0){			
			JSONObject unitJson = new JSONObject();
			for(SortManager smsm : smList){
				JSONArray unitArray = new JSONArray();
				sms.setSortId(smsm.getId());
				sms.setType(3);
				List<SortManager> smsList = sortManagerService.find(sms);
				
				if(smsList.size()>0){
					for(SortManager smsms : smsList){
						unitJson.put("name", smsms.getSortName());
						unitJson.put("id", smsms.getId());
						unitJson.put("tp", 2);
						unitJson.put("count",countMap.get(smsms.getId()));
						sm2.setSortId(smsms.getId());
						unitArray.add(unitJson);
						List<SortManager> sms2List = sortManagerService.find(sm2);
						for(SortManager smsms2 : sms2List){
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
		model.addAttribute("uson",uarray);
		return "/system/information/basis/index";
	}

	@RequestMapping(value = "theme")
	public String theme() {
		return "/system/information/theme/index";
	}

	@RequestMapping(value = "basicEcharts")
	public String basicEcharts(InformationRes o, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONArray unitArray = new JSONArray();
		JSONObject unitJson = new JSONObject();
		SortManager sortManager = new SortManager();
		sortManager.setSortId(1);
		sortManager.setType(3);
		sortManager.setIsDeleted(0);
		o.setIsDeleted(0);
		List<SortManager> basicList = sortManagerService.find(sortManager);
		int count = 0;
		if (basicList.size() > 0) {
			for (SortManager d : basicList) {
				o.setInforTypes2(d.getId());
				int counts = service.count(o);
				count = count + counts;
			}
			for (SortManager d : basicList) {
				o.setInforTypes2(d.getId());
				int counts = service.count(o);
				unitJson.put("name", d.getSortName());
				if (count > 0) {
					DecimalFormat df = new DecimalFormat("0.0");
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
	public String themeEcharts(InformationRes o, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONArray unitArray = new JSONArray();
		JSONObject unitJson = new JSONObject();
		SortManager sortManager = new SortManager();
		sortManager.setSortId(1);
		List<SortManager> basicList = sortManagerService.find(sortManager);
		int count = 0;
		if (basicList.size() > 0) {
			for (SortManager d : basicList) {
				o.setInforTypes2(d.getId());
				int counts = service.count(o);
				count = count + counts;
			}
			for (SortManager d : basicList) {
				o.setInforTypes2(d.getId());
				int counts = service.count(o);
				unitJson.put("name", d.getSortName());
				if (count > 0) {
					unitJson.put("value", counts * 100 / count);
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
	public BaseService getService() {
		return service;
	}

	@RequestMapping("importDataElement")
	@ResponseBody
	public AjaxRes importDataElement(@RequestParam(value = "file", required = false) MultipartFile file, Model model,
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
			file.transferTo(targetFile);
			InformationResAdapter adapter = new InformationResAdapter();
			ExcelUtil excelUtil = new ExcelUtil(adapter);
			excelUtil.excelToList(targetFile.getAbsolutePath(),0);
			
			
			if (adapter.isError()) {
				ar.setRes(Const.FAIL);
			} else {
				try {
					for (InformationRes dm : adapter.getEntityList()) {
						doBeforeInsertUpdate(dm, request, null);
						service.insert(dm);
						doAfterInsertUpdate(dm, request, null);
					}
					ar.setRes(Const.SUCCEED);
				} catch (Exception e) {
					ar.setRes(Const.FAIL);
					e.printStackTrace();
				}
			}
			ar.setResMsg(adapter.getErrorMsg().toString());
			
			
			DataElementNNAdapter nnadapter = new DataElementNNAdapter();
			DataElement dataElement=new DataElement();
			dataElement.setClassType(0);
			ExcelUtil nnexcelUtil = new ExcelUtil(nnadapter);
			nnexcelUtil.excelToList(targetFile.getAbsolutePath(),1);	
			DataList dl = new DataList();			
			if (nnadapter.isError() || adapter.isError()) {
				ar.setRes(Const.FAIL);
			} else {
				try {
					if(nnadapter.getEntityList()!=null){
						for (DataElement de : nnadapter.getEntityList()) {
//							int type=de.getObjectType();
							de.setClassType(0);
							//dataElement.setObjectType(type);
							//dataElement.setClassType(0);
//							String objectTypes = type+"";
//							while (objectTypes.length() < 2) {
//								objectTypes = "0" + objectTypes;
//							}
							String j = dataElementService.maxIdentifier(dataElement);
							if (j != null && j != "") {
								j = Integer.valueOf(j) + 1 + "";
								while (j.length() < 7) {
									j = "0" + j;
								}
							} else {
								j = "0000001";
							}
							de.setIdentifier( j);
							dl.setInformationResId(Integer.valueOf(de.getValue30()));
							de.setValue30(null);
							
							dataElement.setChName(de.getValue1());
							List<DataElement> list=dataElementService.findByName(dataElement," case when t.source_type=2 then -1 end ","asc");
							if(list !=null && list.size() != 0){
								dl.setDataElementId(list.get(0).getId());
							}else{
								dataElementService.insert(de);
								dl.setDataElementId(de.getId());
							}
							
							dataListService.insert(dl);
						}
						ar.setRes(Const.SUCCEED);
					}
				} catch (Exception e) {
					ar.setRes(Const.FAIL);
					e.printStackTrace();
				}
			}
			ar.setResMsg(adapter.getErrorMsg().toString()+"\n"+nnadapter.getErrorMsg().toString());
			
			
		} catch (Exception e) {
			e.printStackTrace();
			ar.setFailMsg(Const.DATA_FAIL);
		}

		return ar;
	}

	
	@RequestMapping("downloadData")
	public ResponseEntity<byte[]> downloadData(String[] xlsFields, HttpServletRequest req, HttpServletResponse response)
			throws Exception {
		InformationRes de = new InformationRes();
		de.setIsDeleted(0);
		InformationRes2ExcelAdapter adapter = new InformationRes2ExcelAdapter(service.find(de), xlsFields,
				getExcelHandler());
		Object2ExcelUtil util = new Object2ExcelUtil(adapter);
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
	
	
	@Override
	public void doBeforeInsertUpdate(InformationRes o, HttpServletRequest req, HttpServletResponse res) {
		String tinfor = sortManagerService.findById(new SortManager(Integer.valueOf(o.getInforTypes()))).getSortCode();
		String tinfor2 = sortManagerService.findById(new SortManager(o.getInforTypes2())).getSortCode();
		String tinfor3 = "N01";
		if (o.getInforTypes3() != null) {
			tinfor3 = sortManagerService.findById(new SortManager(o.getInforTypes3())).getSortCode();
		}
		String tinfor4 = "N001";
		if (o.getInforTypes4() != null) {
			tinfor4 = sortManagerService.findById(new SortManager(o.getInforTypes4())).getSortCode();
		}
		String i = "";
		i = service.getMaxCode(o);

		if (i != null && i != "" && i.length() > 0) {
			// System.out.println("getMaxCode=============== "+i);
			i = Integer.valueOf(i.substring(i.length() - 4, i.length())) + 1 + "";
			while (i.length() < 4) {
				i = "0" + i;
			}
		} else {
			i = "0001";
		}
		String code = tinfor + tinfor2 + tinfor3 + tinfor4 + "/" + i;

		if (o.getId() == null) {
			o.setInforCode(code);
		} else {
			String[] c = o.getInforCode().split("/");
			if (!c[0].equals(tinfor + tinfor2 + tinfor3 + tinfor4)) {
				o.setInforCode(code);
			}
		}
	}

	@Override
	public void doAfterInsertUpdate(InformationRes o, HttpServletRequest req, HttpServletResponse res) {
		int infoResId = o.getId();
		String str = StringUtil.toSQLArray(o.getDataElementId());
		if (str != null && str != "") {
			String[] strs = str.split(",");
			DataList dl = new DataList();
			dl.setInformationResId(infoResId);
			dataListService.deleteByInformationResId(dl);
			for (String ids : strs) {
				if (ids != null && ids != "" && ids.length() > 0) {
					dl.setDataElementId(Integer.valueOf(ids));
					dataListService.insert(dl);
				}
			}
		}
	}

	@Override
	@RequestMapping(value = "listAjax")
	public String listAjax(InformationRes o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		if (StringUtils.isNotEmpty(req.getParameter("inforTypes2"))) {
			o.setInforTypes2(new Integer(req.getParameter("inforTypes2")));
		}
		if (StringUtils.isNotEmpty(req.getParameter("inforTypes3"))) {
			o.setInforTypes3(new Integer(req.getParameter("inforTypes3")));
		}
		// System.out.println(o);
		try {
			if (StringUtils.isNotEmpty(req.getParameter("all"))) {
				List p = getService().find(o, req.getParameter("sort"), req.getParameter("order"));
				res.getWriter().write(DataHandlerUtil.buildJson(p, getDataHandlers(), true).toString());
				res.getWriter().flush();
				res.getWriter().close();
			} else {
				Page<InformationRes> page = new Page<InformationRes>();
				if (StringUtils.isNotEmpty(req.getParameter("page"))) {
					page.setPageNum(Integer.valueOf(req.getParameter("page")));
				}
				if (StringUtils.isNotEmpty(req.getParameter("rows"))) {
					page.setPageSize(Integer.valueOf(req.getParameter("rows")));
				}
				Page p = getService().findByPage(o, page, req.getParameter("sort"), req.getParameter("order"));
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

	// 验证名称重复
	@RequestMapping(value = "validation")
	public String validation(InformationRes o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		InformationRes in = new InformationRes();
		String inname = o.getValue1();
		in.setValue1(inname);
		String results = "";
		if (o.getId() == null) {
				if (!service.find(in).isEmpty()&&StringUtils.isNotEmpty(o.getValue1())) {
					results = "1";
				}
		} else {

				if(service.find(in).size()!=0&&StringUtils.isNotEmpty(o.getValue1())){
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

	//清空表
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

}
