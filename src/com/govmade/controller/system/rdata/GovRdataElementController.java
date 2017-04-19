package com.govmade.controller.system.rdata;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.govmade.adapter.object2excel.DataElement2ExcelAdapter;
import com.govmade.common.mybatis.Page;
import com.govmade.common.utils.ChineseTo;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.DataHandlerUtil;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.poi.Object2ExcelUtil;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.controller.system.data.DataElementController;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.entity.system.customFields.DataElementFields;
import com.govmade.entity.system.customFields.SimpleFields;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.DataFile;
import com.govmade.entity.system.information.InformationLog;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.entity.system.memorizer.GovMemorizer;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.server.GovServer;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.repository.system.information.InformationLogDao;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.DataElementFieldsService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.dict.GovmadeDicService;
import com.govmade.service.system.information.InformationLogService;
import com.govmade.service.system.organization.CompanyService;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/backstage/govRdataElement/")
public class GovRdataElementController extends DataElementController {

	@Autowired
	private DataElementService dataElementservice;
	@Autowired
	private GovmadeDicService govmadeDicservice;
	@Autowired
	private CompanyService companyService;
	@Autowired
	private InformationLogService informationLogService;
	@Autowired
	private DataElementFieldsService dataElementFieldsService;

	@Override
	public String indexURL() {
		return "/system/rdata/index";
	}

	@RequestMapping(value = "status")
	public String status() {
		return "/system/status/index";
	}

	@RequestMapping(value = "waitToDo")
	public String waitToDo() {
		return "/system/waitToDo/dataElement/index";
	}

	@RequestMapping(value = "groups")
	public String groups() {
		return "/system/rdata/groups/index";
	}

