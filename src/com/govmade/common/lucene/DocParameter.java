package com.govmade.common.lucene;

import java.util.List;

import com.govmade.entity.system.information.DataFile;



/** 
* @ClassName: DocParameter 
* @Description: TODO(Lucene建索引参数分装) 
* @author Dongjie 154046519@qq.com 
* @date 2016年5月25日 下午5:00:00 
*  
*/
public class DocParameter {
	private static final String TYPE_CODES="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	private String typeCode;
	public static final int FILE_MODE=0;//单个文件建立索引
	public static final int RAR_ZIP_MODE=1;//压缩文件建立索引
	public static final int RECOVER_MODE=2;//根据GovmadeFile数据库数据建立索引
	private long lastModified;//最后修改时间
	private DataFile file;//GovmadeFile id
	private boolean createOrAppend;
	private Integer mode;//模式
	
	
	
	public static String getTypeCode(Integer id) {
		return TYPE_CODES.charAt(id)+"";
	}
	public long getLastModified() {
		return lastModified;
	}
	public void setLastModified(long lastModified) {
		this.lastModified = lastModified;
	}
	
	
	public boolean isCreateOrAppend() {
		return createOrAppend;
	}
	public void setCreateOrAppend(boolean createOrAppend) {
		this.createOrAppend = createOrAppend;
	}
	public Integer getMode() {
		return mode;
	}
	public void setMode(Integer mode) {
		this.mode = mode;
	}
	public DataFile getFile() {
		return file;
	}
	public void setFile(DataFile file) {
		this.file = file;
	}
	
	
	
}
