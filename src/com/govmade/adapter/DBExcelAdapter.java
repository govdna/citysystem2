package com.govmade.adapter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.lang3.StringUtils;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.ExcelAdapter;
import com.govmade.entity.system.dict.GovmadeDic;
import com.govmade.entity.system.tablex.GovTable;
import com.govmade.entity.system.tablex.GovTableField;


/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan 数据库表导入
* @date 2017年3月14日 上午9:37:49   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: DBExcelAdapter.java
* @Package com.govmade.adapter
* @version V1.0   
*/
public class DBExcelAdapter extends ExcelAdapter<GovTableField>{
	private Map<String,String> yesOrNo=new HashMap<String, String>(); 
	
	private GovTable table;
	
	private void initDic(){
		if(yesOrNo.size()>0){
			return ;
		}
		List<GovmadeDic> dic=ServiceUtil.getDicByDicNum("YESORNO");
		for(GovmadeDic d:dic){
			yesOrNo.put(d.getDicValue(), d.getDicKey());
		}
		
	}
	
	@Override
	public int getClumnSize() {
		return 6;
	}

	@Override
	public int getStartRow() {
		return 0;
	}

	@Override
	public GovTableField doWithRowData(String[] clumns, int rowNum) {
		 initDic();
		if(rowNum==0){
			table=new GovTable();
			table.setValue1(clumns[1]);
			table.setValue2(clumns[4]);
		}else if(rowNum>1&&StringUtils.isNotEmpty(clumns[1])){
			GovTableField field=new GovTableField();
			field.setValue1(clumns[1].trim());
			field.setValue2(clumns[3].trim());
			if(StringUtils.isNotEmpty(clumns[2])){
				Pattern pattern = Pattern.compile("([a-zA-Z0-9]+)\\(?(\\d*)\\)?");
				Matcher matcher = pattern.matcher(clumns[2].trim());
				if(matcher.find()){
					field.setValue5(matcher.group(1));
					field.setValue6(matcher.group(2));
				}
			}
			if(StringUtils.isNotEmpty(clumns[4])){
				if(yesOrNo.get(clumns[4].trim())!=null){
					field.setValue7(yesOrNo.get(clumns[4].trim()));
				}
			}
			field.setValue8(clumns[5]);
			return field;
		}
		return null;
	}

	public GovTable getTable() {
		return table;
	}

	public void setTable(GovTable table) {
		this.table = table;
	}



}
