package com.govmade.repository.system.rbac;


import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.govmade.entity.system.rbac.Permission;
import com.govmade.entity.system.rbac.RolePermission;
import com.govmade.entity.system.rbac.Scope;
import com.govmade.repository.base.BaseDao;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;

@MYBatis
public interface ScopeDAO  extends GovmadeBaseDao<Scope> {
	public List<Scope> getScopesByRoleId(@Param("id")String id,@Param("param")Permission p);

}
