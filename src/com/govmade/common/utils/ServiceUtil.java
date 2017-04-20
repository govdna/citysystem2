package com.govmade.common.utils;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.defaults.DefaultSqlSessionFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.system.rbac.RBACMenuController;
import com.govmade.entity.system.data.CleanDataElement;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.information.Notice;
import com.govmade.entity.system.model.HouseModelFields;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.rbac.RolePermission;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.theme.Theme;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.CleanDataElementService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.data.DataListService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.InformationBusinessService;
import com.govmade.service.system.information.InformationResService;
import com.govmade.service.system.information.InformationResourceService;
import com.govmade.service.system.information.NoticeService;
import com.govmade.service.system.model.HouseModelFieldsService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.rbac.PermissionService;
import com.govmade.service.system.rbac.RolePermissionService;
import com.govmade.service.system.rbac.ScopeService;
import com.govmade.service.system.table.GovTableService;
import com.govmade.service.system.theme.ThemeService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class ServiceUtil implements ApplicationContextAware {
	private static ApplicationContext applicationContext;
	private static Map<String, Class<?>> typeMap;
	private static GovmadeDicService govmadeDicService;
	private static DataElementService dataElementService;
	private static DataListService dataListService;
	private static RolePermissionService rolePermissionService;
	private static ScopeService scopeService;
	private static PermissionService permissionService;
	private static ThemeService themeService;
	private static InformationResourceService informationResourceService;
	private static InformationBusinessService informationBusinessService;
	private static CompanyService companyService;
	private static InformationResService informationResService;
	private static HouseModelFieldsService houseModelFieldsService;
	private static NoticeService noticeService;
	private static GovTableService govTableService;
	
	private static Map<String,Integer> dataElementCount=new HashMap<String,Integer>();
	private static Map<String,Integer> informationCount=new HashMap<String,Integer>();
	private static long lastTime=0;
	
	@Override
	public void setApplicationContext(ApplicationContext arg0) throws BeansException {
		applicationContext = arg0;
		govmadeDicService = (GovmadeDicService) applicationContext.getBean("GovmadeDicService");
		noticeService = (NoticeService) applicationContext.getBean("NoticeService");
		dataElementService = (DataElementService) applicationContext.getBean("DataElementService");
		dataListService = (DataListService) applicationContext.getBean("DataListService");
		rolePermissionService = (RolePermissionService) applicationContext.getBean("RolePermissionService");
		themeService = (ThemeService) applicationContext.getBean("ThemeService");
		scopeService = (ScopeService) applicationContext.getBean("ScopeService");
		permissionService = (PermissionService) applicationContext.getBean("PermissionService");
		informationResourceService = (InformationResourceService) applicationContext
				.getBean("InformationResourceService");
		informationBusinessService = (InformationBusinessService) applicationContext
				.getBean("InformationBusinessService");
		companyService = (CompanyService) applicationContext.getBean("CompanyService");
		informationResService = (InformationResService) applicationContext.getBean("InformationResService");
		houseModelFieldsService = (HouseModelFieldsService) applicationContext.getBean("HouseModelFieldsService");
		govTableService= (GovTableService) applicationContext.getBean("GovTableService");
		try {
			typeMap = ((DefaultSqlSessionFactory) applicationContext.getBean("mysqlSqlSessionFactory"))
					.getConfiguration().getTypeAliasRegistry().getTypeAliases();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	// 数据元待审核条数
	public static Integer deSatausNum() {
		DataElement d=new DataElement();
		d.setClassType(1);
		d.setStatus(25);
		d.setIsDeleted(0);
		return dataElementService.count(d);
	}
	// 信息资源待审核条数
	public static Integer inforSatausNum() {
		InformationResource d=new InformationResource();
		d.setStatus(14);
		d.setIsDeleted(0);
		return informationResourceService.count(d);
	}
	// 信息资源待审核条数
	public static Integer noticeNum() {
		Notice d=new Notice();
		d.setReaded(0);
		d.setAccountId(AccountShiroUtil.getCurrentUser().getId());
		return noticeService.count(d);
	}
	//根据Id显示模块名
	public static String modRename(Integer id) {
		Theme th = new Theme();
		th.setId(id);
		th=themeService.findById(th);
	    String re=th.getTitleBig();
		return re;
	}
	
	//判断是否拥有单点登录权限
	public static Integer OnlyOne(Integer id) {
		Theme th = new Theme();
		th.setId(id);
		th=themeService.findById(th);
		Integer re=th.getLogoSmall();
		return re;
	}
	// 自定义模型
	public static List<HouseModelFields> fieldsType(HttpServletRequest request) {
		HouseModelFields o=new HouseModelFields();
		String model=request.getParameter("model");		
		if(model!=null&&model!=""){
			//System.out.println("model= "+model);
			o.setModelType(Integer.valueOf(model));
		}		
		o.setFatherId(999);
		o.setIsDeleted(0);
		List list=houseModelFieldsService.find(o, "list_no", "asc");
		//System.out.println(list);
		return list;
	}
	
	// 是否有权限
		public static List<InformationRes> getInformationResByLog() {
			return informationResService.getInformationResByLog(AccountShiroUtil.getCurrentUser().getId());
		}
		
	// 是否有权限
	public static boolean hasPermission(Permission p) {
		String roles = AccountShiroUtil.getCurrentUser().getRoleId();
		return permissionService.hasPermission(roles, p);
	}

	// 获取权限下 规则
	public static List<Scope> getScopesByRoleId(Permission p) {
		String roles = AccountShiroUtil.getCurrentUser().getRoleId();
		return scopeService.getScopesByRoleId(roles, p);
	}

	// 获取权限下 规则
	public static List<Scope> getScopesByRoleId(String url) {
		Permission p = new Permission();
		p.setUrl(url);
		String roles = AccountShiroUtil.getCurrentUser().getRoleId();
		return scopeService.getScopesByRoleId(roles, p);
	}
	
	// 获取权限下规则(是否有新增权限)
	public static boolean haveAdd(String url) {
		if( AccountShiroUtil.getCurrentUser().getRoleId()!=null){
			String roles = AccountShiroUtil.getCurrentUser().getRoleId();
			Permission p = new Permission();
			p.setUrl(url);
	        List<Scope> l=scopeService.getScopesByRoleId(roles, p);
	        for(Scope s:l){
	        	if(s.getId()==2){
	        		return true;
	        	}
	        }	
		}
		return false;
	}
	// 获取权限下规则(是否有删除权限)
	public static boolean haveDel(String url) {
		if( AccountShiroUtil.getCurrentUser().getRoleId()!=null){
		String roles = AccountShiroUtil.getCurrentUser().getRoleId();
		Permission p = new Permission();
		p.setUrl(url);
        List<Scope> l=scopeService.getScopesByRoleId(roles, p);
        for(Scope s:l){
        	if(s.getId()==3){
        		return true;
        	}
        }
		}
		return false;
	}
	// 获取权限下规则(是否有导入权限)
		public static boolean haveImp(String url) {
			if( AccountShiroUtil.getCurrentUser().getRoleId()!=null){
			String roles = AccountShiroUtil.getCurrentUser().getRoleId();
			Permission p = new Permission();
			p.setUrl(url);
	        List<Scope> l=scopeService.getScopesByRoleId(roles, p);
	        for(Scope s:l){
	        	if(s.getId()==5){
	        		return true;
	        	}
	        }
			}
			return false;
		}
// 获取权限下规则(是否有导出权限)
		public static boolean haveExp(String url) {
			if( AccountShiroUtil.getCurrentUser().getRoleId()!=null){
			String roles = AccountShiroUtil.getCurrentUser().getRoleId();
			Permission p = new Permission();
			p.setUrl(url);
	        List<Scope> l=scopeService.getScopesByRoleId(roles, p);
	        for(Scope s:l){
	        	if(s.getId()==6){
	        		return true;
	        	}
	        }
			}
			return false;
		}
	// 获取权限下规则(是否有编辑权限)
	public static boolean haveEdit(String url) {
		if( AccountShiroUtil.getCurrentUser().getRoleId()!=null){
		String roles = AccountShiroUtil.getCurrentUser().getRoleId();
		Permission p = new Permission();
		p.setUrl(url);
        List<Scope> l=scopeService.getScopesByRoleId(roles, p);
        for(Scope s:l){
        	if(s.getId()==4){
        		return true;
        	}
        }
		}
		return false;
	}
	// 获取权限下规则(是否有导入模板权限)
		public static boolean havemod(String url) {
			if( AccountShiroUtil.getCurrentUser().getRoleId()!=null){
				String roles = AccountShiroUtil.getCurrentUser().getRoleId();
				Permission p = new Permission();
				p.setUrl(url);
		        List<Scope> l=scopeService.getScopesByRoleId(roles, p);
		        for(Scope s:l){
		        	if(s.getId()==7){
		        		return true;
		        	}
		        }	
			}
			return false;
		}
		// 获取权限下规则(是否有审核权限)
		public static boolean haveCheck(String url) {
			if( AccountShiroUtil.getCurrentUser().getRoleId()!=null){
			String roles = AccountShiroUtil.getCurrentUser().getRoleId();
			Permission p = new Permission();
			p.setUrl(url);
	        List<Scope> l=scopeService.getScopesByRoleId(roles, p);
	        for(Scope s:l){
	        	if(s.getId()==8){
	        		return true;
	        	}
	        }
			}
			return false;
		}
	// 获取权限下 规则
	public static List<Permission> getURLPermisson(HttpServletRequest request) {
		String url=(String) request.getSession().getAttribute("url");
		String path=request.getContextPath();
		if(url==null){
			return null;
		}
		if(url.contains(path)){
			url=url.substring(url.indexOf(path)+path.length(), url.length());
		}
		List<Permission> list=new ArrayList<Permission>();
		Permission p = new Permission();
		p.setType(Permission.MENU);
		p.setUrl(url);
		List<Permission> pp=permissionService.find(p);
		if(pp!=null&&pp.size()>0){
			p=pp.get(0);
			list.add(p);
			while((p=findFatherPermisson(p))!=null){
				list.add(p);
			}
		}
		List<Permission> res=new ArrayList<Permission>();
		for(int i=list.size()-1;i>=0;i--){
			res.add(list.get(i));
		}
		return res;
	}
	
	//获得父级菜单
	private static Permission findFatherPermisson(Permission p) {
		if(p.getParent()!=null&&p.getParent().intValue()>0){
			Permission f=new Permission();
			f.setId(p.getParent());
			f=permissionService.findById(f);
			return f;
		}
		return null;
	}

	// 获取权限下 规则
	public static int getMaxScope(String url) {
		Permission p = new Permission();
		p.setUrl(url);
		String roles = AccountShiroUtil.getCurrentUser().getRoleId();
		int max=0;
		List<Scope> list=scopeService.getScopesByRoleId(roles, p);
		for(Scope s:list){
			if(Integer.valueOf(s.getValue())>max){
				max=Integer.valueOf(s.getValue());
			}
		}
		return max;
	}

	// 判断是否具有相应权限
	public static boolean isHaveRole(int id) {
		RolePermission p = new RolePermission();
		String roles = AccountShiroUtil.getCurrentUser().getRoleId();
		if (roles.indexOf(",") > 0) {
			String[] roleIds = roles.split(",");
			for (int i = 0; i < roleIds.length; i++) {
				p.setRoleId(Integer.valueOf(roleIds[i]));
				p.setPermissionId(id);
				List<RolePermission> rp = rolePermissionService.find(p);
				if (!rp.isEmpty()) {
					return true;
				}
			}
			return false;
		} else {
			p.setRoleId(Integer.valueOf(roles));
			p.setPermissionId(id);
			List<RolePermission> rp = rolePermissionService.find(p);
			return !rp.isEmpty();
		}
	}
	
	public static BaseService getService(String name) {

		try {
			return (BaseService) applicationContext.getBean(name);
		} catch (BeansException e) {
			e.printStackTrace();
		}
		return null;
	}

	// 根据id获得公司名字
	public static String getCompanyNameById(String id) {
		if (StringUtils.isNotEmpty(id) && StringUtils.isNumeric(id)) {
			Company company = new Company();
			company.setId(Integer.valueOf(id));
			company = companyService.findById(company);
			if (company != null) {
				return company.getCompanyName();
			}
		}
		return "";
	}
	
	// 根据id获得公司code
		public static String getCompanyCodeById(String id) {
			if (StringUtils.isNotEmpty(id) && StringUtils.isNumeric(id)) {
				Company company = new Company();
				company.setId(Integer.valueOf(id));
				company = companyService.findById(company);
				if (company != null) {
					return company.getCompanyCode();
				}
			}
			return "";
		}

	// 名字过长时截断
	public static String titleDispose(String str,int i) {
		//System.out.println("str= "+str);
		if(str.length()>i){
			str=str.substring(0, i)+"...";
		}
		return str;
	}
	
	public static List<DataElement> getDataElementListByInforResId(Integer id) {
		return dataElementService.getDataElementListByInforResId(id, null, null);
	}

	public static List<GovmadeDic> getDicByDicNum(String dicNum) {
		GovmadeDic dic = new GovmadeDic();
		dic.setDicNum(dicNum);
		dic.setIsDeleted(0);
		return govmadeDicService.getDicList(dic);
	}

	public static List<DataList> getDataList(Integer id) {
		DataList dl = new DataList();
		dl.setItemSortId(id);
		return dataListService.find(dl);
	}

	public static String getTitleBig(Integer id) {
		Theme dic = new Theme();
		dic.setId(id);
		dic=themeService.findById(dic);
		String TitleBig=dic.getTitleBig();
		return TitleBig;
	}
	public static String getTitleSmall(Integer id) {
		Theme dic = new Theme();
		dic.setId(id);
		dic=themeService.findById(dic);
		String TitleSmall=dic.getTitleSmall();
		return TitleSmall;
	}
	public static String getLogoBig(Integer id) {
		Theme dic = new Theme();
		dic.setId(id);
		dic=themeService.findById(dic);
		String LogoBig=dic.getLogoBig();
		return LogoBig;
	}
	public static Integer getLogoSmall(Integer id) {
		Theme dic = new Theme();
		dic.setId(id);
		dic=themeService.findById(dic);
		Integer LogoSmall=dic.getLogoSmall();
		return LogoSmall;
	}
	public static Integer getThemeType(Integer id) {
		Theme dic = new Theme();
		dic.setId(id);
		dic=themeService.findById(dic);
		Integer ThemeType=dic.getThemeType();
		return ThemeType;
	}

	public static List<GovmadeDic> getDicByNumKey(String dicNum) {
		GovmadeDic dic = new GovmadeDic();
		dic.setDicNum(dicNum);
		dic.setIsDeleted(0);
		return govmadeDicService.getDicByNumKey(dic);
	}

	public static int getcpnum(String s) {
		InformationResource info = new InformationResource();
		info.setInforTypes2(Integer.valueOf(s));
		return informationResourceService.cpcount(info).size();
	}

	public static int countCom(String s) {
		DataElement data = new DataElement();
		data.setId(Integer.valueOf(s));
		List<DataElement> da = dataElementService.countCom(data);
		if (da != null && da.size() > 0) {
			return da.size();
		} else {
			return 0;
		}
	}
	public static Date dataLatestTime(String cpId){
		return dataElementService.latestTime(Integer.valueOf(cpId));
	}
	public static Date resLatestTime(String cpId){
		return informationResourceService.latestTime(Integer.valueOf(cpId));
	}
	public static int countInfor(String s) {
		DataElement data = new DataElement();
		data.setId(Integer.valueOf(s));
		List<DataElement> da = dataElementService.countInfor(data);
		if (da != null && da.size() > 0) {
			return da.size();
		} else {
			return 0;
		}
	}

	public static int getdenum(String s, String d, String v) {
		InformationResource info = new InformationResource();
		if (!s.isEmpty()) {
			info.setValue8(s);
		}
		if (!d.isEmpty()) {
			info.setCompanyId(Integer.valueOf(d));
		}
		if (!v.isEmpty()) {
			info.setValue11(v);
		}
		return informationResourceService.datacount(info);
	}
	
	public static int getshnum(String s,String d) {
		InformationResource info = new InformationResource();
		if (!s.isEmpty()) {
			info.setId(Integer.valueOf(s));
		}
		if (!d.isEmpty()) {
			info.setCompanyId(Integer.valueOf(d));
		}
		
		return informationResourceService.sharecount(info);
	}

	public static List<GovmadeDic> getDicByDicName(String dicNum, String dicKey) {
		GovmadeDic dic = new GovmadeDic();
		dic.setDicNum(dicNum);
		dic.setDicNum(dicKey);
		return govmadeDicService.getDicList(dic);
	}

	public static String getDicValue(String dicNum, String key) {
		GovmadeDic g = new GovmadeDic();
		g.setDicNum(dicNum);
		g.setDicKey(key);
		// System.out.println(g);
		List<GovmadeDic> list = govmadeDicService.getDicTreeList(g);
		// System.out.println(list.size());
		if (list != null && list.size() > 0) {
			return list.get(0).getDicValue();
		}
		return "";
	}

	public static Object buildBean(String str) {
		try {
			String[] bs = str.split("@");
			if (bs.length == 2) {
				String beanName = bs[0];
				String vs = bs[1];
				String[] kvs = bs[1].split("&");
				Map<String, String> map = new HashMap<String, String>();
				for (String s : kvs) {
					String[] kvl = s.split("=");
					if (kvl.length == 2) {
						map.put(kvl[0], kvl[1]);
					}
				}
				return ObjectUtil.initPo(typeMap.get(beanName.toLowerCase()), map);
			} else {
				return typeMap.get(str.toLowerCase()).newInstance();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/** 
	* @Title: findServiceValue 
	* @Description: TODO(根据Service po 查找获取指定字段值) 
	* @param @param serviceName  例子ItemSortService
	* @param @param po  例子ItemSort@isDeleted=0
	* @param @param field  例子ItemSort@isDeleted=0
	* @param @return    设定文件 
	* @return Object    返回类型 
	* 2017年3月7日    日期   
	*/ 
	public static Object findServiceValue(String serviceName,String po,String field){
		List list=getService(serviceName).find(buildBean(po));
	
		if(list!=null&&list.size()>0){
			System.out.println("listsize"+list.size());
			return ObjectUtil.getFieldValueByName(field, list.get(0));
		}
		return null;
	}
	
	/** 
	* @Title: compareList 
	* @Description: TODO(数据元值比对) 
	* @param @param dataElement
	* @param @param valueNo
	* @param @return    设定文件 
	* @return Map<String,Integer>    返回类型 
	* 2017年3月24日    日期   
	*/ 
	public static Map<String,Integer> compareList(List<CleanDataElement> dataElement, int valueNo) {
		return ((CleanDataElementService)getService("CleanDataElementService")).compareList(dataElement, valueNo);
	}
	
	public static GovTable getGovTableById(String id){
		if(StringUtils.isNotEmpty(id)){
			GovTable gt=new GovTable();
			gt.setId(Integer.valueOf(id));
			return govTableService.findById(gt);
		}
		return new GovTable();
	}
	

	/** 
	* @Title: getIdsByValue 
	* @Description: TODO(根据value?的值获得数据元sourceId) 
	* @param @param list
	* @param @param fieldName
	* @param @param key
	* @param @return    设定文件 
	* @return String    返回类型 
	* 2017年3月31日    日期   
	*/ 
	public static String getDataElementIdsByValue(List<CleanDataElement> list,String fieldName,String key){
		StringBuffer ids=new StringBuffer();
		for(CleanDataElement dataElement:list){
			Object obj=ObjectUtil.getFieldValueByName(fieldName, dataElement);
			if(obj!=null&&obj.equals(key)){
				if(dataElement.getSourceId()!=null){
					ids.append(dataElement.getSourceId()).append(",");
				}else{
					DataElement d=new DataElement();
					d.setImported(1);
					d.setChName(dataElement.getChName());
					try {
						ObjectUtil.copyPo(dataElement, d, new String[]{fieldName});
					} catch (Exception e) {
						e.printStackTrace();
					}
					List<DataElement> el=dataElementService.findExactly(d);
					if(el!=null){
						for(DataElement de:el){
							ids.append(de.getId()).append(",");
						}
					}
				}
			}
		}
		if(StringUtils.isNotEmpty(ids.toString())){
			List<InformationResource> inforList=informationResourceService.getInforResByDataElementIds(StringUtil.toSQLArray(ids.toString()));
			if(inforList==null||inforList.size()==0){
				return "";
			}
		}
		return ids.toString();
	}
	
	
	
	/** 
	* @Title: getUseCount 
	* @Description: TODO(数据元使用频率) 
	* @param @return    设定文件 
	* @return List<DataElement>    返回类型 
	* 2017年4月11日    日期   
	*/ 
	public static List<DataElement> getUseCount() {
		return dataElementService.getUseCount();
	}
	
	//根据地址模糊查找
	public static int getCompanyCountByAddr(String name){
		Company c=new Company();
		c.setAddress(name);
		List<Company> list=companyService.find(c);
		return list!=null&&list.size()>0?list.size():0;
	}
	
	public static String getCompanyCountByAddrJS(String name){
		initCountMap();
		Company c=new Company();
		c.setAddress(name);
		List<Company> list=companyService.find(c);
		if(list!=null){
			JSONArray ja=new JSONArray();
			for(Company com:list){
				JSONObject jo=new JSONObject();
				jo.put("name", com.getCompanyName());
				jo.put("dataElement", dataElementCount.get(com.getId())==null?0:dataElementCount.get(com.getId()));
				jo.put("informationResource", informationCount.get(com.getId())==null?0:informationCount.get(com.getId()));
				ja.add(jo);
			}
			return ja.toString();
		}
		return "";
	}
	
	private static void initCountMap(){
		if(System.currentTimeMillis()-lastTime>2000){
			lastTime=System.currentTimeMillis();
			dataElementCount=dataElementService.getCompanyCount();
			informationCount=informationResourceService.getCompanyCount();
		}
	}
	
}
