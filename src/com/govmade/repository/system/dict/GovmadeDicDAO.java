package com.govmade.repository.system.dict;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.repository.base.BaseDao;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;

@MYBatis
public interface GovmadeDicDAO  extends GovmadeBaseDao<GovmadeDic> {
	public List<GovmadeDic> getDicList(GovmadeDic dic);
	public List<GovmadeDic> getDicTreeList(GovmadeDic dic);
	public List<GovmadeDic> getDicByNumKey(GovmadeDic dic);
}
