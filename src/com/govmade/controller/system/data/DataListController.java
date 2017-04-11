package com.govmade.controller.system.data;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.data.DataListService;

import net.sf.json.JSONObject;

/**
 * @author (作者) Zhanglu 274059078@qq.com
 * @Description: CitySystem TODO
 * @date 2016年12月8日 下午1:21:27
 * @Title: DataListController.java
 */

@Controller
@RequestMapping("/backstage/dataList/")
public class DataListController extends GovmadeBaseController<DataList>{

	@Autowired
	private DataListService service;
	@Autowired
	private DataElementService dataElementService;
	
	@Override
	public String indexURL() {
		return "/system/dataList/index";
	}

	@Override
	public BaseService getService() {
		return service;
	}

	@RequestMapping(value="getAmJsonByIsId")
	public String getAmJsonByIsId(DataList o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		List<DataList> amList= service.find(o);
		String n="";
		for(int i=0;i<amList.size();i++){
			if(i<amList.size()-1){
				n+="\""+amList.get(i).getApplicationMaterials()+"\",";
			}else{
				n+="\""+amList.get(i).getApplicationMaterials()+"\"";
			}
		}		
		String str="{\"applicationMaterials\":["+n+"],\"jsonsize\":["+amList.size()+"]}";
		res.getWriter().write(str);
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	@RequestMapping(value="isUse")
	public String isUse(HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		DataList dataList=new DataList();
		DataElement dataElement=new DataElement();
		JSONObject ar = new JSONObject();
		String errName="";
		String dataElementId=req.getParameter("dataElementId");
		
		dataElementId=StringUtil.toSQLArray(dataElementId);
		dataElementId=StringUtil.toSQLStr(dataElementId);
		
		String[] arr=dataElementId.split(",");
		for(String str:arr){
			if(str!=null && str.length()>0){
				
				dataList.setDataElementId(Integer.valueOf(str));
				List<DataList> dl=service.find(dataList);
				if(dl!=null&&dl.size()>0){
					dataElement.setId(Integer.valueOf(str));
					errName=errName+dataElementService.findById(dataElement).getValue1()+",";
				}
				
			}
		}

		if(errName!=""){
			ar.put("code", "1");
			ar.put("errName", StringUtil.toSQLArray(errName));
		}else{
			ar.put("code", "0");
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}
	
}
