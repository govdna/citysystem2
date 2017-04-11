package com.govmade.common.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.database.GovDatabase;

public class Test {
	public static void main(String[] args) throws Exception {
		for(int i=1;i<=30;i++){
			System.out.println("<if test=\"param.value"+i+" != null and param.value"+i+" != ''\">");
			System.out.println("and t.value"+i+" = #{param.value"+i+"}");
			System.out.println("</if>");
		}
	}

	
	public static void getColumns(Connection con,String tbName) throws Exception{
		System.out.println("表名"+tbName);
	    
		ResultSet rs = con.getMetaData().getColumns(null, null, tbName, null);
		while(rs.next()) {
			//获得字段名称
			String name = rs.getString("COLUMN_NAME");
			//获得字段类型名称
			String type = rs.getString("TYPE_NAME");
			//获得字段大小
			int size = rs.getInt("COLUMN_SIZE");
			//获得字段备注
			String remark = rs.getString("REMARKS");
			System.out.println(name+"|"+type+"|"+size+"|"+remark);
		}
	}
	
	
	
	public static void al(List<GovDatabase> list) {
		for (GovDatabase gg : list) {
			GovDatabase g = gg;
			g.setId(1);
		}
	}

	/**
	 * 一个非常标准的连接Oracle数据库的示例代码
	 */
	public void testOracle() {
		Connection con = null;// 创建一个数据库连接
		PreparedStatement pre = null;// 创建预编译语句对象，一般都是用这个而不用Statement
		ResultSet result = null;// 创建一个结果集对象
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");// 加载Oracle驱动程序
			System.out.println("开始尝试连接数据库！");
			String url = "jdbc:oracle:thin:@183.245.210.75:1521:orcl";// 127.0.0.1是本机地址，XE是精简版Oracle的默认数据库名
			String user = "system";// 用户名,系统默认的账户名
			String password = "govmadedb";// 你安装时选设置的密码
			con = DriverManager.getConnection(url, user, password);// 获取连接
			System.out.println("连接成功！");
			String sql = "select * from student where name=?";// 预编译语句，“？”代表参数
			pre = con.prepareStatement(sql);// 实例化预编译语句
			pre.setString(1, "刘显安");// 设置参数，前面的1表示参数的索引，而不是表中列名的索引
			result = pre.executeQuery();// 执行查询，注意括号中不需要再加参数
			while (result.next())
				// 当结果集不为空时
				System.out.println("学号:" + result.getInt("id") + "姓名:" + result.getString("name"));
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				// 逐一将上面的几个对象关闭，因为不关闭的话会影响性能、并且占用资源
				// 注意关闭的顺序，最后使用的最先关闭
				if (result != null)
					result.close();
				if (pre != null)
					pre.close();
				if (con != null)
					con.close();
				System.out.println("数据库连接已关闭！");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
