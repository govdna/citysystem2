package com.govmade.controller.system.information;


import java.io.File;
import java.util.Collections;
import java.util.Comparator;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.govmade.adapter.InformationResAdapter;
import com.govmade.adapter.InformationResourceAdapter;
import com.govmade.common.ajax.AjaxRes;
import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.poi.ExcelUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.entity.system.information.InformationLog;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.data.DataListService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.InformationBusinessService;
import com.govmade.service.system.information.InformationResService;
import com.govmade.service.system.sort.SortManagerService;
import com.govmade.common.utils.SecurityUtil;


/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 最近操作信息资源
* @date 2017年2月9日 下午1:57:16   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: InformationLogController.java
* @Package com.govmade.controller.system.information
* @version V1.0   
*/
@Controller
@RequestMapping("/backstage/information/log/")
public class InformationLogController extends GovmadeBaseController<InformationLog>{

	@Autowired
	private InformationResService service;

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public String indexURL() {
		return "/system/information/log/index";
	}
	
	
}
