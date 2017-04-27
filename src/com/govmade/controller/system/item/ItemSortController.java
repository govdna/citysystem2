package com.govmade.controller.system.item;

import java.io.File;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.govmade.adapter.DataElementAdapter;
import com.govmade.adapter.ItemSortAdapter;
import com.govmade.adapter.object2excel.Computer2ExcelAdapter;
import com.govmade.adapter.object2excel.ItemSort2ExcelAdapter;
import com.govmade.common.ajax.AjaxRes;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.poi.ExcelUtil;
import com.govmade.common.utils.poi.Object2ExcelUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.application.GovApplicationSystemService;
import com.govmade.service.system.data.DataListService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.item.ItemSortService;
import com.govmade.service.system.organization.CompanyService;

/**    
* @author (作者) Chenlei 774329191@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月20日 上午10:11:00   
* @Title: ItemSortController.java  
*/
@Controller
@RequestMapping("/backstage/itemSort/")
public class ItemSortController extends GovmadeBaseController<ItemSort>{

	@Autowired
	private ItemSortService service;
	
	@Autowired
	private GovmadeDicService govmadeDicservice;
	
	@Autowired
	private GovApplicationSystemService govApplicationSystemService;
	
	@Autowired
	private CompanyService companyService;
	
	@Autowired
	private DataListService dataListService;
	
