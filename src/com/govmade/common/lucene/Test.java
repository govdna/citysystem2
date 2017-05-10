package com.govmade.common.lucene;

import java.io.File;
import java.io.FileOutputStream;
import java.io.StringReader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.tokenattributes.CharTermAttribute;

import com.chenlb.mmseg4j.analysis.ComplexAnalyzer;
import com.chenlb.mmseg4j.analysis.MaxWordAnalyzer;
import de.innosystec.unrar.Archive;
import de.innosystec.unrar.rarfile.FileHeader;
import net.lingala.zip4j.core.ZipFile;
import net.lingala.zip4j.exception.ZipException;

public class Test {
public static void main(String[] args) throws Exception {
	Analyzer analyzer = new ComplexAnalyzer("./dic/");
	//MyNumberAnalyzer analyzer = new MyNumberAnalyzer();
	   //WhitespaceAnalyzer analyzer = new WhitespaceAnalyzer();
	   TokenStream tokenStream = analyzer.tokenStream("content", new StringReader("十三五"));
	   tokenStream.reset();
	   tokenStream.addAttribute(CharTermAttribute.class);
	   while(tokenStream.incrementToken()){
	    CharTermAttribute termAttribute = tokenStream.getAttribute(CharTermAttribute.class);
	   System.out.println(termAttribute.toString());
	   }
}

public static void unrarzip(){
	
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
            System.out.println((++count) + ") " + compressFileName);  
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
