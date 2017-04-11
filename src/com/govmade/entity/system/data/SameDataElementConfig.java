package com.govmade.entity.system.data;

import java.util.List;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;

/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: citysystem_hainan 数据元近义词配置
* @date 2017年3月27日 上午10:47:07   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: SameDataElementConfig.java
* @Package com.govmade.entity.system.data
* @version V1.0   
*/
@Alias("SameDataElementConfig")
public class SameDataElementConfig  extends IdBaseEntity{
	private String name;//配置名字
	private Integer fatherId;//父节点
	private Integer levels;//层级
	private Integer counts;//次数
	private List<SameDataElementConfig> childList;
	public String getName() {
		return name;
	}
	public String getSQLName() {
		return name.replaceAll("\\*", "%");
	}
	
	public void setName(String name) {
		this.name = name;
	}
	public Integer getFatherId() {
		return fatherId;
	}
	public void setFatherId(Integer fatherId) {
		this.fatherId = fatherId;
	}
	public Integer getLevels() {
		return levels;
	}
	public void setLevels(Integer levels) {
		this.levels = levels;
	}
	public List<SameDataElementConfig> getChildList() {
		return childList;
	}
	public void setChildList(List<SameDataElementConfig> childList) {
		this.childList = childList;
	}
	public Integer getCounts() {
		return counts;
	}
	public void setCounts(Integer counts) {
		this.counts = counts;
	}

}
