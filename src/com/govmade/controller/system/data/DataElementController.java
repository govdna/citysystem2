package com.govmade.controller.system.data;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
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
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.poi.ExcelUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.data.DataListService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.InformationResourceService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.organization.GroupsService;
import com.govmade.service.system.table.GovTableFieldService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * @author (作者) Dong Jie 154046519@qq.com
 * @Description: CitySystem TODO
 * @date 2016年12月22日 上午10:22:58
 * @company (开发公司) 国脉海洋信息发展有限公司
 * @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
 * @since (该版本支持的JDK版本) 1.7
 * @Title: DataElementController.java
 * @Package com.govmade.controller.system.data
 * @version V1.0
 */
@Controller
@RequestMapping("/backstage/dataElement/")
public class DataElementController extends GovmadeBaseController<DataElement> {

	@Autowired
	private DataElementService service;

	@Autowired
	private CompanyService companyService;

	@Autowired
	private GroupsService groupsService;

	@Autowired
	private GovmadeDicService govmadeDicservice;

	@Autowired
	private DataListService dataListService;
	
	@Autowired
	private InformationResourceService informationResourceService;

	@Autowired
	private GovTableFieldService govTableFieldService;
	
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
		
		map.put("sourceType", new DataHandler() {
			// 数据类型（datatype）根据数据字典配置，通过ID读取后dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic = new GovmadeDic();
				dic.setDicNum("SOURCETYPE");
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
/*		
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
*/
		map.put("imported", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				if ((Integer) obj == 1) {
					return "已导入";
				}
				return "未导入";
			}

			@Override
			public void doHandle(Object bo, JSONObject jo) {
				Integer im = (Integer) ObjectUtil.getFieldValueByName("imported", bo);
				Integer id = (Integer) ObjectUtil.getFieldValueByName("id", bo);
				jo.put("imported", im);
				if (im != null && im.intValue() == 1) {
					DataElement d = new DataElement();
					d.setSourceId(id);
					List<DataElement> list = service.find(d);
					if (list != null && list.size() > 0) {
						if (list.get(0).getStatus().intValue() == 0) {
							jo.put("importedForShow", "已导入");
						} else {
							jo.put("importedForShow", "导入中");
						}
					}
				} else {
					jo.put("importedForShow", "未导入");
				}
			}

			@Override
			public int getMode() {
				return FREEDOM_MODE;
			}

		});

