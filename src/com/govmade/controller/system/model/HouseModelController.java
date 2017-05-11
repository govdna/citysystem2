package com.govmade.controller.system.model;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.data.CleanDataElement;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.model.HouseModel;
import com.govmade.entity.system.model.HouseModelFields;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.CleanDataElementService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.data.DataListService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.InformationResourceService;
import com.govmade.service.system.model.HouseModelFieldsService;
import com.govmade.service.system.model.HouseModelService;
import com.govmade.service.system.organization.CompanyService;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月8日 上午9:54:39   
* @Title: HouseModleController.java  
*/

@Controller
@RequestMapping("/backstage/model/houseModel/")
public class HouseModelController extends GovmadeBaseController<HouseModel>{

	@Autowired
	private HouseModelService service;
	@Autowired
	private InformationResourceService informationResourceService;
	@Autowired
	private DataElementService dataElementService;
	@Autowired
	private DataListService dataListService;
	@Autowired
	private CompanyService companyService;
	@Autowired
	private GovmadeDicService govmadeDicservice;
	@Autowired
	private CleanDataElementService cleanDataElementService;
	@Autowired
	private HouseModelFieldsService houseModelFieldsService;
	
	@Override
	public String index(Model model, HttpServletRequest req, HttpServletResponse res) {
		String u=req.getParameter("types");
		if(u!=null&&u.equals("1")){
			return "/system/model/houseModel1/index";
		}else if(u!=null&&u.equals("2")){
			return "/system/model/houseModel2/index";
		}else if(u!=null&&u.equals("3")){
			return "/system/model/houseModel3/index";
		}else if(u!=null&&u.equals("4")){
			return "/system/model/houseModel4/index";
		}else if(u!=null&&u.equals("5")){
			return "/system/model/houseModel5/index";
		}
		return "/system/model/houseModel/index";
	}

