package com.govmade.controller.system.theme;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.utils.DataHandler;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.theme.Theme;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.item.ItemSortService;
import com.govmade.service.system.theme.ThemeService;

/**   
* @author (作者) Chenlei 774329191@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月28日 上午10:06:05   
* @Title: ThemeController.java  
*/
@Controller
@RequestMapping("/backstage/theme/")
public class ThemeController extends GovmadeBaseController<Theme>{

	@Autowired
	private ThemeService service;
	
	@Autowired
	private GovmadeDicService govmadeDicservice;
	
	@Override
	public BaseService getService() {
		return service;
	}
	
	@Override
	public String indexURL() {
		return "/system/theme/index";
	}
	
	@RequestMapping("index")
	public String index(Model model, HttpServletRequest req, HttpServletResponse res) {
		String url = null;
		// 根据type分成三个页面
		if (req.getParameter("type").equals("1")) {
			url = "/system/theme/index";
		} else if (req.getParameter("type").equals("2")) {
			url = "/system/modulename/index";
		}
		// System.out.println(url);
		return url;
	}
	
	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map= super.getDataHandlers();
		map.put("themeType", new DataHandler() {
             //服务对象分类（serObjSort）根据数据字典配置，通过ID读取dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic=new GovmadeDic();
				dic.setDicNum("STYLE");
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
		
		return map;
	}
	
}
