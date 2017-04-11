package com.govmade.common.utils;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;


/**
 * @ClassName: ObjectUtil
 * @Description: TODO(反射获取属性名和值)
 * @author Dongjie 154046519@qq.com
 * @date 2016年7月11日 下午5:04:55
 * 
 */
public class ObjectUtil {

	

	/**
	 * 获取对象属性，返回一个字符串数组
	 * 
	 * @param o
	 *            对象
	 * @return String[] 字符串数组
	 */
	public static String[] getFiledName(Object o) {
		try {
			List<String> list = new ArrayList<String>();
			Class c = o.getClass();
			while (c != null) {
				Field[] fields = c.getDeclaredFields();
				for (int i = 0; i < fields.length; i++) {
					if (fields[i].getModifiers() == 2) {
						list.add(fields[i].getName());
					}
				}
				c = c.getSuperclass();
			}
			return list.toArray(new String[list.size()]);
		} catch (SecurityException e) {
			e.printStackTrace();
			//System.out.println(e.toString());
		}
		return null;
	}

	/**
	 * 获取对象属性，返回一个字符串数组
	 * 
	 * @param c
	 *            class
	 * @return String[] 字符串数组
	 */
	public static String[] getFiledName(Class c) {
		try {
			List<String> list = new ArrayList<String>();
			while (c != null) {
				Field[] fields = c.getDeclaredFields();
				for (int i = 0; i < fields.length; i++) {
					if (fields[i].getModifiers() == 2) {
						list.add(fields[i].getName());
					}
				}
				c = c.getSuperclass();
			}
			return list.toArray(new String[list.size()]);
		} catch (SecurityException e) {
			e.printStackTrace();
			System.out.println(e.toString());
		}
		return null;
	}

	/**
	 * 使用反射根据属性名称获取属性值
	 * 
	 * @param fieldName
	 *            属性名称
	 * @param o
	 *            操作对象
	 * @return Object 属性值
	 */

	public static Object getFieldValueByName(String fieldName, Object o) {
		try {
			String firstLetter = fieldName.substring(0, 1).toUpperCase();
			String getter = "get" + firstLetter + fieldName.substring(1);
			Method method = o.getClass().getMethod(getter, new Class[] {});
			Object value = method.invoke(o, new Object[] {});
			return value;
		} catch (Exception e) {
			//System.out.println("属性不存在");
			return null;
		}
	}

	public static void copyPo( Object from, Object to, String[] fieldNames) throws Exception {
		Class c=to.getClass();
		while (c != null) {

			Field[] fields = c.getDeclaredFields();
			for (int i = 0; i < fields.length; i++) {
				for (String fn : fieldNames) {
					if (fields[i].getName().equals(fn)) {
						// list.add(fields[i].getName());
						String fieldType = fields[i].getType().getSimpleName();
						String fieldName = fields[i].getName();
						String firstLetter = fieldName.substring(0, 1).toUpperCase();
						String setter = "set" + firstLetter + fieldName.substring(1);
						Method method = to.getClass().getMethod(setter, fields[i].getType());
						Object value = getFieldValueByName(fn, from);
						method.invoke(to, value);

					}
				}

			}
			c = c.getSuperclass();
		}
	}
	
	public static void setValue( Object obj, String fieldNames,Object value) throws Exception {
		Class c=obj.getClass();
		while (c != null) {

			Field[] fields = c.getDeclaredFields();
			for (int i = 0; i < fields.length; i++) {
				if (fields[i].getName().equals(fieldNames)) {
						// list.add(fields[i].getName());
						String fieldType = fields[i].getType().getSimpleName();
						String fieldName = fields[i].getName();
						String firstLetter = fieldName.substring(0, 1).toUpperCase();
						String setter = "set" + firstLetter + fieldName.substring(1);
						Method method = c.getMethod(setter, fields[i].getType());
						method.invoke(obj, value);
				}
			}
			c = c.getSuperclass();
		}
	}

	public static Object initPo(Class c, Map<String,String> map) throws Exception {
		Object obj = c.newInstance();
		while (c != null) {
			Field[] fields = c.getDeclaredFields();
			for (int i = 0; i < fields.length; i++) {
				if (fields[i].getModifiers() == 2) {
					// list.add(fields[i].getName());
					String fieldType = fields[i].getType().getSimpleName();
					String fieldName = fields[i].getName();
					//System.out.println("fieldName:"+fieldName);
					String firstLetter = fieldName.substring(0, 1).toUpperCase();
					String setter = "set" + firstLetter + fieldName.substring(1);
					Method method = obj.getClass().getMethod(setter, fields[i].getType());
					String value=map.get(fieldName);
					//System.out.println("value:"+value);
					if (StringUtils.isNotEmpty(value)) {
						if ("String".equals(fieldType)) {
							method.invoke(obj, value);
						} else if ("Double".equals(fieldType)) {
							method.invoke(obj, Double.valueOf(value));
						} else if ("Integer".equals(fieldType)) {
							if (StringUtils.isNumeric(value)) {
								method.invoke(obj, Integer.valueOf(value));
							} else if(StringUtils.isNotEmpty(value)&&value.length()==64){
								method.invoke(obj,Integer.valueOf(StringUtils.trim(SecurityUtil.decrypt(value))));
							}

						} else if ("Float".equals(fieldType)) {
							method.invoke(obj, Float.valueOf(value));
						} else if ("float".equals(fieldType)) {
							method.invoke(obj, Float.valueOf(value).floatValue());
						} else if ("double".equals(fieldType)) {
							method.invoke(obj, Double.valueOf(value).doubleValue());
						} else if ("int".equals(fieldType)) {
							method.invoke(obj, Integer.valueOf(value).intValue());
						}
					}

				}
			}
			c = c.getSuperclass();
		}
		return obj;
	}

}
