package com.govmade.service.system.data;


import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.base.BaseEntity;
import com.govmade.entity.system.data.CleanDataElement;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.data.SameDataElementConfig;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.repository.system.data.CleanDataElementDao;
import com.govmade.repository.system.data.SameDataElementConfigDao;
import com.govmade.service.base.GovmadeBaseServiceImp;




/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan 数据元近义词配置
* @date 2017年3月27日 上午10:56:47   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: SameDataElementConfigServiceImp.java
* @Package com.govmade.service.system.data
* @version V1.0   
*/
@Service(" SameDataElementConfigService")
public class SameDataElementConfigServiceImp extends GovmadeBaseServiceImp<SameDataElementConfig> implements  SameDataElementConfigService {

	@Autowired
	private SameDataElementConfigDao sameDataElementConfigDao;

	@Override
	public List<SameDataElementConfig> getTreeList(SameDataElementConfig g) {
		List<SameDataElementConfig> list =find(g,"levels","asc");
		List<SameDataElementConfig> cl=new ArrayList<SameDataElementConfig>();
		for(SameDataElementConfig sec:list){
			if(sec.getLevels().intValue()==1){
				setChild(sec,list);
				cl.add(sec);
			}else{
				return cl;
			}
		}
		return cl;
	}

	
	public void setChild(SameDataElementConfig parent, List<SameDataElementConfig> list) {
		List<SameDataElementConfig> re = new ArrayList<SameDataElementConfig>();
		for (SameDataElementConfig p : list) {
			if (p.getFatherId().intValue() == parent.getId()) {
				re.add(p);
			}
		}
		parent.setChildList(re);
	}
}

