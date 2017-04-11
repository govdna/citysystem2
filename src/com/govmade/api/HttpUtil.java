package com.govmade.api;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

public class HttpUtil {

	public static String getResult(String url,Map<String,String> params,String secret) throws Exception{
		StringBuffer bufferRes = null;
	    URL urlGet = new URL(url);
	    HttpURLConnection http = (HttpURLConnection) urlGet.openConnection();
	    http.setConnectTimeout(25000);
	    http.setReadTimeout(25000);
	    http.setRequestMethod("POST");
	    StringBuffer paramsStr=new StringBuffer();
	    for(String key:params.keySet()){
	    	paramsStr.append(key).append("=").append(params.get(key)).append("&");
	    }
	    paramsStr.append("sign=").append(SecurityUtil.signTopRequest(params, secret));
	    http.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
	    http.setDoOutput(true);
	    http.setDoInput(true);
	    http.connect();
	    
	    OutputStream out = http.getOutputStream();
	    out.write(paramsStr.toString().getBytes("UTF-8"));
	    out.flush();
	    out.close();
	    
	    InputStream in = http.getInputStream();
	    BufferedReader read = new BufferedReader(new InputStreamReader(in, "utf-8"));
	    String valueString = null;
	    bufferRes = new StringBuffer();
	    while ((valueString = read.readLine()) != null){
	        bufferRes.append(valueString);
	    }
	    in.close();
	    if (http != null) {
	        // 关闭连接
	        http.disconnect();
	    }
	    return bufferRes.toString();
	}
}
