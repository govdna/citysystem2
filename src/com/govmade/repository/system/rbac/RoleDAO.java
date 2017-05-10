package com.govmade.repository.system.rbac;


import com.govmade.entity.system.rbac.Role;
import com.govmade.repository.base.BaseDao;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;

@MYBatis
public interface RoleDAO  extends GovmadeBaseDao<Role> {

}
