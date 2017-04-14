package com.govmade.controller.system.database;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.database.GovDatabase;
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
	
}
