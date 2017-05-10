package com.govmade.controller.system.data;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.ChineseTo;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.controller.system.data.DataElementController;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationLog;
import com.govmade.entity.system.organization.Company;
import com.govmade.repository.system.information.InformationLogDao;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.InformationLogService;
import com.govmade.service.system.organization.CompanyService;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/backstage/sysDataElement/")
public class SysDataElementController extends DataElementController {

	@Autowired
	private DataElementService dataElementservice;
	@Autowired
	private GovmadeDicService govmadeDicservice;
	@Autowired
	private CompanyService companyService;
	@Autowired
	private InformationLogService informationLogService;
	
	@Override
	public String indexURL() {
		return "/system/sdata/index";
	}
	@RequestMapping(value = "business")
	public String business() {
		return "/system/bdata/index";
	}

	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map = super.getDataHandlers();
		map.put("dataType", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic = new GovmadeDic();
				dic.setDicNum("DATATYPE");
				dic.setDicKey((Integer) obj + "");
				List<GovmadeDic> l = govmadeDicservice.getDicList(dic);
				if (l != null && l.size() > 0) {
					return l.get(0).getDicValue();
				}
				return "";
			}

			@Override
			public int getMode() {
				return ADD_MODE;
			}
		});
		map.put("objectType", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				GovmadeDic dic = new GovmadeDic();
				dic.setDicNum("OBJECTTYPE");
				dic.setDicKey((Integer) obj + "");
				List<GovmadeDic> l = govmadeDicservice.getDicList(dic);
				if (l != null && l.size() > 0) {
					return l.get(0).getDicValue();
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
				
				return null;
			}

			@Override
			public void doHandle(Object bo, JSONObject jo) {
				String id = (String) ObjectUtil.getFieldValueByName("value8", bo);
				Integer cid = (Integer) ObjectUtil.getFieldValueByName("companyId", bo);
				
				if(StringUtils.isNotEmpty(id)&&StringUtils.isNumeric(id)){
					Company c = new Company();
					c.setId(Integer.valueOf(id));
					c = companyService.findById(c);
					jo.put("companyIdForShow", c.getCompanyName());
					
				}else{
					jo.put("companyIdForShow", "");
					
				}
				jo.put("companyId", cid);
				
			}

			@Override
			public int getMode() {
				return FREEDOM_MODE;
			}
		});

		return map;
	}

	@RequestMapping(value = "insertList", method = RequestMethod.POST)
	public String insertList(HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		String ids = req.getParameter("ids");
		Integer companyId = AccountShiroUtil.getCurrentUser().getCompanyId();
		Integer groupId = AccountShiroUtil.getCurrentUser().getGroupId();
		JSONObject ar = new JSONObject();
		String stips = "";
		String ftips = "";
		List<DataElement> fail=new ArrayList<DataElement>();
		if (StringUtils.isNotEmpty(ids)) {
			String [] id=ids.split(",");
			for(String str:id){
				if(StringUtils.isNotEmpty(str)&&StringUtils.isNumeric(str)){
					int dId=Integer.valueOf(str);
					DataElement d=new DataElement();
					d.setId(dId);
					d=dataElementservice.findById(d);
					List<DataElement> list=dataElementservice.getChild(d);
					int fid=dataElementservice.copyDataElement(d,null,companyId,groupId);
					System.out.println("fid= "+fid);
					if(fid==0){
						fail.add(d);
						fail.addAll(list);
					}else{
						if(list!=null&&list.size()>0){
							for(DataElement de:list){
								int r=dataElementservice.copyDataElement(de,fid,companyId,groupId);
								System.out.println("r= "+r);
								if(r==0){
									fail.add(de);
								}
							}
						}
					}
				}
			}
		}
		if(fail.size()>0){
			ar.put("rows", DataHandlerUtil.buildJson(fail, getDataHandlers(), true));
			ar.put("total", fail.size());
			ar.put("code", Const.FAIL);
		}else{
			ar.put("code", Const.SUCCEED);
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	@Override
	public void doBeforeInsertUpdate(DataElement o, HttpServletRequest req, HttpServletResponse res) {
		String sys = req.getParameter("sys");
		if (sys != null && sys != "") {
			o.setSystemType(Integer.valueOf(sys));
		}
		String type = req.getParameter("type");
		if (type != null && type != "") {
			o.setSystemType(Integer.valueOf(type));
		}
		
		String objectType = o.getObjectType() + "";
		while (objectType.length() < 2) {
			objectType = "0" + objectType;
		}

		String i = dataElementservice.maxIdentifier(o);
		if (i != null && i != "") {
			i = Integer.valueOf(i.substring(2, 7)) + 1 + "";
			while (i.length() < 5) {
				i = "0" + i;
			}
		} else {
			i = "00001";
		}

		if (o.getId() == null) {
			o.setIdentifier(objectType + i);
		} else {
			if (!objectType.equals(o.getIdentifier().substring(0, 2))) {
				o.setIdentifier(objectType + i);
			}
		}
		o.setClassType(1);
	}

	
	// 验证名称重复
	@RequestMapping(value = "validation")
	public String validation(DataElement o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		
		if (!dataElementservice.volidate(o)) {
			ar.put("results", 1);
			//ar.put("egName", "");
		}else{
			String pinyin = ChineseTo.getPinYinHeadChar(o.getChName());
			String egname = pinyin.toUpperCase();
			ar.put("results", 0);
			ar.put("egName", egname);
		}

		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;

	}

	@Override
	public void doBeforeListAjax(DataElement o, HttpServletRequest req, HttpServletResponse res) {
		String sys = req.getParameter("sys");
		if (sys != null && sys != "") {
			o.setSystemType(Integer.valueOf(sys));
		}
		String type = req.getParameter("type");
		if (type != null && type != "") {
			o.setSystemType(Integer.valueOf(type));
		}
		super.doBeforeListAjax(o, req, res);
	}


	@RequestMapping(value="checkDataElementByIRId")
	public String checkDataElementByIRId(DataList o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();	
		List<DataElement> list=new ArrayList<DataElement>();
		if(o.getDataManagerId()==null&&o.getInformationResId()==null){
			
		}else{
			list=dataElementservice.getDataElementListByDataList(o);
		}
		boolean allIn=true;
		List<DataElement> result=new ArrayList<DataElement>();
		for(DataElement d:list){
			if(d.getImported()!=null&&d.getImported().intValue()==1){
				DataElement f=new DataElement();
				f.setSourceId(d.getId());
				List<DataElement> re=dataElementservice.find(f);
				if(re!=null&&re.size()>0){
					d=re.get(0);
					d.setImported(1);
				}
			}else{
				allIn=false;
			}
			result.add(d);
		}
		if(!allIn){
			InformationLog il=new InformationLog();
			il.setInformationId(o.getInformationResId());
			il.setAccountId(AccountShiroUtil.getCurrentUser().getId());
			informationLogService.insert(il);
		}
		try {
			ar.put("rows", DataHandlerUtil.buildJson(result, getDataHandlers(), true));
			ar.put("total", result.size());
			ar.put("code", Const.SUCCEED);
		} catch (Exception e) {
			ar.put("code", Const.FAIL);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	@Override
	public int getClassType() {
		return 1;
	}


}
