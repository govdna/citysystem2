package com.govmade.controller.system.database;

import java.io.File;
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
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.adapter.object2excel.GovDatabase2ExcelAdapter;
import com.govmade.adapter.object2excel.InformationResource2ExcelAdapter;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.Object2ExcelComplexUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.organization.Groups;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.database.GovDatabaseService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.organization.GroupsService;
import com.govmade.service.system.table.GovTableFieldService;
import com.govmade.service.system.table.GovTableService;

@Controller
@RequestMapping("/backstage/govDatabase/")
public class GovDatabaseController extends GovmadeBaseController<GovDatabase>{

	@Autowired
	private GovDatabaseService service;
	@Autowired
	private CompanyService companyservice;
	@Autowired
	private GroupsService groupsService;
	@Autowired
	private GovTableService govTableService;
	@Autowired
	private GovTableFieldService govTableFieldService;
	@Override
	public String indexURL() {
		return "/system/govDatabase/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map= super.getDataHandlers();
		map=DataHandlerUtil.buildSimpleFieldsDataHandlers(map, GovDatabase.class);
		// 资源类型
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
	public void doBeforeListAjax(GovDatabase o, HttpServletRequest req, HttpServletResponse res) {
		List<Scope> sc=ServiceUtil.getScopesByRoleId("/backstage/govDatabase/index");
		for(Scope s:sc){
			if(s.getValue().equals("1")){
				o.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
			}
		}
	}

	@Override
	public void doWithDelete(GovDatabase o, HttpServletRequest req, HttpServletResponse res) {
		GovTable table=new GovTable();
		table.setValue3(o.getId() + "");
		List<GovTable> tblist = govTableService.find(table);
		for(GovTable t:tblist){
			// 关联删除表下面的字段
			GovTableField gtf = new GovTableField();
			gtf.setValue3(t.getId() + "");
			List<GovTableField> list = govTableFieldService.find(gtf);
			if(list!=null&&list.size()>0){
				govTableFieldService.deleteBatch(list);
			}
		}
		//删除关联表
		if(tblist!=null&&tblist.size()>0){
			govTableService.deleteBatch(tblist);
		}
		
	}
	
	
	@RequestMapping("downloadData")
	public ResponseEntity<byte[]> downloadData(GovDatabase db,String[] dbFields, String[] tbFields, String[] fdFields, HttpServletRequest req,
			HttpServletResponse response) throws Exception {
		if (dbFields == null) {
			dbFields = new String[0];
		}
		if (tbFields == null) {
			tbFields = new String[0];
		}
		if (fdFields == null) {
			fdFields = new String[0];
		}
		List<GovDatabase> dbList=service.find(db);
		List<GovTable> tbList=null;
		List<GovTableField> tfList=null;
		if(dbList!=null&&dbList.size()>0){
			tbList=govTableService.findByGovDatabase(dbList);
		}
		if(tbList!=null&&tbList.size()>0){
			tfList=govTableFieldService.findByGovTable(tbList);
		}
		
		GovDatabase2ExcelAdapter adapter = new GovDatabase2ExcelAdapter(dbList, tbList, tfList, dbFields, tbFields, fdFields);
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
