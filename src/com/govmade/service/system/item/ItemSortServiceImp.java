package com.govmade.service.system.item;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.entity.system.data.DataList;
import com.govmade.entity.system.information.InformationResource;
import com.govmade.entity.system.item.ItemSort;
import com.govmade.repository.system.data.DataListDao;
import com.govmade.repository.system.item.ItemSortDao;
import com.govmade.service.base.GovmadeBaseServiceImp;


/**   
* @author (作者) Chenlei 774329191@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月20日 上午10:10:22   
* @Title: ItemSortServiceImp.java  
*/
@Service("ItemSortService")
public class ItemSortServiceImp extends GovmadeBaseServiceImp<ItemSort> implements ItemSortService{

	@Autowired
	private ItemSortDao itemSortDao;
	@Autowired
	private DataListDao dataListDao;
	
	

	@Override
	public void delete(ItemSort o) {
		baseDao.delete(o);
		DataList d=new DataList();
		d.setItemSortId(o.getId());
		dataListDao.deleteByItemSortId(d);
	}
}
