package com.govmade.service.system.information;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.govmade.entity.system.information.InformationLog;
import com.govmade.repository.system.information.InformationBusinessDao;
import com.govmade.repository.system.information.InformationLogDao;
import com.govmade.service.base.GovmadeBaseServiceImp;



/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 最近操作的信息资源
* @date 2017年2月9日 下午1:41:07   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: InformationLogServiceImp.java
* @Package com.govmade.service.system.information
* @version V1.0   
*/
@Service("InformationLogService")
public class InformationLogServiceImp extends GovmadeBaseServiceImp<InformationLog> implements InformationLogService {
	@Autowired
	private InformationLogDao informationLogDao;

	@Override
	public void insert(InformationLog o) {
		List<InformationLog> list=informationLogDao.find(o, null, null);
		if(list!=null&&list.size()>0){
			o=list.get(0);
			o.setTimeModified(new Date());
			informationLogDao.update(o);
		}else{
			super.insert(o);
		}
	}

}