		map.put("companyId", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				Integer companyId = (Integer) obj;
				GovmadeDic dic = new GovmadeDic();
				dic.setDicNum("ZYTGF");
				dic.setDicKey(companyId + "");
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
				String companyId = (String) obj;
				GovmadeDic dic = new GovmadeDic();
				dic.setDicNum("ZYTGF");
				dic.setDicKey(companyId);
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
		map.put("dataElementId", new DataHandler() {
			@Override
			public int getMode() {
				return FREEDOM_MODE;
			}

			@Override
			public void doHandle(Object bo, JSONObject jo) {
				String mentId = (String) ObjectUtil.getFieldValueByName("dataElementId", bo);
				jo.put("dataElementId", mentId);
				String strLIst = "";
				if (mentId != null && mentId != "") {
					DataElement ment = new DataElement();
					String[] id = mentId.split(",");
					for (String i : id) {
						if (i.length() > 0) {
							ment.setId(Integer.valueOf(i));
							DataElement ment2 = service.findById(ment);
							strLIst += ment2.getChName() + ",";
						}
					}
					if (strLIst != "" && strLIst.length() > 0) {
						strLIst = strLIst.substring(0, strLIst.length() - 1);
						jo.put("dataElementIdForShow", strLIst);
					}
				}
			}

			@Override
			public Object doHandle(Object obj) {
				return obj;
			}
		});

		map.put("isShare", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				if (obj != null && ((Integer) obj).equals(0)) {
					return "共享";
				}
				return "不共享";
			}

			@Override
			public int getMode() {
				return ADD_MODE;
			}

		});
		return map;
	}

	/**
	 * @Title: doAfterInsertUpdate @Description:
	 * TODO(处理插入和修改之后的操作可以写在此方法) @param @param o 设定文件 @return void 返回类型 @throws
	 */
	public void doAfterInsertUpdate(DataElement o, HttpServletRequest req, HttpServletResponse res) {
		if (o.getDataElementId() != null && o.getDataElementId() != "") {
			String[] id = o.getDataElementId().split(",");
			for (String x : id) {
				if (x.length() > 0) {
					DataElement t = new DataElement();
					t.setId(Integer.valueOf(x));
					DataElement ment2 = service.findById(t);
					if (ment2.getDataElementId() != null && ment2.getDataElementId() != "") {
						ment2.setDataElementId(ment2.getDataElementId() + "," + o.getId());
					} else {
						ment2.setDataElementId(o.getId() + "");
					}
					service.update(ment2);
				}
			}
		}
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public String indexURL() {
		return "/system/dataElement/index";
	}

	@Override
	public void doBeforeInsertUpdate(DataElement o, HttpServletRequest req, HttpServletResponse res) {
		o.setClassType(getClassType());
		service.setIdentifier(o);
		// 和父数据元标识符保持一致
		if (o.getFatherId() != null) {
			DataElement fd = new DataElement();
			fd.setId(o.getFatherId());
			fd = service.findById(fd);
			o.setIdentifier(fd.getIdentifier());
		} else {
			service.updateChildIdentifier(o);
		}
		o.setClassType(0);

	}
	
	@RequestMapping(value="getDataElementAjax")
	public String getDataElementAjax(Integer id,DataElement dataElement,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();	
		
		if(id!=null){
			List<DataElement> list=	service.getByCustomizationId(id, dataElement);

			try {
				Page<DataElement> page = new Page<DataElement>();		
				page.setResults(list);
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
		}

		return null;
	}

	@RequestMapping(value = "dmAjax")
	public String dmAjax(InformationRes o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		// System.out.println("---------------------------");

		String inforResId = req.getParameter("inforResId");
		String objType = req.getParameter("objectType");
		Integer objectType = null;
		if (objType != null && objType != "") {
			objectType = Integer.valueOf(objType);
		}
		String chName = req.getParameter("chName");

		List<DataElement> listdm = null;
		JSONObject ar = new JSONObject();
		if (inforResId != null && inforResId != "") {
			listdm = service.getDataElementListByInforResId(Integer.valueOf(inforResId), objectType, chName);
		} else if (o != null && o.getId() != null) {
			listdm = service.getDataElementListByInforResId(o.getId(), objectType, chName);
		} else {
			// listdm=service.getDataElementListByInforResId(null,objectType,chName);
		}
		try {
			Page<DataElement> page = new Page<DataElement>();
			page.setResults(listdm);
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

	@RequestMapping(value = "dmAjax2")
	public String dmAjax2(DataElement o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		String inforResId = req.getParameter("inforResId");
		String objType = req.getParameter("objectType");
//		Integer objectType = null;
//		if (objType != null && objType != "") {
//			objectType = Integer.valueOf(objType);
//		}
		String chName = req.getParameter("chName");
		Page<DataElement> page = new Page<DataElement>();
		if (StringUtils.isNotEmpty(req.getParameter("page"))) {
			page.setPageNum(Integer.valueOf(req.getParameter("page")));
		}
		if (StringUtils.isNotEmpty(req.getParameter("rows"))) {
			page.setPageSize(Integer.valueOf(req.getParameter("rows")));
		}

		String dataManagerStr = req.getParameter("dataManagerId");
		String informationResStr = req.getParameter("informationResId");
		
		//System.out.println("dataManagerStr= "+dataManagerStr);
		//System.out.println("informationResStr= "+informationResStr);
		
		DataElement de=new DataElement();
		if(dataManagerStr!=null && dataManagerStr!=""){
			page =   service.getDataElementListByDataListPage(de,null,Integer.valueOf(dataManagerStr),objType, chName,page);
		}else{
			page =   service.getDataElementListByDataListPage(de,null,null,objType, chName,page);
		}
		//System.out.println("page.getResults() "+page.getResults());
		try {
			ar.put("rows", DataHandlerUtil.buildJson(page.getResults(), getDataHandlers(), true));
			ar.put("total",page.getTotalRecord() );
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
	
	@RequestMapping(value="hmAjax")
	public String hmAjax(InformationResource o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		
		if(o!=null&&o.getId()!=null){
			List<DataElement> listdm=service.getDataElementListByHouseModelId(o.getId());		
			JSONObject ar = new JSONObject();		
			try {
				Page<DataElement> page = new Page<DataElement>();		
				page.setResults(listdm);
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
		}
		return null;
	}
	
	@RequestMapping(value = "getDataElementJson")
	public String getDataElementJson(DataList o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		String informationResId = req.getParameter("informationResId");		
		List<DataList> dmlist = null;
		String dmids="";
		if(informationResId!=null&&informationResId!=""){
			o.setInformationResId(Integer.valueOf(informationResId));
			dmlist=dataListService.find(o);
			//System.out.println("dmlist= "+dmlist);
			for(DataList dm:dmlist){
				dmids=dmids+dm.getId()+",";
			}
		}
		res.getWriter().write(dmids.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
	
	@RequestMapping(value = "getDataElementByInforResId")
	public String getDataElementByInforResIdAjax(Integer inforResId, DataElement dataElement, HttpServletRequest req,
			HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		List<DataElement> list = service.getDataElementListByInforResId2(inforResId, dataElement);
		try {
			Page<DataElement> page = new Page<DataElement>();
			page.setResults(list);
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

	/**
	 * @Title: getDataElementByIRId
	 * @Description: TODO(根据信息资源管理id获取数据元)
	 * @param @param
	 *            o
	 * @param @param
	 *            req
	 * @param @param
	 *            res
	 * @param @return
	 * @param @throws
	 *            Exception 设定文件
	 * @return String 返回类型 2016年12月22日 日期
	 */
	@RequestMapping(value = "getDataElementByIRId")
	public String getDataElementByIRId(DataList o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		List<DataElement> list = null;
		if (o.getDataManagerId() == null && o.getInformationResId() == null) {

		} else {
			list = service.getDataElementListByDataList(o);
		}
		try {
			Page<DataElement> page = new Page<DataElement>();
			page.setResults(list);
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

	// 验证名称重复
	@RequestMapping(value = "validation")
	public String validation(DataElement o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		
		if (!service.volidate(o)) {
			ar.put("results", 1);
			//ar.put("egName", "");
		}else{
			String pinyin = ChineseTo.getPinYinHeadChar(o.getChName());
			String egname = pinyin.toUpperCase();
			ar.put("results", 0);
			ar.put("egName", egname);
		}

		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	public int getClassType() {
		return 0;
	}

	@RequestMapping("importDataElement")
	@ResponseBody
	public AjaxRes importDataElement(@RequestParam(value = "file", required = false) MultipartFile file, Model model,
			HttpServletRequest request) {
		long time=System.currentTimeMillis();
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
			DataElementAdapter adapter = new DataElementAdapter(getClassType());
			ExcelUtil excelUtil = new ExcelUtil(adapter);
			excelUtil.excelToList(targetFile.getAbsolutePath(),0);
			if (adapter.isError()) {
				ar.setRes(Const.FAIL);
			} else {
				try {
					
					int classType=1;
					if (t.equals("1")) {
						classType=0;
					}
					System.out.println(System.currentTimeMillis()-time);
					
					service.insertList(adapter.getEntityList(), classType);
					
					ar.setRes(Const.SUCCEED);
				} catch (Exception e) {
					ar.setRes(Const.FAIL);
					e.printStackTrace();
				}
			}
			System.out.println(System.currentTimeMillis()-time);
			ar.setResMsg(adapter.getErrorMsg().toString());
		} catch (Exception e) {
			e.printStackTrace();
			ar.setFailMsg(Const.DATA_FAIL);
		}

		return ar;
	}

	@RequestMapping(value = "echarts")
	public void echarts(DataElement o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject echartjson = new JSONObject();
		JSONArray unitArray = new JSONArray();
		List<DataElement> echartOrigin = service.echarts(o);
		JSONArray nameArray = new JSONArray();
		if (echartOrigin.size() > 0) {
			JSONObject unitJson = new JSONObject();
			for (DataElement d : echartOrigin) {
				Integer counts = d.getCounts();
				String objectTypeId = d.getValue5();
				if(!objectTypeId.equals("null")){
				GovmadeDic dic = new GovmadeDic();
				dic.setDicNum("OBJECTTYPE");
				dic.setDicKey(objectTypeId);
				List<GovmadeDic> l = govmadeDicservice.getDicList(dic);
				if (l != null && l.size() > 0) {
					String objectType = l.get(0).getDicValue();
					unitJson.put("name", objectType);
					nameArray.add(objectType);
				}
				unitJson.put("value", counts);
				unitArray.add(unitJson);
				}
			}
		}
		echartjson.put("legend", nameArray);
		echartjson.put("data", unitArray);
		res.getWriter().write(echartjson.toString());
		res.getWriter().flush();
		res.getWriter().close();
	}

	/*** 
	* @Description: 关联分析
	* @author Dearest
	* @date 2017年2月7日上午9:45:09
	*/

	@RequestMapping(value="analyse")
	public void analyse(DataElement o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject echartjson = new JSONObject();
		JSONArray nodeArray = new JSONArray();
		JSONArray linkArray = new JSONArray();
		String sname = service.find(o).get(0).getChName();
		String inforIds = service.findInforx(o);
		if(inforIds!=null){
			String[] inforIdsArray = inforIds.split(",");
			int arrLength = inforIdsArray.length;
			if(arrLength>0){
				JSONObject unitjson = new JSONObject();
				JSONObject linkjson = new JSONObject();
				unitjson.put("category", 0);
				unitjson.put("name", sname);
				unitjson.put("value", 10);
				nodeArray.add(unitjson);
				for(String inforId : inforIdsArray){
					Random random = new Random();
					int s = random.nextInt(6)%(6-2+1) + 2; 
					InformationResource infor = new InformationResource();
					infor.setId(Integer.valueOf(inforId));
					List<InformationResource> inforList = informationResourceService.find(infor);
					if(inforList.size()>0){
						unitjson.put("name", inforList.get(0).getValue1());
						unitjson.put("category", 1);
						unitjson.put("value", s);
						nodeArray.add(unitjson);
						linkjson.put("source", inforList.get(0).getValue1());	
						linkjson.put("target", sname);
						linkjson.put("weight", s);
						linkjson.put("name", "引用");
						linkArray.add(linkjson);
						Company c=new Company();
						c.setId(Integer.valueOf(inforList.get(0).getValue3()));
						c=companyService.findById(c);
						unitjson.put("name", c.getCompanyName());
						unitjson.put("category", 2);
						unitjson.put("value", s);
						nodeArray.add(unitjson);
						linkjson.put("source", c.getCompanyName());	
						linkjson.put("target", inforList.get(0).getValue1());
						linkjson.put("weight", s);
						linkjson.put("name", "引用");
						linkArray.add(linkjson);
					}					
				}			
			}
		}	
		echartjson.put("node", nodeArray);
		echartjson.put("link", linkArray);
		res.getWriter().write(echartjson.toString());
		res.getWriter().flush();
		res.getWriter().close();
	}


	
	@RequestMapping(value = "detail")
	public String detail(DataElement o, HttpServletRequest req, HttpServletResponse res, Model m) throws Exception {

		if (o instanceof IdBaseEntity && StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
			int id = Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow")));
			((IdBaseEntity) o).setId(id);
		}
		o = service.findById(o);
		m.addAttribute("dataElement", o);
		if (o.getFatherId() != null) {
			DataElement d = new DataElement();
			d.setId(o.getFatherId());
			m.addAttribute("father", service.findById(d));
		} else {
			DataElement d = new DataElement();
			d.setFatherId(o.getId());
			m.addAttribute("childList", service.find(d));
		}
		if(o.getClassType()!=null&&o.getClassType().intValue()==1){
			
			GovTableField f=new GovTableField();
			f.setDataElementId(o.getId());
			m.addAttribute("fieldList",govTableFieldService.find(f));
		}
		return "/system/rdata/detail";
	}

	/**
	 * @Title: addChild
	 * @Description: TODO(数据元添加子数据元)
	 * @param @param
	 *            o
	 * @param @param
	 *            req
	 * @param @param
	 *            res
	 * @param @param
	 *            m
	 * @param @return
	 * @param @throws
	 *            Exception 设定文件
	 * @return String 返回类型 2017年2月4日 日期
	 */
	@RequestMapping(value = "addChild")
	public String addChild(DataElement o, HttpServletRequest req, HttpServletResponse res, Model m) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		if (o instanceof IdBaseEntity && StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
			int id = Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow")));
			((IdBaseEntity) o).setId(id);
		}
		JSONObject ar = new JSONObject();
		try {
			DataElement dataElement = new DataElement();
			dataElement.setId(o.getId());
			dataElement = service.findById(dataElement);
			dataElement.setFatherId(dataElement.getId());
			dataElement.setId(null);
			dataElement.setValue1(o.getValue1());
			dataElement.setValue2(o.getValue2());
			dataElement.setValue3(o.getValue3());
			service.insert(dataElement);
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
	
	@RequestMapping(value = "setChild")
	public String setChild(DataElement o, HttpServletRequest req, HttpServletResponse res, Model m) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		if (o instanceof IdBaseEntity && StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
			int id = Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow")));
			((IdBaseEntity) o).setId(id);
		}
		JSONObject ar = new JSONObject();
		try {
			DataElement dataElement = new DataElement();
			dataElement.setId(o.getId());
			dataElement = service.findById(dataElement);
			String ids=req.getParameter("ids");
			service.setChild(dataElement, ids);
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

	@Override
	public void doBeforeListAjax(DataElement o, HttpServletRequest req, HttpServletResponse res) {
		o.setClassType(getClassType());
		if(StringUtils.isEmpty(req.getParameter("sourceType"))){
			o.setSourceType(99);
		}
	}

	// 显示无父级和子集的数据元
	@RequestMapping(value = "listSingle")
	public String listSingle(DataElement o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		doBeforeListAjax(o, req, res);
		JSONObject ar = new JSONObject();
		try {
			Page<DataElement> page = new Page<DataElement>();
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
	
	
	// 清空表
		@RequestMapping(value = "cleanTable")
		public String cleanTable(HttpServletRequest req, HttpServletResponse res) throws Exception {
			res.setContentType("text/html;charset=utf-8");
			res.setCharacterEncoding("utf-8");
			JSONObject ar = new JSONObject();
			try {
				DataElement d=new DataElement();
				d.setClassType(getClassType());
				service.cleanTable(d);
				if(d.getClassType()==1){
					service.clearAllImported();
				}
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
		
	@RequestMapping(value = "insertAjax", method = RequestMethod.POST)
	public String insertAjax(DataElement o,HttpServletRequest req, HttpServletResponse res) throws Exception {
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
			ar.put("show", DataHandlerUtil.buildJson(service.findByName(o), getDataHandlers(), true).toString());
		} catch (Exception e) {
			ar.put("msg", Const.SAVE_FAIL);
			ar.put("code", Const.FAIL);
			ar.put("show", 0);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
		
}
