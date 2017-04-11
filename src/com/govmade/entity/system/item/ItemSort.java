package com.govmade.entity.system.item;

import org.apache.ibatis.type.Alias;

import com.govmade.entity.base.IdBaseEntity;

/**   
* @author (作者) Chenlei 774329191@qq.com   
* @Description: CitySystem TODO
* @date 2016年12月20日 上午10:09:28   
* @Title: ItemSort.java  
*/
@Alias("ItemSort")
public class ItemSort extends IdBaseEntity{
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String itemName; // 事项名称
	
	private Integer serObjSort; // 服务对象分类（公民、法人）
	
	private Integer serContent; // 服务内容（便民服务、行政审批、内部审批（非行政审批））
	
	private Integer preApprovalMatter; // 前置审批事项（外键）
	
	private Integer deadline; // 时限
	
	//private Integer responsibleDepart; // 责任部门
	
	private String applicationMaterial; // 申请材料（多行）

	private String certificateName; // 所需证件名称
	
	private Integer fileType; // 办件结果文件类型（证照、批文、证明、其他）
	
	private String fileName; // 办件结果文件名称
	
	private Integer yesorno; //是否有业务系统支撑
	
	private Integer busSystem; // 业务应用系统名称（默认值为无，外键）
	
	private Integer itemSortId;
	
	private String applicationMaterialId;

	public String getApplicationMaterialId() {
		return applicationMaterialId;
	}

	public void setApplicationMaterialId(String applicationMaterialId) {
		this.applicationMaterialId = applicationMaterialId;
	}

	public Integer getItemSortId() {
		return itemSortId;
	}

	public void setItemSortId(Integer itemSortId) {
		this.itemSortId = itemSortId;
	}

	public String getItemName() {
		return itemName;
	}

	public Integer getYesorno() {
		return yesorno;
	}

	public void setYesorno(Integer yesorno) {
		this.yesorno = yesorno;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public Integer getSerObjSort() {
		return serObjSort;
	}

	public void setSerObjSort(Integer serObjSort) {
		this.serObjSort = serObjSort;
	}

	public Integer getSerContent() {
		return serContent;
	}

	public void setSerContent(Integer serContent) {
		this.serContent = serContent;
	}

	public Integer getPreApprovalMatter() {
		return preApprovalMatter;
	}

	public void setPreApprovalMatter(Integer preApprovalMatter) {
		this.preApprovalMatter = preApprovalMatter;
	}

	public Integer getDeadline() {
		return deadline;
	}

	public void setDeadline(Integer deadline) {
		this.deadline = deadline;
	}
	public String getApplicationMaterial() {
		return applicationMaterial;
	}

	public void setApplicationMaterial(String applicationMaterial) {
		this.applicationMaterial = applicationMaterial;
	}

	public String getCertificateName() {
		return certificateName;
	}

	public void setCertificateName(String certificateName) {
		this.certificateName = certificateName;
	}

	public Integer getFileType() {
		return fileType;
	}

	public void setFileType(Integer fileType) {
		this.fileType = fileType;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public Integer getBusSystem() {
		return busSystem;
	}

	public void setBusSystem(Integer busSystem) {
		this.busSystem = busSystem;
	}
	
}
