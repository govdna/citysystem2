package com.govmade.service.system.organization;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.govmade.common.utils.SecurityUtil;
import com.govmade.entity.system.organization.Company;
import com.govmade.repository.system.organization.CompanyDAO;
import com.govmade.service.base.GovmadeBaseServiceImp;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("CompanyService")
public class CompanyServiceImp extends GovmadeBaseServiceImp<Company> implements CompanyService {

}
