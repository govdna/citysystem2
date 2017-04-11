package com.govmade.service.system.model;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.govmade.common.utils.SecurityUtil;
import com.govmade.entity.system.model.HouseModelFields;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.rbac.RolePermission;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.repository.system.model.HouseModelFieldsDao;
import com.govmade.repository.system.rbac.PermissionDAO;
import com.govmade.repository.system.rbac.RolePermissionDAO;
import com.govmade.repository.system.sort.SortManagerDao;
import com.govmade.service.base.GovmadeBaseServiceImp;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**   
* @author (作者) Zhanglu 274059078@qq.com   
* @Description: CitySystem TODO
* @date 2017年2月14日 下午1:31:45   
* @Title: HouseModelFieldsServiceImp.java  
*/
@Service("HouseModelFieldsService")
public class HouseModelFieldsServiceImp extends GovmadeBaseServiceImp<HouseModelFields> implements HouseModelFieldsService{

	@Autowired
	private HouseModelFieldsDao houseModelFieldsDao;
	@Autowired
	private RolePermissionDAO rolePermissionDao;
	@Autowired
	private PermissionDAO permissionDao;

	// 是否是叶子节点
	private boolean isLeaf(HouseModelFields p, List<HouseModelFields> list) {
		for (HouseModelFields pp : list) {
			if (pp.getFatherId().intValue() == p.getId().intValue()) {
				return false;
			}
		}
		return true;
	}

	@Override
	public JSONArray getJqGridTreeJson(HouseModelFields c) {
		List<HouseModelFields> list = sort(find(c, "model_type,level_s,list_no", "asc"));
		if (list == null || list.size() == 0) {
			return null;
		}
		JSONArray re = new JSONArray();
		for (HouseModelFields p : list) {
			JSONObject menu = JSONObject.fromObject(p);
			menu.put("idForShow", SecurityUtil.encrypt(p.getId()));
			menu.put("isLeaf", isLeaf(p, list));
			menu.put("expanded", true);
			re.add(menu);
		}
		return re;
	}

	// 对树进行排序
	public List<HouseModelFields> sort(List<HouseModelFields> list) {
		if (list == null || list.size() <= 1) {
			return list;
		}
		List<HouseModelFields> ps = new ArrayList<HouseModelFields>();
		for (HouseModelFields p : list) {
			if (p.getFatherId() == null || p.getFatherId() == 0) {
				ps.add(p);
				ps.addAll(getTreeChild(p, list));
			}
		}
		return ps;
	}

	public List<HouseModelFields> getTreeChild(HouseModelFields parent, List<HouseModelFields> list) {
		List<HouseModelFields> re = new ArrayList<HouseModelFields>();
		for (HouseModelFields p : list) {
			if (p.getFatherId().intValue() == parent.getId()) {
				re.add(p);
				List<HouseModelFields> ps = getTreeChild(p, list);
				if (ps.size() > 0) {
					re.addAll(ps);
				}
			}
		}
		return re;
	}

	@Override
	public void delete(HouseModelFields o) {
		//System.out.println("o=v "+o);
		if(o.getFatherId()==0 && o.getLevel()==1){
			HouseModelFields houseModelFields=houseModelFieldsDao.find(o, null, null).get(0);
			
			// 删除菜单
			Permission p=new Permission();
			p.setNodeName(houseModelFields.getModelName());
			p.setUrl("/backstage/model/customModel/index?model="+houseModelFields.getModelType());
			permissionDao.deleteToHouseModelFields(p);
			//
			Permission p2=new Permission();
			p2.setNodeName(houseModelFields.getModelName()+"树形图");
			p2.setUrl("/backstage/model/houseModel/treeAjax?type="+houseModelFields.getModelType());
			permissionDao.deleteToHouseModelFields(p2);
			
			// 删除权限

			
			// 删除子集
			houseModelFieldsDao.deleteByFatherId(o);
		}
		baseDao.delete(o);
	}
	
}
