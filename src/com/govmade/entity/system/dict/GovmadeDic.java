package com.govmade.entity.system.dict;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;


/** 
* @ClassName: GovmadeDic 
* @Description: TODO(数据字典) 
* @author Dongjie 154046519@qq.com 
* @date 2016年6月22日 上午10:44:48 
*  
*/
@Alias("GovmadeDic")
public class GovmadeDic  extends IdBaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8825245757324053474L;
	private String dicNum;//字典号
	private String dicName;//字典名称
	private String dicKey;
	private String dicValue;//字典值
	private Integer listNo;//排序
	private Integer rootId;//根节点
	private Integer fatherId;//父节点
	private Integer level;//层级
	
	public String getDicNum() {
		return dicNum;
	}
	public void setDicNum(String dicNum) {
		this.dicNum = dicNum;
	}
	
	
	
	public String getDicName() {
		return dicName;
	}
	public void setDicName(String dicName) {
		this.dicName = dicName;
	}
	public String getDicKey() {
		return dicKey;
	}
	public void setDicKey(String dicKey) {
		this.dicKey = dicKey;
	}
	public String getDicValue() {
		return dicValue;
	}
	public void setDicValue(String dicValue) {
		this.dicValue = dicValue;
	}
	public Integer getFatherId() {
		return fatherId;
	}
	public void setFatherId(Integer fatherId) {
		this.fatherId = fatherId;
	}

	public Integer getRootId() {
		return rootId;
	}
	public void setRootId(Integer rootId) {
		this.rootId = rootId;
	}
	public Integer getLevel() {
		return level;
	}
	public void setLevel(Integer level) {
		this.level = level;
	}
	public Integer getListNo() {
		return listNo;
	}
	public void setListNo(Integer listNo) {
		this.listNo = listNo;
	}
	
}
