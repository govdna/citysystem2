package com.govmade.common.converter;

import org.apache.commons.lang3.StringUtils;
import org.springframework.core.convert.converter.Converter;

public class StringToIntegerConverter implements Converter<String, Integer>{

	@Override
	public Integer convert(String arg0) {
		//System.out.println("-----StringToIntegerConverter-----");
		//System.out.println(arg0);
		
		if(arg0!=null&&!arg0.trim().equals("")&&StringUtils.isNumeric(arg0.replaceFirst("-", ""))){
			return Integer.valueOf(arg0);
		}
		//System.out.println("null");
		return null;
	}

}