	@Override
	public String indexURL() {
		
		return "/system/model/houseModel/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map= super.getDataHandlers();
		map.put("informationResId", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				InformationResource c=new InformationResource();
				c.setId((Integer)obj);	
				InformationResource res = informationResourceService.findById(c);
				   if(res.getId()!=null){
					return res.getValue1();
				}
				return "";
			}
			@Override
			public int getMode() {
				return ADD_MODE;
			}			
		});	
		map.put("inforCode", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				InformationResource c=new InformationResource();
				Integer id = Integer.valueOf((String)obj);
				c.setId(id);	
				List<InformationResource> l=informationResourceService.find(c);		
				if(l!=null&&l.size()>0){
					return l.get(0).getValue2();
				}
				return "";
			}
			@Override
			public int getMode() {
				return ADD_MODE;
			}			
		});	
		map.put("department", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				Company c=new Company();
				c.setId((Integer)obj);	
				List<Company> l=companyService.find(c);		
				if(l!=null&&l.size()>0){
					return l.get(0).getCompanyName();
				}
				return "";
			}
			@Override
			public int getMode() {
				return ADD_MODE;
			}			
		});
		map.put("dataType", new DataHandler() {
            //数据类型（datatype）根据数据字典配置，通过ID读取后dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic=new GovmadeDic();
				dic.setDicNum("DATATYPE");
				dic.setDicKey((Integer)obj+"");			
				List<GovmadeDic> l=govmadeDicservice.getDicList(dic);
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
	@Override
	public void doBeforeInsertUpdate(HouseModel o,HttpServletRequest req, HttpServletResponse res) {
		if(o.getHouseTypes()==1){
			if(o.getInfoTypes()==3){			
				o.setInforCode(o.getInformationResId()+"");
			}else{
				//o.setDataElementId(",");
				o.setInformationResId(0);
				o.setInforCode("0");
			}
		}
		
	}
	@Override
	public void doAfterInsertUpdate(HouseModel o, HttpServletRequest req, HttpServletResponse res) {
		String str = StringUtil.toSQLArray(o.getDataElementId());
		int infoResId = o.getId();		
//		if (str != null && str != "") {
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
//		}		
	}

	
	@RequestMapping(value="treeAjax")
	public String treeAjax(Model m, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String type = req.getParameter("type");
		Integer typei = Integer.valueOf(type);
//		if(typei==1){
//			m.addAttribute("url", "/backstage/model/houseModel/testAjax");
//		}else if(typei==2){
//			m.addAttribute("url", "/backstage/model/houseModel/legalAjax");
//		}else if(typei==3){
//			m.addAttribute("url", "/backstage/model/houseModel/creditAjax");
//		}else if(typei==4){
//			m.addAttribute("url", "/backstage/model/houseModel/licenceAjax");
//		}else{
			m.addAttribute("url", "/backstage/model/houseModel/customAjax?model="+typei);
//		}
		return "/system/model/houseModel6/index";
	}
	@RequestMapping(value="customAjax")
	public String customAjax(CleanDataElement o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject tree = new JSONObject();
		JSONArray ja = new JSONArray();
		JSONObject menu = new JSONObject();
		HouseModelFields hmf= new HouseModelFields();
		String type=req.getParameter("model");
		
		List<HouseModel> hm = service.customTree(Integer.valueOf(type));
		InformationResource infor=new InformationResource();
		if(hm.size()>0){
			for (HouseModel h : hm) {
				if(h != null){
					infor.setId(h.getInformationResId());
					  String infoName = informationResourceService.findById(infor).getValue1();
					  menu.put("name",infoName);
					  	  String s = h.getDataElementId();
						  JSONArray ja2 = new JSONArray();
					  	if(s == null || s.isEmpty()){}
						  else{
							  String [] stringArr= s.split(",");
							  if(stringArr.length == 1){
								  stringArr[0] = s;
							  }
							  for (String hs : stringArr){
								  JSONObject menu2 = new JSONObject();
								  o.setId(Integer.valueOf(hs));
								  DataElement d = cleanDataElementService.findById(o);
								  if(d.getChName()!=null && d.getChName()!=""){
									  menu2.put("name", d.getChName());
									  ja2.add(menu2);
								  }								  

							  }  
						  }					  
						  menu.put("children", ja2);
						ja.add(menu);  
				}				  		  
			}
		}	
		hmf.setModelType(Integer.valueOf(type));
		hmf.setLevel(1);
		tree.put("name", houseModelFieldsService.find(hmf).get(0).getModelName());
		tree.put("children", ja);
		res.getWriter().write(tree.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	/** 
	* @Title: testAjax 
	* @Description: 用于获取人口库JSON数据展现 
	* @param @param o
	* @param @param req
	* @param @param res
	* @param @return
	* @param @throws Exception    设定文件 
	* @return String    返回类型 
	* @throws 
	
	@RequestMapping(value="testAjax")
	public String testAjax(DataElement o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		List<HouseModel> hm = service.popTreeFirst();
		List<HouseModel> hm2 = service.popTreeSecond();
		JSONObject tree = new JSONObject();
		JSONArray ja = new JSONArray();
		JSONObject menu = new JSONObject();
		if(hm.size()>0){
			for (HouseModel h : hm) {
				  Integer infoType = h.getInfoTypes();
				  switch(infoType){
				  case 1:
					  menu.put("name","基础信息"); 
					  break;
				  case 2:
					  menu.put("name","扩展信息"); 
					  break;
				  default:
					  menu.put("name","未知信息");
				  }				  
					  String s = h.getDataElementId();
					  JSONArray ja2 = new JSONArray();
					  if(s == null || s.isEmpty()){}
					  else{
						  String [] stringArr= s.split(",");
						  if(stringArr.length == 1){
							  stringArr[0] = s;
						  }
						  for (String hs : stringArr){
							  JSONObject menu2 = new JSONObject();
							  o.setId(Integer.valueOf(hs));
							  List<DataElement> d = dataElementService.find(o);
							  menu2.put("name", d.get(0).getChName());
							  ja2.add(menu2);
						  }
					  }					  
					  menu.put("children", ja2);
					ja.add(menu);  				  		  
			}
		}		
		if(hm2.size()>0){
			for (HouseModel h : hm2) {
				  String inforName = h.getInfoName();
					  menu.put("name",inforName);
						  String s = h.getDataElementId();
						  JSONArray ja2 = new JSONArray();
						  if(s == null || s.isEmpty()){							  
						  }else{
							  String [] stringArr= s.split(",");
							  if(stringArr.length == 1){
								  stringArr[0] = s;
							  }
							  for (String hs : stringArr){
								  JSONObject menu2 = new JSONObject();
								  o.setId(Integer.valueOf(hs));
								  List<DataElement> d = dataElementService.find(o);
								  menu2.put("name", d.get(0).getChName());
								  ja2.add(menu2);
							  }
						  }						 
						  menu.put("children", ja2);
						ja.add(menu);    
				  		  		  
			}
		}		
		tree.put("name", "人口库");
		tree.put("children", ja);
		res.getWriter().write(tree.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
	/** 
	* @Title: legalAjax 
	* @Description: 用于获取法人库JSON数据展现  
	* @param @param o
	* @param @param req
	* @param @param res
	* @param @return
	* @param @throws Exception    设定文件 
	* @return String    返回类型 
	* @throws 
	
	@RequestMapping(value="legalAjax")
	public String legalAjax(DataElement o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		List<HouseModel> hm = service.legalTree();
		JSONObject tree = new JSONObject();
		JSONArray ja = new JSONArray();
		JSONObject menu = new JSONObject();
		if(hm.size()>0){
			for (HouseModel h : hm) {
				  Integer infoType = h.getInfoTypes();
				  switch(infoType){
				  case 1:
					  menu.put("name","登记类"); 
					  break;
				  case 2:
					  menu.put("name","资质类"); 
					  break;
				  case 3:
					  menu.put("name","监管类"); 
					  break;
				  case 4:
					  menu.put("name","处罚类"); 
					  break;
				  default:
					  menu.put("name","未知信息");
				  }
				  
					  String s = h.getDataElementId();
					  JSONArray ja2 = new JSONArray();
					  if(s == null || s.isEmpty()){}
					  else{
						  String [] stringArr= s.split(",");
						  if(stringArr.length == 1){
							  stringArr[0] = s;
						  }
						  for (String hs : stringArr){
							  JSONObject menu2 = new JSONObject();
							  o.setId(Integer.valueOf(hs));
							  List<DataElement> d = dataElementService.find(o);
							  menu2.put("name", d.get(0).getChName());
							  ja2.add(menu2);
						  }  
					  }					  
					  menu.put("children", ja2);
					ja.add(menu);  
				  		  
			}
		}
		
		tree.put("name", "法人库");
		tree.put("children", ja);
		res.getWriter().write(tree.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}	
	/** 
	* @Title: creditAjax 
	* @Description: 用于获取信用库JSON数据展现 
	* @param @param o
	* @param @param req
	* @param @param res
	* @param @return
	* @param @throws Exception    设定文件 
	* @return String    返回类型 
	* @throws 
	
	@RequestMapping(value="creditAjax")
	public String creditAjax(DataElement o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		List<HouseModel> hm = service.creditTree();
		JSONObject tree = new JSONObject();
		JSONArray ja = new JSONArray();
		JSONObject menu = new JSONObject();
		if(hm.size()>0){
			for (HouseModel h : hm) {
				  Integer infoType = h.getInfoTypes();
				  switch(infoType){
				  case 1:
					  menu.put("name","个人信用"); 
					  break;
				  case 2:
					  menu.put("name","法人信用"); 
					  break;
				  default:
					  menu.put("name","未知信息");
				  }
				  
					  String s = h.getDataElementId();
					  JSONArray ja2 = new JSONArray();
					  if(s == null || s.isEmpty()){}
					  else{
						  String [] stringArr= s.split(",");
						  if(stringArr.length == 1){
							  stringArr[0] = s;
						  }
						  for (String hs : stringArr){
							  JSONObject menu2 = new JSONObject();
							  o.setId(Integer.valueOf(hs));
							  List<DataElement> d = dataElementService.find(o);
							  menu2.put("name", d.get(0).getChName());
							  ja2.add(menu2);
						  }  
					  }					  
					  menu.put("children", ja2);
					ja.add(menu);  
				  		  
			}
		}
		
		tree.put("name", "信用库");
		tree.put("children", ja);
		res.getWriter().write(tree.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
	@RequestMapping(value="licenceAjax")
	public String licenceAjax(DataElement o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		List<HouseModel> hm = service.licenceTree();
		JSONObject tree = new JSONObject();
		JSONArray ja = new JSONArray();
		JSONObject menu = new JSONObject();
		if(hm.size()>0){
			for (HouseModel h : hm) {
				  String infoName = h.getInfoName();
				  menu.put("name",infoName);
				  	  String s = h.getDataElementId();
					  JSONArray ja2 = new JSONArray();
				  	if(s == null || s.isEmpty()){}
					  else{
						  String [] stringArr= s.split(",");
						  if(stringArr.length == 1){
							  stringArr[0] = s;
						  }
						  for (String hs : stringArr){
							  JSONObject menu2 = new JSONObject();
							  o.setId(Integer.valueOf(hs));
							  List<DataElement> d = dataElementService.find(o);
							  menu2.put("name", d.get(0).getChName());
							  ja2.add(menu2);
						  }  
					  }					  
					  menu.put("children", ja2);
					ja.add(menu);  
				  		  
			}
		}	
		tree.put("name", "证照库");
		tree.put("children", ja);
		res.getWriter().write(tree.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
	*/
	
	@Override
	public void doBeforeListAjax(HouseModel o, HttpServletRequest req, HttpServletResponse res) {
		List<Scope> sc=ServiceUtil.getScopesByRoleId("/backstage/model/houseModel/index");
		for(Scope s:sc){
			if(s.getValue().equals("1")){
				o.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
			}
		}
	}

	//验证名称重复
	@RequestMapping(value="validation")
	public String validation(HouseModel o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");		
		HouseModel hm=new HouseModel();
		String inname=o.getInfoName();
		hm.setInfoName(inname);
		String results = "";
		if (o.getId() == null) {
			if (!service.find(hm).isEmpty()&&StringUtils.isNotEmpty(o.getInfoName())) {
				results = "1";
			}
	} else {

			if(service.find(hm).size()!=0&&StringUtils.isNotEmpty(o.getInfoName())){
				if ((int) service.find(hm).get(0).getId() != (int) o.getId()) {
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
	
	@RequestMapping(value="isUse")
	public String isUse(HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		HouseModel houseModel=new HouseModel();
		JSONObject ar = new JSONObject();
		String informationResourceId=req.getParameter("informationResourceId");
		if(informationResourceId!=null&&informationResourceId!=""){
			houseModel.setInformationResId(Integer.valueOf(informationResourceId));
		}			
		if(service.find(houseModel)!=null&&service.find(houseModel).size()>0){
			ar.put("code", "1");
		}else{
			ar.put("code", "0");
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
	
}
