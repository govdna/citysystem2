package com.govmade.adapter;

import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.govmade.common.utils.ServiceUtil;
import com.govmade.common.utils.poi.ExcelAdapter;
import com.govmade.entity.system.sort.SortManager;
import com.govmade.service.system.sort.SortManagerService;

public class SortManagerAdapter  extends ExcelAdapter<SortManager>{

	private SortManagerService sortManagerService;
	
	private Integer belong;;
	private SortManager sortManager;
	

	public SortManagerAdapter(Integer belong) {
		super();
		this.belong = belong;
		sortManager=new SortManager();
		if(belong.equals(1)){
			sortManager.setType(3);
		}else{
			sortManager.setBelong(2);
		}
	}

	private void init(){
		if(sortManagerService==null){
			sortManagerService=(SortManagerService) ServiceUtil.getService("SortManagerService");
		}
		
	}
	
	@Override
	public int getClumnSize() {
		return 3;
	}

	@Override
	public int getStartRow() {
		return 1;
	}

	private boolean validateName(String name){
		SortManager sm=new SortManager();
		sm.setSortName(name);
		sm.setType(sortManager.getType());
		sm.setBelong(sortManager.getBelong());
		return sortManagerService.validateName(sm);
	}
	
	private boolean validateCode(String code){
		for(SortManager s:getEntityList()){
			if(s.getSortCode().equals(code)){
				return false;
			}
		}
		SortManager sm=new SortManager();
		sm.setSortCode(code);
		sm.setType(sortManager.getType());
		sm.setBelong(sortManager.getBelong());
		return sortManagerService.validateName(sm);
	}
	
	@Override
	public SortManager doWithRowData(String[] clumns, int rowNum) {
		init();
		SortManager sm=new SortManager();
		int realNum=rowNum+1;
		if(StringUtils.isEmpty(clumns[0])){
			setError(true);
			appendMsg("第"+realNum+"行，代码为空！");
		}else{
			if(validateCode(clumns[0])){
				sm.setSortCode(clumns[0]);
			}else{
				setError(true);
				appendMsg("第"+realNum+"行，"+clumns[0]+" 代码已存在！");
			}
		}
		
		if(StringUtils.isEmpty(clumns[1])){
			setError(true);
			appendMsg("第"+realNum+"行，名称为空！");
		}else{
			sm.setSortName(clumns[1]);
		}
		
		if(StringUtils.isEmpty(clumns[2])){
			sm.setLevel(1);
			sm.setSortId(0);
		}else{
			boolean hasFather=false;
			for(SortManager s:getEntityList()){
				if(s.getSortCode().equals(clumns[2])){
					hasFather=true;
				}
			}
			if(hasFather){
				sm.setFatherCode(clumns[2]);
			}else{
				SortManager father=new SortManager();
				father.setSortCode(clumns[2]);
				father.setType(sortManager.getType());
				father.setBelong(sortManager.getBelong());
				List<SortManager> list=sortManagerService.find(father);
				if(list!=null&&list.size()>0){
					sm.setSortId(list.get(0).getId());
					sm.setLevel(list.get(0).getLevel()+1);
				}else{
					setError(true);
					appendMsg("第"+realNum+"行，父级代码有误，父级不存在！");
				}
			}
			
		}
		
		if(belong.equals(2)){
			sm.setType(1);
			sm.setBelong(2);
		}else{
			sm.setType(3);
			sm.setBelong(1);
		}
		
		
		return sm;
	}

	public SortManager getSortManager() {
		return sortManager;
	}

	public void setSortManager(SortManager sortManager) {
		this.sortManager = sortManager;
	}

}
