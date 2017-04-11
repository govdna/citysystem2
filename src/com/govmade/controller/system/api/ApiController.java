package com.govmade.controller.system.api;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
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

import com.govmade.api.ApiCode;
import com.govmade.api.ApiResult;
import com.govmade.api.ApiSecurityUtil;
import com.govmade.api.ValueMeaning;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.DateUtil;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.entity.system.api.ApiAccount;
import com.govmade.entity.system.customFields.DataElementFields;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.data.DataManager;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.Application;
import com.govmade.entity.system.information.DataFile;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.information.Subscribe;
import com.govmade.entity.system.organization.City;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.service.system.api.ApiAccountService;
import com.govmade.service.system.application.GovApplicationSystemService;
import com.govmade.service.system.computer.GovComputerRoomService;
import com.govmade.service.system.data.DataElementFieldsService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.data.DataListService;
import com.govmade.service.system.data.DataManagerService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.ApplicationService;
import com.govmade.service.system.information.DataFileService;
import com.govmade.service.system.information.InformationResourceService;
import com.govmade.service.system.information.NoticeService;
import com.govmade.service.system.information.SearchLogService;
import com.govmade.service.system.information.SubscribeService;
import com.govmade.service.system.item.ItemSortService;
import com.govmade.service.system.memorizer.GovMemorizerService;
import com.govmade.service.system.organization.CityService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.organization.GroupsService;
import com.govmade.service.system.server.GovServerService;
import com.govmade.service.system.sort.SortManagerService;
import com.govmade.service.system.table.GovTableService;
import com.govmade.service.system.versionControl.VersionControlService;

import net.sf.json.JSONObject;

@Controller
@RequestMapping("/api/")
public class ApiController {
	
	@Autowired
	private ApiAccountService apiAccountService;
	
	@Autowired
	private CompanyService companyService;
	
	@Autowired
	private CityService cityService;
	

	@Autowired
	private DataListService dataListService;
	@Autowired
	private DataElementService dataElementService;
	@Autowired
	private ItemSortService itemSortService;
	@Autowired
	private DataManagerService dataManagerService;
	@Autowired
	private GovApplicationSystemService govApplicationSystemService;

	@Autowired
	private GovMemorizerService govMemorizerService;

	@Autowired
	private GovServerService govServerService;

	@Autowired
	private GovComputerRoomService govComputerRoomService;

	@Autowired
	private GovmadeDicService govmadeDicService;

	@Autowired
	private GroupsService groupsService;

	@Autowired
	private SortManagerService sortManagerService;

	@Autowired
	private InformationResourceService informationResourceService;
	
	@Autowired
	private DataElementFieldsService dataElementFieldsService;
	
