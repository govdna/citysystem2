package com.govmade.common.utils.poi;

import java.io.FileInputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

public class DataExcelUtil {
	

	public static List<String []> excelToList(String fullPath) {
		if(fullPath==null){
			System.out.println("路径为空或Adapter空");
			return null;
		}
		List<String []>  list=new ArrayList<String []>();
		// 解析excel
		Workbook wookbook = null;
		// 将Excel的各行记录放入ImpExcelBean的list里面
		try {
			// WorkbookFactory是用来将Excel内容导入数据库的一个类
			wookbook = WorkbookFactory.create(new FileInputStream(fullPath));
			Sheet sheet = wookbook.getSheetAt(0);// 统计excel的行数
			int rowLen = sheet.getPhysicalNumberOfRows();// excel总行数，记录数=行数-1
			if(rowLen>6){
				rowLen=6;
			}
			int coloumNum=sheet.getRow(0).getPhysicalNumberOfCells();
			for (int i = 0; i < rowLen; i++) {
				Row row = sheet.getRow(i);
				int startCol = 0;
				// 将Excel中各行记录依次导入到ImpExcelBean的list中
				if (row != null) {
					String [] str=new String[coloumNum];
					for(int j=0;j<coloumNum;j++){
						str[j]=getValue(row.getCell(j));
					}
					list.add(str);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	private static String getValue(Cell cell) {
		if (cell == null)
			return "";
		if (cell.getCellType() == Cell.CELL_TYPE_BOOLEAN) {
			return String.valueOf(cell.getBooleanCellValue()).trim();
		} else if (cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
			DecimalFormat df = new DecimalFormat("0");  
			String str = df.format(cell.getNumericCellValue());  
			return str;
		} else {
			return String.valueOf(cell.getStringCellValue()).trim();
		}
	}

	
}
