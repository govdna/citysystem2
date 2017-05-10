package com.govmade.common.lucene;



/** 
* @ClassName: LuceneConfig 
* @Description: TODO(Lucene配置) 
* @author Dongjie 154046519@qq.com 
* @date 2016年5月9日 下午1:36:10 
*  
*/
public class LuceneConfig {
	private static ConfigReader _cr;
	private static String docPath = null;// 文件上传路径
	private static String lucenePath = null;// 索引路径
    static {_cr = new ConfigReader("/lucene/lucene.properties");
        setDocPath(_cr.get("docPath"));
        setLucenePath(_cr.get("lucenePath"));
    }
	public static String getDocPath() {
		return docPath;
	}
	public static void setDocPath(String docPath) {
		LuceneConfig.docPath = docPath;
	}
	public static String getLucenePath() {
		return lucenePath;
	}
	public static void setLucenePath(String lucenePath) {
		LuceneConfig.lucenePath = lucenePath;
	}
	
	
}
