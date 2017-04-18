package com.govmade.controller.system.table;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.govmade.adapter.DBExcelAdapter;
import com.govmade.adapter.DBSExcelAdapter;
import com.govmade.common.ajax.AjaxRes;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.poi.ExcelUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.organization.Groups;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.entity.system.server.GovServer;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.data.DataListService;
import com.govmade.service.system.database.GovDatabaseService;
import com.govmade.service.system.information.InformationResourceService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.organization.GroupsService;
import com.govmade.service.system.table.GovTableFieldService;
import com.govmade.service.system.table.GovTableService;

import net.sf.json.JSONObject;

/**
 * @author (作者) Dong Jie 154046519@qq.com
 * @Description: CitySystem_Oracle 数据表
 * @date 2017年3月14日 上午9:49:07
 * @company (开发公司) 国脉海洋信息发展有限公司
 * @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
 * @since (该版本支持的JDK版本) 1.7
 * @Title: GovTableController.java
 * @Package com.govmade.controller.system.table
 * @version V1.0
 */
@Controller
@RequestMapping("/backstage/govTable/")
public class GovTableController extends GovmadeBaseController<GovTable> {

	@Autowired
	private GovTableService service;
	@Autowired
	private CompanyService companyservice;
	@Autowired
	private GroupsService groupsService;
	@Autowired
	private DataElementService dataElementService;
	@Autowired
	private GovTableFieldService govTableFieldService;
	@Autowired
	private InformationResourceService informationResourceService;
	@Autowired
	private DataListService dataListService;
	@Autowired
	private GovDatabaseService govDatabaseService;

