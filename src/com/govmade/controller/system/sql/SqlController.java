package com.govmade.controller.system.sql;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.commons.io.FileUtils;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.Trigger;
import org.quartz.impl.JobDetailImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.govmade.common.utils.QuartzManager;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.controller.base.GovmadeBaseController;
import com.govmade.entity.system.computer.GovComputerRoom;
import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;
import com.govmade.quartz.job.DataBaseJob;
import com.govmade.service.base.BaseService;
import com.govmade.service.system.database.GovDatabaseService;
import com.govmade.service.system.table.GovTableFieldService;
import com.govmade.service.system.table.GovTableService;

@Controller
@RequestMapping("/backstage/sql/")
public class SqlController extends GovmadeBaseController<GovComputerRoom>{
	@Autowired
	private GovTableService service;
	@Autowired
	private GovDatabaseService govDatabaseService;
	@Autowired
	private GovTableFieldService govTableFieldService;
	private Connection con = null;// 创建一个数据库连接
	private String databaseName = "";
	@Autowired
	private Scheduler  scheduler ;
	
	@Override
	public BaseService getService() {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public String indexURL() {
		// TODO Auto-generated method stub
		return "system/sql/sql";
	}
	
	@RequestMapping(value="listAllTales")
	public void listAllTables(GovComputerRoom c,HttpServletRequest req, HttpServletResponse res) throws Exception {
		res.setContentType("application/json; charset=utf-8");
		res.setCharacterEncoding("utf-8");
		PreparedStatement pre = null;// 创建预编译语句对象，一般都是用这个而不用Statement
		ResultSet result = null;// 创建一个结果集对象
		String dbtype = c.getValue1();				//数据库类型
		String user = c.getValue2();			//用户名
		String password = c.getValue3();			//密码
		String address = c.getValue4();			//数据库连接地址
		String dbport = c.getValue5();				//端口
		databaseName = c.getValue6();	//数据库名
		System.out.println("(每5秒输出一次)...");    
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("jobData", c);
		QuartzManager.addJob(scheduler, "name", "group", "trrigger", "trriggerGroup", DataBaseJob.class, "0/5 * * * * ?",map);
		
		String url = "";
		JSONArray js = new JSONArray();
		if("mysql".equals(dbtype)){
			url = "jdbc:mysql://"+address+":"+dbport+"/"+databaseName;
			Class.forName("com.mysql.jdbc.Driver");					
		}else if("oracle".equals(dbtype)){
			String sid = c.getValue7();
			url = "jdbc:oracle:thin:@"+address+":"+dbport+":"+sid;
			Class.forName("oracle.jdbc.driver.OracleDriver"); 
		}else if("sqlserver".equals(dbtype)){
			url = "jdbc:microsoft:sqlserver://"+address+":"+dbport+";DatabaseName="+databaseName;
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		}
		try {  
			con = DriverManager.getConnection(url, user, password); 
        } catch (Exception e) {  
        	e.printStackTrace();
        }  	
		System.out.println("开始尝试连接数据库！连接为"+con);	
		if(con!=null){
			ResultSet rs = con.getMetaData().getTables(null, databaseName.toUpperCase(), null, new String[]{"TABLE"});
			while(rs.next()) {
			    js.add(rs.getString("TABLE_NAME"));
			}
		}		
		res.getWriter().write(js.toString());
		res.getWriter().flush();
		res.getWriter().close();
	}
	@RequestMapping(value="listFields")
	public ResponseEntity<byte[]> listFields(HttpServletRequest req, HttpServletResponse res) throws Exception {
		String[] checkbox= req.getParameterValues("iCheck");
		String sql = "";
		String field = "";
		int dbId;
		int tbId;
		String path = req.getSession().getServletContext().getRealPath("upload/sql");
		String fileName = System.currentTimeMillis()+".sql";
		String fullPath = path + "/" + fileName;
		File file = new File(fullPath);
		BufferedWriter ow = new BufferedWriter(new FileWriter(file));
		GovDatabase db = new GovDatabase();
		db.setValue1(databaseName);
		db.setValue2(databaseName);
		System.out.println(databaseName);
		db.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
		db.setGroupId(AccountShiroUtil.getCurrentUser().getGroupId());
		List<GovDatabase> dbList = govDatabaseService.find(db);
		if(dbList.size()<1){
			govDatabaseService.insert(db);
			dbId = db.getId();
		}else{
			dbId = dbList.get(0).getId();
		}
		GovTable tb = new GovTable();
		tb.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
		tb.setGroupId(AccountShiroUtil.getCurrentUser().getGroupId());
		for(int i =0;i<checkbox.length;i++) //对checkbox进行遍历  
		{ 
			field = checkbox[i];
			tb.setValue1(field);
			tb.setValue2(field);
			tb.setValue3(dbId+"");
			List<GovTable> tbList = service.find(tb);
			if(tbList.size()<1){
				service.insert(tb);
				tbId = tb.getId();
			}else{
				tbId = tbList.get(0).getId();
			}
			sql = getColumns(con,field,tbId,govTableFieldService);
			ow.write(sql + ";" + "\n");
		}		
		ow.close();
		HttpHeaders headers = new HttpHeaders();
		String fn = new String(fileName.getBytes("UTF-8"), "iso-8859-1");// 为了解决中文名称乱码问题
		headers.setContentDispositionFormData("attachment", fn);
		headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
		return new ResponseEntity<byte[]>(FileUtils.readFileToByteArray(new File(fullPath)), headers,
				HttpStatus.CREATED);
	}
	
	public static String getColumns(Connection con,String tbName,int tbId,GovTableFieldService govTableFieldService) throws Exception{
		System.out.println("表名"+tbName);
	    String sql = "CREATE TABLE "+tbName+" ("+"\n";
	    System.out.println(con);
		ResultSet rs = con.getMetaData().getColumns(null, null, tbName, null);
		GovTableField tf = new GovTableField();
		tf.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
		tf.setGroupId(AccountShiroUtil.getCurrentUser().getGroupId());
		while(rs.next()) {
			//获得字段名称
			String name = rs.getString("COLUMN_NAME");
			//获得字段类型名称
			String type = rs.getString("TYPE_NAME");
			//获得字段大小
			int size = rs.getInt("COLUMN_SIZE");
			//获得字段备注
			String remark = rs.getString("REMARKS");
			tf.setValue1(name);
			tf.setValue2(remark);
			tf.setValue3(tbId+"");
			tf.setValue5(type);
			tf.setValue6(size+"");
			List<GovTableField> filList = govTableFieldService.find(tf);
			if(filList.size()<1){
				govTableFieldService.insert(tf);
			}
			sql = sql + name + " "+type+"("+size+")"+","+"\n";
		}
		 sql=sql+")";
		 return sql;
	}
	
}
