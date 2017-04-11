package com.govmade.common.lucene;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.util.List;
import org.apache.pdfbox.cos.COSDocument;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.poi.POIXMLDocument;
import org.apache.poi.POIXMLTextExtractor;
import org.apache.poi.hslf.extractor.PowerPointExtractor;
import org.apache.poi.hssf.extractor.ExcelExtractor;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.poi.openxml4j.exceptions.OpenXML4JException;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.apache.xmlbeans.XmlException;
import org.openxmlformats.schemas.drawingml.x2006.main.CTRegularTextRun;
import org.openxmlformats.schemas.drawingml.x2006.main.CTTextBody;
import org.openxmlformats.schemas.drawingml.x2006.main.CTTextParagraph;
import org.openxmlformats.schemas.presentationml.x2006.main.CTGroupShape;
import org.openxmlformats.schemas.presentationml.x2006.main.CTShape;
import org.openxmlformats.schemas.presentationml.x2006.main.CTSlide;
import org.apache.poi.xslf.usermodel.XMLSlideShow;
import org.apache.poi.xslf.usermodel.XSLFSlide;
import org.apache.poi.xslf.usermodel.XSLFSlideShow;

public class ReadFile {
	  
    /** 
     * 处理word2003 
     * @param path 
     * @return 
     * @throws Exception 
     */  
    public static String readWord(String path) throws Exception {  
        String bodyText = null;  
        InputStream inputStream = new FileInputStream(path);  
        WordExtractor extractor = new WordExtractor(inputStream);    
        bodyText = extractor.getText();  
        return bodyText;  
    }  
      
    /** 
     * 处理word2007 
     * @param path 
     * @return 
     * @throws IOException 
     * @throws OpenXML4JException 
     * @throws XmlException 
     */  
    public static String readWord2007(String path) throws IOException, OpenXML4JException, XmlException {  
        OPCPackage opcPackage = POIXMLDocument.openPackage(path); 
        POIXMLTextExtractor ex = new XWPFWordExtractor(opcPackage); 
        
        return ex.getText();  
    }  
    /** 
     * 处理excel2003 
     * @param path 
     * @return 
     * @throws IOException 
     */  
    public static String ReadExcel(String path) throws IOException {  
        InputStream inputStream = null;  
        String content = null;  
        try {  
            inputStream = new FileInputStream(path);  
            HSSFWorkbook wb = new HSSFWorkbook(inputStream);  
            ExcelExtractor extractor = new ExcelExtractor(wb);  
            extractor.setFormulasNotResults(true);  
            extractor.setIncludeSheetNames(false);  
            content = extractor.getText();  
        } catch (FileNotFoundException e) {  
            e.printStackTrace();  
        }  
        return content;  
    }  
    /** 
     * 处理excel2007 
     * @param path 
     * @return 
     * @throws IOException 
     */  
    public static String readExcel2007(String path) throws IOException {  
        StringBuffer content = new StringBuffer();  
        // 构造 XSSFWorkbook 对象，strPath 传入文件路径  
        XSSFWorkbook xwb = new XSSFWorkbook(path);  
        // 循环工作表Sheet  
        for (int numSheet = 0; numSheet < xwb.getNumberOfSheets(); numSheet++) {  
            XSSFSheet xSheet = xwb.getSheetAt(numSheet);  
            if (xSheet == null) {  
                continue;  
            }  
            // 循环行Row  
            for (int rowNum = 0; rowNum <= xSheet.getLastRowNum(); rowNum++) {  
                XSSFRow xRow = xSheet.getRow(rowNum);  
                if (xRow == null) {  
                    continue;  
                }  
                // 循环列Cell  
                for (int cellNum = 0; cellNum <= xRow.getLastCellNum(); cellNum++) {  
                    XSSFCell xCell = xRow.getCell(cellNum);  
                    if (xCell == null) {  
                        continue;  
                    }  
                    if (xCell.getCellType() == XSSFCell.CELL_TYPE_BOOLEAN) {  
                        content.append(xCell.getBooleanCellValue());  
                    } else if (xCell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {  
                        content.append(xCell.getNumericCellValue());  
                    } else {  
                        content.append(xCell.getStringCellValue());  
                    }  
                }  
            }  
        }  
  
        return content.toString();  
    }  
   
    public static String readPPT(String path) throws IOException{
    	FileInputStream fis = new FileInputStream(path);  
        PowerPointExtractor extractor=new PowerPointExtractor(fis);
        return extractor.getText();
    }
    public static String readPPT2007(String path) {
        String reusltString=null;
        try {
        	FileInputStream fis = new FileInputStream(path);  
            XMLSlideShow xmlSlideShow = new XMLSlideShow(fis);
            List<XSLFSlide> slides = xmlSlideShow.getSlides();
            StringBuilder sb = new StringBuilder();
            for (XSLFSlide slide : slides) {
                CTSlide rawSlide = slide.getXmlObject();
                CTGroupShape gs = rawSlide.getCSld().getSpTree();
                CTShape[] shapes = gs.getSpArray();
                for (CTShape shape : shapes) {
                    CTTextBody tb = shape.getTxBody();
                    if (null == tb)
                        continue;
                    CTTextParagraph[] paras = tb.getPArray();
                    for (CTTextParagraph textParagraph : paras) {
                        CTRegularTextRun[] textRuns = textParagraph.getRArray();
                        for (CTRegularTextRun textRun : textRuns) {
                            sb.append(textRun.getT());
                        }
                    }
                }
            }
        reusltString=sb.toString();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        return reusltString;
    }

    
    
    public static String readTxt(String path,String code) throws Exception{
        // TODO Auto-generated method stub
        File file = new File(path);
        InputStreamReader read = new InputStreamReader (new FileInputStream(file),code); 
        BufferedReader reader=new BufferedReader(read); 
        String tempString = null;
        StringBuffer str=new StringBuffer();
        try {
            while ((tempString = reader.readLine()) != null) {
            	str.append(tempString);
            }
            reader.close();
        } catch (FileNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }finally{
            if(reader != null){
                try {
                    reader.close();
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
        }
        return str.toString();
    }
    
    /** 
     * 处理pdf 
     * @param path 
     * @return 
     * @throws IOException 
     */  
    public static String readPdf(String path) throws IOException {  
        StringBuffer content = new StringBuffer("");// 文档内容  
        PDDocument pdfDocument = null;  
        try {  
            FileInputStream fis = new FileInputStream(path);  
            PDFTextStripper stripper = new PDFTextStripper();  
            pdfDocument = PDDocument.load(fis);  
            StringWriter writer = new StringWriter();  
            stripper.writeText(pdfDocument, writer);  
            content.append(writer.getBuffer().toString());  
            fis.close();  
        } catch (java.io.IOException e) {  
            System.err.println("IOException=" + e);  
            //System.exit(1);  
        } finally {  
            if (pdfDocument != null) {  
                COSDocument cos = pdfDocument.getDocument();  
                cos.close();  
                pdfDocument.close();  
            }  
        }  
          
        return content.toString();  
  
    }  
   
      
}
