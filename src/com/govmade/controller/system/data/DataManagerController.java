/**   
* @author (作者) Yulei 117815986@qq.com   
* @date 2016年12月8日 下午2:26:08   
* @Title: DataManagerController.java
* @Package com.govmade.controller.system.data
* @version V1.0   
*/
package com.govmade.controller.system.data;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataManager;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.DataManagerService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.InformationResourceService;

import net.sf.json.JSONObject;

/**   
* @author (作者) Yulei 117815986@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月8日 下午2:26:08   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: DataManagerController.java
* @Package com.govmade.controller.system.data
* @version V1.0   
*/
@Controller
@RequestMapping("/backstage/dataManager/")
public class DataManagerController extends GovmadeBaseController<DataManager>{

	@Autowired
	private DataManagerService service;
	
	@Autowired
	private GovmadeDicService govmadeDicservice;

	@Autowired
	private InformationResourceService informationResourceService;
	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map= super.getDataHandlers();
		map.put("dataType", new DataHandler() {
         //s数据字典中读取数据类型
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
		map.put("sortManagerId", new DataHandler() {
	         //s数据字典中读取数据类型
				@Override
				public Object doHandle(Object obj) {
					
					return "";
				}
				
				@Override
				public void doHandle(Object bo, JSONObject jo) {
					Integer obj=(Integer)ObjectUtil.getFieldValueByName("sortManagerId", bo);
					jo.put("sortManagerId", obj);
					GovmadeDic dic=new GovmadeDic();
					dic.setDicNum("ORIGNDATATYPE");
					dic.setDicKey((Integer)obj+"");			
					List<GovmadeDic> l=govmadeDicservice.getDicTreeList(dic)	;
					if(l!=null&&l.size()>0){
						jo.put("sortManagerIdForShow",  l.get(0).getFatherId());
						jo.put("sortManagerIdValue",  l.get(0).getDicValue());
					}
					
				}

				@Override
				public int getMode() {
					return FREEDOM_MODE;
				}
				
			});
		
		return map;
	}
	
	@Override
	public void doBeforeInsertUpdate(DataManager o, HttpServletRequest req, HttpServletResponse res) {
		if(o.getValueNo()!=null){
			return;
		}
		List<DataManager> dmList=service.find(new DataManager());
		for(int i=1;i<=30;i++){
			boolean used=false;
			for(DataManager dm:dmList){
				if(dm.getValueNo()!=null&&dm.getValueNo().intValue()==i){
					used=true;
					break;
				}
			}
			if(!used){
				o.setValueNo(i);
				return;
			}
		}
	}

	@Override
	public String deleteAjax(DataManager o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		DataManager dm=service.findById(o);
		if(dm.getValueNo()!=null){
			informationResourceService.clearColumn(dm.getValueNo());
		}
		return super.deleteAjax(o, req, res);
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public String indexURL() {
		return "/system/dataManager/index";
	}
	
	//验证名称重复
	@RequestMapping(value="validation")
	public String validation(DataManager o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");		
		DataManager de=new DataManager();
		String dname=o.getDataName();
		de.setDataName(dname);
		String results = "";
		if (o.getId() == null) {
			if (!service.find(de).isEmpty()&&StringUtils.isNotEmpty(o.getDataName())) {
				results = "1";
			}
	} else {
			if(service.find(de).size()!=0&&StringUtils.isNotEmpty(o.getDataName())){
				if ((int) service.find(de).get(0).getId() != (int) o.getId()) {
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
	
}
