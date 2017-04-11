package com.govmade.repository.system.information;

import java.util.List;

import com.govmade.entity.system.information.DataFile;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.Notice;
import com.govmade.entity.system.information.SearchLog;
import com.govmade.entity.system.information.Subscribe;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;





/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 订阅推送
* @date 2017年1月18日 下午5:19:38   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: NoticeDao.java
* @Package com.govmade.repository.system.information
* @version V1.0   
*/
@MYBatis
public interface NoticeDao extends GovmadeBaseDao<Notice> {
	
}
