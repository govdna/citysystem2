package com.govmade.controller.system.server;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
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

import com.govmade.adapter.ServerAdapter;
import com.govmade.adapter.object2excel.Server2ExcelAdapter;
import com.govmade.common.ajax.AjaxRes;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.poi.ExcelUtil;
import com.govmade.common.utils.poi.Object2ExcelUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
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
import com.govmade.service.system.computer.GovComputerRoomService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.organization.GroupsService;
import com.govmade.service.system.server.GovServerService;
import com.govmade.service.system.simpleFields.SimpleFieldsService;

@Controller
@RequestMapping("/backstage/govServer/")
public class GovServerController extends GovmadeBaseController<GovServer>{

	@Autowired
	private GovServerService service;
	@Autowired
	private CompanyService companyservice;
	@Autowired
	private GovmadeDicService govmadeDicservice;
	@Autowired
	private GovComputerRoomService govComputerRoomService;
	@Autowired
	private GroupsService groupsService;
	@Autowired
	private SimpleFieldsService simpleFieldsService;
	
	@Override
	public String indexURL() {
		return "/system/govServer/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map= super.getDataHandlers();
		map=DataHandlerUtil.buildSimpleFieldsDataHandlers(map, GovServer.class);
		// 资源类型
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
				map.put("serverType", new DataHandler() {

					@Override
					public Object doHandle(Object obj) {
						GovmadeDic dic=new GovmadeDic();
						dic.setFatherId(227);
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
				map.put("belongCproomId", new DataHandler() {

					@Override
					public int getMode() {
						return ADD_MODE;
					}

					@Override
					public Object doHandle(Object obj) {
						GovComputerRoom computer = new GovComputerRoom();
						computer.setId((Integer)obj);	
						List<GovComputerRoom> l = govComputerRoomService.find(computer);		
						if(l!=null&&l.size()>0){
							return l.get(0).getCproomNum();
						}
						return "";
					}
				});	
				
				map.put("operatingSystem", new DataHandler() {

					@Override
					public Object doHandle(Object obj) {
						GovmadeDic dic=new GovmadeDic();
						dic.setFatherId(229);
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
	@RequestMapping("relation")
	public String relation() {
		return "/system/govServer/relation";
	}
	@Override
	public void doBeforeListAjax(GovServer o, HttpServletRequest req, HttpServletResponse res) {
		List<Scope> sc=ServiceUtil.getScopesByRoleId("/backstage/govServer/index");
		for(Scope s:sc){
			if(s.getValue().equals("1")){
				o.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
			}
		}
	}
	
	private Map<String, DataHandler> getExcelHandler() {
		Map<String, DataHandler> map = new HashMap<String, DataHandler>();
		SimpleFields sfs = new SimpleFields();
		sfs.setIsDeleted(0);
		sfs.setClassName("GovServer");
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
	public ResponseEntity<byte[]> downloadData(GovServer de,String[] xlsFields, HttpServletRequest req, HttpServletResponse response)
			throws Exception {
		de.setIsDeleted(0);
		Server2ExcelAdapter adapter = new Server2ExcelAdapter(service.find(de), xlsFields,
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
	
	@RequestMapping("import")
	@ResponseBody
	public AjaxRes importServer(@RequestParam(value = "file", required = false) MultipartFile file, Model model,HttpServletRequest request) {
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
			ServerAdapter adapter = new ServerAdapter();
			ExcelUtil excelUtil = new ExcelUtil(adapter);
			excelUtil.excelToList(targetFile.getAbsolutePath(),0);
			if (adapter.isError()) {
				ar.setRes(Const.FAIL);
			} else {
				try {
					for (GovServer dm : adapter.getEntityList()) {
						service.insert(dm);
					}
					ar.setRes(Const.SUCCEED);
				} catch (Exception e) {
					ar.setRes(Const.FAIL);
					e.printStackTrace();
				}
			}
			ar.setResMsg(adapter.getErrorMsg().toString());
		} catch (Exception e) {
			e.printStackTrace();
			ar.setFailMsg(Const.DATA_FAIL);
		}
		return ar;
	}

	
}
