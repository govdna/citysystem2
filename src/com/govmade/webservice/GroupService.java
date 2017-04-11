package com.govmade.webservice;

import javax.jws.WebService;
import javax.xml.ws.Endpoint;

@WebService
public class GroupService {
	public String queryWeather(String cityName) {
        System.out.println("from client"+cityName);
        String result="晴朗";
        return result;
    }
	
	 public static void main (String []args){
	        String address ="http://127.0.0.1:12345/weather";
	        Endpoint.publish(address, new GroupService());
	        System.out.print("发布webservice");
	    }
}
