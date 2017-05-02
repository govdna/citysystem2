package com.govmade.controller.system.echart;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.mybatis.PageInterceptor;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.StringUtil;
import com.govmade.common.utils.db.DbConfig;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.information.SearchLog;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.server.GovServer;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.data.DataElementService;
import com.govmade.service.system.database.GovDatabaseService;
import com.govmade.service.system.information.InformationResService;
import com.govmade.service.system.information.InformationResourceService;
import com.govmade.service.system.information.SearchLogService;
import com.govmade.service.system.organization.CompanyService;
import com.govmade.service.system.server.GovServerService;
import com.govmade.service.system.sort.SortManagerService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/backstage/echart/")
public class EchartController extends GovmadeBaseController<GovComputerRoom>{
	public static String dburl = DbConfig.getString("jdbc.mysql.url");
	public static String driver = DbConfig.getString("jdbc.mysql.driver");
	public static String user = DbConfig.getString("jdbc.mysql.username");
	public static String pwd = DbConfig.getString("jdbc.mysql.password");
	@Autowired
	private DataElementService dataElementService;
	@Autowired
	private CompanyService companyservice;
	@Autowired
	private GovServerService govServerService;
	@Autowired
	private GovDatabaseService govDatabaseService;
	@Autowired
	private InformationResourceService informationResourceService;
	@Autowired
	private InformationResService informationResService;
	@Autowired
	private SearchLogService searchLogService;
	@Autowired
	private SortManagerService sortManagerService;
	@Autowired
	private InformationResService inforService;
	@Override
	public BaseService getService() {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public String indexURL() {
		// TODO Auto-generated method stub
		return null;
	}
	/**
	 * 
	 * @param ja
	 *            json数组
	 * @param field
	 *            要排序的key
	 * @param isAsc
	 *            是否升序
	 */
	private static void sort(JSONArray ja, final String field, boolean isAsc) {
		Collections.sort(ja, new Comparator<JSONObject>() {
			@Override
			public int compare(JSONObject o1, JSONObject o2) {
				Object f1 = o1.get(field);
				Object f2 = o2.get(field);
				if (f1 instanceof Number && f2 instanceof Number) {
					return ((Number) f1).intValue() - ((Number) f2).intValue();
				} else {
					return f1.toString().compareTo(f2.toString());
				}
			}
		});
		if (!isAsc) {
			Collections.reverse(ja);
		}
	}
	@RequestMapping(value="statistics")
	public String statistics(HttpServletRequest req,Model model) {
		String index = req.getParameter("index");
		Connection conn = null;
		Statement stmt = null;
		int option = Integer.valueOf(index);
		switch(option){
		case 0:
			try {
				Class.forName(driver);
				conn = (Connection) DriverManager.getConnection(dburl,user, pwd);	
				stmt = (Statement) conn.createStatement();				
				//注入sql语句
				String sql ="SELECT\n" +
						"  icount,\n" +
						"  dcount,\n" +
						"  bcount,\n" +
						"  tcount,\n" +
						"  t1.cname,\n" +
						"  t1.cid\n" +
						"FROM\n" +
						"  (\n" +
						"    SELECT\n" +
						"      count(gov_data_element.id) dcount,\n" +
						"      gov_company.company_name cname,\n" +
						"      gov_company.id cid\n" +
						"    FROM\n" +
						"      gov_company\n" +
						"    LEFT JOIN gov_data_element ON gov_data_element.value8 = gov_company.id\n" +
						"    AND gov_data_element.isDeleted = 0\n" +
						"    AND gov_data_element.class_type = 1\n" +
						"    WHERE\n" +
						"      gov_company.isDeleted = 0\n" +
						"    GROUP BY\n" +
						"      gov_company.id,\n" +
						"      gov_company.company_name\n" +
						"    ORDER BY\n" +
						"      gov_company.id ASC\n" +
						"  ) t1\n" +
						"JOIN (\n" +
						"  SELECT\n" +
						"    count(\n" +
						"      gov_information_resource_main.id\n" +
						"    ) icount,\n" +
						"    gov_company.company_name cname\n" +
						"  FROM\n" +
						"    gov_company\n" +
						"  LEFT JOIN gov_information_resource_main ON gov_information_resource_main.value3 = gov_company.id\n" +
						"  AND gov_information_resource_main.status = 0\n" +
						"  AND gov_information_resource_main.isDeleted = 0\n" +
						"  WHERE\n" +
						"    gov_company.isDeleted = 0\n" +
						"  GROUP BY\n" +
						"    gov_company.id,\n" +
						"    gov_company.company_name\n" +
						"  ORDER BY\n" +
						"    gov_company.id ASC\n" +
						") t2 ON  t1.cname = t2.cname\n" +
						"JOIN (\n" +
						"  SELECT\n" +
						"    count(\n" +
						"      gov_information_resource_main.id\n" +
						"    ) bcount,\n" +
						"    gov_company.company_name cname\n" +
						"  FROM\n" +
						"    gov_company\n" +
						"  LEFT JOIN gov_information_resource_main ON gov_information_resource_main.value3 = gov_company.id\n" +
						"  AND gov_information_resource_main.status = 0\n" +
						"  AND gov_information_resource_main.inforTypes = 1\n" +
						"  AND gov_information_resource_main.isDeleted = 0\n" +
						"  WHERE\n" +
						"    gov_company.isDeleted = 0\n" +
						"  GROUP BY\n" +
						"    gov_company.id,\n" +
						"    gov_company.company_name\n" +
						"  ORDER BY\n" +
						"    gov_company.id ASC\n" +
						") t3  ON  t2.cname = t3.cname\n" +
						"JOIN (\n" +
						"  SELECT\n" +
						"    count(\n" +
						"      gov_information_resource_main.id\n" +
						"    ) tcount,\n" +
						"    gov_company.company_name cname\n" +
						"  FROM\n" +
						"    gov_company\n" +
						"  LEFT JOIN gov_information_resource_main ON gov_information_resource_main.value3 = gov_company.id\n" +
						"  AND gov_information_resource_main.status = 0\n" +
						"  AND gov_information_resource_main.inforTypes = 2\n" +
						"  AND gov_information_resource_main.isDeleted = 0\n" +
						"  WHERE\n" +
						"    gov_company.isDeleted = 0\n" +
						"  GROUP BY\n" +
						"    gov_company.id,\n" +
						"    gov_company.company_name\n" +
						"  ORDER BY\n" +
						"    gov_company.id ASC\n" +
						") t4  ON  t3.cname = t4.cname\n" +
						"where\n" +
						"  t1.dcount > 0\n" +
						"  OR t3.bcount > 0\n" +
						"  OR t2.icount > 0\n" +
						"  OR t4.tcount > 0\n" +
						"GROUP BY\n" +
						"  t1.cname,  icount,\n" +
						"  dcount,\n" +
						"  bcount,\n" +
						"  tcount,\n" +
						"  t1.cid\n" +
						"ORDER BY\n" +
						"  icount DESC";
				ResultSet rs = stmt.executeQuery(sql);
				JSONObject json = new JSONObject();
				JSONArray jsa = new JSONArray();
				while (rs.next()) {	
					json.put("icount", rs.getString(1));
					json.put("dcount", rs.getString(2));
					json.put("bcount", rs.getString(3));
					json.put("tcount", rs.getString(4));
					json.put("cname", rs.getString(5));
					json.put("cid", rs.getString(6));
					jsa.add(json);
				}
				model.addAttribute("jsa",jsa);
				stmt.close();
				conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			break;
		case 1:
			try {
				Class.forName(driver);
				conn = (Connection) DriverManager.getConnection(dburl,user, pwd);	
				stmt = (Statement) conn.createStatement();				
				//注入sql语句
				String sql ="SELECT\n" +
						"	icount,\n" +
						"	ccount,\n" +
						"	t1.sname\n" +
						"FROM\n" +
						"	(\n" +
						"		SELECT\n" +
						"			count(gov_information_resource_main.id) icount,\n" +
						"			gov_sort_manager.sort_name sname\n" +
						"		FROM\n" +
						"			gov_sort_manager\n" +
						"		LEFT JOIN gov_information_resource_main ON gov_information_resource_main.inforTypes2 = gov_sort_manager.id\n" +
						"		AND gov_information_resource_main.status = 0\n" +
						"		AND gov_information_resource_main.isDeleted = 0\n" +
						"		WHERE\n" +
						"			gov_sort_manager.isDeleted = 0\n" +
						"		AND gov_sort_manager.sort_id = 2\n" +
						"		AND gov_sort_manager.belong = 2\n" +
						"		GROUP BY\n" +
						"			gov_sort_manager.id,\n" +
						"			gov_sort_manager.sort_name\n" +
						"		ORDER BY\n" +
						"			gov_sort_manager.id ASC\n" +
						"	) t1\n" +
						"JOIN (\n" +
						"	SELECT\n" +
						"			count(DISTINCT gov_information_resource_main.value3) ccount,\n" +
						"			gov_sort_manager.sort_name sname\n" +
						"		FROM\n" +
						"			gov_sort_manager\n" +
						"		LEFT JOIN gov_information_resource_main ON gov_information_resource_main.inforTypes2 = gov_sort_manager.id\n" +
						"		AND gov_information_resource_main.status = 0\n" +
						"		AND gov_information_resource_main.isDeleted = 0\n" +
						"		WHERE\n" +
						"			gov_sort_manager.isDeleted = 0\n" +
						"		AND gov_sort_manager.sort_id = 2\n" +
						"		AND gov_sort_manager.belong = 2\n" +
						"		GROUP BY\n" +
						"			gov_sort_manager.id,\n" +
						"			gov_sort_manager.sort_name\n" +
						"		ORDER BY\n" +
						"			gov_sort_manager.id ASC\n" +
						") t2\n" +
						"ON\n" +
						"	t1.sname = t2.sname\n" +
						"AND (\n" +
						"	t1.icount > 0\n" +
						"	OR t2.ccount > 0\n" +
						")\n" +
						"GROUP BY\n" +
						"	t1.sname,\n" +
						"icount,\n" +
						"	ccount\n" +
						"ORDER BY\n" +
						"	icount DESC"
						;
				ResultSet rs = stmt.executeQuery(sql);
				JSONObject json = new JSONObject();
				JSONArray jsa = new JSONArray();
				while (rs.next()) {	
					json.put("icount", rs.getString(1));
					json.put("ccount", rs.getString(2));
					json.put("sname", rs.getString(3));
					jsa.add(json);
				}
				model.addAttribute("jsa",jsa);
				stmt.close();
				conn.close();
			}catch (Exception e) {
						e.printStackTrace();
					}
				break;
		case 2:
			try {
				Class.forName(driver);
				conn = (Connection) DriverManager.getConnection(dburl,user, pwd);	
				stmt = (Statement) conn.createStatement();				
				//注入sql语句
				String sql ="SELECT\n" +
						"	icount,\n" +
						"	ccount,\n" +
						"	t1.sname\n" +
						"FROM\n" +
						"	(\n" +
						"		SELECT\n" +
						"			count(gov_information_resource_main.id) icount,\n" +
						"			gov_sort_manager.sort_name sname\n" +
						"		FROM\n" +
						"			gov_sort_manager\n" +
						"		LEFT JOIN gov_information_resource_main ON gov_information_resource_main.inforTypes2 = gov_sort_manager.id\n" +
						"		AND gov_information_resource_main.status = 0\n" +
						"		AND gov_information_resource_main.isDeleted = 0\n" +
						"		WHERE\n" +
						"			gov_sort_manager.isDeleted = 0\n" +
						"		AND gov_sort_manager.sort_id = 1\n" +
						"		AND gov_sort_manager.belong = 2\n" +
						"		GROUP BY\n" +
						"			gov_sort_manager.id,\n" +
						"			gov_sort_manager.sort_name\n" +
						"		ORDER BY\n" +
						"			gov_sort_manager.id ASC\n" +
						"	) t1\n" +
						"JOIN (\n" +
						"	SELECT\n" +
						"			count(DISTINCT gov_information_resource_main.value3) ccount,\n" +
						"			gov_sort_manager.sort_name sname\n" +
						"		FROM\n" +
						"			gov_sort_manager\n" +
						"		LEFT JOIN gov_information_resource_main ON gov_information_resource_main.inforTypes2 = gov_sort_manager.id\n" +
						"		AND gov_information_resource_main.status = 0\n" +
						"		AND gov_information_resource_main.isDeleted = 0\n" +
						"		WHERE\n" +
						"			gov_sort_manager.isDeleted = 0\n" +
						"		AND gov_sort_manager.sort_id = 1\n" +
						"		AND gov_sort_manager.belong = 2\n" +
						"		GROUP BY\n" +
						"			gov_sort_manager.id,\n" +
						"			gov_sort_manager.sort_name\n" +
						"		ORDER BY\n" +
						"			gov_sort_manager.id ASC\n" +
						") t2\n" +
						"ON\n" +
						"	t1.sname = t2.sname\n" +
						"AND (\n" +
						"	t1.icount > 0\n" +
						"	OR t2.ccount > 0\n" +
						")\n" +
						"GROUP BY\n" +
						"	t1.sname,\n" +
						"icount,\n" +
						"	ccount\n" +
						"ORDER BY\n" +
						"	icount DESC"
						;
				ResultSet rs = stmt.executeQuery(sql);
				JSONObject json = new JSONObject();
				JSONArray jsa = new JSONArray();
				while (rs.next()) {	
					json.put("icount", rs.getString(1));
					json.put("ccount", rs.getString(2));
					json.put("sname", rs.getString(3));
					jsa.add(json);
				}
				model.addAttribute("jsa",jsa);
				stmt.close();
				conn.close();
			}catch (Exception e) {
						e.printStackTrace();
					}
				break;
		case 3:
			try {
				Class.forName(driver);
				conn = (Connection) DriverManager.getConnection(dburl,user, pwd);	
				stmt = (Statement) conn.createStatement();				
				//注入sql语句
				String sql ="SELECT\n" +
						"	t5.lct,\n" +
						"	t5.cname,\n" +
						"	t1.icount,\n" +
						"	t2.ocount,\n" +
						"	t3.pcount,\n" +
						"	t4.sct\n" +
						"FROM\n" +
						"	(\n" +
						"		SELECT\n" +
						"			COUNT(gov_data_list.id) lct,\n" +
						"			cname\n" +
						"		FROM\n" +
						"			(\n" +
						"				SELECT\n" +
						"					gov_information_resource_main.id id,\n" +
						"					gov_company.company_name cname\n" +
						"				FROM\n" +
						"					gov_company\n" +
						"				LEFT JOIN gov_information_resource_main ON gov_information_resource_main.value3 = gov_company.id\n" +
						"				AND gov_information_resource_main.status = 0\n" +
						"				AND gov_information_resource_main.isDeleted = 0\n" +
						"				WHERE\n" +
						"					gov_company.isDeleted = 0\n" +
						"				GROUP BY\n" +
						"					gov_company.id,\n" +
						"					gov_company.company_name,\n" +
						"gov_information_resource_main.id\n" +
						"				ORDER BY\n" +
						"					gov_company.id ASC\n" +
						"			) t11\n" +
						"		LEFT JOIN gov_data_list ON gov_data_list.data_manager_id = t11.id\n" +
						"		AND gov_data_list.is_share = 0\n" +
						"		GROUP BY\n" +
						"			t11.cname\n" +
						"	) t5\n" +
						"JOIN (\n" +
						"	SELECT\n" +
						"		count(\n" +
						"			gov_information_resource_main.id\n" +
						"		) icount,\n" +
						"		gov_company.company_name cname\n" +
						"	FROM\n" +
						"		gov_company\n" +
						"	LEFT JOIN gov_information_resource_main ON gov_information_resource_main.value3 = gov_company.id\n" +
						"	AND gov_information_resource_main.status = 0\n" +
						"	AND gov_information_resource_main.isDeleted = 0\n" +
						"	AND gov_information_resource_main.value8 = 1\n" +
						"	WHERE\n" +
						"		gov_company.isDeleted = 0\n" +
						"	GROUP BY\n" +
						"		gov_company.id,\n" +
						"		gov_company.company_name,\n" +
						"gov_information_resource_main.id\n" +
						"	ORDER BY\n" +
						"		gov_company.id ASC\n" +
						") t1 ON\n" +
						"	t1.cname = t5.cname\n" +
						"JOIN (\n" +
						"	SELECT\n" +
						"		count(\n" +
						"			gov_information_resource_main.id\n" +
						"		) ocount,\n" +
						"		gov_company.company_name cname\n" +
						"	FROM\n" +
						"		gov_company\n" +
						"	LEFT JOIN gov_information_resource_main ON gov_information_resource_main.value3 = gov_company.id\n" +
						"	AND gov_information_resource_main.status = 0\n" +
						"	AND gov_information_resource_main.isDeleted = 0\n" +
						"	AND gov_information_resource_main.value8 = 2\n" +
						"	WHERE\n" +
						"		gov_company.isDeleted = 0\n" +
						"	GROUP BY\n" +
						"		gov_company.id,\n" +
						"		gov_company.company_name\n" +
						"	ORDER BY\n" +
						"		gov_company.id ASC\n" +
						") t2\n" +
						"ON t1.cname = t2.cname\n" +
						"JOIN (\n" +
						"	SELECT\n" +
						"		count(\n" +
						"			gov_information_resource_main.id\n" +
						"		) pcount,\n" +
						"		gov_company.company_name cname\n" +
						"	FROM\n" +
						"		gov_company\n" +
						"	LEFT JOIN gov_information_resource_main ON gov_information_resource_main.value3 = gov_company.id\n" +
						"	AND gov_information_resource_main.status = 0\n" +
						"	AND gov_information_resource_main.isDeleted = 0\n" +
						"	AND gov_information_resource_main.value8 = 3\n" +
						"	WHERE\n" +
						"		gov_company.isDeleted = 0\n" +
						"	GROUP BY\n" +
						"		gov_company.id,\n" +
						"		gov_company.company_name\n" +
						"	ORDER BY\n" +
						"		gov_company.id ASC\n" +
						") t3\n" +
						"ON t1.cname = t3.cname\n" +
						"JOIN (\n" +
						"	SELECT\n" +
						"		COUNT(gov_data_list.id) sct,\n" +
						"		cname\n" +
						"	FROM\n" +
						"		(\n" +
						"			SELECT\n" +
						"				gov_information_resource_main.id id,\n" +
						"				gov_company.company_name cname\n" +
						"			FROM\n" +
						"				gov_company\n" +
						"			LEFT JOIN gov_information_resource_main ON gov_information_resource_main.value3 = gov_company.id\n" +
						"			AND gov_information_resource_main.status = 0\n" +
						"			AND gov_information_resource_main.isDeleted = 0\n" +
						"			WHERE\n" +
						"				gov_company.isDeleted = 0\n" +
						"			GROUP BY\n" +
						"				gov_company.id,\n" +
						"		gov_company.company_name,\n" +
						"gov_information_resource_main.id\n" +
						"			ORDER BY\n" +
						"				gov_company.id ASC\n" +
						"		) t12\n" +
						"	LEFT JOIN gov_data_list ON gov_data_list.data_manager_id = t12.id\n" +
						"	AND gov_data_list.is_share = 1\n" +
						"	GROUP BY\n" +
						"		t12.cname\n" +
						") t4\n" +
						"ON t1.cname = t4.cname\n" +
						"WHERE\n" +
						"	t1.icount > 0\n" +
						"	OR t2.ocount > 0\n" +
						"	OR t3.pcount > 0\n" +
						"	OR t4.sct > 0\n" +
						"	OR t5.lct > 0\n" +
						"GROUP BY\n" +
						"t5.cname,\n" +
						"	t5.lct,	\n" +
						"	t1.icount,\n" +
						"	t2.ocount,\n" +
						"	t3.pcount,\n" +
						"	t4.sct\n" +
						"ORDER BY\n" +
						"	t1.icount DESC"
						;
				ResultSet rs = stmt.executeQuery(sql);
				JSONObject json = new JSONObject();
				JSONArray jsa = new JSONArray();
				while (rs.next()) {	
					json.put("lct", rs.getString(1));
					json.put("cname", rs.getString(2));
					json.put("icount", rs.getString(3));
					json.put("ocount", rs.getString(4));
					json.put("pcount", rs.getString(5));
					json.put("sct", rs.getString(6));
					jsa.add(json);
				}
				model.addAttribute("jsa",jsa);
				stmt.close();
				conn.close();
			}catch (Exception e) {
						e.printStackTrace();
					}
				break;
		}
		
		return "/system/statistics/index"+index;
	}
	
	@RequestMapping(value="dataInfor")
	public void dataInfor(Company c,DataElement d,InformationResource i,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		Connection conn = null;
		Statement stmt = null;
		List<String> ids = new ArrayList<String>();
		try {
			Class.forName(driver);
			conn = (Connection) DriverManager.getConnection(dburl,user, pwd);	
			stmt = (Statement) conn.createStatement();
			String sql = "";
			if(PageInterceptor.getDatabaseType().equals("mysql")){
				sql = "SELECT\n" +
						"	*\n" +
						"FROM\n" +
						"	(\n" +
						"		SELECT\n" +
						"			COUNT(ID) ids,\n" +
						"			value8\n" +
						"		FROM\n" +
						"			gov_data_element\n" +
						"		WHERE\n" +
						"			isDeleted = 0\n" +
						"		AND class_type = 1\n" +
						"		AND value8 > 0\n" +
						"		GROUP BY\n" +
						"			value8\n" +
						"		ORDER BY\n" +
						"			ids DESC\n" +
						"	) AS cnm\n" +
						"LIMIT 9";		
			}else{
				sql = "SELECT\n" +
						"	*\n" +
						"FROM\n" +
						"	(\n" +
						"		SELECT\n" +
						"			COUNT (ID) ids,\n" +
						"			value8\n" +
						"		FROM\n" +
						"			gov_data_element\n" +
						"		WHERE\n" +
						"			isDeleted = 0\n" +
						"		AND class_type = 1\n" +
						"		AND value8 > 0\n" +
						"		GROUP BY\n" +
						"			value8\n" +
						"		ORDER BY\n" +
						"			ids DESC\n" +
						"	)\n" +
						"WHERE\n" +
						"	ROWNUM < 9";		
			}
			ResultSet rs = stmt.executeQuery(sql);
			//数组循环获得sql数据
			while (rs.next()) {	
				ids.add(rs.getString(2));
			}
			stmt.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		JSONObject echartjson = new JSONObject();
		int lsize = ids.size();
		if(lsize>0){
			String[] strArray =  new String[lsize];
			int[] dataArray = new int[lsize]; 
			int[] inforArray = new int[lsize];
			int[] openArray = new int[lsize]; 
			int[] shareArray = new int[lsize];
			int index = 0;
			for(String cid : ids){
				c.setId(Integer.valueOf(cid));
				List<Company> companies = companyservice.find(c,"id","asc");
				strArray[index] = companies.get(0).getCompanyName();
				d.setValue8(cid);
				d.setIsDeleted(0);
				d.setClassType(1);
				dataArray[index] = dataElementService.count(d);
				i.setValue3(cid);
				i.setIsDeleted(0);
				i.setStatus(0);
				inforArray[index] = informationResourceService.count(i);
				InformationResource informationRes = new InformationResource();
				informationRes.setValue3(cid);	
				informationRes.setValue11("1");
				informationRes.setIsDeleted(0);
				informationRes.setStatus(0);
				openArray[index] = informationResourceService.count(informationRes);
				InformationResource informationResource = new InformationResource();
				informationResource.setValue3(cid);
				informationResource.setStatus(0);
				informationResource.setId(0);
				informationResource.setValue8("1");
				shareArray[index] = informationResourceService.count(informationResource);
				index++;						
			}
			echartjson.put("legend", strArray);
			echartjson.put("data", dataArray);
			echartjson.put("infor", inforArray);
			echartjson.put("open", openArray);
			echartjson.put("share", shareArray);
		}		
		res.getWriter().write(echartjson.toString());
		res.getWriter().flush();
		res.getWriter().close();
	}
	
	@RequestMapping(value="dataInforSelect")
	public void dataInforSelect(Company c,GovServer s,DataElement d,InformationResource i,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");		
		String[] ids = s.getValue1().split(",");		
		JSONObject echartjson = new JSONObject();
		int lsize = ids.length;
		if(lsize>0){
			String[] strArray =  new String[lsize];
			int[] dataArray = new int[lsize]; 
			int[] inforArray = new int[lsize];
			int[] openArray = new int[lsize]; 
			int[] shareArray = new int[lsize];
			int index = 0;
			for(String cid : ids){
				c.setId(Integer.valueOf(cid));
				List<Company> companies = companyservice.find(c,"id","asc");
				strArray[index] = companies.get(0).getCompanyName();
				d.setValue8(cid);
				d.setStatus(0);
				d.setIsDeleted(0);
				dataArray[index] = dataElementService.count(d);
				i.setValue3(cid);
				i.setIsDeleted(0);
				i.setStatus(0);
				inforArray[index] = informationResourceService.count(i);
				InformationResource informationRes = new InformationResource();
				informationRes.setValue3(cid);	
				informationRes.setValue11("1");
				informationRes.setIsDeleted(0);
				informationRes.setStatus(0);
				openArray[index] = informationResourceService.count(informationRes);
				InformationResource informationResource = new InformationResource();
				informationResource.setValue3(cid);
				informationResource.setStatus(0);
				informationResource.setId(0);
				informationResource.setValue8("1");
				shareArray[index] = informationResourceService.count(informationResource);
				index++;						
			}
			echartjson.put("legend", strArray);
			echartjson.put("data", dataArray);
			echartjson.put("infor", inforArray);
			echartjson.put("open", openArray);
			echartjson.put("share", shareArray);
		}		
		res.getWriter().write(echartjson.toString());
		res.getWriter().flush();
		res.getWriter().close();
	}
	
	@RequestMapping(value="openShare")
	public void openShare(Company c,InformationResource i,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		Connection conn = null;
		Statement stmt = null;
		List<String> ids = new ArrayList<String>();
		try {
			Class.forName(driver);
			conn = (Connection) DriverManager.getConnection(dburl,user, pwd);	
			stmt = (Statement) conn.createStatement();
			//注入sql语句
			String sql = "SELECT\n" +
					"	*\n" +
					"FROM\n" +
					"	(\n" +
					"		SELECT\n" +
					"			COUNT (ID) ids,\n" +
					"			value3\n" +
					"		FROM\n" +
					"			gov_information_resource_main\n" +
					"		WHERE\n" +
					"			isDeleted = 0\n" +
					"		AND status = 0\n" +
					"		AND value11 = 1\n" +
					"		GROUP BY\n" +
					"			value3\n" +
					"		ORDER BY\n" +
					"			ids DESC\n" +
					"	)\n" +
					"WHERE\n" +
					"	ROWNUM < 6";		
			ResultSet rs = stmt.executeQuery(sql);
			//数组循环获得sql数据
			while (rs.next()) {	
				ids.add(rs.getString(2));
			}
			stmt.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		JSONObject echartjson = new JSONObject();
		int lsize = ids.size();
		if(lsize>0){
			String[] strArray =  new String[lsize];
			int[] openArray = new int[lsize]; 
			int[] shareArray = new int[lsize];
			int index = 0;
			for(String cid : ids){
				c.setId(Integer.valueOf(cid));
				List<Company> companies = companyservice.find(c,"id","asc");
				strArray[index] = companies.get(0).getCompanyName();
				i.setValue3(cid);	
				i.setValue11("1");
				i.setIsDeleted(0);
				i.setStatus(0);
				openArray[index] = informationResourceService.count(i);
				InformationResource informationResource = new InformationResource();
				informationResource.setValue3(cid);
				informationResource.setStatus(0);
				informationResource.setId(0);
				informationResource.setValue8("1");
				shareArray[index] = informationResourceService.count(informationResource);
				index++;						
			}
			echartjson.put("legend", strArray);
			echartjson.put("data", openArray);
			echartjson.put("infor", shareArray);
		}
		res.getWriter().write(echartjson.toString());
		res.getWriter().flush();
		res.getWriter().close();
	}
	
	@RequestMapping(value="hotres")
	public void hotres(HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		JSONObject echartjson = new JSONObject();
		List<SearchLog> list = searchLogService.hotres();
		if(list!=null){
			int leng = list.size();
			if(leng>10){
				String[] strArray =  new String[10];
				int[] openArray = new int[10]; 
				int index = 0;
				for(SearchLog sLog : list){
					strArray[index] = sLog.getKeyWord();
					openArray[index] = sLog.getCount();
					index++;
				}
				echartjson.put("legend", strArray);
				echartjson.put("data", openArray);
			}else{
				String[] strArray =  new String[leng];
				int[] openArray = new int[leng]; 
				int index = 0;
				for(SearchLog sLog : list){
					strArray[index] = sLog.getKeyWord();
					openArray[index] = sLog.getCount();
					index++;
				}
				echartjson.put("legend", strArray);
				echartjson.put("data", openArray);
			}			
		}		
		res.getWriter().write(echartjson.toString());
		res.getWriter().flush();
		res.getWriter().close();
	}
	
	@RequestMapping("seranalyse")
	public void seranalyse(GovServer gs,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		String depart = "";
		Company c = new Company();
		int companyId = AccountShiroUtil.getCurrentUser().getCompanyId();
		c.setId(companyId);
		gs.setCompanyId(companyId);
		gs.setValue3(companyId+"");
		List<Company> cpList = companyservice.find(c);		
		JSONObject echartjson = new JSONObject();
		JSONArray nodeArray = new JSONArray();
		JSONArray linkArray = new JSONArray();
		JSONObject unitjson = new JSONObject();
		JSONObject linkjson = new JSONObject();
		if(cpList.size()>0){
			depart = cpList.get(0).getCompanyName();
		}
		unitjson.put("category", 0);
		unitjson.put("name", depart);
		unitjson.put("value", 10);
		nodeArray.add(unitjson);
		List<GovServer> syslist = govServerService.syslist(gs);
		if(syslist.size()>0){
			for(GovServer gs1 : syslist){
				if(gs1.getValue7()!=null&&!gs1.getValue7().equals("")){
					int dbid = Integer.valueOf(gs1.getValue7());
					GovDatabase gd = new GovDatabase();
					gd.setId(dbid);
					List<GovDatabase> gdList = govDatabaseService.find(gd);
					if(gdList.size()>0){
						String dbName = gdList.get(0).getValue2();
						String name1 = gs1.getValue2();
						Random random = new Random();
						int s = random.nextInt(6)%(6-2+1) + 2;						
						unitjson.put("category", 1);
						unitjson.put("name", name1);
						unitjson.put("value", s);
						nodeArray.add(unitjson);
						linkjson.put("source", name1);	
						linkjson.put("target", depart);
						linkjson.put("weight", s);
						linkjson.put("name", "系统");
						linkArray.add(linkjson);
						unitjson.put("category", 2);
						unitjson.put("name", dbName);
						unitjson.put("value", s);
						nodeArray.add(unitjson);
						linkjson.put("source", dbName);	
						linkjson.put("target", name1);
						linkjson.put("weight", s);
						linkjson.put("name", "库");
						linkArray.add(linkjson);
						gs.setValue3(gs1.getValue7());
						List<GovServer> tblist = govServerService.tblist(gs);
						if(tblist.size()>0){
							for(GovServer gs2 : tblist){
								String name2 = gs2.getValue2();
								int s1 = random.nextInt(6)%(6-2+1) + 2; 
								unitjson.put("category", 3);
								unitjson.put("name", name2);
								unitjson.put("value", s1);
								nodeArray.add(unitjson);
								linkjson.put("source", name2);	
								linkjson.put("target", dbName);
								linkjson.put("weight", s1);
								linkjson.put("name", "表");
								linkArray.add(linkjson);
								gs.setValue3(gs2.getId()+"");
								List<GovServer> fllist = govServerService.fllist(gs);
								if(fllist.size()>0){
									for(GovServer gs3 : fllist){
										String name3 = gs3.getValue2();
										String name4 = gs3.getValue1();
										if(name3.trim().isEmpty()){
											name3 = name4;
										}
										int s2 = random.nextInt(6)%(6-2+1) + 2; 
										unitjson.put("category", 4);
										unitjson.put("name", name3);
										unitjson.put("value", s2);
										nodeArray.add(unitjson);
										linkjson.put("source", name3);	
										linkjson.put("target", name2);
										linkjson.put("weight", s2);
										linkjson.put("name", name3);
										linkArray.add(linkjson);
									}
								}
							}
						}
					}
				}				
			}
		}		
		echartjson.put("node", nodeArray);
		echartjson.put("link", linkArray);
		res.getWriter().write(echartjson.toString());
		res.getWriter().flush();
		res.getWriter().close();
	}
	
	@RequestMapping("unions")
	public void unions(HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		Connection conn = null;
		Statement stmt = null;
		try {
			Class.forName(driver);
			conn = (Connection) DriverManager.getConnection(dburl,user, pwd);	
			stmt = (Statement) conn.createStatement();				
			//注入sql语句
			String sql = "";
			if(PageInterceptor.getDatabaseType().equals("mysql")){
				sql ="SELECT\n" +
						"	*\n" +
						"FROM\n" +
						"	(\n" +
						"		SELECT\n" +
						"			icount,\n" +
						"			dcount,\n" +
						"			bcount,\n" +
						"			tcount,\n" +
						"			t1.cname\n" +
						"		FROM\n" +
						"			(\n" +
						"				SELECT\n" +
						"					count(gov_data_element.id) dcount,\n" +
						"					gov_company.company_name cname\n" +
						"				FROM\n" +
						"					gov_company\n" +
						"				LEFT JOIN gov_data_element ON gov_data_element.value8 = gov_company.id\n" +
						"				AND gov_data_element.isDeleted = 0\n" +
						"				AND gov_data_element.class_type = 1\n" +
						"				WHERE\n" +
						"					gov_company.isDeleted = 0\n" +
						"				GROUP BY\n" +
						"					gov_company.id,\n" +
						"					gov_company.company_name\n" +
						"				ORDER BY\n" +
						"					gov_company.id ASC\n" +
						"			) t1\n" +
						"		JOIN (\n" +
						"			SELECT\n" +
						"				count(\n" +
						"					gov_information_resource_main.id\n" +
						"				) icount,\n" +
						"				gov_company.company_name cname\n" +
						"			FROM\n" +
						"				gov_company\n" +
						"			LEFT JOIN gov_information_resource_main ON gov_information_resource_main.value3 = gov_company.id\n" +
						"			AND gov_information_resource_main. STATUS = 0\n" +
						"			AND gov_information_resource_main.isDeleted = 0\n" +
						"			WHERE\n" +
						"				gov_company.isDeleted = 0\n" +
						"			GROUP BY\n" +
						"				gov_company.id,\n" +
						"				gov_company.company_name\n" +
						"			ORDER BY\n" +
						"				gov_company.id ASC\n" +
						"		) t2 ON t1.cname = t2.cname\n" +
						"		JOIN (\n" +
						"			SELECT\n" +
						"				count(\n" +
						"					gov_information_resource_main.id\n" +
						"				) bcount,\n" +
						"				gov_company.company_name cname\n" +
						"			FROM\n" +
						"				gov_company\n" +
						"			LEFT JOIN gov_information_resource_main ON gov_information_resource_main.value3 = gov_company.id\n" +
						"			AND gov_information_resource_main. STATUS = 0\n" +
						"			AND gov_information_resource_main.inforTypes = 1\n" +
						"			AND gov_information_resource_main.isDeleted = 0\n" +
						"			WHERE\n" +
						"				gov_company.isDeleted = 0\n" +
						"			GROUP BY\n" +
						"				gov_company.id,\n" +
						"				gov_company.company_name\n" +
						"			ORDER BY\n" +
						"				gov_company.id ASC\n" +
						"		) t3 ON t2.cname = t3.cname\n" +
						"		JOIN (\n" +
						"			SELECT\n" +
						"				count(\n" +
						"					gov_information_resource_main.id\n" +
						"				) tcount,\n" +
						"				gov_company.company_name cname\n" +
						"			FROM\n" +
						"				gov_company\n" +
						"			LEFT JOIN gov_information_resource_main ON gov_information_resource_main.value3 = gov_company.id\n" +
						"			AND gov_information_resource_main. STATUS = 0\n" +
						"			AND gov_information_resource_main.inforTypes = 2\n" +
						"			AND gov_information_resource_main.isDeleted = 0\n" +
						"			WHERE\n" +
						"				gov_company.isDeleted = 0\n" +
						"			GROUP BY\n" +
						"				gov_company.id,\n" +
						"				gov_company.company_name\n" +
						"			ORDER BY\n" +
						"				gov_company.id ASC\n" +
						"		) t4 ON t3.cname = t4.cname\n" +
						"		WHERE\n" +
						"			t1.dcount > 0\n" +
						"		OR t3.bcount > 0\n" +
						"		OR t2.icount > 0\n" +
						"		OR t4.tcount > 0\n" +
						"		GROUP BY\n" +
						"			t1.cname,\n" +
						"			icount,\n" +
						"			dcount,\n" +
						"			bcount,\n" +
						"			tcount\n" +
						"		ORDER BY\n" +
						"			dcount DESC\n" +
						"	) AS cnm\n" +
						"LIMIT 10";
			}else{
				sql ="SELECT * FROM(SELECT\n" +
						"  icount,\n" +
						"  dcount,\n" +
						"  bcount,\n" +
						"  tcount,\n" +
						"  t1.cname\n" +
						"FROM\n" +
						"  (\n" +
						"    SELECT\n" +
						"      count(gov_data_element.id) dcount,\n" +
						"      gov_company.company_name cname\n" +
						"    FROM\n" +
						"      gov_company\n" +
						"    LEFT JOIN gov_data_element ON gov_data_element.value8 = gov_company.id\n" +
						"    AND gov_data_element.isDeleted = 0\n" +
						"    AND gov_data_element.class_type = 1\n" +
						"    WHERE\n" +
						"      gov_company.isDeleted = 0\n" +
						"    GROUP BY\n" +
						"      gov_company.id,\n" +
						"      gov_company.company_name\n" +
						"    ORDER BY\n" +
						"      gov_company.id ASC\n" +
						"  ) t1\n" +
						"JOIN (\n" +
						"  SELECT\n" +
						"    count(\n" +
						"      gov_information_resource_main.id\n" +
						"    ) icount,\n" +
						"    gov_company.company_name cname\n" +
						"  FROM\n" +
						"    gov_company\n" +
						"  LEFT JOIN gov_information_resource_main ON gov_information_resource_main.value3 = gov_company.id\n" +
						"  AND gov_information_resource_main.status = 0\n" +
						"  AND gov_information_resource_main.isDeleted = 0\n" +
						"  WHERE\n" +
						"    gov_company.isDeleted = 0\n" +
						"  GROUP BY\n" +
						"    gov_company.id,\n" +
						"    gov_company.company_name\n" +
						"  ORDER BY\n" +
						"    gov_company.id ASC\n" +
						") t2 ON  t1.cname = t2.cname\n" +
						"JOIN (\n" +
						"  SELECT\n" +
						"    count(\n" +
						"      gov_information_resource_main.id\n" +
						"    ) bcount,\n" +
						"    gov_company.company_name cname\n" +
						"  FROM\n" +
						"    gov_company\n" +
						"  LEFT JOIN gov_information_resource_main ON gov_information_resource_main.value3 = gov_company.id\n" +
						"  AND gov_information_resource_main.status = 0\n" +
						"  AND gov_information_resource_main.inforTypes = 1\n" +
						"  AND gov_information_resource_main.isDeleted = 0\n" +
						"  WHERE\n" +
						"    gov_company.isDeleted = 0\n" +
						"  GROUP BY\n" +
						"    gov_company.id,\n" +
						"    gov_company.company_name\n" +
						"  ORDER BY\n" +
						"    gov_company.id ASC\n" +
						") t3  ON  t2.cname = t3.cname\n" +
						"JOIN (\n" +
						"  SELECT\n" +
						"    count(\n" +
						"      gov_information_resource_main.id\n" +
						"    ) tcount,\n" +
						"    gov_company.company_name cname\n" +
						"  FROM\n" +
						"    gov_company\n" +
						"  LEFT JOIN gov_information_resource_main ON gov_information_resource_main.value3 = gov_company.id\n" +
						"  AND gov_information_resource_main.status = 0\n" +
						"  AND gov_information_resource_main.inforTypes = 2\n" +
						"  AND gov_information_resource_main.isDeleted = 0\n" +
						"  WHERE\n" +
						"    gov_company.isDeleted = 0\n" +
						"  GROUP BY\n" +
						"    gov_company.id,\n" +
						"    gov_company.company_name\n" +
						"  ORDER BY\n" +
						"    gov_company.id ASC\n" +
						") t4  ON  t3.cname = t4.cname\n" +
						"where\n" +
						"  t1.dcount > 0\n" +
						"  OR t3.bcount > 0\n" +
						"  OR t2.icount > 0\n" +
						"  OR t4.tcount > 0\n" +
						"GROUP BY\n" +
						"  t1.cname,  icount,\n" +
						"  dcount,\n" +
						"  bcount,\n" +
						"  tcount\n" +
						"ORDER BY\n" +
						"  dcount DESC)\n" +
						"WHERE ROWNUM < 11";
			}
			ResultSet rs = stmt.executeQuery(sql);
			JSONObject json = new JSONObject();
			JSONObject Ejson = new JSONObject();
			JSONArray jsa = new JSONArray();
			List<String > list= new ArrayList<String >();
			while (rs.next()) {
				String cpName = rs.getString(5);
				if(rs.getString(5).length()>6){
					cpName = rs.getString(5).substring(0,6);
				}			
				int[] arr3=new int[]{Integer.valueOf(rs.getString(1)),Integer.valueOf(rs.getString(2)),Integer.valueOf(rs.getString(3)),Integer.valueOf(rs.getString(4))};
				json.put("value", arr3);
				json.put("name", cpName);
				list.add(cpName);
				jsa.add(json);
			}
			String[] arr3=new String[]{"信息资源","数据元","基础库","主题库"};
			Ejson.put("sdata", jsa);
			Ejson.put("keyCity", list);
			Ejson.put("xpoint", arr3);
			res.getWriter().write(Ejson.toString());
			res.getWriter().flush();
			res.getWriter().close();
			stmt.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}		
	}
	
	@RequestMapping("unionsSelect")
	public void unionsSelect(GovServer s,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		String[] ids = s.getValue1().split(",");
		JSONObject json = new JSONObject();
		JSONObject Ejson = new JSONObject();
		JSONArray jsa = new JSONArray();
		List<String > list= new ArrayList<String >();
		Company c = new Company();
		c.setIsDeleted(0);
		DataElement da = new DataElement();
		da.setIsDeleted(0);
		InformationResource in = new InformationResource();
		InformationResource in1 = new InformationResource();
		InformationResource in2 = new InformationResource();
		in.setIsDeleted(0);
		in.setStatus(0);
		in1.setIsDeleted(0);
		in1.setStatus(0);
		in2.setIsDeleted(0);
		in2.setStatus(0);
		for(String id : ids) {
			da.setValue8(id);
			in.setValue3(id);
			in1.setValue3(id);
			in2.setValue3(id);
			in1.setInforTypes(1);
			in2.setInforTypes2(2);
			c.setId(Integer.valueOf(id));
			Company cm = companyservice.findById(c);
			int[] arr3=new int[]{informationResourceService.count(in),dataElementService.count(da),informationResourceService.count(in2),informationResourceService.count(in1)};
			json.put("value", arr3);
			json.put("name", cm.getCompanyName());
			list.add(cm.getCompanyName());
			jsa.add(json);
		}
		String[] arr3=new String[]{"信息资源","数据元","主题库","基础库"};
		Ejson.put("sdata", jsa);
		Ejson.put("keyCity", list);
		Ejson.put("xpoint", arr3);
		res.getWriter().write(Ejson.toString());
		res.getWriter().flush();
		res.getWriter().close();	
	}
	
	@RequestMapping(value="muban")
	public void muban(InformationRes o,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		Connection conn = null;
		Statement stmt = null;
		try {
			Class.forName(driver);
			conn = (Connection) DriverManager.getConnection(dburl,user, pwd);	
			stmt = (Statement) conn.createStatement();				
			//注入sql语句
			String sql = "";
			if(PageInterceptor.getDatabaseType().equals("mysql")){
				sql ="SELECT\n" +
						"	*\n" +
						"FROM\n" +
						"	(\n" +
						"		SELECT\n" +
						"			*\n" +
						"		FROM\n" +
						"			(\n" +
						"				SELECT\n" +
						"					COUNT(T.ID) SECONDCOUNTS,\n" +
						"					S.SORT_NAME\n" +
						"				FROM\n" +
						"					gov_information_resource T,\n" +
						"					gov_sort_manager S\n" +
						"				WHERE\n" +
						"					S.ID = T.INFORTYPES2\n" +
						"				AND T.isDeleted = 0\n" +
						"				GROUP BY\n" +
						"					T.inforTypes2,\n" +
						"					S.SORT_NAME\n" +
						"				UNION\n" +
						"					SELECT\n" +
						"						COUNT(T.ID) SECONDCOUNTS,\n" +
						"						S.SORT_NAME\n" +
						"					FROM\n" +
						"						gov_information_resource T,\n" +
						"						gov_sort_manager S\n" +
						"					WHERE\n" +
						"						S.ID = T.INFORTYPES3\n" +
						"					AND T.isDeleted = 0\n" +
						"					GROUP BY\n" +
						"						T.inforTypes3,\n" +
						"						S.SORT_NAME\n" +
						"			) AS cc\n" +
						"		ORDER BY\n" +
						"			SECONDCOUNTS DESC\n" +
						"	) AS cnm\n" +
						"LIMIT 6";
			}else{
				sql ="SELECT\n" +
						"	*\n" +
						"FROM\n" +
						"	(\n" +
						"		SELECT\n" +
						"			*\n" +
						"		FROM\n" +
						"			(\n" +
						"				SELECT\n" +
						"					COUNT (T . ID) SECONDCOUNTS,\n" +
						"					S.SORT_NAME\n" +
						"				FROM\n" +
						"					gov_information_resource T,\n" +
						"					GOV_SORT_MANAGER S\n" +
						"				WHERE\n" +
						"					S. ID = T .INFORTYPES2\n" +
						"				AND T .isDeleted = 0\n" +
						"				GROUP BY\n" +
						"					T .inforTypes2,\n" +
						"					S.SORT_NAME\n" +
						"				UNION\n" +
						"					SELECT\n" +
						"						COUNT (T . ID) SECONDCOUNTS,\n" +
						"						S.SORT_NAME\n" +
						"					FROM\n" +
						"						gov_information_resource T,\n" +
						"						GOV_SORT_MANAGER S\n" +
						"					WHERE\n" +
						"						S. ID = T .INFORTYPES3\n" +
						"					AND T .isDeleted = 0\n" +
						"					GROUP BY\n" +
						"						T .inforTypes3,\n" +
						"						S.SORT_NAME\n" +
						"			)\n" +
						"		ORDER BY\n" +
						"			SECONDCOUNTS DESC\n" +
						"	)\n" +
						"WHERE\n" +
						"	ROWNUM < 16";
			}
			ResultSet rs = stmt.executeQuery(sql);
			JSONObject json = new JSONObject();
			JSONArray jsa = new JSONArray();
			while (rs.next()) {	
				json.put("name", rs.getString(2));
				json.put("count", rs.getString(1));
				jsa.add(json);
			}
			res.getWriter().write(jsa.toString());
			res.getWriter().flush();
			res.getWriter().close();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			stmt.close();
			conn.close();
		}
	}
	@RequestMapping(value="mrank")
	public void mrank(HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		Connection conn = null;
		Statement stmt = null;
		try {
			Class.forName(driver);
			conn = (Connection) DriverManager.getConnection(dburl,user, pwd);	
			stmt = (Statement) conn.createStatement();	
			String sql = "";
			//注入sql语句
			if(PageInterceptor.getDatabaseType().equals("mysql")){
				sql ="SELECT\n" +
						"	*\n" +
						"FROM\n" +
						"	(\n" +
						"		SELECT\n" +
						"			icount,\n" +
						"			dcount,\n" +
						"			t1.cname\n" +
						"		FROM\n" +
						"			(\n" +
						"				SELECT\n" +
						"					COUNT(gov_data_element.ID) dcount,\n" +
						"					govmade_dic.DIC_VALUE cname\n" +
						"				FROM\n" +
						"					govmade_dic\n" +
						"				LEFT JOIN gov_data_element ON gov_data_element.value8 = govmade_dic.dic_key\n" +
						"				AND gov_data_element.CLASS_TYPE = 0\n" +
						"				AND gov_data_element.isDeleted = 0\n" +
						"				WHERE\n" +
						"					govmade_dic.isDeleted = 0\n" +
						"				AND govmade_dic.father_id IN (\n" +
						"					SELECT\n" +
						"						ID\n" +
						"					FROM\n" +
						"						govmade_dic\n" +
						"					WHERE\n" +
						"						dic_num = 'ZYTGF'\n" +
						"				)\n" +
						"				GROUP BY\n" +
						"					govmade_dic.dic_key,\n" +
						"					govmade_dic.dic_value\n" +
						"				ORDER BY\n" +
						"					govmade_dic.dic_key ASC\n" +
						"			) t1\n" +
						"		JOIN (\n" +
						"			SELECT\n" +
						"				COUNT(\n" +
						"					gov_information_resource.ID\n" +
						"				) icount,\n" +
						"				govmade_dic.dic_value cname\n" +
						"			FROM\n" +
						"				govmade_dic\n" +
						"			LEFT JOIN gov_information_resource ON gov_information_resource.value2 = govmade_dic.dic_key\n" +
						"			AND gov_information_resource.isDeleted = 0\n" +
						"			WHERE\n" +
						"				govmade_dic.isDeleted = 0\n" +
						"			AND govmade_dic.father_id IN (\n" +
						"				SELECT\n" +
						"					ID\n" +
						"				FROM\n" +
						"					govmade_dic\n" +
						"				WHERE\n" +
						"					dic_num = 'ZYTGF'\n" +
						"			)\n" +
						"			GROUP BY\n" +
						"				govmade_dic.dic_key,\n" +
						"				govmade_dic.dic_value\n" +
						"			ORDER BY\n" +
						"				govmade_dic.dic_key ASC\n" +
						"		) t2 ON t1.cname = t2.cname\n" +
						"		WHERE\n" +
						"			t1.dcount > 0\n" +
						"		OR t2.icount > 0\n" +
						"		GROUP BY\n" +
						"			t1.cname,\n" +
						"			icount,\n" +
						"			dcount\n" +
						"		ORDER BY\n" +
						"			icount DESC\n" +
						"	) as cnm\n" +
						"ORDER BY\n" +
						"	icount ASC\n" +
						"LIMIT 6";
			}else{
				sql ="SELECT\n" +
						"	*\n" +
						"FROM\n" +
						"	(\n" +
						"		SELECT\n" +
						"			icount,\n" +
						"			dcount,\n" +
						"			t1.cname\n" +
						"		FROM\n" +
						"			(\n" +
						"				SELECT\n" +
						"					COUNT (gov_data_element. ID) dcount,\n" +
						"					govmade_dic.DIC_VALUE cname\n" +
						"				FROM\n" +
						"					govmade_dic\n" +
						"				LEFT JOIN gov_data_element ON gov_data_element.value8 = govmade_dic.dic_key\n" +
						"				AND GOV_DATA_ELEMENT.CLASS_TYPE = 0\n" +
						"				AND gov_data_element.isDeleted = 0\n" +
						"				WHERE\n" +
						"					govmade_dic.isDeleted = 0\n" +
						"				AND govmade_dic.father_id IN (\n" +
						"					SELECT\n" +
						"						ID\n" +
						"					FROM\n" +
						"						govmade_dic\n" +
						"					WHERE\n" +
						"						dic_num = 'ZYTGF'\n" +
						"				)\n" +
						"				GROUP BY\n" +
						"					govmade_dic.dic_key,\n" +
						"					govmade_dic.dic_value\n" +
						"				ORDER BY\n" +
						"					govmade_dic.dic_key ASC\n" +
						"			) t1\n" +
						"		JOIN (\n" +
						"			SELECT\n" +
						"				COUNT (\n" +
						"					gov_information_resource. ID\n" +
						"				) icount,\n" +
						"				govmade_dic.dic_value cname\n" +
						"			FROM\n" +
						"				govmade_dic\n" +
						"			LEFT JOIN gov_information_resource ON gov_information_resource.value2 = govmade_dic.dic_key\n" +
						"			AND gov_information_resource.isDeleted = 0\n" +
						"			WHERE\n" +
						"				govmade_dic.isDeleted = 0\n" +
						"			AND govmade_dic.father_id IN (\n" +
						"				SELECT\n" +
						"					ID\n" +
						"				FROM\n" +
						"					govmade_dic\n" +
						"				WHERE\n" +
						"					dic_num = 'ZYTGF'\n" +
						"			)\n" +
						"			GROUP BY\n" +
						"				govmade_dic.dic_key,\n" +
						"				govmade_dic.dic_value\n" +
						"			ORDER BY\n" +
						"				govmade_dic.dic_key ASC\n" +
						"		) t2 ON t1.cname = t2.cname\n" +
						"		WHERE\n" +
						"			t1.dcount > 0\n" +
						"		OR t2.icount > 0\n" +
						"		GROUP BY\n" +
						"			t1.cname,\n" +
						"			icount,\n" +
						"			dcount\n" +
						"		ORDER BY\n" +
						"			icount DESC\n" +
						"	)\n" +
						"WHERE\n" +
						"	ROWNUM < 6\n" +
						"ORDER BY\n" +
						"	icount ASC";
			}
			ResultSet rs = stmt.executeQuery(sql);
			JSONObject json = new JSONObject();
			JSONArray jsa = new JSONArray();
			int icounts = 0,dcounts=0;
			while (rs.next()) {	
				icounts+=Integer.valueOf(rs.getString(1));
				dcounts+=Integer.valueOf(rs.getString(2));
				json.put("icount", rs.getString(1));
				json.put("dcount", rs.getString(2));
				json.put("cname", rs.getString(3));
				jsa.add(json);
			}
			json.put("icount", icounts);
			json.put("dcount", dcounts);
			json.put("cname", "所有部门(个)");
			jsa.add(json);
			res.getWriter().write(jsa.toString());
			stmt.close();
			conn.close();
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping("systree")
	public void systree(GovServer gs,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		int cid = gs.getCompanyId();
		Company cp = new Company();
		cp.setId(cid);
		List<Company> cpList = companyservice.find(cp);
		JSONObject echartjson = new JSONObject();
		if(cpList.size()>0){
			echartjson.put("name", cpList.get(0).getCompanyName());
		}
		JSONArray unitArray = new JSONArray();
		gs.setValue3(cid+"");
		List<GovServer> syslist = govServerService.syslist(gs);
				if(syslist.size()>0){			
					for(GovServer gs1 : syslist){
						JSONObject unitjson = new JSONObject();
						JSONArray unArray = new JSONArray();
						String name1 = gs1.getValue2();				
						unitjson.put("name", name1);
						if(gs1.getValue7()!=null&&!gs1.getValue7().equals("")){
							int dbid = Integer.valueOf(gs1.getValue7());
							GovDatabase gd = new GovDatabase();
							gd.setId(dbid);
							List<GovDatabase> gdList = govDatabaseService.find(gd);
							if(gdList.size()>0){
								JSONObject unitjson1 = new JSONObject();
								gs.setValue3(gs1.getValue7());
								List<GovServer> tblist = govServerService.tblist(gs);
								unitjson1.put("name", gdList.get(0).getValue2());
								if(tblist.size()>0){
									JSONArray unitArray1 = new JSONArray();
									for(GovServer gs2 : tblist){
										JSONObject unitjson2 = new JSONObject();
										String name2 = gs2.getValue2();
										unitjson2.put("name", name2);
										gs.setValue3(gs2.getId()+"");
										List<GovServer> fllist = govServerService.fllist(gs);
										if(fllist.size()>0){
											JSONObject unitjson3 = new JSONObject();
											JSONArray unitArray2 = new JSONArray();
											int index = 0;
											for(GovServer gs3 : fllist){
												if(index < 5){
													String name3 = gs3.getValue2();
													unitjson3.put("name", name3);
													unitArray2.add(unitjson3);
													index++;
												}									
											}
											unitjson2.put("children", unitArray2);
										}
										unitArray1.add(unitjson2);
									}
									unitjson1.put("children", unitArray1);
								}

								unArray.add(unitjson1);
							}							
						}
						unitjson.put("children", unArray);
						unitArray.add(unitjson);
					}			
				}		
		echartjson.put("children", unitArray);
		res.getWriter().write(echartjson.toString());
		res.getWriter().flush();
		res.getWriter().close();
	}
	
	@RequestMapping(value="hotData")
	public void hotData(Company c,InformationResource i,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		Connection conn = null;
		Statement stmt = null;
		try {
			Class.forName(driver);
			conn = (Connection) DriverManager.getConnection(dburl,user, pwd);	
			stmt = (Statement) conn.createStatement();
			JSONObject echartjson = new JSONObject();
			JSONArray jsa = new JSONArray();
			String sql = "";
			//注入sql语句
			if(PageInterceptor.getDatabaseType().equals("mysql")){
				sql = "SELECT\n" +
						"	*\n" +
						"FROM\n" +
						"	(\n" +
						"		SELECT\n" +
						"			gov_data_list.DATA_ELEMENT_ID,\n" +
						"			gov_data_element.VALUE1,\n" +
						"			count(\n" +
						"				gov_data_list.DATA_ELEMENT_ID\n" +
						"			) COUNS\n" +
						"		FROM\n" +
						"			gov_data_list\n" +
						"		JOIN gov_data_element ON gov_data_list.DATA_ELEMENT_ID = gov_data_element.ID\n" +
						"		WHERE\n" +
						"			gov_data_list.DATA_MANAGER_ID > 0\n" +
						"		AND gov_data_list.DATA_ELEMENT_ID > 0\n" +
						"		AND gov_data_element.ISDELETED = 0\n" +
						"		GROUP BY\n" +
						"			gov_data_list.DATA_ELEMENT_ID,\n" +
						"			gov_data_element.VALUE1\n" +
						"		ORDER BY\n" +
						"			COUNS DESC\n" +
						"	) AS cnm\n" +
						"LIMIT 20";		
			}else{
				sql = "SELECT\n" +
						"	*\n" +
						"FROM\n" +
						"	(\n" +
						"		SELECT\n" +
						"			GOV_DATA_LIST.DATA_ELEMENT_ID,\n" +
						"			GOV_DATA_ELEMENT.VALUE1,\n" +
						"			COUNT (\n" +
						"				GOV_DATA_LIST.DATA_ELEMENT_ID\n" +
						"			) COUNS\n" +
						"		FROM\n" +
						"			GOV_DATA_LIST\n" +
						"		JOIN GOV_DATA_ELEMENT ON GOV_DATA_LIST.DATA_ELEMENT_ID = GOV_DATA_ELEMENT. ID\n" +
						"		WHERE\n" +
						"			GOV_DATA_LIST.DATA_MANAGER_ID > 0\n" +
						"		AND GOV_DATA_LIST.DATA_ELEMENT_ID > 0\n" +
						"		AND GOV_DATA_ELEMENT.ISDELETED = 0\n" +
						"		GROUP BY\n" +
						"			GOV_DATA_LIST.DATA_ELEMENT_ID,\n" +
						"			GOV_DATA_ELEMENT.VALUE1\n" +
						"		ORDER BY\n" +
						"			COUNS DESC\n" +
						"	)\n" +
						"WHERE\n" +
						"	ROWNUM < 20";		
			}
			ResultSet rs = stmt.executeQuery(sql);
			//数组循环获得sql数据
			while (rs.next()) {	
				echartjson.put("name",rs.getString(2));
				echartjson.put("value", rs.getString(3));
				jsa.add(echartjson);
			}			
			res.getWriter().write(jsa.toString());
			stmt.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		res.getWriter().flush();
		res.getWriter().close();
	}
	
	@RequestMapping(value="listAllTales")
	public void listAllTables(GovComputerRoom c,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		Connection con = null;// 创建一个数据库连接
		PreparedStatement pre = null;// 创建预编译语句对象，一般都是用这个而不用Statement
		ResultSet result = null;// 创建一个结果集对象
		String dbtype = c.getValue1();				//数据库类型
		String user = c.getValue2();			//用户名
		String password = c.getValue3();			//密码
		String address = c.getValue4();			//数据库连接地址
		String dbport = c.getValue5();				//端口
		String databaseName = c.getValue6();	//数据库名
		String url;
		JSONArray js = new JSONArray();
		if("mysql".equals(dbtype)){
			url = "jdbc:mysql://"+address+":"+dbport+"/"+databaseName;
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection(url, user, password);
		}else if("oracle".equals(dbtype)){
			String sid = c.getValue7();
			url = "jdbc:oracle:thin:@"+address+":"+dbport+":"+sid;
			Class.forName("oracle.jdbc.driver.OracleDriver"); 
			con = DriverManager.getConnection(url, user, password);
		}else if("sqlserver".equals(dbtype)){
			url = "jdbc:microsoft:sqlserver://"+address+":"+dbport+";DatabaseName="+databaseName;
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			con = DriverManager.getConnection(url, user, password);
		}else{
			con =  null;
		}	
		System.out.println("开始尝试连接数据库！连接为"+con);		
		ResultSet rs = con.getMetaData().getTables(null, databaseName.toUpperCase(), null, new String[]{"TABLE"});
		while(rs.next()) {
		    js.add(rs.getString("TABLE_NAME"));
		}
		res.getWriter().write(js.toString());
		res.getWriter().flush();
		res.getWriter().close();
	}
	
	
	@RequestMapping("systreeall")
	public void systreeall(GovServer gs,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		List<GovServer> cplist =  govServerService.cplist(gs);
		JSONObject artjson = new JSONObject();		
		if(cplist.size()>0){
			JSONArray uArray = new JSONArray();
			for(GovServer gscp : cplist){				
				JSONObject echartjson = new JSONObject();
			echartjson.put("name", gscp.getValue1());
		JSONArray unitArray = new JSONArray();
		String[] sar = gscp.getValue2().split(",");
		int[] array = new int[sar.length];  
		for(int i=0;i<sar.length;i++){  
		    array[i]=Integer.parseInt(sar[i]); 
		}
		List<GovServer> syslist = govServerService.applist(array);
				if(syslist.size()>0){			
					for(GovServer gs1 : syslist){
						JSONObject unitjson = new JSONObject();
						JSONArray unArray = new JSONArray();
						String name1 = gs1.getValue2();				
						unitjson.put("name", name1);
						if(gs1.getValue7()!=null&&!gs1.getValue7().equals("")){
							int dbid = Integer.valueOf(gs1.getValue7());
							GovDatabase gd = new GovDatabase();
							gd.setId(dbid);
							List<GovDatabase> gdList = govDatabaseService.find(gd);
							if(gdList.size()>0){
								JSONObject unitjson1 = new JSONObject();
								gs.setValue3(gs1.getValue7());
								List<GovServer> tblist = govServerService.tblist(gs);
								unitjson1.put("name", gdList.get(0).getValue2());
								if(tblist.size()>0){
									JSONArray unitArray1 = new JSONArray();
									for(GovServer gs2 : tblist){
										JSONObject unitjson2 = new JSONObject();
										String name2 = gs2.getValue2();
										unitjson2.put("name", name2);
										gs.setValue3(gs2.getId()+"");
										List<GovServer> fllist = govServerService.fllist(gs);
										if(fllist.size()>0){
											JSONObject unitjson3 = new JSONObject();
											JSONArray unitArray2 = new JSONArray();
											int index = 0;
											for(GovServer gs3 : fllist){
												if(index < 5){
													String name3 = gs3.getValue2();
													unitjson3.put("name", name3);
													unitArray2.add(unitjson3);
													index++;
												}									
											}
											unitjson2.put("children", unitArray2);
										}
										unitArray1.add(unitjson2);
									}
									unitjson1.put("children", unitArray1);
								}

								unArray.add(unitjson1);
							}							
						}
						unitjson.put("children", unArray);
						unitArray.add(unitjson);
					}			
				}		
		echartjson.put("children", unitArray);
		uArray.add(echartjson);
			}
			artjson.put("children", uArray);
		}
		artjson.put("name", "部门");
		res.getWriter().write(artjson.toString());
		res.getWriter().flush();
		res.getWriter().close();
	}
	
	@RequestMapping("exall")
	public String exall() {
		return "/system/govServer/exall";		
	}
	
	@RequestMapping(value="mubanCompare")
	public String mubanCompare(Model model,HttpServletRequest req, HttpServletResponse res) throws Exception {
		return "/system/echart/mubanCompare";		
	}
	
	@RequestMapping(value="mCompare")
	public void mCompare(HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		String cid = req.getParameter("cid");
		String mid = req.getParameter("mid");
		Map<String,String> dicCompany=new HashMap<String, String>();
		List<GovmadeDic> dicc=ServiceUtil.getDicByDicNum("ZYTGF");
		for(GovmadeDic d:dicc){
			dicCompany.put(d.getDicKey(),d.getDicValue());
		}
		JSONArray artjson = new JSONArray();
		DataElement mde = new DataElement();
		DataElement de = new DataElement();
		InformationResource ir = new InformationResource();
		InformationRes mir = new InformationRes();
		mde.setIsDeleted(0);
		mde.setClassType(0);
		mde.setValue8(mid);
		de.setIsDeleted(0);
		de.setValue8(cid);
		de.setClassType(1);
		ir.setIsDeleted(0);
		mir.setIsDeleted(0);
		mir.setValue2(mid);
		ir.setStatus(0);
		ir.setValue3(cid);
		List<DataElement> mdeList = dataElementService.find(mde);
		List<DataElement> deList = dataElementService.find(de);
		List<InformationRes> mirList = informationResService.find(mir);
		List<InformationResource> irList = informationResourceService.find(ir);
		int mdeSize = mdeList.size();
		int deSize = deList.size();
		int mirSize = mirList.size();
		int irSize = irList.size();
		JSONObject marray = new JSONObject();
		JSONObject comparray = new JSONObject();
		marray.put("title", dicCompany.get(mid));
		marray.put("sp1", mdeSize);
		marray.put("sp2", mirSize);
		marray.put("p1", "数据元模板数量：");
		marray.put("p2", "信息资源模板数量：");
		comparray.put("title", "资源对比");
		comparray.put("p1", "数据元匹配度：");
		comparray.put("p2", "信息资源匹配度：");
		artjson.add(marray);
		if(mdeSize>0&&deSize>0){
			List<String> sameArrayList = new ArrayList<String>();
			Set<String> tempSet = new HashSet<String>();
			for(DataElement del:mdeList){
				tempSet.add(del.getChName());
			}
			for(DataElement delg:deList) {
				if(!tempSet.add(delg.getValue1())) {
				sameArrayList.add(delg.getValue1());
				}				
			}
			comparray.put("sp1",sameArrayList.size()*100/deSize+"%");
		}else{
			comparray.put("sp1",0);
		}
		if(mirSize>0&&irSize>0){
			List<String> sameArrayList = new ArrayList<String>();
			for(InformationResource delg:irList) {
				if(isMacth(delg,mirList)) {
				sameArrayList.add(delg.getValue1());
				}				
			}
			comparray.put("sp2",sameArrayList.size()*100/irSize+"%");
		}else{
			comparray.put("sp2",0);
		}
		artjson.add(comparray);
		res.getWriter().write(artjson.toString());
		res.getWriter().flush();
		res.getWriter().close();		
	}
	
	//信息资源名称是否匹配
	private boolean isMacth(InformationResource info,List<InformationRes> list){
		for(InformationRes res:list){
			if(StringUtil.stringMatching(info.getValue1(),res.getValue1())>50){
				return true;
			}
		}
		return false;
	}
	
}
