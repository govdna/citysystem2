package com.govmade.entity.system.memorizer;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.system.base.SimpleFieldsValues;


/** 
* @ClassName: GovMemorizer 
* @Description: GovMemorizer PO
* @author Dearest
* @date 2016 12/9 9:21  
*/


@Alias("GovMemorizer")
public class GovMemorizer  extends SimpleFieldsValues{
	
		private static final long serialVersionUID = 8825245757324053474L;
		
	    /**
	     * 存储器编号
	     * 表字段 : gov_memorizer.memorizer_num
	     */
	    private String memorizerNum;

	    /**
	     * 单位名称
	     * 表字段 : gov_memorizer.company_id
	     */
	   // private Integer companyId;

	    /**
	     * 存储器品牌
	     * 表字段 : gov_memorizer.memorizer_brand
	     */
	    private Integer memorizerBrand;

	    /**
	     * 存储器型号
	     * 表字段 : gov_memorizer.memorizer_model
	     */
	    private String memorizerModel;

	    /**
	     * 存储器数量
	     * 表字段 : gov_memorizer.number
	     */
	    private Integer number;

	    /**
	     * 存储器类型
	     * 表字段 : gov_memorizer.memorizer_type
	     */
	    private Integer memorizerType;

	    /**
	     * 设备容量
	     * 表字段 : gov_memorizer.equipment_capacity
	     */
	    private String equipmentCapacity;

	    /**
	     * 已用容量
	     * 表字段 : gov_memorizer.used_capacity
	     */
	    private String usedCapacity;

	    /**
	     * 购买时间
	     * 表字段 : gov_memorizer.buying_time
	     */
	    private String buyingTime;

	    /**
	     * 备注
	     * 表字段 : gov_memorizer.remark
	     */
	    private String remark;

	    /**
	     * 所在机房
	     * 表字段 : gov_memorizer.belong_cproom_id
	     */
	    private Integer belongCproomId;

		public String getMemorizerNum() {
			return memorizerNum;
		}

		public void setMemorizerNum(String memorizerNum) {
			this.memorizerNum = memorizerNum;
		}


		public Integer getMemorizerBrand() {
			return memorizerBrand;
		}

		public void setMemorizerBrand(Integer memorizerBrand) {
			this.memorizerBrand = memorizerBrand;
		}

		public String getMemorizerModel() {
			return memorizerModel;
		}

		public void setMemorizerModel(String memorizerModel) {
			this.memorizerModel = memorizerModel;
		}

		public Integer getNumber() {
			return number;
		}

		public void setNumber(Integer number) {
			this.number = number;
		}

		public Integer getMemorizerType() {
			return memorizerType;
		}

		public void setMemorizerType(Integer memorizerType) {
			this.memorizerType = memorizerType;
		}

		public String getEquipmentCapacity() {
			return equipmentCapacity;
		}

		public void setEquipmentCapacity(String equipmentCapacity) {
			this.equipmentCapacity = equipmentCapacity;
		}

		public String getUsedCapacity() {
			return usedCapacity;
		}

		public void setUsedCapacity(String usedCapacity) {
			this.usedCapacity = usedCapacity;
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
