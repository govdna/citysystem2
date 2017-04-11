/**   
* @author (作者) Yulei 117815986@qq.com   
* @date 2017年1月9日 下午3:46:18   
* @Title: ResourceDemandController.java
* @Package com.govmade.controller.system.resources
* @version V1.0   
*/
package com.govmade.controller.system.resources;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.organization.Groups;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.entity.system.resources.ResourceDemand;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.organization.GroupsService;
import com.govmade.service.system.resources.ResourceDemandService;

/**   
* @author (作者) Yulei 117815986@qq.com   
* @Description: CitySystem TODO
* @date 2017年1月9日 下午3:46:18   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: ResourceDemandController.java
* @Package com.govmade.controller.system.resources
* @version V1.0   
*/ 
@Controller
@RequestMapping("/backstage/resourcesDemand/")
public class ResourceDemandController extends GovmadeBaseController<ResourceDemand>{

	@Autowired
	private ResourceDemandService service;
	@Autowired
	private CompanyService companyService;
	@Autowired
	private GroupsService groupsService;
	@Autowired
	private GovmadeDicService govmadeDicservice;
	
	@Override
	public BaseService getService() {
		return service;
	}

	public String indexURL() {
		return "/system/resourcesDemand/index";
	}
	
	@RequestMapping(value="index2")
	public String indexURL2(){
		return "/system/resourcesDemand/index2";
	}
	
	@Override
	public void doBeforeListAjax(ResourceDemand o, HttpServletRequest req, HttpServletResponse res) {
			List<Scope> sc=ServiceUtil.getScopesByRoleId("/backstage/resourcesDemand/index");		
			for(Scope s:sc){
				if(s.getValue().equals("1")){
					o.setResCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
			}
		}	
	}
	
	@Override
	public String index(Model model, HttpServletRequest req, HttpServletResponse res) {
		model.addAttribute("type", req.getParameter("type"));
		return super.index(model, req, res);
	}

	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map= super.getDataHandlers();
		//根据政府机构ID从政府机构中取出政府机构名字
		map.put("resCompanyId", new DataHandler() {
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
		//根据业务处室ID从业务处室中取出业务处室名字
		map.put("resGroupId", new DataHandler() {
				@Override
				public Object doHandle(Object obj) {
					Groups g=new Groups();
					g.setId((Integer)obj);	
					List<Groups> l=groupsService.find(g);		
					if(l!=null&&l.size()>0){
						return l.get(0).getName();
					}
					return "";
				}
				@Override
				public int getMode() {
					return ADD_MODE;
				}			
			});	
		map.put("resFormat", new DataHandler() {
            //信息资源格式 根据数据字典配置，通过ID读取dicvalue
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic=new GovmadeDic();
				dic.setDicNum("INFORMATIONFORMAT");
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
			map.put("updateCycle", new DataHandler() {
	             //更新周期 根据数据字典配置，通过ID读取dicvalue
				@Override
				public Object doHandle(Object obj) {
					GovmadeDic dic=new GovmadeDic();
					dic.setDicNum("UPDATECYCLE");
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
