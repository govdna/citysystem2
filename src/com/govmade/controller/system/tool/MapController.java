package com.govmade.controller.system.tool;

import java.io.UnsupportedEncodingException;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.utils.base.Const;
import com.govmade.controller.base.BaseController;
@Controller
@RequestMapping("/backstage/tool/map/")
public class MapController extends BaseController<Object>{

	
	@RequestMapping("index")	
	public String index(Model model) throws UnsupportedEncodingException{
		if(doSecurityIntercept(Const.RESOURCES_TYPE_MENU)){
			return "/system/tool/map/list";
		}
		return Const.NO_AUTHORIZED_URL;	
	}
}
