package com.govmade.common.utils.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class OracleUtil {
	public static void main(String[] args) throws Exception {
		// readFileByLines("D://dc.sql");
		// System.out.println(mysql2Oracle("'3','0',NULL,'2016-11-08
		// 15:53:36','2016-12-15 19:44:11','0');"));
		String ss="GOV_INFOR_RESOURCE_MAIN";
		 System.out.println(getSequence(ss.split(",")));
		// alterTable("GOV_COMPUTER_ROOM");
		//value1_50xml();
		 //whereStr();
	}
	

	// 添加value1-50列sql语句
	public static void whereStr() {
		for (int i = 1; i <= 50; i++) {
			System.out.println("<if test=\"param.value"+i+" != null and param.value"+i+" !=''\"> and");
			System.out.println("value"+i+" = #{param.value"+i+",jdbcType=VARCHAR}");
			System.out.println("</if>");
		}
		
	}
	

	// 添加value1-50列sql语句
	public static void alterTable(String table) {
		System.out.println(" alter table " + table + " add (");
		for (int i = 1; i <= 50; i++) {
			if (i == 50) {
				System.out.println("value" + i + " varchar2(500)");
			} else {
				System.out.println("value" + i + " varchar2(500),");
			}

		}
		System.out.println(");");
	}

	public static void value1_50xml() {
		for (int i = 1; i <= 50; i++) {
			System.out.println("		<result column=\"value"+i+"\" property=\"value"+i+"\" jdbcType=\"VARCHAR\" />");
		}
		
		for (int i = 1; i <= 50; i++) {
			if (i == 50) {
				System.out.println("value" + i);
			} else {
				System.out.print("value" + i + ",");
			}

		}
		for (int i = 1; i <= 50; i++) {
			if (i == 50) {
				System.out.println("#{value" + i + ",jdbcType=VARCHAR}");
			} else {
				System.out.print("#{value" + i + ",jdbcType=VARCHAR},");
			}
		}
		
		for (int i = 1; i <= 50; i++) {
			if (i == 50) {
				System.out.println("value"+i+"=#{value" + i + ",jdbcType=VARCHAR}");
			} else {
				System.out.println("value"+i+"=#{value" + i + ",jdbcType=VARCHAR},");
			}
		}
	}

	public static String getSequence(String[] tables) {
		StringBuffer sb = new StringBuffer();
		for (String tb : tables) {
			sb.append("create sequence ").append(tb).append("_seq \n");
			sb.append("increment by 1 \n start with 1 \n nomaxvalue \n nominvalue \n nocache; \n\n\n");

			sb.append("create or replace trigger ").append(tb).append("_tr \n");
			sb.append("before insert on  ").append(tb).append("\n");
			sb.append("for each row \n");
			sb.append("begin \n");
			sb.append("select ").append(tb).append("_seq.nextval into :new.id from dual;\n");
			sb.append("end;\n\n\n");

		}
		return sb.toString();
	}

	public static String mysql2Oracle(String sql) {
		sql = sql.replaceAll("`", "");
		sql = sql.replaceAll("values\\(", "select ");
		sql = sql.replaceAll("\\);", " from dual   union all  ");
		Pattern pattern = Pattern.compile("'\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}'");
		Matcher matcher = pattern.matcher(sql);
		StringBuffer sb = new StringBuffer();
		while (matcher.find()) {
			String old = matcher.group();
			matcher.appendReplacement(sb, "to_date ( " + old + " , 'YYYY-MM-DD HH24:MI:SS' ) ");
			// matcher.appendTail(sb);
		}
		matcher.appendTail(sb);
		return sb.toString();
	}

	public static void readFileByLines(String fileName) {
		File file = new File(fileName);
		BufferedReader reader = null;
		try {
			reader = new BufferedReader(new FileReader(file));
			String tempString = null;
			int line = 1;
			boolean first = false;
			// 一次读入一行，直到读入null为文件结束
			while ((tempString = reader.readLine()) != null) {
				String sql = mysql2Oracle(tempString);
				if (!first && sql.indexOf("insert") > -1) {
					first = true;
					System.out.println(sql.replace("level", "level_s").replace("number", "number_s"));
				} else {
					System.out.println(sql.replaceAll("insert[\\d\\D]+?\\)", ""));
				}

				line++;
			}
			reader.close();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (reader != null) {
				try {
					reader.close();
				} catch (IOException e1) {
				}
			}
		}
	}
}
