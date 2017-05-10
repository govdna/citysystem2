package com.govmade.service.system.sort;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.entity.system.data.DataElement;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.repository.system.data.DataElementDao;
import com.govmade.repository.system.sort.SortManagerDao;
import com.govmade.service.base.GovmadeBaseServiceImp;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * @author (作者) Chenlei 774329191@qq.com
 * @Description: CitySystem TODO
 * @date 2016年12月8日 上午11:08:48
 * @Title: SortManagerServiceImp.java
 */
@Service("SortManagerService")
public class SortManagerServiceImp extends GovmadeBaseServiceImp<SortManager>implements SortManagerService {

	@Autowired
	private SortManagerDao sortManagerDao;

	// 是否是叶子节点
	private boolean isLeaf(SortManager p, List<SortManager> list) {
		for (SortManager pp : list) {
			if (pp.getSortId().intValue() == p.getId().intValue()) {
				return false;
			}
		}
		return true;
	}

	@Override
	public JSONArray getJqGridTreeJson(SortManager c) {
		List<SortManager> list = sort(find(c, "level_s,list_no", "asc"));
		if (list == null || list.size() == 0) {
			return null;
		}
		JSONArray re = new JSONArray();
		for (SortManager p : list) {
			JSONObject menu = JSONObject.fromObject(p);
			menu.put("idForShow", SecurityUtil.encrypt(p.getId()));
			menu.put("isLeaf", isLeaf(p, list));
			menu.put("expanded", true);
			re.add(menu);
		}
		return re;
	}
	
	public JSONArray getSearch(SortManager c){
		List<SortManager> list = findByPage(c, "level_s,list_no", "asc");
		System.out.println(list+"------");
		if (list == null || list.size() == 0) {
			return null;
		}
		JSONArray re = new JSONArray();
		for (SortManager p : list) {
			JSONObject menu = JSONObject.fromObject(p);
			menu.put("idForShow", SecurityUtil.encrypt(p.getId()));
			menu.put("isLeaf", isLeaf(p, list));
			menu.put("expanded", true);
			re.add(menu);
		}
		return re;
	}

	// 对树进行排序
	public List<SortManager> sort(List<SortManager> list) {
		if (list == null || list.size() <= 1) {
			return list;
		}
		List<SortManager> ps = new ArrayList<SortManager>();
		for (SortManager p : list) {
			if (p.getSortId() == null || p.getSortId() == 0) {
				ps.add(p);
				ps.addAll(getTreeChild(p, list));
			}
		}
		return ps;
	}

	public List<SortManager> getTreeChild(SortManager parent, List<SortManager> list) {
		List<SortManager> re = new ArrayList<SortManager>();
		for (SortManager p : list) {
			if (p.getSortId().intValue() == parent.getId()) {
				re.add(p);
				List<SortManager> ps = getTreeChild(p, list);
				if (ps.size() > 0) {
					re.addAll(ps);
				}
			}
		}
		return re;
	}

	@Override
	public List<SortManager> getSortList(SortManager s) {
		return sortManagerDao.getSortList(s);
	}

	@Override
	public void delete1(SortManager o) {
		sortManagerDao.delete1(o);
	}

	@Override
	public boolean validateName(SortManager sm) {
		List<SortManager> list = sortManagerDao.validateName(sm);
		if (list != null && list.size() > 0) {
			return false;
		}
		return true;
	}

	@Override
	public String importList(List<SortManager> list) {
		if (list != null && list.size() > 0) {
			list = buildTree(list);
			for (SortManager sm : list) {
				importSortManager(sm);
			}
		}
		return null;
	}

	private void importSortManager(SortManager sm) {
		if(sm.getLevel()==null){
			sm.setLevel(1);
		}
		insert(sm);
		List<SortManager> list = sm.getChildrens();
		if (list != null && list.size() > 0) {
			for (SortManager s : list) {
				s.setSortId(sm.getId());
				s.setLevel(sm.getLevel()+1);
				importSortManager(s);
			}
		}
	}

	private List<SortManager> buildTree(List<SortManager> list) {
		List<SortManager> cs = new ArrayList<SortManager>();
		Iterator<SortManager> it = list.iterator();
		while (it.hasNext()) {
			SortManager s = it.next();
			if((s.getLevel()!=null&&s.getLevel().equals(1))||s.getSortId()!=null){
				List<SortManager> l = getChild(s, list);
				if (l.size() > 0) {
					s.setChildrens(l);
				}
				cs.add(s);
			}
		}
		return cs;
	}

	private List<SortManager> getChild(SortManager sm, List<SortManager> list) {
		List<SortManager> cs = new ArrayList<SortManager>();
		Iterator<SortManager> it = list.iterator();
		while (it.hasNext()) {
			SortManager s = it.next();
			if (s.getFatherCode()!=null&&s.getFatherCode().equals(sm.getSortCode())) {
				List<SortManager> l = getChild(s, list);
				if (l.size() > 0) {
					s.setChildrens(l);
				}
				cs.add(s);
			}
		}
		return cs;
	}
}