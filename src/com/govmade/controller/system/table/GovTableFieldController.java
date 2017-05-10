package com.govmade.controller.system.table;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.organization.Groups;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.organization.GroupsService;
import com.govmade.service.system.table.GovTableFieldService;
import com.govmade.service.system.table.GovTableService;

import net.sf.json.JSONObject;

@Controller
@RequestMapping("/backstage/govTableField/")
public class GovTableFieldController extends GovmadeBaseController<GovTableField> {

	@Autowired
	private GovTableFieldService service;
	@Autowired
	private CompanyService companyservice;
	@Autowired
	private GroupsService groupsService;

	@Override
	public String indexURL() {
		return "/system/govTableField/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map = super.getDataHandlers();
		map = DataHandlerUtil.buildSimpleFieldsDataHandlers(map, GovTable.class);
		// 所属表
		map.put("value3", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {

				return "";
			}

			@Override
			public void doHandle(Object bo, JSONObject jo) {
				
				String value3 = (String) ObjectUtil.getFieldValueByName("value3", bo);
				if(StringUtils.isEmpty(value3)){
					return;
				}
				List<GovTable> ls = ServiceUtil.getService("GovTableService")
						.find(ServiceUtil.buildBean("GovTable@isDeleted=0&id=" + value3));
				jo.put("value3", value3);
				if (ls != null && ls.size() > 0) {
					jo.put("value3ForShow", ls.get(0).getValue1());
					jo.put("tableName", ls.get(0).getValue2());
					jo.put("database13", ls.get(0).getValue3());
				}
			}

			@Override
			public int getMode() {
				return FREEDOM_MODE;
			}
		});
		// 关联字段
		map.put("value4", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {

				return "";
			}

			@Override
			public void doHandle(Object bo, JSONObject jo) {
				String value4 = (String) ObjectUtil.getFieldValueByName("value4", bo);
				if(StringUtils.isEmpty(value4)){
					return;
				}
				List<GovTableField> ls=ServiceUtil.getService("GovTableFieldService").find(ServiceUtil.buildBean("GovTableField@isDeleted=0&id="+value4));
				jo.put("value4", value4);
				if (ls != null && ls.size() > 0) {
					jo.put("value4ForShow", ls.get(0).getValue1());
					jo.put("table14", ls.get(0).getValue3());
					List<GovTable> dbs = ServiceUtil.getService("GovTableService")
							.find(ServiceUtil.buildBean("GovTable@isDeleted=0&id=" + ls.get(0).getValue3()));
					if (dbs != null && dbs.size() > 0) {
						jo.put("database14", dbs.get(0).getValue3());
					}
				}
			}

			@Override
			public int getMode() {
				return FREEDOM_MODE;
			}
		});
		// 资源类型
		map.put("companyId", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				Company company = new Company();
				company.setId((Integer) obj);
				List<Company> comlist = companyservice.find(company);
				if (comlist != null && comlist.size() > 0) {
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
				Groups group = new Groups();
				group.setId((Integer) obj);
				List<Groups> comlist = groupsService.find(group);
				if (comlist != null && comlist.size() > 0) {
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
	public void doBeforeListAjax(GovTableField o, HttpServletRequest req, HttpServletResponse res) {
		List<Scope> sc = ServiceUtil.getScopesByRoleId("/backstage/govTable/index");
		for (Scope s : sc) {
			if (s.getValue().equals("1")) {
				o.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
			}
		}
	}

}
