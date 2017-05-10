package com.govmade.service.system.information;



import com.govmade.entity.system.information.Notice;
import com.govmade.entity.system.information.Subscribe;
import com.govmade.service.base.BaseService;

public interface NoticeService extends BaseService<Notice>{
	/** 
	* @Title: sendNotice 
	* @Description: TODO(批量推送) 
	* @param @param n    设定文件 
	* @return void    返回类型 
	* 2017年1月19日    日期   
	*/ 
	public void sendNotice(Notice n);
}
