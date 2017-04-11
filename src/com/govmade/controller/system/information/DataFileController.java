package com.govmade.controller.system.information;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.google.gson.JsonObject;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.poi.DataExcelUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.information.DataFile;
import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.information.DataFileService;
import com.govmade.service.system.information.InformationBusinessService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * @author (作者) Dong Jie 154046519@qq.com
 * @Description: CitySystem 信息资源数据文件
 * @date 2017年1月16日 下午1:24:25
 * @company (开发公司) 国脉海洋信息发展有限公司
 * @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
 * @since (该版本支持的JDK版本) 1.7
 * @Title: DataFileController.java
 * @Package com.govmade.controller.system.information
 * @version V1.0
 */
@Controller
@RequestMapping("/backstage/dataFile/")
public class DataFileController extends GovmadeBaseController<DataFile> {
	@Autowired
	private DataFileService service;

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public String indexURL() {
		return null;
	}

	@RequestMapping(value = "show")
	public String show(Model model,DataFile df, HttpServletRequest req, HttpServletResponse res) throws Exception {

		if (StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
			int id = Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow")));
			df.setId(id);
		}
		df=service.findById(df);
		if(StringUtils.isEmpty(df.getShowJson())){
			List<String []> list=DataExcelUtil.excelToList(df.getRealPath());
			df.setShowJson(JSONArray.fromObject(list).toString());
			service.update(df);
		}
		model.addAttribute("json",  JSONArray.fromObject(df.getShowJson()));
		return "/system/information/dataFile/show";
	}
	
}
