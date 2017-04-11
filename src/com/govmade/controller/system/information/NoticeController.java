package com.govmade.controller.system.information;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.google.gson.JsonObject;
import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.RelativeDateFormat;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.poi.DataExcelUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.information.DataFile;
import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.information.Notice;
import com.govmade.entity.system.information.Subscribe;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.information.DataFileService;
import com.govmade.service.system.information.InformationBusinessService;
import com.govmade.service.system.information.InformationResourceService;
import com.govmade.service.system.information.NoticeService;
import com.govmade.service.system.information.SubscribeService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem TODO消息推送
* @date 2017年1月19日 上午9:32:08   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: NoticeController.java
* @Package com.govmade.controller.system.information
* @version V1.0   
*/
@Controller
@RequestMapping("/backstage/notice/")
public class NoticeController extends GovmadeBaseController<Notice> {
	@Autowired
	private NoticeService service;
	@Autowired
	private InformationResourceService informationResourceService;
	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public String indexURL() {
		return "/system/information/notice/index";
	}

	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map= super.getDataHandlers();
		map.put("timeCreate", new DataHandler() {
			
			@Override
			public int getMode() {
				return ADD_MODE;
			}
			
			@Override
			public Object doHandle(Object obj) {
				return RelativeDateFormat.format((Date)obj);
			}
		});
		map.put("informationResourceId", new DataHandler() {
			
			@Override
			public int getMode() {
				return ADD_MODE;
			}
			
			@Override
			public Object doHandle(Object obj) {
				InformationResource ir=new InformationResource();
				ir.setId((Integer)obj);
				ir=informationResourceService.findById(ir);
				JSONObject jo=JSONObject.fromObject(ir);
				jo.put("idForShow", SecurityUtil.encrypt(ir.getId()));
				return jo;
			}
		});
		return map;
	}

	@Override
	public void doBeforeListAjax(Notice o, HttpServletRequest req, HttpServletResponse res) {
		if(o.getAccountId()==null){
			o.setAccountId(AccountShiroUtil.getCurrentUser().getId());
		}
	}

}
