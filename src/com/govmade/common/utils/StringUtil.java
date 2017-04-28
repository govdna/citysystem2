package com.govmade.common.utils;

import java.io.ByteArrayOutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

public class StringUtil {
	public static void main(String[] args) {
		System.out.println(stringMatching("女方姓名","男方姓名"));
	}
	/** 
	* @Title: stringMatching 
	* @Description: TODO(匹配程度 ) 
	* @param @param m 
	* @param @param target
	* @param @return    设定文件 
	* @return int    返回类型 
	* 2017年4月28日    日期   
	*/ 
	public static int stringMatching(String m,String target){
		int lastMacth=0;
		int macthTime=0;
		if(StringUtils.isEmpty(m)||StringUtils.isEmpty(target)){
			return 0;
		}
		for(int i=0;i<m.length();i++){
			int c=target.indexOf(m.charAt(i));
			if(c>-1&&c>lastMacth){
				lastMacth=c;
				macthTime++;
			}
		}
		return macthTime*100/m.length();
	}

	public static String toDateString(String str){
		String [] d=str.split("-");
		StringBuffer sb=new StringBuffer();
		if(d[1].startsWith("0")){
			sb.append(d[1].charAt(1));
		}else{
			sb.append(d[1]);
		}
		sb.append("月");
		if(d[2].startsWith("0")){
			sb.append(d[2].charAt(1));
		}else{
			sb.append(d[2]);
		}
		sb.append("日");
		return sb.toString();
	}
	
	
	public static String arrayToString(String [] args){
		String re="";
		if(args==null||args.length<=0){
			return re;
		}
		
		for(String ss:args){
			re+=","+ss;
		}
		re+=",";
		return re;
	}
	/** 
	* @Title: buildNumber 
	* @Description: TODO(根据编号规则生成字符串，位数不够填0) 
	* @param @param num
	* @param @param numberRole
	* @param @return    设定文件 
	* @return String    返回类型 
	* @throws 
	*/
	public static String buildNumber(int num,String numberRole) {
		if(StringUtils.isEmpty(numberRole)){
			return "";
		}
		String number=num+"";
		//HTyymmdd{4}
		Date currentTime = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");
		String dateString = formatter.format(currentTime);
		String [] ts=dateString.split("-");
		numberRole=numberRole.replace("{y}", ts[0]).replace("{M}", ts[1]).replace("{d}", ts[2]).replace("{H}", ts[3]).replace("{m}", ts[4]).replace("{s}", ts[5]);
		Pattern    pattern = Pattern.compile("\\{x(\\d+)\\}");
        Matcher matcher = pattern.matcher(numberRole);
		if(matcher.find()){
			int size=Integer.valueOf(matcher.group(1));
			numberRole=numberRole.replaceAll("\\{x\\d+\\}",String.format("%0"+size+"d", num));
		}
        //System.out.println(numberRole);
		return numberRole;
	}
	
