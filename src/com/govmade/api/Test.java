package com.govmade.api;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

public class Test {
public static void main(String[] args) throws Exception {
    String app_key="551dcbf431e44458be6f8c75a5a7d235";
    String timestamp= System.currentTimeMillis()+"";
    Map<String,String> map=new HashMap<String,String>();
    map.put("app_key", app_key);
    map.put("timestamp", timestamp);
    map.put("id", "68");
    System.out.println(HttpUtil.getResult("http://114.55.11.227:8088/CitySystem_Hainan/api/information",map,"9QH3cpEygv2MaKPa7NAXw"));
}


}
