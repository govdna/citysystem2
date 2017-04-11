package com.govmade.entity.system.server;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.system.base.SimpleFieldsValues;


/** 
* @ClassName: GovServer 
* @Description: GovServer PO
* @author Dearest
* @date 2016/12/09 13:14
*  
*/
@Alias("GovServer")
public class GovServer  extends SimpleFieldsValues{

	/**
	 * GovComputerRoom
	 * 
	 */
		private static final long serialVersionUID = 8825245757324053474L;
		
		 /**
	     * 服务器编号
	     * 表字段 : gov_server.server_num
	     */
	    private String serverNum;

	    /**
	     * 单位名称
	     * 表字段 : gov_server.company_id
	     */
	   // private Integer companyId;

	    /**
	     * 服务器品牌
	     * 表字段 : gov_server.server_brand
	     */
	    private Integer serverBrand;

	    /**
	     * 服务器型号
	     * 表字段 : gov_server.server_model
	     */
	    private String serverModel;

	    /**
	     * 服务器数量
	     * 表字段 : gov_server.number
	     */
	    private Integer number;

	    /**
	     * 服务器类型
	     * 表字段 : gov_server.server_type
	     */
	    private Integer serverType;

	    /**
	     * 操作系统
	     * 表字段 : gov_server.operating_system
	     */
	    private Integer operatingSystem;

	    /**
	     * 购买时间
	     * 表字段 : gov_server.buying_time
	     */
	    private String buyingTime;

	    /**
	     * 备注
	     * 表字段 : gov_server.remark
	     */
	    private String remark;

	    /**
	     * 所在机房
	     * 表字段 : gov_server.belong_cproom_id
	     */
	    private Integer belongCproomId;

		public String getServerNum() {
			return serverNum;
		}

		public void setServerNum(String serverNum) {
			this.serverNum = serverNum;
		}


		public Integer getServerBrand() {
			return serverBrand;
		}

		public void setServerBrand(Integer serverBrand) {
			this.serverBrand = serverBrand;
		}

		public String getServerModel() {
			return serverModel;
		}

		public void setServerModel(String serverModel) {
			this.serverModel = serverModel;
		}

		public Integer getNumber() {
			return number;
		}

		public void setNumber(Integer number) {
			this.number = number;
		}

		public Integer getServerType() {
			return serverType;
		}

		public void setServerType(Integer serverType) {
			this.serverType = serverType;
		}

		public Integer getOperatingSystem() {
			return operatingSystem;
		}

		public void setOperatingSystem(Integer operatingSystem) {
			this.operatingSystem = operatingSystem;
		}

		public String getBuyingTime() {
			return buyingTime;
		}

		public void setBuyingTime(String buyingTime) {
			this.buyingTime = buyingTime;
		}

		public String getRemark() {
			return remark;
		}

		public void setRemark(String remark) {
			this.remark = remark;
		}

		public Integer getBelongCproomId() {
			return belongCproomId;
		}

		public void setBelongCproomId(Integer belongCproomId) {
			this.belongCproomId = belongCproomId;
		}
	
	
}