	public static String urlencoder(String str) {
		if (str == null || str == "")
			return "";
		try {
			return URLEncoder.encode(str, "gbk");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}

	public static String toSQLArray(String str){
		if (str == null || str == ""){
			return "";
		}
		if(str.contains(",,")){
			str=str.replaceAll(",+", ",");
		}
		if(str.startsWith(",")){
			str=str.substring(1,str.length());
		}
		if(str.endsWith(",")){
			str=str.substring(0,str.length()-1);
		}
		return str;
	}
	//两边加逗号
	public static String toSQLStr(String str){
		if (str == null || str == ""){
			return "";
		}
		if(str.contains(",,")){
			str=str.replaceAll(",+", ",");
		}
		if(!str.startsWith(",")){
			str=","+str;
		}
		if(!str.endsWith(",")){
			str=str+",";
		}
		return str;
	}
	
	public static Object [] toSQLObjectArray(String str){
		str=toSQLArray(str);
		String [] list=str.split(",");
		Object [] objs=new  Object[list.length];
		for(int i=0;i<list.length;i++){
			objs[i]=list[i];
		}
		return objs;
	}
	
	public static String urldecoder(String str) {
		if (str == null || str == "")
			return "";
		try {
			return URLDecoder.decode(str, "gbk");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}

	public static String delHtml(String str) {
		String temp = str;
		temp = temp.replaceAll("[\f\r\t]", "");
		temp = temp.replaceAll("<br>", "\n");
		temp = temp.replaceAll("&(quot|#34);", "\"");
		temp = temp.replaceAll("&(amp|#38);", "&");
		temp = temp.replaceAll("&(lt|#60);", "<");
		temp = temp.replaceAll("&(gt|#62);", ">");
		temp = temp.replaceAll("&(nbsp|#160);", " ");
		temp = temp.replaceAll("&(iexcl|#161)", "?");
		temp = temp.replaceAll("&(cent|#162);", "?");
		temp = temp.replaceAll("&(pound|#163);", "?");
		temp = temp.replaceAll("&(copy|#169);", "?");
		temp = temp.replaceAll("<[^>]*>", "");
		return temp;
	}

	public static String toScriptStr(String str) {
		if (StringUtil.is_Empty(str))
			return "";
		str = str.replace("\n", "\\n");
		str = str.replace("\"", "\\\"");
		str = str.replaceAll("	", " ");
		str = str.replaceAll("  ", " ");
		str = str.replace("\r", "");
		return str;
	}

	public static String showShort(String content, int length) {
		if (content == null)
			return null;
		if (content.getBytes().length <= length)
			return content;

		byte[] s = content.getBytes();
		int flag = 0;
		for (int i = 0; i < length; ++i) {
			if (s[i] < 0)
				flag++;
		}
		if (flag % 2 != 0)
			length--;

		byte[] d = new byte[length];
		System.arraycopy(s, 0, d, 0, length);
		return new String(d) + "..";
	}

	public static String toHtml(String str) {
		String temp = str;
		temp = temp.replaceAll("&(nbsp|#160);", " ");
		temp = temp.replaceAll("<", "&lt;");
		temp = temp.replaceAll(">", "&gt;");
		temp = temp.replaceAll("\n", "<br>");
		return temp;
	}

	public static String dtoHtml(String str) {
		if (StringUtil.is_Empty(str)) {
			return "";
		}
		String temp = StringUtil.delHtml(str);
		temp = StringUtil.toHtml(temp);
		return temp;
	}

	public static String getBASE64(String s) {
		if (s == null)
			return null;
		return (new BASE64Encoder()).encode(s.getBytes());
	}

	public static String getFromBASE64(String s) {
		if (s == null)
			return null;
		BASE64Decoder decoder = new BASE64Decoder();
		try {
			byte[] b = decoder.decodeBuffer(s);
			return new String(b);
		} catch (Exception e) {
			return null;
		}
	}

	public static String getMD5(String str) {
		if (str == null || str.length() == 0) {
			return "";
		}

		StringBuffer hexString = new StringBuffer();

		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(str.getBytes());
			byte[] hash = md.digest();

			for (int i = 0; i < hash.length; i++) {
				if ((0xff & hash[i]) < 0x10) {
					hexString.append("0"
							+ Integer.toHexString((0xFF & hash[i])));
				} else {
					hexString.append(Integer.toHexString(0xFF & hash[i]));
				}
			}
		} catch (NoSuchAlgorithmException e) {

		}
		return hexString.toString();
	}

	public static String mergeString(String str1, String str2) {
		StringBuffer tmp = new StringBuffer();
		tmp.append(str1);
		tmp.append(str2);
		return tmp.toString();
	}

	public static String joinArr(Object[] arr, String type) {
		StringBuffer tmp = new StringBuffer();
		int i = 0;
		for (Object o : arr) {
			String s = String.valueOf(o);
			if (i > 0) {
				tmp.append(type);
			}
			tmp.append(s);
			i++;
		}
		return tmp.toString();
	}

	public static String joinArrforInt(int[] arr, String type, int out) {
		StringBuffer tmp = new StringBuffer();
		int i = 0;
		for (int o : arr) {
			if (o == out)
				continue;
			if (i > 0) {
				tmp.append(type);
			}
			tmp.append(String.valueOf(o));
			i++;
		}
		return tmp.toString();
	}

	

	public static boolean findArr(String index, String strarr, String type) {
		if (StringUtil.is_Empty(strarr))
			return false;
		String[] l = strarr.split(type);
		for (int i = 0; i < l.length; i++) {
			if (l[i].equals(index)) {
				return true;
			}
		}
		return false;
	}

	public static int indexArr(String index, String strarr, String type) {
		if (StringUtil.is_Empty(strarr))
			return -1;
		String[] l = strarr.split(type);
		for (int i = 0; i < l.length; i++) {
			if (l[i].equals(index)) {
				return i;
			}
		}
		return -1;
	}

	public static String delArr(String index, String strarr, String type) {
		if (StringUtil.is_Empty(strarr))
			return "";
		String[] l = strarr.split(type);
		StringBuffer tmp = new StringBuffer();
		for (int i = 0; i < l.length; i++) {
			if (!l[i].equals(index) && l[i].length() > 0) {
				if (tmp.length() > 0)
					tmp.append(type);
				tmp.append(l[i]);
			}
		}
		return tmp.toString();
	}

	public static String joinString(String[] str, String type) {
		StringBuffer s = new StringBuffer();
		int i = 0;
		for (String value : str) {
			if (i > 0 && !StringUtil.is_Empty(type))
				s.append(type);
			s.append(value);
			i++;
		}
		return s.toString();
	}

	public static String setSafeUrl(String url) {
		if (url.indexOf("?") >= 0) {
			url = StringUtil.mergeString(url, "&");
		} else {
			url = StringUtil.mergeString(url, "?");
		}
		return url;
	}

	public static String toSafeStr(String str) {
		str = str.replaceAll("\"", "��");
		str = str.replaceAll("'", "��");
		str = str.replaceAll("	", " ");
		str = str.replaceAll("  ", " ");
		str = str.replaceAll("\r", "");
		str = str.replaceAll("\n", "\\n");
		return str;
	}

	public static String toSafeSqlStr(String str) {
		str = str.replace("\"", "\\\"");
		return str;
	}

	public static String delNullStr(String str) {
		if (str == null)
			return "";
		return str;
	}

	public static String utf2gbk(String str) {
		String tmp = "";
		try {
			tmp = new String(str.getBytes("utf-8"), "gbk");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return tmp;
	}

	public static String gbk2utf(String str) {
		String tmp = "";
		try {
			tmp = new String(str.getBytes("gbk"), "utf-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return tmp;
	}

	public static String decodeQuotedPrintable(String str) {
		byte ESCAPE_CHAR = '=';
		if (str == null) {
			return null;
		}
		byte[] bytes = str.getBytes();
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();
		for (int i = 0; i < bytes.length; i++) {
			int b = bytes[i];
			if (b == ESCAPE_CHAR) {
				try {
					int u = Character.digit((char) bytes[++i], 16);
					int l = Character.digit((char) bytes[++i], 16);
					if (u == -1 || l == -1) {
						// ����
						return "";
					}
					buffer.write((char) ((u << 4) + l));
				} catch (ArrayIndexOutOfBoundsException e) {
					// ����
					return "";
				}
			} else {
				buffer.write(b);
			}
		}
		bytes = buffer.toByteArray();
		str = "";
		try {
			str = new String(bytes, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return str;
	}

	public static boolean is_Empty(String str) {
		if (str == null)
			return true;
		if (str.length() == 0)
			return true;
		return false;
	}

	public static boolean isHttpUrl(String url) {
		return (url.toLowerCase().indexOf("http://") >= 0);
	}

	public static boolean is_Email(String str) {
		if (is_Empty(str))
			return false;
		String check = "\\w+(\\.\\w+)*@\\w+(\\.\\w+)+";
		Pattern regex = Pattern.compile(check);
		Matcher matcher = regex.matcher(str);
		boolean isMatched = matcher.matches();
		if (isMatched) {
			return true;
		} else {
			return false;
		}
	}
}