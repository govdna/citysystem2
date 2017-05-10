package com.govmade.repository.system.organization;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.rbac.Permission;
import com.govmade.repository.base.BaseDao;
import com.govmade.repository.base.GovmadeBaseDao;
import com.govmade.repository.base.MYBatis;

@MYBatis
public interface CompanyDAO  extends GovmadeBaseDao<Company> {
	
}
