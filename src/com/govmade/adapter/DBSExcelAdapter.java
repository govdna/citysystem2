package com.govmade.adapter;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.apache.commons.lang3.StringUtils;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.ExcelAdapter;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.entity.system.database.GovDatabase;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.organization.Company;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;

/**
 * @author (作者) Dong Jie 154046519@qq.com
 * @Description: citysystem_hainan 多数据库表导入
 * @date 2017年3月14日 上午9:37:49
 * @company (开发公司) 国脉海洋信息发展有限公司
 * @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
 * @since (该版本支持的JDK版本) 1.7
 * @Title: DBExcelAdapter.java
 * @Package com.govmade.adapter
 * @version V1.0
 */
public class DBSExcelAdapter extends ExcelAdapter<GovTableField> {
	private Map<String, String> yesOrNo = new HashMap<String, String>();
	private Map<String,GovTable> tableMap=new HashMap<String,GovTable>();
	private Map<String,GovDatabase> databaseMap=new HashMap<String,GovDatabase>();
	private Map<String,String> companyname=new HashMap<String, String>();
	
	private void initDic() {
		if (yesOrNo.size() > 0) {
			return;
		}
		List<GovmadeDic> dic = ServiceUtil.getDicByDicNum("YESORNO");
		for (GovmadeDic d : dic) {
			yesOrNo.put(d.getDicValue(), d.getDicKey());
		}
		Company com=new Company();
		List<Company> company=(List<Company>)ServiceUtil.getService("CompanyService").find(com);
		for(Company c:company){
			companyname.put(c.getCompanyName(), c.getId()+"");
		}

	}

	@Override
	public int getClumnSize() {
		return 15;
	}

	@Override
	public int getStartRow() {
		return 1;
	}

	@Override
	public GovTableField doWithRowData(String[] clumns, int rowNum) {
		initDic();
		//value1 代码 3
		//value2 名称 4
		//value3 所属表  1
		//value4 关联字段
		//value5 类型 5
		//value6 长度 6
		//value7 精度 7
		//value8 小数位 8
		//value9 是否主键 9
		//value10 可否空 10
		//value11 默认值 11
		//value12 是否外键 11
		GovTableField field = new GovTableField();
		
		GovTable gt=new GovTable();
		gt.setValue1(clumns[2].trim());
		gt.setValue2(clumns[3].trim());
		gt.setValue3(clumns[0].trim());
		if(StringUtils.isNotEmpty(clumns[14])) {
			if(companyname.get(clumns[14])==null){
				appendMsg("不存在该部门！");
				setError(true);
			}else{
				if(!databaseMap.containsKey(clumns[0].trim())){
					GovDatabase base =new GovDatabase();
					base.setValue1(clumns[0].trim());
					base.setValue2(clumns[1].trim()); /// 
					base.setCompanyId(Integer.valueOf(companyname.get(clumns[14].trim())));
					databaseMap.put(clumns[0].trim(),base);
				}
				gt.setCompanyId(Integer.valueOf(companyname.get(clumns[14].trim())));
			}
		}else{
			gt.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
			if(!databaseMap.containsKey(clumns[0].trim())){
				GovDatabase base =new GovDatabase();
				base.setValue1(clumns[0].trim());
				base.setValue2(clumns[1].trim()); /// 
				base.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
				databaseMap.put(clumns[0].trim(),base);
			}
		}
		
		if(tableMap.get(clumns[0].trim()+"?"+clumns[2].trim())==null){
			tableMap.put(clumns[0].trim()+"?"+clumns[2].trim(), gt);
		}
		field.setValue1(clumns[4].trim());
		if(StringUtils.isNotEmpty(clumns[5].trim())){
			field.setValue2(clumns[5].trim());
		}else{
			field.setValue2(clumns[4].trim());
		}
		field.setValue3(clumns[2].trim());
		field.setValue5(clumns[6].trim());
		field.setValue6(clumns[7].trim());
		field.setValue7(clumns[8].trim());
		field.setValue8(clumns[9].trim());
		field.setValue8(clumns[9].trim());
		field.setValue11(clumns[12].trim());
		
		if(StringUtils.isNotEmpty(clumns[14])) {
			if(companyname.get(clumns[14])==null){
				appendMsg("不存在该部门！");
				setError(true);
			}else{
				field.setCompanyId(Integer.valueOf(companyname.get(clumns[14].trim())));
			}
		}else{
			field.setCompanyId(AccountShiroUtil.getCurrentUser().getCompanyId());
		}
		
		if (StringUtils.isNotEmpty(clumns[10])) {
			if (yesOrNo.get(clumns[10].trim()) != null) {
				field.setValue9(yesOrNo.get(clumns[10].trim()));
			}
		}
		if (StringUtils.isNotEmpty(clumns[11])) {
			if (yesOrNo.get(clumns[11].trim()) != null) {
				field.setValue10(yesOrNo.get(clumns[11].trim()));
			}
		}
		if (StringUtils.isNotEmpty(clumns[13])) {
			if (yesOrNo.get(clumns[13].trim()) != null) {
				field.setValue12(yesOrNo.get(clumns[13].trim()));
			}
		}
		addField2Table(clumns[0].trim(),clumns[2].trim(),field);
		return field;
	}

	private void addField2Table(String dbName,String tbName,GovTableField field){
		GovTable table=tableMap.get(dbName+"?"+tbName);
		if(table!=null){
			table.addGovTableField(field);
		}
		
	}


	public Map<String, GovDatabase> getDatabaseMap() {
		return databaseMap;
	}

	public void setDatabaseMap(Map<String, GovDatabase> databaseMap) {
		this.databaseMap = databaseMap;
	}

	public Map<String, GovTable> getTableMap() {
		return tableMap;
	}

	public void setTableMap(Map<String, GovTable> tableMap) {
		this.tableMap = tableMap;
	}

	

	
}