	@Override
	public void doAfterInsertUpdate(ItemSort o,HttpServletRequest req, HttpServletResponse res) {
		String[] str=req.getParameterValues("applicationMaterials");
		
		int itemid=o.getId();
		DataList dl=new DataList();
		dl.setItemSortId(itemid);
		dataListService.deleteByItemSortId(dl);		
		if(str!=null&&str.length>0){
			for(String ams:str){			
				if(ams!=""&&ams.length()>0){
					dl.setApplicationMaterials(ams);
					dl.setDataElementId(0);
					dl.setDataManagerId(0);
					dl.setHouseModelId(0);
					dl.setInformationResId(0);	
					dataListService.insert(dl);	
				}
			}
		}
	}
	
	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map= super.getDataHandlers();
		map.put("serObjSort", new DataHandler() {
             //服务对象分类（serObjSort）根据数据字典配置，通过ID读取dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic=new GovmadeDic();
				dic.setDicNum("SEROBJSORT");
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
		map.put("serContent", new DataHandler() {
			//服务内容（serContent）根据数据字典配置，通过ID读取dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic=new GovmadeDic();
				dic.setDicNum("SERCONTENT");
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

		map.put("deadline", new DataHandler() {
			//服务内容（serContent）根据数据字典配置，通过ID读取dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic=new GovmadeDic();
				dic.setDicNum("DEADLINE");
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
		map.put("fileType", new DataHandler() {
			//办证文件类型（fileType）根据数据字典配置，通过ID读取dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic=new GovmadeDic();
				dic.setDicNum("FILETYPE");
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
		map.put("preApprovalMatter", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				ItemSort s=new ItemSort();
				s.setId((Integer)obj);
				List<ItemSort> l=service.find(s);
				if(l!=null&&l.size()>0){
					return l.get(0).getItemName();
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
		map.put("busSystem", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				GovApplicationSystem app=new GovApplicationSystem();
				app.setId((Integer)obj);
				List<GovApplicationSystem> l=govApplicationSystemService.find(app);
				if(l!=null&&l.size()>0){
					return l.get(0).getAppsystemName();
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
	public Map<String, DataHandler> getExcelHandlers() {
		Map<String, DataHandler> map= super.getDataHandlers();
		map.put("serObjSort", new DataHandler() {
             //服务对象分类（serObjSort）根据数据字典配置，通过ID读取dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic=new GovmadeDic();
				dic.setDicNum("SEROBJSORT");
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
		map.put("serContent", new DataHandler() {
			//服务内容（serContent）根据数据字典配置，通过ID读取dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic=new GovmadeDic();
				dic.setDicNum("SERCONTENT");
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

		map.put("deadline", new DataHandler() {
			//服务内容（serContent）根据数据字典配置，通过ID读取dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic=new GovmadeDic();
				dic.setDicNum("DEADLINE");
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
		map.put("fileType", new DataHandler() {
			//办证文件类型（fileType）根据数据字典配置，通过ID读取dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic=new GovmadeDic();
				dic.setDicNum("FILETYPE");
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
		map.put("preApprovalMatter", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				ItemSort s=new ItemSort();
				s.setId((Integer)obj);
				List<ItemSort> l=service.find(s);
				if(l!=null&&l.size()>0){
					return l.get(0).getItemName();
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
		map.put("yesorno", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				if((int) obj==1){
					return "是";
				}else if((int) obj==0){
					return "否";
				}
				return "";
			}
			@Override
			public int getMode() {
				return ADD_MODE;
			}			
		});	
		map.put("busSystem", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				GovApplicationSystem app=new GovApplicationSystem();
				app.setId((Integer)obj);
				List<GovApplicationSystem> l=govApplicationSystemService.find(app);
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

		return map;
	}
	
	@Override
	public void doBeforeListAjax(ItemSort o, HttpServletRequest req, HttpServletResponse res) {
		List<Scope> sc=ServiceUtil.getScopesByRoleId("/backstage/itemSort/index");
		//ServiceUtil.haveAdd("/backstage/itemSort/index");
		for(Scope s:sc){
			if(s.getValue().equals("1")){
				o.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
			}
		}
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public String indexURL() {
		return "/system/item/index";
	}
	
	@RequestMapping("index")
	public String index(Model model,HttpServletRequest req, HttpServletResponse res) {	
		String url=null;
	    if(req.getParameter("ids").equals("1")){
	    	url="/system/item/index";
	    }else if(req.getParameter("ids").equals("2")){
	    	url="/system/itemgroup/index";
	    }
	    return url;
	}
	@RequestMapping("downloadData")
	public ResponseEntity<byte[]> downloadData(ItemSort de,String[] xlsFields, HttpServletRequest req, HttpServletResponse response)
			throws Exception {
		de.setIsDeleted(0);
		ItemSort2ExcelAdapter adapter = new ItemSort2ExcelAdapter(service.findByPage(de,null,null), xlsFields,
				getExcelHandlers());
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

	//验证名称重复
			@RequestMapping(value="validation")
			public String validation(ItemSort o,HttpServletRequest req, HttpServletResponse res) throws Exception {
				res.setContentType("text/html;charset=utf-8");
				res.setCharacterEncoding("utf-8");		
				ItemSort it=new ItemSort();
				String itname=o.getItemName();
				it.setItemName(itname);
				String results = "";
				if (o.getId() == null) {
					if (!service.find(it).isEmpty()&&StringUtils.isNotEmpty(o.getItemName())) {
						results = "1";
					}
			} else {

					if(service.find(it).size()!=0&&StringUtils.isNotEmpty(o.getItemName())){
						if ((int) service.find(it).get(0).getId() != (int) o.getId()) {
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
			
			@RequestMapping("import")
			@ResponseBody
			public AjaxRes importItemSort(@RequestParam(value = "file", required = false) MultipartFile file, Model model,HttpServletRequest request) {
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
					DataList dl=new DataList();
					ItemSortAdapter adapter = new ItemSortAdapter();
					ExcelUtil excelUtil = new ExcelUtil(adapter);
					excelUtil.excelToList(targetFile.getAbsolutePath(),0);
					if (adapter.isError()) {
						ar.setRes(Const.FAIL);
					} else {
						try {
							for (ItemSort dm : adapter.getEntityList()) {
								service.insert(dm);
								
								if(dm.getApplicationMaterial()!=null){
									if(dm.getApplicationMaterial().indexOf("；")>0){
										String[] arr=dm.getApplicationMaterial().split("；");
										dl.setItemSortId(dm.getId());
										for(int i=0;i<arr.length;i++){
											dl.setApplicationMaterials(arr[i]);
											dataListService.insert(dl);
										}								
									}else{
										dl.setItemSortId(dm.getId());
										dl.setApplicationMaterials(dm.getApplicationMaterial());
										dataListService.insert(dl);
									}
								}								

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
