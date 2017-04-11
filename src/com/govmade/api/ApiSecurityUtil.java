package com.govmade.api;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.lang3.StringUtils;

import com.govmade.entity.system.api.ApiAccount;

import sun.misc.BASE64Encoder;

public class ApiSecurityUtil {
	
	public static void main(String[] args) throws Exception {
		  ApiAccount a=new ApiAccount();
		  ApiSecurityUtil.setAppKey(a);
		  System.out.println(a.getAppKey());
		  System.out.println(a.getSecret());
	}
	
	public static ApiAccount setAppKey(ApiAccount account) throws Exception{
		UUID uuid = UUID.randomUUID();
		account.setAppKey(uuid.toString().replaceAll("-", ""));
		MessageDigest md5=MessageDigest.getInstance("MD5");
	    BASE64Encoder base64en = new BASE64Encoder();
	    String scret=base64en.encode(md5.digest(uuid.toString().getBytes("utf-8")));
	    account.setSecret(scret.replaceAll("\\W", ""));
		return account;
	}
	
	public static String signTopRequest(Map<String, String> params, String secret) throws Exception {
	    // 第一步：检查参数是否已经排序
	    String[] keys = params.keySet().toArray(new String[0]);
	    Arrays.sort(keys);
	 
	    // 第二步：把所有参数名和参数值串在一起
	    StringBuilder query = new StringBuilder();
	    query.append(secret);
	    for (String key : keys) {
	        String value = params.get(key);
	        if (StringUtils.isNotEmpty(value)) {
	            query.append(key).append(value);
	        }
	    }
	 
	    // 第三步：使用MD5/HMAC加密
	    byte[] bytes;
	    query.append(secret);
	    bytes = encryptMD5(query.toString());
	    // 第四步：把二进制转化为大写的十六进制
	    return byte2hex(bytes);
	}
	 
	
	 
	public static byte[] encryptMD5(String data) throws  Exception {
		MessageDigest md5=MessageDigest.getInstance("MD5");
        BASE64Encoder base64en = new BASE64Encoder();
        //加密后的字符串
		return base64en.encode(md5.digest(data.getBytes("utf-8"))).getBytes();
	}
	 
	
	
	public static String byte2hex(byte[] bytes) {
	    StringBuilder sign = new StringBuilder();
	    for (int i = 0; i < bytes.length; i++) {
	        String hex = Integer.toHexString(bytes[i] & 0xFF);
	        if (hex.length() == 1) {
	            sign.append("0");
	        }
	        sign.append(hex.toUpperCase());
	    }
	    return sign.toString();
	}
}
