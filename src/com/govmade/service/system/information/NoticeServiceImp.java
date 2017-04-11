package com.govmade.service.system.information;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.information.DataFile;
import com.govmade.entity.system.information.InformationBusiness;
import com.govmade.entity.system.information.InformationRes;
import com.govmade.entity.system.information.Notice;
import com.govmade.entity.system.information.SearchLog;
import com.govmade.entity.system.information.Subscribe;
import com.govmade.repository.system.data.DataListDao;
import com.govmade.repository.system.dict.GovmadeDicDAO;
import com.govmade.repository.system.information.ApplicationDao;
import com.govmade.repository.system.information.DataFileDao;
import com.govmade.repository.system.information.InformationBusinessDao;
import com.govmade.repository.system.information.InformationResDao;
import com.govmade.repository.system.information.NoticeDao;
import com.govmade.repository.system.information.SearchLogDao;
import com.govmade.repository.system.information.SubscribeDao;
import com.govmade.service.base.GovmadeBaseServiceImp;
import com.govmade.service.system.dict.GovmadeDicService;






/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 订阅推送
* @date 2017年1月18日 下午5:21:20   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: NoticeServiceImp.java
* @Package com.govmade.service.system.information
* @version V1.0   
*/
@Service("NoticeService")
public class NoticeServiceImp extends GovmadeBaseServiceImp<Notice> implements NoticeService {
	@Autowired
	private NoticeDao noticeDao;
	
	@Autowired
	private SubscribeDao subscribeDao;
	@Override
	public void sendNotice(Notice n) {
		n.setTimeCreate(new Date());
		n.setTimeModified(new Date());
		
		Subscribe ss=new Subscribe();
		ss.setInformationResourceId(n.getInformationResourceId());
		List<Subscribe> sList=subscribeDao.find(ss, null, null);
		if(sList!=null&&sList.size()>0){
			for(Subscribe s:sList){
				Notice notice=new Notice();
				notice.setAccountId(s.getAccountId());
				notice.setInformationResourceId(n.getInformationResourceId());
				notice.setMsg(n.getMsg());
				notice.setNoticeId(n.getNoticeId());
				notice.setNoticeType(n.getNoticeType());
				notice.setTimeCreate(n.getTimeCreate());
				notice.setTimeModified(n.getTimeModified());
				noticeDao.insert(notice);
			}
		}
		
	}
	
}
