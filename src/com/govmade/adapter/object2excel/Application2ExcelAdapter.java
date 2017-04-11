package com.govmade.adapter.object2excel;

import java.util.List;
import java.util.Map;

import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.Object2ExcelAdapter;
import com.govmade.entity.system.application.GovApplicationSystem;
import com.govmade.entity.system.customFields.SimpleFields;
import com.govmade.service.system.simpleFields.SimpleFieldsService;

public class Application2ExcelAdapter extends Object2ExcelAdapter<GovApplicationSystem> {
	private SimpleFieldsService service = (SimpleFieldsService) ServiceUtil
			.getService("SimpleFieldsService");
	private String[] fields;
	private Map<String,DataHandler> map;
	public Application2ExcelAdapter(List<GovApplicationSystem> list, String[] fields,Map<String,DataHandler> map) {
		super(list);
		this.fields = fields;
		this.map=map;
	}

	@Override
	public String[] getTitle() {
		SimpleFields sf = new SimpleFields();
		sf.setIsDeleted(0);
		sf.setClassName("GovApplicationSystem");
		List<SimpleFields> list = service.find(sf);
		String[] str = new String[fields.length];
		for (int i=0;i<fields.length;i++) {
			for (SimpleFields def : list) {

				if (("value" + def.getValueNo()).equals(fields[i])) {
					str[i]=def.getName();
				}

			}
		}
		return str;
	}

	@Override
	public String[] object2StrArray(GovApplicationSystem t) {
		String[] str = new String[fields.length];
		for(int i=0;i<fields.length;i++){
			DataHandler dh=map.get(fields[i]);
			Object val=ObjectUtil.getFieldValueByName(fields[i], t);
			if(dh!=null){
				if(val!=null&&dh.doHandle(val)!=null){
					str[i]=dh.doHandle(val).toString();
				}else{
					str[i]="";
				}
			}else{
				str[i]=val.toString();
			}
			
		}
		return str;
	}

}
