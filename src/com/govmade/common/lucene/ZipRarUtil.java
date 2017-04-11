package com.govmade.common.lucene;

import java.io.File;
import java.io.FileOutputStream;

import de.innosystec.unrar.Archive;
import de.innosystec.unrar.rarfile.FileHeader;
import net.lingala.zip4j.core.ZipFile;

public class ZipRarUtil {

	//是否是zip
	public static boolean isZip(File file){
		if(file.getAbsolutePath().toLowerCase().endsWith(".zip")){
			return true;
		}
		return false;
	}
	//是否是rar
	public static boolean isRar(File file){
		if(file.getAbsolutePath().toLowerCase().endsWith(".rar")){
			return true;
		}
		return false;
	}
	//是否是zip或rar
	public static boolean isZipRar(File file){
		if(isRar(file)||isZip(file)){
			return true;
		}
		return false;
	}
	
	//解压缩

	public static String unrarzip(File sourceRar,DocParameter parameter) throws Exception{
		String path=LuceneConfig.getDocPath()+"/"+System.currentTimeMillis();
		if(sourceRar.getAbsolutePath().toLowerCase().endsWith(".zip")){
			ZipFile zipFile = new ZipFile(sourceRar);  
			zipFile.setFileNameCharset("GBK");       
			zipFile.extractAll(path);
		}else if(sourceRar.getAbsolutePath().toLowerCase().endsWith(".rar")){
			unrar(sourceRar, new File(path));
		}
		parameter.setCreateOrAppend(false);
		System.out.println("建立索引"+sourceRar);
		if(!isZipRar(sourceRar)){
			parameter.setMode(DocParameter.FILE_MODE);
			LuceneUtils.createIndex(sourceRar.getAbsolutePath(),LuceneConfig.getLucenePath(), parameter);
		}else{
			parameter.setMode(DocParameter.RAR_ZIP_MODE);
			LuceneUtils.createIndex(path, LuceneConfig.getLucenePath(), parameter);
			return new File(path).getAbsolutePath();
		}
		return null;
	}

	private static void unrar(File sourceRar, File destDir) throws Exception {  
	    Archive archive = null;  
	    FileOutputStream fos = null;  
	    System.out.println("Starting...");  
	    try {  
	        archive = new Archive(sourceRar);  
	        FileHeader fh = archive.nextFileHeader();  
	        int count = 0;  
	        File destFileName = null;  
	        while (fh != null) {
	            String compressFileName = fh.isUnicode()?fh.getFileNameW().trim():fh.getFileNameString().trim();
	            System.out.println(fh.getArcTime()+"|"+fh.getMTime());
	            destFileName = new File(destDir.getAbsolutePath() + "/" + compressFileName);  
	            if (fh.isDirectory()) {  
	                if (!destFileName.exists()) {  
	                    destFileName.mkdirs();  
	                }  
	                fh = archive.nextFileHeader();  
	                continue;  
	            }   
	            if (!destFileName.getParentFile().exists()) {  
	                destFileName.getParentFile().mkdirs();  
	            }  
	            fos = new FileOutputStream(destFileName);  
	            archive.extractFile(fh, fos);  
	            fos.close();  
	            destFileName.setLastModified(fh.getMTime().getTime());
	            fos = null;  
	            fh = archive.nextFileHeader();  
	        }  

	        archive.close();  
	        archive = null;  
	        System.out.println("Finished !");  
	    } catch (Exception e) {  
	        throw e;  
	    } finally {  
	        if (fos != null) {  
	            try {  
	                fos.close();  
	                fos = null;  
	            } catch (Exception e) {  
	                //ignore  
	            }  
	        }  
	        if (archive != null) {  
	            try {  
	                archive.close();  
	                archive = null;  
	            } catch (Exception e) {  
	                //ignore  
	            }  
	        }  
	    }  
	}  
}
