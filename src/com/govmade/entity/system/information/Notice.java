package com.govmade.entity.system.information;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;


/**   
* @author (作者) Dong Jie 154046519@qq.com   
* @Description: CitySystem 订阅推送
* @date 2017年1月18日 下午5:16:59   
* @company (开发公司) 国脉海洋信息发展有限公司
* @copyright (版权) 本文件归国脉海洋信息发展有限公司所有
* @since (该版本支持的JDK版本) 1.7
* @Title: Notice.java
* @Package com.govmade.entity.system.information
* @version V1.0   
*/
@Alias("Notice")
public class Notice extends IdBaseEntity {
	private Integer informationResourceId;//信息资源id
	private String msg;//推送消息
	private Integer accountId;//推送订阅者
	private Integer noticeType;//消息类型 0 信息资源有修改 1 有数据上传
	private Integer noticeId;//消息来源id
	private Integer readed=0;//是否已阅读 0否
	public Integer getInformationResourceId() {
		return informationResourceId;
	}
	public void setInformationResourceId(Integer informationResourceId) {
		this.informationResourceId = informationResourceId;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public Integer getAccountId() {
		return accountId;
	}
	public void setAccountId(Integer accountId) {
		this.accountId = accountId;
	}
	public Integer getReaded() {
		return readed;
	}
	public void setReaded(Integer readed) {
		this.readed = readed;
	}
	public Integer getNoticeType() {
		return noticeType;
	}
	public void setNoticeType(Integer noticeType) {
		this.noticeType = noticeType;
	}
	public Integer getNoticeId() {
		return noticeId;
	}
	public void setNoticeId(Integer noticeId) {
		this.noticeId = noticeId;
	}
	
	
}
