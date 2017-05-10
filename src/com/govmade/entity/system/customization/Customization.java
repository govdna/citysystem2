package com.govmade.entity.system.customization;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import com.govmade.common.utils.StringUtil;
import com.govmade.entity.base.IdBaseEntity;

@Alias("Customization")
public class Customization extends IdBaseEntity{
    /**
     *
     * 
     * 表字段 : gov_customization.id
     * 
     * 
     */
    private Integer id;

    /**
     *
     * 名称
     * 表字段 : gov_customization.cname
     * 
     * 
     */
    private String cname;

    /**
     *
     * 意义
     * 表字段 : gov_customization.meanting
     * 
     * 
     */
    private String meanting;

    /**
     *
     * 用途
     * 表字段 : gov_customization.application
     * 
     * 
     */
    private String application;

    /**
     *
     * 效果
     * 表字段 : gov_customization.effect
     * 
     * 
     */
    private String effect;

    /**
     *
     * 关联数据
     * 表字段 : gov_customization.data_element_id
     * 
     * 
     */
    private String dataElementId;

    /**
     *
     * 单位名称
     * 表字段 : gov_customization.company_id
     * 
     * 
     */
    private Integer companyId;

    /**
     *
     * 
     * 表字段 : gov_customization.group_id
     * 
     * 
     */
    private Integer groupId;



    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname == null ? null : cname.trim();
    }

    public String getMeanting() {
        return meanting;
    }

    public void setMeanting(String meanting) {
        this.meanting = meanting == null ? null : meanting.trim();
    }

    public String getApplication() {
        return application;
    }

    public void setApplication(String application) {
        this.application = application == null ? null : application.trim();
    }

    public String getEffect() {
        return effect;
    }

    public void setEffect(String effect) {
        this.effect = effect == null ? null : effect.trim();
    }

    public String getDataElementId() {
		return StringUtil.toSQLArray(dataElementId);
	}

	public void setDataElementId(String dataElementId) {
		this.dataElementId = StringUtil.toSQLStr(dataElementId);
	}

    public Integer getCompanyId() {
        return companyId;
    }

    public void setCompanyId(Integer companyId) {
        this.companyId = companyId;
    }

    public Integer getGroupId() {
        return groupId;
    }

    public void setGroupId(Integer groupId) {
        this.groupId = groupId;
    }

 
}