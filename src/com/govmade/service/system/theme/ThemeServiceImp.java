package com.govmade.service.system.theme;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.govmade.entity.system.theme.Theme;
import com.govmade.service.base.GovmadeBaseServiceImp;

/**   
* @author (作者) Chenlei 774329191@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月28日 上午10:05:09   
* @Title: ThemeServiceImp.java  
*/
@Service("ThemeService")
public class ThemeServiceImp  extends GovmadeBaseServiceImp<Theme> implements ThemeService{
	private static Map<Integer,Theme> cache=new HashMap<Integer,Theme>();
	@Override
	public Theme findById(Theme o) {
		initMap();
		if(cache.containsKey(o.getId())){
			return cache.get(o.getId());
		}
		return super.findById(o);
	}
	
	@Override
	public void insert(Theme o) {
		// TODO Auto-generated method stub
		super.insert(o);
		cache.put(o.getId(), o);
	}

	@Override
	public void update(Theme o) {
		// TODO Auto-generated method stub
		super.update(o);
		cache.put(o.getId(), o);
	}

	private synchronized void initMap(){
		if(cache.size()==0){
			List<Theme> list=find(new Theme());
			for(Theme c:list){
				cache.put(c.getId(), c);
			}
		}
	}
}
