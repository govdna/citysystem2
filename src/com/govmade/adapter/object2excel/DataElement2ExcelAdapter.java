package com.govmade.adapter.object2excel;

import java.util.List;
import java.util.Map;
import com.govmade.common.utils.DataHandler;
import com.govmade.common.utils.ObjectUtil;
import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.Object2ExcelAdapter;
import com.govmade.entity.system.customFields.DataElementFields;
import com.govmade.entity.system.data.DataElement;
import com.govmade.service.system.data.DataElementFieldsService;

public class DataElement2ExcelAdapter extends Object2ExcelAdapter<DataElement> {
	private DataElementFieldsService service = (DataElementFieldsService) ServiceUtil
			.getService("DataElementFieldsService");
	private String[] fields;
	private Map<String,DataHandler> map;
	public DataElement2ExcelAdapter(List<DataElement> list, String[] fields,Map<String,DataHandler> map) {
		super(list);
		this.fields = fields;
		this.map=map;
	}

	@Override
	public String[] getTitle() {
		List<DataElementFields> list = service.find(new DataElementFields());
		String[] str = new String[fields.length];
		for (int i=0;i<fields.length;i++) {
			for (DataElementFields def : list) {

				if (("value" + def.getValueNo()).equals(fields[i])) {
					str[i]=def.getName();
				}

			}
		}
		return str;
	}

	@Override
	public String[] object2StrArray(DataElement t) {
		String[] str = new String[fields.length];
		for(int i=0;i<fields.length;i++){
			DataHandler dh=map.get(fields[i]);
			Object val=ObjectUtil.getFieldValueByName(fields[i], t);
			if(dh!=null){
				Object o=dh.doHandle(val);
				if(val!=null&&o!=null){
					str[i]=o.toString();
				}else{
					str[i]="";
				}
			}else{
				if(val==null){
					str[i]="";
				}else{
					str[i]=val.toString();
				}
			}
			
		}
		return str;
	}

}
