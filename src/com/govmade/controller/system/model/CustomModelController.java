package com.govmade.controller.system.model;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
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

import com.govmade.adapter.object2excel.HouseModel2ExcelAdapter;
import com.govmade.adapter.object2excel.InformationResource2ExcelAdapter;
import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.poi.Object2ExcelComplexUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.memorizer.GovMemorizer;
import com.govmade.entity.system.model.HouseModel;
import com.govmade.entity.system.model.HouseModelFields;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.server.GovServer;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.data.DataListService;
import com.govmade.service.system.model.HouseModelFieldsService;
import com.govmade.service.system.model.HouseModelService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2017年2月15日 下午2:01:07   
* @Title: CustomModelController.java  
*/
@Controller
@RequestMapping("/backstage/model/customModel/")
public class CustomModelController extends GovmadeBaseController<HouseModel>{

	
	@Autowired
	private HouseModelService service;
	@Autowired
	private DataListService dataListService;
	@Autowired
	private HouseModelFieldsService houseModelFieldsService;
	@Autowired
	private DataElementService dataElementService;
	
	@Override
	public BaseService getService() {
		return service;
	}

	
	@Override
	public String index(Model model, HttpServletRequest req, HttpServletResponse res) {
		String type=req.getParameter("model");
		if(type!=null&&type!=""){
			model.addAttribute("columns", getColumns(Integer.valueOf(type)));
		}
		
		return super.index(model, req, res);
	}

	public String getColumns(Integer type) {
		
		HouseModelFields fields=new HouseModelFields();
		String strcolumns="[";
		fields.setModelType(type);
		fields.setIsDeleted(0);
		fields.setFatherId(999);
		fields.setIsShow(1);; ////////// 
		List<HouseModelFields> list=houseModelFieldsService.find(fields, "list_no", "asc");
		
		if(list!=null&&list.size()>0){
			for(HouseModelFields h:list){
				strcolumns=strcolumns+
						"{\"field\": \"value"+h.getValueNo();
						if(h.getIsShow() == 1 && !h.getInputType().equals("1")){
							strcolumns=strcolumns+"ForShow";	
						}
						strcolumns=strcolumns+"\",\"title\": \""+h.getName()+"\"},";
			}
		}
		
		strcolumns=strcolumns+
				"{\"field\":\"id\",\"title\": \"操作\",\"formatter\": \"doFormatter\"}"+
				"]";
		
		
		return strcolumns;
	}
	
	@Override
	public String indexURL() {
		return "/system/model/customModel/index";
	}
	

