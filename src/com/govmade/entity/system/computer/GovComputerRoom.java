package com.govmade.entity.system.computer;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.base.SimpleFieldsValues;


/** 
* @ClassName: GovComputerRoom 
* @Description: No desc
* @author No author
* @date No date
*  
*/
@Alias("GovComputerRoom")
public class GovComputerRoom  extends SimpleFieldsValues{

	/**
	 * GovComputerRoom
	 * 
	 */
		private static final long serialVersionUID = 8825245757324053474L;
		
	 	private String cproomNum;//机房编号

	   // private Integer companyId;//单位名称

	    private String cproomArea;//机房面积

	    private String upsModel;//UPS型号

	    private String backupPower;//备电

	    private String powerSupply;//供电功率

	    private Integer precisionAirConditioner;//精密空调

	    private Integer airConditionerNum;//空调数量

	    private Integer lightningProtection;//防雷接地设施

	    private Integer monitor;//监控设施

	    private Integer fireAlarm;//消防报警系统

	    private String remark;//备注

		public String getCproomNum() {
			return cproomNum;
		}

		public void setCproomNum(String cproomNum) {
			this.cproomNum = cproomNum;
		}

		public String getCproomArea() {
			return cproomArea;
		}

		public void setCproomArea(String cproomArea) {
			this.cproomArea = cproomArea;
		}

		public String getUpsModel() {
			return upsModel;
		}

		public void setUpsModel(String upsModel) {
			this.upsModel = upsModel;
		}

		public String getBackupPower() {
			return backupPower;
		}

		public void setBackupPower(String backupPower) {
			this.backupPower = backupPower;
		}

		public String getPowerSupply() {
			return powerSupply;
		}

		public void setPowerSupply(String powerSupply) {
			this.powerSupply = powerSupply;
		}

		public Integer getPrecisionAirConditioner() {
			return precisionAirConditioner;
		}

		public void setPrecisionAirConditioner(Integer precisionAirConditioner) {
			this.precisionAirConditioner = precisionAirConditioner;
		}

		public Integer getAirConditionerNum() {
			return airConditionerNum;
		}

		public void setAirConditionerNum(Integer airConditionerNum) {
			this.airConditionerNum = airConditionerNum;
		}

		public Integer getLightningProtection() {
			return lightningProtection;
		}

		public void setLightningProtection(Integer lightningProtection) {
			this.lightningProtection = lightningProtection;
		}

		public Integer getMonitor() {
			return monitor;
		}

		public void setMonitor(Integer monitor) {
			this.monitor = monitor;
		}

		public Integer getFireAlarm() {
			return fireAlarm;
		}

		public void setFireAlarm(Integer fireAlarm) {
			this.fireAlarm = fireAlarm;
		}

		public String getRemark() {
			return remark;
		}

		public void setRemark(String remark) {
			this.remark = remark;
		}
	
	
}
