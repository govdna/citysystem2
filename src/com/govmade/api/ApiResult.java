package com.govmade.api;

/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan API返回参数
* @date 2017年4月5日 上午10:41:28   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: ApiResult.java
* @Package com.govmade.api
* @version V1.0   
*/
public class ApiResult {
	private int code;
	private String msg;
	private Object data;
	public ApiResult() {
		super();
		code=ApiCode.SUCCESS;
		msg="success";
	}
	public int getCode() {
		return code;
	}
	public void setCode(int code) {
		this.code = code;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public Object getData() {
		return data;
	}
	public void setData(Object data) {
		this.data = data;
	}
}