	@RequestMapping("company")
	public String company(Company company,HttpServletRequest req, HttpServletResponse res) {
		try {
			res.setContentType("text/html;charset=utf-8");
			res.setCharacterEncoding("utf-8");
			ApiResult result=volidate(req);
			if(!filter(result,req,res)){
				return null;
			}
			List<Company> list=companyService.find(company);
			result.setData(DataHandlerUtil.buildJson(list, getCompanyDataHandlers(), true));
			JSONObject ar = JSONObject.fromObject(result);
			res.getWriter().write(ar.toString());
			res.getWriter().flush();
			res.getWriter().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@RequestMapping("listener")
	public String listener(HttpServletRequest req, HttpServletResponse res) {
		try {
			res.setContentType("text/html;charset=utf-8");
			res.setCharacterEncoding("utf-8");
			System.out.println("改动通知接收到id"+req.getParameter("id"));
			res.getWriter().write(req.getParameter("id"));
			res.getWriter().flush();
			res.getWriter().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	@RequestMapping("inforValueMeaning")
	public String inforValueMeaning(HttpServletRequest req, HttpServletResponse res) {
		try {
			res.setContentType("text/html;charset=utf-8");
			res.setCharacterEncoding("utf-8");
			ApiResult result=volidate(req);
			if(!filter(result,req,res)){
				return null;
			}
			List<DataManager> list=dataManagerService.find(new DataManager());
			if(list!=null){
				List<ValueMeaning> vmList=new ArrayList<ValueMeaning>();
				for(DataManager fm:list){
					ValueMeaning vm=new ValueMeaning("value"+fm.getValueNo(), fm.getDataName());
					vmList.add(vm);
				}
				result.setData(vmList);
				
			}
			JSONObject ar = JSONObject.fromObject(result);
			res.getWriter().write(ar.toString());
			res.getWriter().flush();
			res.getWriter().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	@RequestMapping("dataElementValueMeaning")
	public String dataElementValueMeaning(HttpServletRequest req, HttpServletResponse res) {
		try {
			res.setContentType("text/html;charset=utf-8");
			res.setCharacterEncoding("utf-8");
			ApiResult result=volidate(req);
			if(!filter(result,req,res)){
				return null;
			}
			List<DataElementFields> list=dataElementFieldsService.find(new DataElementFields());
			if(list!=null){
				List<ValueMeaning> vmList=new ArrayList<ValueMeaning>();
				for(DataElementFields fm:list){
					ValueMeaning vm=new ValueMeaning("value"+fm.getValueNo(), fm.getName());
					vmList.add(vm);
				}
				result.setData(vmList);
				
			}
			JSONObject ar = JSONObject.fromObject(result);
			res.getWriter().write(ar.toString());
			res.getWriter().flush();
			res.getWriter().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	@RequestMapping("information")
	public String information(InformationResource infor,HttpServletRequest req, HttpServletResponse res) {
		try {
			res.setContentType("text/html;charset=utf-8");
			res.setCharacterEncoding("utf-8");
			ApiResult result=volidate(req);
			if(!filter(result,req,res)){
				return null;
			}
			infor.setStatus(0);
			List<InformationResource> list=informationResourceService.findExactly(infor);
			if(list.size()>1000){
				result.setCode(ApiCode.OVER_SIZE);
				result.setMsg("数据过多，请增加查询条件");
			}
			result.setData(DataHandlerUtil.buildJson(list, getInformationDataHandlers(), true));
			JSONObject ar = JSONObject.fromObject(result);
			List<DataManager> dmlist=dataManagerService.find(new DataManager());
			if(list!=null){
				List<ValueMeaning> vmList=new ArrayList<ValueMeaning>();
				for(DataManager fm:dmlist){
					ValueMeaning vm=new ValueMeaning("value"+fm.getValueNo(), fm.getDataName());
					vmList.add(vm);
				}
				ar.put("inforValueMeaning", vmList);
				
			}
			
			List<DataElementFields> delist=dataElementFieldsService.find(new DataElementFields());
			if(list!=null){
				List<ValueMeaning> vmList=new ArrayList<ValueMeaning>();
				for(DataElementFields fm:delist){
					ValueMeaning vm=new ValueMeaning("value"+fm.getValueNo(), fm.getName());
					vmList.add(vm);
				}
				ar.put("dataElementValueMeaning", vmList);
			}
			res.getWriter().write(ar.toString());
			res.getWriter().flush();
			res.getWriter().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	public Map<String, DataHandler> getDataElementDataHandlers() {
		Map<String, DataHandler> map = getDataHandlers();
		map.put("dataType", new DataHandler() {
			// 数据类型（datatype）根据数据字典配置，通过ID读取后dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic = new GovmadeDic();
				dic.setDicNum("DATATYPE");
				dic.setDicKey((Integer) obj + "");
				List<GovmadeDic> l = govmadeDicService.getDicList(dic);
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
				List<GovmadeDic> l = govmadeDicService.getDicList(dic);
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
				List<GovmadeDic> l = govmadeDicService.getDicList(dic);
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
				
				Company c = new Company();
				c.setId(Integer.valueOf((String)obj));
				c = companyService.findById(c);
				return c.getCompanyName();
			}

			@Override
			public int getMode() {
				return ADD_MODE;
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

	
	

	//信息资源
	public Map<String, DataHandler> getInformationDataHandlers() {
		Map<String, DataHandler> map = getDataHandlers();
		map.put("sourceType", new DataHandler() {
			// 数据类型（datatype）根据数据字典配置，通过ID读取后dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic = new GovmadeDic();
				dic.setDicNum("SOURCETYPE");
				dic.setDicKey((Integer) obj + "");
				List<GovmadeDic> l = govmadeDicService.getDicList(dic);
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
		
		
		map.put("inforTypes", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				SortManager sm=new SortManager();
				sm.setId((Integer)obj);
				sm=sortManagerService.findById(sm);
				if (sm != null ) {
					return sm.getSortName();
				}
				return "";
			}

			@Override
			public int getMode() {
				return ADD_MODE;
			}

		});
		map.put("inforTypes2", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				SortManager sm=new SortManager();
				sm.setId((Integer)obj);
				sm=sortManagerService.findById(sm);
				if (sm != null ) {
					return sm.getSortName();
				}
				return "";
			}

			@Override
			public int getMode() {
				return ADD_MODE;
			}

		});
		map.put("inforTypes3", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				SortManager sm=new SortManager();
				sm.setId((Integer)obj);
				sm=sortManagerService.findById(sm);
				if (sm != null ) {
					return sm.getSortName();
				}
				return "";
			}

			@Override
			public int getMode() {
				return ADD_MODE;
			}

		});
		map.put("inforTypes4", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				SortManager sm=new SortManager();
				sm.setId((Integer)obj);
				sm=sortManagerService.findById(sm);
				if (sm != null ) {
					return sm.getSortName();
				}
				return "";
			}

			@Override
			public int getMode() {
				return ADD_MODE;
			}

		});
		
		map.put("value3", new DataHandler() {

			@Override
			public int getMode() {
				return FREEDOM_MODE;
			}

			@Override
			public void doHandle(Object bo, JSONObject jo) {
				String val = (String) ObjectUtil.getFieldValueByName("value3", bo);
				Integer id = (Integer) ObjectUtil.getFieldValueByName("id", bo);
				
				if (StringUtils.isNotEmpty(val) && StringUtils.isNumeric(val)) {
					int value = Integer.valueOf(val);
					jo.put("value3", value);
					Company c = new Company();
					c.setId(value);
					c = companyService.findById(c);
					jo.put("providerId", value);
					jo.put("providerName", c.getCompanyName());
					jo.put("providerCode", c.getCompanyCode());
				}

			}

			@Override
			public Object doHandle(Object obj) {
				// TODO Auto-generated method stub
				return null;
			}
		});

	

		map.put("dataElementList", new DataHandler() {
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
				int id = (int) ObjectUtil.getFieldValueByName("Id", bo);
				DataList dl=new DataList();
				dl.setDataManagerId(id);
				List<DataElement> list=dataElementService.getDataElementListByDataList(dl);
				jo.put("dataElementList", DataHandlerUtil.buildJson(list, getDataElementDataHandlers(), true));
			}
		});

		return map;
	}
	
	
	//company处理
	public Map<String, DataHandler> getCompanyDataHandlers() {
		Map<String, DataHandler> map = getDataHandlers();
		map.put("cityId", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				City city=new City();
				city.setId((Integer)obj);			
				List<City> l=cityService.find(city);		
				if(l!=null&&l.size()>0){
					return l.get(0).getCityName();
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
	
	
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map = new HashMap<String, DataHandler>();
		

		// 创建时间获得字符串时间类型 timeCreate;

		map.put("timeCreate", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				if(obj==null){
					return "";
				}
				return DateUtil.dateFormateObject((Date) obj);
			}

			@Override
			public int getMode() {
				return REPLACE_MODE;
			}
		});
		// 更新时间获得字符串类型 timeModified;
		map.put("timeModified", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				if(obj==null){
					return "";
				}
				return DateUtil.dateFormateObject((Date) obj);
			}

			@Override
			public int getMode() {
				return REPLACE_MODE;
			}
		});
		
		
		map.put("companyId", new DataHandler() {

			@Override
			public Object doHandle(Object obj) {
				if(obj==null){
					return "";
				}
				Company c = new Company();
				c.setId((Integer)obj);
				c = companyService.findById(c);
				return c.getCompanyName();
			}

			@Override
			public int getMode() {
				return ADD_MODE;
			}
		});
		
		
		return map;
	}
	
	
	
	
	
	public boolean filter(ApiResult result,HttpServletRequest req, HttpServletResponse res) throws Exception{
		if(result.getCode()!=ApiCode.SUCCESS){
			JSONObject ar = JSONObject.fromObject(result);
			res.getWriter().write(ar.toString());
			res.getWriter().flush();
			res.getWriter().close();
			return false;
		}
		return true;
	}
	
	
	public ApiResult volidate(HttpServletRequest req){
		ApiResult result=new ApiResult();
		try {
			Map<String,String[]> map=req.getParameterMap();
			if(!map.containsKey("app_key")){
				result.setCode(ApiCode.MISSING_PARAMETER);
				result.setMsg("缺少参数app_key");
				return result;
			}else if(!map.containsKey("sign")){
				result.setCode(ApiCode.MISSING_PARAMETER);
				result.setMsg("缺少参数sign");
				return result;
			}else if(!map.containsKey("timestamp")){
				result.setCode(ApiCode.MISSING_PARAMETER);
				result.setMsg("缺少参数timestamp");
				return result;
			}
			
			String timestamp=req.getParameter("timestamp");
			if(StringUtils.isNumeric(timestamp)){
				long time=Long.valueOf(timestamp);
				if(System.currentTimeMillis()-time>10*60*1000){
					result.setCode(ApiCode.OVER_TIME);
					result.setMsg("请求超时");
					return result;
				}
			}
			
			ApiAccount account=new ApiAccount();
			account.setAppKey(req.getParameter("app_key"));
			List<ApiAccount> list=apiAccountService.find(account);
			if(list==null||list.size()==0){
				result.setCode(ApiCode.ILLEGAL_PARAMETER);
				result.setMsg("不存在的app_key");
				return result;
			}
			account=list.get(0);
			Map<String,String> pMap=new HashMap<String,String>();
			for(String key:map.keySet()){
				if(!key.equals("sign")){
					pMap.put(key, map.get(key)[0]);
				}
			}
			
			String sign=ApiSecurityUtil.signTopRequest(pMap, account.getSecret());
			if(!sign.equals(req.getParameter("sign"))){
				result.setCode(ApiCode.ERROR_SIGN);
				result.setMsg("签名错误");
			}
		}  catch (Exception e) {
			result.setCode(ApiCode.SERVICE_ERROR);
			result.setMsg("服务器端出错");
			e.printStackTrace();
		}
		return result;
	}
	
}