	@Override
	public String indexURL() {
		return "/system/govTable/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map = super.getDataHandlers();
		map = DataHandlerUtil.buildSimpleFieldsDataHandlers(map, GovTable.class);
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
	public void doBeforeListAjax(GovTable o, HttpServletRequest req, HttpServletResponse res) {
		List<Scope> sc = ServiceUtil.getScopesByRoleId("/backstage/govTable/index");
		for (Scope s : sc) {
			if (s.getValue().equals("1")) {
				o.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
			}
		}
	}

	@RequestMapping("importTable")
	@ResponseBody
	public AjaxRes importTable(@RequestParam(value = "file", required = false) MultipartFile file, Model model,
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
			DBExcelAdapter adapter = new DBExcelAdapter();
			ExcelUtil excelUtil = new ExcelUtil(adapter);
			excelUtil.excelToList(targetFile.getAbsolutePath(), 0);

			if (adapter.isError()) {
				ar.setRes(Const.FAIL);
			} else {
				try {
					GovTable t = adapter.getTable();
					t.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
					t.setGroupId(AccountShiroUtil.getCurrentUser().getGroupId());
					service.insert(t);
					if (adapter.getEntityList() != null) {
						for (GovTableField tf : adapter.getEntityList()) {
							tf.setValue3(t.getId() + "");
							tf.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
							tf.setGroupId(AccountShiroUtil.getCurrentUser().getGroupId());
							DataElement de = new DataElement();
							de.setClassType(1);
							de.setChName(tf.getValue2());
							DataElement fd = dataElementService.getDataElementByChName(de);
							if (fd != null) {
								tf.setDataElementId(fd.getId());
							} else {
								de.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
								de.setGroupId(AccountShiroUtil.getCurrentUser().getGroupId());
								dataElementService.insert(de);
								tf.setDataElementId(de.getId());
							}
							govTableFieldService.insert(tf);
						}
						ar.setRes(Const.SUCCEED);
					}
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

	@RequestMapping("importDB")
	@ResponseBody
	public AjaxRes importDB(@RequestParam(value = "file", required = false) MultipartFile file, Model model,
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
			DBSExcelAdapter adapter = new DBSExcelAdapter();
			ExcelUtil excelUtil = new ExcelUtil(adapter);
			excelUtil.excelToList(targetFile.getAbsolutePath(), 0);
			if (adapter.isError()) {
				ar.setRes(Const.FAIL);
			} else {
				try {
					Map<String, GovTable> tableMap = adapter.getTableMap();

					// 批量插入数据库
					
					Map<String,GovDatabase> dataBaseMap=adapter.getDatabaseMap();
					List<GovDatabase> dbList = new ArrayList<GovDatabase>();
					
					for (String dbName : dataBaseMap.keySet()) {
						GovDatabase db =dataBaseMap.get(dbName);
						//System.out.println("db cid"+db.getCompanyId());
						dbList.add(db);
					}
					govDatabaseService.insertList(dbList);
					// 批量插入数据库结束
					Map<String, Integer> dbMap = new HashMap<String, Integer>();
					for (GovDatabase db : dbList) {
						dbMap.put(db.getValue1(), db.getId());
					}
					//批量插入表
					List<GovTable> tbList = new ArrayList<GovTable>();
					for (String tableName : tableMap.keySet()) {
						GovTable tb = tableMap.get(tableName);
						tb.setValue3(dbMap.get(tb.getValue3()) + "");
						//System.out.println("tb cid"+tb.getCompanyId());
						tbList.add(tb);
					}
					service.insertList(tbList);
					//插入字段
					
					List<GovmadeDic> dicList=ServiceUtil.getDicByDicNum("TABLETODATATYPE");
					for(GovmadeDic dic:dicList){
						dic.setDicKey("/"+dic.getDicKey().trim().toUpperCase()+"/");
					}
					List<GovmadeDic> dtList=ServiceUtil.getDicByDicNum("DATATYPE");
					Map<String,String> dtMap=new HashMap<String,String>();
					for(GovmadeDic d:dtList){
						dtMap.put(d.getDicValue(), d.getDicKey());
					}
					List<GovTableField> tfList = new ArrayList<GovTableField>();
					for (GovTable tb : tbList) {
						for (GovTableField tf : tb.getFieldList()) {
							tf.setValue3(tb.getId() + "");
							//System.out.println("fd cid"+tf.getCompanyId());
							tfList.add(tf);
							
						}
					}
					govTableFieldService.insertList(tfList);
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

	@Override
	public void doWithDelete(GovTable o, HttpServletRequest req, HttpServletResponse res) {
		// 关联删除表下面的字段
		GovTableField gtf = new GovTableField();
		gtf.setValue3(o.getId() + "");
		List<GovTableField> list = govTableFieldService.find(gtf);
		if(list!=null&&list.size()>0){
			govTableFieldService.deleteBatch(list);
		}
	}

	@RequestMapping(value = "createSql")
	public String createSql(GovTable g, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();	
		
		GovTable o=new GovTable();
		o.setId(g.getId());
		o=service.findById(o);
		
		//表
		String tables=o.getValue1();
		
//		//库
//		GovDatabase gdb=new GovDatabase();
//		gdb.setId(Integer.valueOf(o.getValue3()));;
//		String database=govDatabaseService.findById(gdb).getValue1();
		
		//字段
		GovTableField gtf = new GovTableField();
		gtf.setValue3(o.getId()+"");
		List<GovTableField> list = govTableFieldService.find(gtf);
		
		
		String oracle="CREATE TABLE \""+tables+"\" ( \n"+
		"  \"ID\" NUMBER(12) NOT NULL , \n";

		String oracleFields="";
		for(GovTableField t:list){
			oracleFields=oracleFields+"  \""+t.getValue1()+"\" "+t.getValue5();
			if(t.getValue6()!=null&&t.getValue6()!=""){
				oracleFields=oracleFields+"("+t.getValue6()+" BYTE)";
			}
			oracleFields=oracleFields+" DEFAULT NULL NULL , \n";
		}

		oracleFields=oracleFields+
		"  \"TIME_CREATE\" DATE DEFAULT NULL  NULL , \n"+
		"  \"TIME_MODIFIED\" DATE DEFAULT NULL  NULL , \n"+
		"  \"ISDELETED\" VARCHAR2(2 BYTE) DEFAULT NULL NULL , \n"+
		"  PRIMARY KEY (\"ID\") \n"+		//主键
		"); \n";
		
		String notes="";
		for(GovTableField t:list){
			notes=notes+"COMMENT ON COLUMN \""+tables+"\".\""+t.getValue1()+"\" IS '"+t.getValue2()+"'; \n";
		}

		oracle=oracle+oracleFields+notes;
		
		///
		String mySql="DROP TABLE IF EXISTS `"+tables+"`; \nCREATE TABLE `"+tables+"` ( \n"+
		"`id` int(12) NOT NULL AUTO_INCREMENT COMMENT 'Id' , \n";
		
		String mySqlFields="";
		for(GovTableField t:list){
			mySqlFields=mySqlFields+"`"+t.getValue1()+"` "+t.getValue5();
			if(t.getValue6()!=null&&t.getValue6()!=""){
				mySqlFields=mySqlFields+"("+t.getValue6()+")";
			}
			mySqlFields=mySqlFields+" DEFAULT NULL COMMENT '"+t.getValue2()+"', \n";			
		}
		mySqlFields=mySqlFields+"`time_create` datetime DEFAULT NULL, \n"+
				"`time_modified` datetime DEFAULT NULL, \n"+
				"`isDeleted` varchar(2) DEFAULT NULL, \n"+
		" PRIMARY KEY (`id`) \n"+
		"); ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;";
		
		mySql=mySql+mySqlFields;
		//System.out.println("-------------");
		//System.out.println(mySql);
		
		ar.put("oracle", oracle);
		ar.put("mySql", mySql);
		ar.put("tables", tables);
		
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		
		String path = req.getSession().getServletContext().getRealPath("upload/excel");
		String oraclefile = "oracle-"+tables+".sql";
		String oraclefullPath = path + "/" +  oraclefile;
		String mySqlfile = "mySql-"+tables+".sql";
		String mySqlfullPath = path + "/" +  mySqlfile;
		
		FileOutputStream ff1=null;
		File f1=new File(oraclefullPath);  
		ff1=new FileOutputStream(f1);
		byte[] b=oracle.getBytes("UTF-8");
		
		FileOutputStream ff2=null;
		File f2=new File(mySqlfullPath);  
		ff2=new FileOutputStream(f2);
		byte[] b2=mySql.getBytes("UTF-8");

		ff1.write(b);
		ff2.write(b2);
		ff1.close();				
		ff2.close();
		
		return null;
	}

	
	@RequestMapping(value = "updateFields")
	public void updateFields(GovServer gs,GovTableField gf, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		String inforId = gs.getValue2();
		String tbId = gs.getValue1();
		DataList dl = new DataList();
		dl.setDataManagerId(Integer.valueOf(inforId));
		dataListService.deleteByDataManagerId(dl);
		gf.setValue3(tbId);
		List<GovTableField> fiList = govTableFieldService.find(gf);
		for(GovTableField field : fiList){
			DataElement de = new DataElement();
			String fName = field.getValue2();
			de.setChName(fName);
			List<DataElement> deList = dataElementService.find(de);
			if(deList.size()>0){
				dl.setDataElementId(deList.get(0).getId());
			}else{
				de.setClassType(1);
				de.setChName(field.getValue2());
				de.setSourceType(4);
				dataElementService.setIdentifier(de);
				de.setValue2(field.getValue1());
				de.setValue7(field.getValue6());
				de.setValue8(""+field.getCompanyId());
				de.setCompanyId(field.getCompanyId());
				de.setGroupId(field.getGroupId());
				dataElementService.insert(de);
				field.setDataElementId(de.getId());
				govTableFieldService.update(field);
				dl.setDataElementId(de.getId());
			}
			dataListService.insert(dl);
		}
		JSONObject echartjson = new JSONObject();
		echartjson.put("status", 0);
		res.getWriter().write(echartjson.toString());
		res.getWriter().flush();
		res.getWriter().close();
	}
	@RequestMapping(value = "fields2DataElement")
	public String fields2DataElement(String id, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();	
		
		if(StringUtils.isNotEmpty(id)){
			String [] ids=id.split(",");
			List<GovmadeDic> dicList=ServiceUtil.getDicByDicNum("TABLETODATATYPE");
			for(GovmadeDic dic:dicList){
				dic.setDicKey("/"+dic.getDicKey().trim().toUpperCase()+"/");
			}
			List<GovmadeDic> dtList=ServiceUtil.getDicByDicNum("DATATYPE");
			Map<String,String> dtMap=new HashMap<String,String>();
			for(GovmadeDic d:dtList){
				dtMap.put(d.getDicValue(), d.getDicKey());
			}
			
			for(String idStr:ids){
				if(StringUtils.isNotEmpty(idStr)&&StringUtils.isNumeric(idStr)){
					int dId=Integer.valueOf(idStr);
					GovTableField field=new GovTableField();
					field.setId(dId);
					field=govTableFieldService.findById(field);
					DataElement de = new DataElement();
					de.setClassType(1);
					de.setChName(field.getValue2());
					de.setSourceType(4);
					dataElementService.setIdentifier(de);
					if(StringUtils.isNotEmpty(field.getValue5())){
						for(GovmadeDic dic:dicList){
							if(dic.getDicKey().contains("/"+field.getValue5().trim().toUpperCase()+"/")){
								de.setValue4(dtMap.get(dic.getDicValue()));
								break;
							}
						}
					}
				
					de.setValue2(field.getValue1());
					de.setValue7(field.getValue6());
					de.setValue8(""+field.getCompanyId());
					de.setCompanyId(field.getCompanyId());
					de.setGroupId(field.getGroupId());
					dataElementService.insert(de);
					field.setDataElementId(de.getId());
					govTableFieldService.update(field);
				}
			}
			
		}
		ar.put("code", Const.SUCCEED);
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
	
	
}
