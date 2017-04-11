package com.govmade.controller.system.application;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.adapter.object2excel.Application2ExcelAdapter;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.poi.Object2ExcelUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.entity.system.customFields.SimpleFields;
import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.memorizer.GovMemorizer;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.organization.Groups;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.entity.system.server.GovServer;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.application.GovApplicationSystemService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.memorizer.GovMemorizerService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.organization.GroupsService;
import com.govmade.service.system.server.GovServerService;
import com.govmade.service.system.simpleFields.SimpleFieldsService;

@Controller
@RequestMapping("/backstage/govApplicationSystem/")
public class GovApplicationSystemController extends GovmadeBaseController<GovApplicationSystem>{

	@Autowired
	private GovApplicationSystemService service;
	@Autowired
	private CompanyService companyservice;
	@Autowired
	private GovmadeDicService govmadeDicservice;
	@Autowired
	private GovServerService govServerService;
	@Autowired
	private GovMemorizerService govMemorizerService;
	@Autowired
	private GroupsService groupsService;
	@Autowired
	private SimpleFieldsService simpleFieldsService;
	
	@Override
	public String indexURL() {
		return "/system/govApplicationSystem/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map= super.getDataHandlers();
		map=DataHandlerUtil.buildSimpleFieldsDataHandlers(map, GovApplicationSystem.class);
		// 资源类型
				
				map.put("value5", new DataHandler() {

					@Override
					public int getMode() {
						return ADD_MODE;
					}

					@Override
					public Object doHandle(Object obj) {
						GovServer serv = new GovServer();
						serv.setId(Integer.valueOf((String)obj));	
						List<GovServer> l = govServerService.find(serv);		
						if(l!=null&&l.size()>0){
							return l.get(0).getValue1();
						}
						return "";
					}
				});	
				
				map.put("value6", new DataHandler() {

					@Override
					public int getMode() {
						return ADD_MODE;
					}

					@Override
					public Object doHandle(Object obj) {
						GovMemorizer mem = new GovMemorizer();
						mem.setId(Integer.valueOf((String)obj));	
						List<GovMemorizer> l = govMemorizerService.find(mem);		
						if(l!=null&&l.size()>0){
							return l.get(0).getValue1();
						}
						return "";
					}
				});	
				
				map.put("network", new DataHandler() {

					@Override
					public Object doHandle(Object obj) {
						GovmadeDic dic=new GovmadeDic();
						dic.setFatherId(242);
						dic.setDicKey((Integer)obj+"");			
						List<GovmadeDic> l=govmadeDicservice.find(dic);		
						if(l!=null&&l.size()>0){
							return l.get(0).getDicValue();
						}
						return "";
					}

					@Override
					public int getMode() {
						return ADD_MODE;
					}
				});	
				map.put("serverBrand", new DataHandler() {

					@Override
					public Object doHandle(Object obj) {
						GovmadeDic dic=new GovmadeDic();
						dic.setFatherId(225);
						dic.setDicKey((Integer)obj+"");			
						List<GovmadeDic> l=govmadeDicservice.find(dic);		
						if(l!=null&&l.size()>0){
							return l.get(0).getDicValue();
						}
						return "";
					}

					@Override
					public int getMode() {
						return ADD_MODE;
					}
				});	
				map.put("memorizerBrand", new DataHandler() {

					@Override
					public Object doHandle(Object obj) {
						GovmadeDic dic=new GovmadeDic();
						dic.setFatherId(219);
						dic.setDicKey((Integer)obj+"");			
						List<GovmadeDic> l=govmadeDicservice.find(dic);		
						if(l!=null&&l.size()>0){
							return l.get(0).getDicValue();
						}
						return "";
					}

					@Override
					public int getMode() {
						return ADD_MODE;
					}
				});	
				map.put("companyId", new DataHandler() {

					@Override
					public Object doHandle(Object obj) {
						Company company=new Company();
						company.setId((Integer)obj);
						List<Company> comlist=companyservice.find(company);		
						if(comlist!=null&&comlist.size()>0){
							return comlist.get(0).getCompanyName();
						}
						return "";
					}

					@Override
					public int getMode() {
						return ADD_MODE;
					}
				});
				
				map.put("groupId", new DataHandler() {

					@Override
					public Object doHandle(Object obj) {
						Groups group=new Groups();
						group.setId((Integer)obj);
						List<Groups> comlist=groupsService.find(group);		
						if(comlist!=null&&comlist.size()>0){
							return comlist.get(0).getName();
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
	public void doBeforeListAjax(GovApplicationSystem o, HttpServletRequest req, HttpServletResponse res) {
		List<Scope> sc=ServiceUtil.getScopesByRoleId("/backstage/govApplicationSystem/index");
		for(Scope s:sc){
			if(s.getValue().equals("1")){
				o.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
			}
		}
	}
	
	@RequestMapping(value="relation")
	public String relation() {
		return "/system/govApplicationSystem/relation";
	}
	//验证名称重复
	@RequestMapping(value="validation")
	public String validation(GovApplicationSystem o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");		
		GovApplicationSystem gov=new GovApplicationSystem();
		String appname=o.getValue2();
		gov.setValue2(appname);
		String results = "";
		if (o.getId() == null) {
			if (!service.find(gov).isEmpty()&&StringUtils.isNotEmpty(o.getValue2())) {
				results = "1";
			}
	} else {

			if(service.find(gov).size()!=0&&StringUtils.isNotEmpty(o.getValue2())){
				if ((int) service.find(gov).get(0).getId() != (int) o.getId()) {
					results = "1";
				}
     	}
	}
		if(results==""){
			results = "0";
		}
		
		String str="{\"results\":["+ results +"]}";
		res.getWriter().write(str);
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}	
	
	private Map<String, DataHandler> getExcelHandler() {
		Map<String, DataHandler> map = new HashMap<String, DataHandler>();
		SimpleFields sfs = new SimpleFields();
		sfs.setIsDeleted(0);
		sfs.setClassName("GovApplicationSystem");
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
	
	@RequestMapping("downloadData")
	public ResponseEntity<byte[]> downloadData(String[] xlsFields, HttpServletRequest req, HttpServletResponse response)
			throws Exception {
		GovApplicationSystem de = new GovApplicationSystem();
		de.setIsDeleted(0);
		Application2ExcelAdapter adapter = new Application2ExcelAdapter(service.find(de), xlsFields,
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
	
	@RequestMapping(value = "deleteRelationAjax")
	public String deleteRelationAjax(GovApplicationSystem o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		service.deleteRelation(o);			
		ar.put("code", Const.SUCCEED);
		ar.put("msg", Const.DEL_SUCCEED);		
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
	
}
