package com.govmade.repository.system.rbac;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.govmade.entity.system.rbac.Permission;
import com.govmade.repository.base.BaseDao;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;

@MYBatis
public interface PermissionDAO  extends GovmadeBaseDao<Permission> {
	public List<Permission> getPermissionsByRoleId(@Param("id")String id,@Param("param")Permission p);

	/**
	 * @param p
	 */
	public void deleteToHouseModelFields(Permission p);
}
