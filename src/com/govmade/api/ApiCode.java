package com.govmade.api;

public class ApiCode {
	public final static int SUCCESS=0;
	public final static int MISSING_PARAMETER=10;//缺少参数
	public final static int ILLEGAL_PARAMETER=11;//参数不规范
	public final static int OVER_TIME=20;//请求超时
	public final static int ERROR_SIGN=30;//签名错误
	public final static int OVER_SIZE=40;//数据过多
	public final static int  SERVICE_ERROR=50;//服务器运行出错
}