	@Override
	public Map<String, DataHandler> getDataHandlers() {
		Map<String, DataHandler> map = super.getDataHandlers();
		map=DataHandlerUtil.buildRdataElementDataHandlers(map);
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
		map.put("status", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				if ((Integer) obj == 0) {
					return "审核成功";
				} else if ((Integer) obj == 2 || (Integer) obj == 1) {
					return "待审核";
				} else if ((Integer) obj == 3) {
					return "拒绝加入";
				} else if ((Integer) obj == 4) {
					return "注销成功";
				} else if ((Integer) obj == 5) {
					return "提出注销";
				}
				return "";
			}

			@Override
			public int getMode() {
				return ADD_MODE;
			}
		});
		
		map.put("value8", new DataHandler() {
			@Override
			public Object doHandle(Object obj) {
				
				Company c = new Company();
				c.setId(Integer.valueOf((String)obj));
				c = companyService.findById(c);
				return c.getCompanyName();
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

				if (StringUtils.isNotEmpty(id) && StringUtils.isNumeric(id)) {
					Company c = new Company();
					c.setId(Integer.valueOf(id));
					c = companyService.findById(c);
					jo.put("companyIdForShow", c.getCompanyName());

				} else {
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

	private Map<String, DataHandler> getExcelHandler() {
		Map<String, DataHandler> map = new HashMap<String, DataHandler>();
		List<DataElementFields> list = dataElementFieldsService.find(new DataElementFields());
		for (final DataElementFields sf : list) {
			map.put("value" + sf.getValueNo(), new DataHandler() {

				@Override
				public int getMode() {
					return ADD_MODE;
				}

				@Override
				public Object doHandle(Object obj) {
					if (sf.getInputType().equals("2")) {
						return ServiceUtil.getDicValue(sf.getInputValue(), (String) obj);
					} else if (sf.getInputType().equals("3")) {
						List<ItemSort> ls = ServiceUtil.getService("ItemSortService")
								.find(ServiceUtil.buildBean("ItemSort@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getItemName();
						}
					} else if (sf.getInputType().equals("5")) {
						List<Company> ls = ServiceUtil.getService("CompanyService")
								.find(ServiceUtil.buildBean("Company@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getCompanyName();
						}
					} else if (sf.getInputType().equals("7")) {
						List<GovServer> ls = ServiceUtil.getService("GovServerService")
								.find(ServiceUtil.buildBean("GovServer@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					} else if (sf.getInputType().equals("8")) {
						List<GovMemorizer> ls = ServiceUtil.getService("GovMemorizerService")
								.find(ServiceUtil.buildBean("GovMemorizer@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					} else if (sf.getInputType().equals("9")) {
						List<GovComputerRoom> ls = ServiceUtil.getService("GovComputerRoomService")
								.find(ServiceUtil.buildBean("GovComputerRoom@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					} else if (sf.getInputType().equals("10")) {
						List<GovApplicationSystem> ls = ServiceUtil.getService("GovApplicationSystemService")
								.find(ServiceUtil.buildBean("GovApplicationSystem@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					} else if (sf.getInputType().equals("12")) {
						List<GovDatabase> ls = ServiceUtil.getService("GovDatabaseService")
								.find(ServiceUtil.buildBean("GovDatabase@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue2();
						}
					} else if (sf.getInputType().equals("13")) {
						List<GovTable> ls = ServiceUtil.getService("GovTableService")
								.find(ServiceUtil.buildBean("GovTable@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					} else if (sf.getInputType().equals("14")) {
						List<GovTableField> ls = ServiceUtil.getService("GovTableFieldService")
								.find(ServiceUtil.buildBean("GovTableField@isDeleted=0&id=" + (String) obj));
						if (ls != null && ls.size() > 0) {
							return ls.get(0).getValue1();
						}
					}
					return obj;
				}
			});
		}
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
		List<DataElement> fail = new ArrayList<DataElement>();
		if (StringUtils.isNotEmpty(ids)) {
			String[] id = ids.split(",");
			for (String str : id) {
				if (StringUtils.isNotEmpty(str) && StringUtils.isNumeric(str)) {
					int dId = Integer.valueOf(str);
					DataElement d = new DataElement();
					d.setId(dId);
					d = dataElementservice.findById(d);
					List<DataElement> list = dataElementservice.getChild(d);
					int fid = dataElementservice.copyDataElement(d, null, companyId, groupId);
					if (fid == 0) {
						fail.add(d);
						fail.addAll(list);
					} else {
						if (list != null && list.size() > 0) {
							for (DataElement de : list) {
								int r = dataElementservice.copyDataElement(de, fid, companyId, groupId);
								if (r == 0) {
									fail.add(de);
								}
							}
						}
					}
				}
			}
		}
		if (fail.size() > 0) {
			ar.put("rows", DataHandlerUtil.buildJson(fail, getDataHandlers(), true));
			ar.put("total", fail.size());
			ar.put("code", Const.FAIL);
		} else {
			ar.put("code", Const.SUCCEED);
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	@Override
	public void doBeforeInsertUpdate(DataElement o, HttpServletRequest req, HttpServletResponse res) {
		o.setType(1);
		o.setClassType(getClassType());
		dataElementservice.setIdentifier(o);
		o.setStatus(0);
		// 和父数据元标识符保持一致
		if (o.getFatherId() != null) {
			DataElement fd = new DataElement();
			fd.setId(o.getFatherId());
			fd = dataElementservice.findById(fd);
			o.setIdentifier(fd.getIdentifier());
		} else {
			dataElementservice.updateChildIdentifier(o);
		}

	}

	/**
	 * @Title: doAfterInsertUpdate @Description:
	 *         TODO(处理插入和修改之后的操作可以写在此方法) @param @param o 设定文件 @return void
	 *         返回类型 @throws
	 */
	public void doAfterInsertUpdate(DataElement o, HttpServletRequest req, HttpServletResponse res) {
		if (o.getDataElementId() != null && o.getDataElementId() != "") {
			String[] id = o.getDataElementId().split(",");
			for (String x : id) {
				if (x.length() > 0) {
					DataElement t = new DataElement();
					t.setId(Integer.valueOf(x));
					DataElement ment2 = (DataElement) getService().findById(t);
					if (ment2.getDataElementId() != null && ment2.getDataElementId() != "") {
						ment2.setDataElementId(ment2.getDataElementId() + "," + o.getId());
					} else {
						ment2.setDataElementId(o.getId() + "");
					}
					getService().update(ment2);
				}
			}
		}
	}

	@RequestMapping(value = "statusAll")
	public String statusAll(HttpServletRequest req, HttpServletResponse res) throws Exception {
		JSONObject ar = new JSONObject();
		try {

			dataElementservice.statusAll();

			ar.put("code", Const.SUCCEED);
			ar.put("msg", Const.ACTION_SUCCEED);
		} catch (Exception e) {
			ar.put("code", Const.FAIL);
			ar.put("msg", Const.ACTION_FAIL);
			e.printStackTrace();
		}
		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	// 审核
	@RequestMapping(value = "toStatus")
	public String toStatus(HttpServletRequest req, HttpServletResponse res) throws Exception {
		DataElement rdataElement = new DataElement();
		String sid = req.getParameter("sid");
		String s = req.getParameter("status");
		String r = req.getParameter("reason");

		String[] ids = sid.split(",");

		for (int i = 0; i < ids.length; i++) {
			if (!StringUtils.isEmpty(ids[i])) {
				rdataElement.setId(Integer.valueOf(ids[i]));
				rdataElement.setStatus(Integer.valueOf(s));
				rdataElement.setReason(r);
				// rdataElement.setClassType(1);
				dataElementservice.toStatus(rdataElement);
				// 父类审核状态 同步到子类
				DataElement fd = new DataElement();
				fd.setFatherId(rdataElement.getId());
				// System.out.println(rdataElement.getId()+"id________");
				List<DataElement> list = dataElementservice.find(fd);
				if (list != null && list.size() > 0) {
					for (DataElement d : list) {
						// System.out.println(d);

						d.setStatus(rdataElement.getStatus());
						dataElementservice.toStatus(d);
					}
				}
			}
		}
		return null;
	}

	// 验证名称重复
	@RequestMapping(value = "validation")
	public String validation(DataElement o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		DataElement de = new DataElement();
		if (!dataElementservice.volidate(o)) {
			ar.put("results", 1);
			de.setChName(o.getChName());
			//ar.put("show", SecurityUtil.encrypt(dataElementservice.findByName(de).get(0).getId()));
			ar.put("show", DataHandlerUtil.buildJson(dataElementservice.findByName(de), getDataHandlers(), true).toString());
			// ar.put("egName", "");
		} else {
			String pinyin = ChineseTo.getPinYinHeadChar(o.getChName());
			String egname = pinyin.toUpperCase();
			ar.put("results", 0);
			// ar.put("show", "0");
			ar.put("egName", egname);
		}

		res.getWriter().write(ar.toString());
		res.getWriter().flush();
		res.getWriter().close();
		return null;
	}

	@Override
	public void doBeforeListAjax(DataElement o, HttpServletRequest req, HttpServletResponse res) {
		String st = req.getParameter("st");
		String statuses = req.getParameter("statuses");
		if (statuses != null && statuses != "") {
			o.setStatus(123);
			o.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
		}
		if (st != null && st != "") {
			o.setStatus(123);
		}
		super.doBeforeListAjax(o, req, res);
	}

	@Override
	public int getClassType() {
		return 1;
	}

	@RequestMapping(value = "checkDataElementByIRId")
	public String checkDataElementByIRId(DataList o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		List<DataElement> list = new ArrayList<DataElement>();
		if (o.getDataManagerId() == null && o.getInformationResId() == null) {

		} else {
			list = dataElementservice.getDataElementListByDataList(o);
		}
		boolean allIn = true;
		List<DataElement> result = new ArrayList<DataElement>();
		for (DataElement d : list) {
			if (d.getImported() != null && d.getImported().intValue() == 1) {
				DataElement f = new DataElement();
				f.setSourceId(d.getId());
				List<DataElement> re = dataElementservice.find(f);
				if (re != null && re.size() > 0) {
					d = re.get(0);
					d.setImported(1);
				}else{
					DataElement de=new DataElement();
					de.setChName(d.getChName());
					de.setClassType(1);
					List<DataElement> dl=dataElementservice.findByName(de);
					if(dl!=null&&dl.size()>0){
						d=dl.get(0);
						d.setImported(1);
					}
				}
			} else {
				DataElement de=new DataElement();
				de.setChName(d.getChName());
				de.setClassType(1);
				List<DataElement> dl=dataElementservice.findByName(de);
				if(dl!=null&&dl.size()>0){
					d=dl.get(0);
					d.setImported(1);
				}else{
					allIn = false;
				}
			}
			result.add(d);
		}
		if (!allIn) {
			InformationLog il = new InformationLog();
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

	
	@RequestMapping(value = "getDataElementListByTableId")
	public String getDataElementListByTableId(GovTable o, HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("text/html;charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject ar = new JSONObject();
		List<DataElement> list = dataElementservice.getDataElementListByTableId(o);
		try {
			ar.put("rows", DataHandlerUtil.buildJson(list, getDataHandlers(), true));
			ar.put("total", list.size());
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
	public void doWithDelete(DataElement o, HttpServletRequest req, HttpServletResponse res) {
		DataElement d = dataElementservice.findById(o);
		if (d.getSourceId() != null) {
			dataElementservice.clearImported(d);
		}
	}

	@RequestMapping("downloadData")
	public ResponseEntity<byte[]> downloadData(String[] xlsFields, HttpServletRequest req, HttpServletResponse response)
			throws Exception {
		DataElement de = new DataElement();
		de.setClassType(getClassType());
		DataElement2ExcelAdapter adapter = new DataElement2ExcelAdapter(dataElementservice.find(de), xlsFields,
				getExcelHandler());
		Object2ExcelUtil util = new Object2ExcelUtil(adapter);
		String path = req.getSession().getServletContext().getRealPath("upload/excel");
		String fileName = "导出数据.xls";
		String icon = System.currentTimeMillis() + "/";
		String fullPath = path + "/" + icon + fileName;
		File targetFile = new File(path + "/" + icon);
		if (!targetFile.exists()) {
			targetFile.mkdirs();
		}
		util.object2Excel(fullPath);

		HttpHeaders headers = new HttpHeaders();
		String fn = new String(fileName.getBytes("UTF-8"), "iso-8859-1");// 为了解决中文名称乱码问题
		headers.setContentDispositionFormData("attachment", fn);
		headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
		return new ResponseEntity<byte[]>(FileUtils.readFileToByteArray(new File(fullPath)), headers,
				HttpStatus.CREATED);
	}
}
