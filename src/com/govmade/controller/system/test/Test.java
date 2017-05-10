/**   
* @author (作者) Yulei 117815986@qq.com   
* @date 2017年2月15日 上午10:33:51   
* @Title: Test.java
* @Package com.govmade.controller.system.test
* @version V1.0   
*/
package com.govmade.controller.system.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.govmade.common.utils.db.DbConfig;
import com.govmade.entity.system.organization.Company;

/**   
* @author (作者) Yulei 117815986@qq.com   
* @Description: CitySystem TODO
* @date 2017年2月15日 上午10:33:51   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: Test.java
* @Package com.govmade.controller.system.test
* @version V1.0   
*/
public class Test {
	
	public static String dburl = DbConfig.getString("jdbc.mysql.url");
	public static String driver = DbConfig.getString("jdbc.mysql.driver");
	public static String user = DbConfig.getString("jdbc.mysql.username");
	public static String pwd = DbConfig.getString("jdbc.mysql.password");

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		/* 链接本地数据库 */
		Connection conn = null;
		Statement stmt = null;
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
					"			value8\n" +
					"		FROM\n" +
					"			gov_data_element\n" +
					"		WHERE\n" +
					"			isDeleted = 0\n" +
					"		AND status = 0\n" +
					"		AND class_type = 1\n" +
					"		GROUP BY\n" +
					"			value8\n" +
					"		ORDER BY\n" +
					"			ids DESC\n" +
					"	)\n" +
					"WHERE\n" +
					"	ROWNUM < 6";		
			ResultSet rs = stmt.executeQuery(sql);
			System.out.println(sql);
			List<Company> comList = new ArrayList<Company>();
			Company com=new Company();
			//数组循环获得sql数据
			System.out.println("CompanyName="+rs.getRow());
			while (rs.next()) {	
			    //com.setCompanyNumber(rs.getString(1));	
				//com.setCompanyName(rs.getString(2));
				System.out.println("CompanyNumber="+rs.getString(1));
				System.out.println("CompanyName="+rs.getString(2));
				//comList.add(com);
			}
			
			System.out.println("chenggong");
			stmt.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}


}
