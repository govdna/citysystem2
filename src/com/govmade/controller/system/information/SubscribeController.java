package com.govmade.controller.system.information;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.google.gson.JsonObject;
import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.poi.DataExcelUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.information.DataFile;
import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.information.Subscribe;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.information.DataFileService;
import com.govmade.service.system.information.InformationBusinessService;
import com.govmade.service.system.information.InformationResourceService;
import com.govmade.service.system.information.SubscribeService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * @author (作者) Dong Jie 154046519@qq.com
 * @Description: CitySystem 信息资源订阅
 * @date 2017年1月18日 下午2:09:10
 * @company (开发公司) 国脉海洋信息发展有限公司
 * @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
 * @since (该版本支持的JDK版本) 1.7
 * @Title: SubscribeController.java
 * @Package com.govmade.controller.system.information
 * @version V1.0
 */
@Controller
@RequestMapping("/backstage/subscribe/")
public class SubscribeController extends GovmadeBaseController<Subscribe> {
	@Autowired
	private SubscribeService service;
	@Autowired
	private InformationResourceService informationResourceService;

	@Override
	public BaseService getService() {
		return service;
	}

	@Override
	public String indexURL() {
		return "/system/information/subscribe/index";
	}

	@Override
	public void doBeforeInsertUpdate(Subscribe o, HttpServletRequest req, HttpServletResponse res) {
		if (o.getAccountId() == null) {
			o.setAccountId(AccountShiroUtil.getCurrentUser().getId());
		}
	}

	@Override
	public boolean insertAjaxIntercept(Subscribe o, HttpServletRequest req, HttpServletResponse res) {
		try {
			List list = service.find(o);
			if (list != null && list.size() > 0) {
				JSONObject ar = new JSONObject();
				ar.put("code", Const.SUCCEED);
				res.getWriter().write(ar.toString());
				res.getWriter().flush();
				res.getWriter().close();
				return true;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return false;
	}

	// 取消订阅
	@RequestMapping(value = "deleteSubscribe")
	public String deleteSubscribe(Subscribe subscribe, HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		try {
			subscribe.setAccountId(AccountShiroUtil.getCurrentUser().getId());
			List<Subscribe> list = service.find(subscribe);
			if (list != null) {
				service.delete(list.get(0));
			}
			ar.put("msg", "操作成功!");
			ar.put("code", Const.SUCCEED);
		} catch (Exception e) {
			ar.put("msg", "操作失败！");
			ar.put("code", Const.FAIL);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

}
