package com.govmade.entity.system.application;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.system.base.SimpleFieldsValues;


/** 
* @ClassName: GovApplicationSystem 
* @Description: GovApplicationSystem PO
* @author Dearest
* @date 2016/12/09 13:14
*  
*/
@Alias("GovApplicationSystem")
public class GovApplicationSystem  extends SimpleFieldsValues{

	/**
	 * GovApplicationSystem
	 * 
	 */
		private static final long serialVersionUID = 8825245757324053474L;
		
		/**
	     * 应用系统编号
	     * 表字段 : gov_application_system.appsystem_num
	     */
	    private String appsystemNum;

	    /**
	     * 应用系统名称
	     * 表字段 : gov_application_system.appsystem_name
	     */
	    private String appsystemName;

	    /**
	     * 单位名称
	     * 表字段 : gov_application_system.company_id
	     */
	   // private Integer companyId;

	    /**
	     * 所在网络
	     * 表字段 : gov_application_system.network
	     */
	    private Integer network;

	    /**
	     * 部署服务器
	     * 表字段 : gov_application_system.belong_server_id
	     */
	    private Integer belongServerId;

	    /**
	     * 部署存储器
	     * 表字段 : gov_application_system.belong_memorizer_id
	     */
	    private Integer belongMemorizerId;

		public String getAppsystemNum() {
			return appsystemNum;
		}

		public void setAppsystemNum(String appsystemNum) {
			this.appsystemNum = appsystemNum;
		}

		public String getAppsystemName() {
			return appsystemName;
		}

		public void setAppsystemName(String appsystemName) {
			this.appsystemName = appsystemName;
		}


		public Integer getNetwork() {
			return network;
		}

		public void setNetwork(Integer network) {
			this.network = network;
		}

		public Integer getBelongServerId() {
			return belongServerId;
		}

		public void setBelongServerId(Integer belongServerId) {
			this.belongServerId = belongServerId;
		}

		public Integer getBelongMemorizerId() {
			return belongMemorizerId;
		}

		public void setBelongMemorizerId(Integer belongMemorizerId) {
			this.belongMemorizerId = belongMemorizerId;
		}
}