	public Map<String, DataHandler> getDataHandlers(HttpServletRequest req, HttpServletResponse res) {
		String type=req.getParameter("model");
		Map<String, DataHandler> map= super.getDataHandlers();
		
		if(type!=null && type!=""){
			map=DataHandlerUtil.buildModelDataHandlers(map,Integer.valueOf(type));
		}
		
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
				HouseModel res=(HouseModel)bo;
				jo.put("id", res.getId());
				jo.put("idForShow", SecurityUtil.encrypt(res.getId()));
				DataList dl=new DataList();
				String dmids="";
				dl.setHouseModelId(res.getId());
				List<DataList> dmlist=dataListService.find(dl);
				for(DataList dm:dmlist){
					dmids=dmids+dm.getDataElementId()+",";
				}
				dmids=StringUtil.toSQLArray(dmids);
				jo.put("dataElementIds", dmids.toString());
			}			
		});
		
		return map;
	}
	
	public Map<String, DataHandler> getExlDataHandlers(HttpServletRequest req, HttpServletResponse res) {
		Map<String, DataHandler> map = new HashMap<String, DataHandler>();
		String type=req.getParameter("model");
		HouseModelFields houseModelFields=new HouseModelFields();
		houseModelFields.setModelType(Integer.valueOf(type));
		List<HouseModelFields> list=houseModelFieldsService.find(houseModelFields);
		
		for(final HouseModelFields sf:list){
			if(sf.getIsShow()!=null&&sf.getIsShow()==1){
				map.put("value"+sf.getValueNo(), new DataHandler() {					
					@Override
					public int getMode() {
						return ADD_MODE;
					}					
					@Override
					public Object doHandle(Object obj) {
						if(sf.getInputType().equals("2")){
							return ServiceUtil.getDicValue(sf.getInputValue(), (String)obj);
						}else if(sf.getInputType().equals("3")){
							List<ItemSort> ls=ServiceUtil.getService("ItemSortService").find(ServiceUtil.buildBean("ItemSort@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getItemName();
							}
						}else if(sf.getInputType().equals("5")){
							List<Company> ls=ServiceUtil.getService("CompanyService").find(ServiceUtil.buildBean("Company@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getCompanyName();
							}
						}else if(sf.getInputType().equals("7")){
							List<GovServer> ls=ServiceUtil.getService("GovServerService").find(ServiceUtil.buildBean("GovServer@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("8")){
							List<GovMemorizer> ls=ServiceUtil.getService("GovMemorizerService").find(ServiceUtil.buildBean("GovMemorizer@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("9")){
							List<GovComputerRoom> ls=ServiceUtil.getService("GovComputerRoomService").find(ServiceUtil.buildBean("GovComputerRoom@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("10")){
							List<GovApplicationSystem> ls=ServiceUtil.getService("GovApplicationSystemService").find(ServiceUtil.buildBean("GovApplicationSystem@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("12")){
							List<GovDatabase> ls=ServiceUtil.getService("GovDatabaseService").find(ServiceUtil.buildBean("GovDatabase@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue2();
							}
						}else if(sf.getInputType().equals("13")){
							List<GovTable> ls=ServiceUtil.getService("GovTableService").find(ServiceUtil.buildBean("GovTable@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}else if(sf.getInputType().equals("14")){
							List<GovTableField> ls=ServiceUtil.getService("GovTableFieldService").find(ServiceUtil.buildBean("GovTableField@isDeleted=0&id="+(String)obj));
							if(ls!=null&&ls.size()>0){
								return ls.get(0).getValue1();
							}
						}
						return obj;
					}
				});
			}
		}
		return map;
	}
	
	@Override
	public void doBeforeListAjax(HouseModel o,HttpServletRequest req, HttpServletResponse res) {
		String type=req.getParameter("model");
		if(type!=null&&type!=""){
			o.setHouseTypes(Integer.valueOf(type));
		}
	}
	
	
	@Override
	public boolean insertAjaxIntercept(HouseModel o,HttpServletRequest req, HttpServletResponse res) {
		String type=req.getParameter("model");
		//System.out.println("type= "+type);
		if(type!=null&&type!=""){
			o.setHouseTypes(Integer.valueOf(type));
			return false;
		}else{
			return true;
		}
	}
	
	@Override
	public void doAfterInsertUpdate(HouseModel o, HttpServletRequest req, HttpServletResponse res) {
		String str = StringUtil.toSQLArray(o.getDataElementId());
		//System.out.println("str=  "+str);
		int infoResId = o.getId();		
		if (str != null && str != "") {
			String[] strs = str.split(",");
			DataList dl = new DataList();			
			dl.setHouseModelId(infoResId);
			dataListService.deleteByHouseModelId(dl);
			for (String ids: strs) {
				if(!StringUtil.is_Empty(ids)){
					dl.setDataElementId(Integer.valueOf(ids));
					dataListService.insert(dl);
				}				
			}
		}		
	}
	
	@RequestMapping(value = "listAjax")
	public String listAjax(HouseModel o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		doBeforeListAjax(o,req,res);
		JSONObject ar = new JSONObject();
		try {
			if (StringUtils.isNotEmpty(req.getParameter("all"))) {
				List p = getService().find(o,req.getParameter("sort"), req.getParameter("order"));
				res.getWriter().write(DataHandlerUtil.buildJson(p, getDataHandlers(), true).toString());
				res.getWriter().flush();
				res.getWriter().close();
			} else {
				Page<HouseModel> page = new Page<HouseModel>();
				if (StringUtils.isNotEmpty(req.getParameter("page"))) {
					page.setPageNum(Integer.valueOf(req.getParameter("page")));
				}
				if (StringUtils.isNotEmpty(req.getParameter("rows"))) {
					page.setPageSize(Integer.valueOf(req.getParameter("rows")));
				}
				Page p = getService().findByPage(o, page,req.getParameter("sort"), req.getParameter("order"));
				ar.put("rows", DataHandlerUtil.buildJson(p.getResults(), getDataHandlers(req,res), true));
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

	@RequestMapping(value = "createSql")
	public String createSql(HouseModel g, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();	
		
		
		//库
		HouseModelFields hmf=new HouseModelFields();
		hmf.setModelType(service.findById(g).getHouseTypes());
		hmf.setLevel(1);
		hmf.setIsDeleted(0);
		String gdb=houseModelFieldsService.find(hmf).get(0).getModelCode();

		//表
		hmf.setLevel(2);		
		String tables="";
		for(int i=1;i<31;i++){
			hmf.setValueNo(i); /// ///
			List<HouseModelFields> HMlist=houseModelFieldsService.find(hmf);
			if(HMlist!=null && HMlist.size()>0){
				tables=HMlist.get(0).getModelCode();
				break;
			}
		}
		
		//字段
		List<DataElement> list=dataElementService.getDataElementListByHouseModelId(g.getId());
		
		
		String oracle="CREATE TABLE \""+tables+"\" ( \n"+
		"  \"ID\" NUMBER(12) NOT NULL , \n";
		
		String mysql="CREATE TABLE `"+tables+"` ( \n"+
		"  `id` int(12) NOT NULL AUTO_INCREMENT, \n";
		
		String oracleFields="";
		String mysqlFields="";
		for(DataElement t:list){
			oracleFields=oracleFields+"  \""+t.getValue2()+"\"";
			mysqlFields=mysqlFields+"  `"+t.getValue2()+"`";
			if(t.getValue4().equals("3") || t.getValue4().equals("5")){
				oracleFields=oracleFields+" DATE ";
				mysqlFields=mysqlFields+" date";
			}else{
				oracleFields=oracleFields+" VARCHAR2";
				mysqlFields=mysqlFields+" varchar";
			}
			if(t.getValue7()!=null&&t.getValue7()!=""){
				oracleFields=oracleFields+"("+t.getValue7()+" BYTE)";
				mysqlFields=mysqlFields+"("+t.getValue7()+")";
			}
			oracleFields=oracleFields+" DEFAULT NULL NULL , \n";
			mysqlFields=mysqlFields+" DEFAULT NULL COMMENT '"+t.getValue1()+"' , \n";
		}

		oracleFields=oracleFields+
		"  \"TIME_CREATE\" DATE DEFAULT NULL  NULL , \n"+
		"  \"TIME_MODIFIED\" DATE DEFAULT NULL  NULL , \n"+
		"  \"ISDELETED\" VARCHAR2(2 BYTE) DEFAULT NULL NULL , \n"+
		"  PRIMARY KEY (\"ID\") \n"+		//主键
		"); \n";
		
		mysqlFields=mysqlFields+
				"  `time_create` datetime DEFAULT NULL, \n"+
				"  `time_modified` datetime DEFAULT NULL, \n"+
				"  `isdeleted` varchar(2) DEFAULT NULL, \n"+
				"  PRIMARY KEY (`id`) \n"+		//主键
				") ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC; \n";
		
		String notes="";
		for(DataElement t:list){
			notes=notes+"COMMENT ON COLUMN \""+tables+"\".\""+t.getValue2()+"\" IS '"+t.getValue1()+"'; \n";
		}

		oracle=oracle+oracleFields+notes;
		mysql=mysql+mysqlFields;

//		System.out.println("-------------");
//		System.out.println(oracle);
		
		ar.put("oracle", oracle);
		ar.put("mySql", mysql);
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
		byte[] b2=mysql.getBytes("UTF-8");
		
		ff1.write(b);
		ff2.write(b2);
		ff1.close();
		ff2.close();
		
		return null;
	}
	
	@RequestMapping(value = "downloadData")
	public ResponseEntity<byte[]> downloadData(HouseModel de,String[] xlsFields, String[] deFields, HttpServletRequest req,
			HttpServletResponse response) throws Exception {
		if (xlsFields == null) {
			xlsFields = new String[0];
		}
		if (deFields == null) {
			deFields = new String[0];
		}
		de.setHouseTypes(Integer.valueOf(req.getParameter("model")));
		HouseModel2ExcelAdapter adapter = new HouseModel2ExcelAdapter(service.find(de), xlsFields,
				deFields, getExlDataHandlers(req, response));
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
		
//		return null;
	}

	
}
