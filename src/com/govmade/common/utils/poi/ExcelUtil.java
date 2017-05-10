package com.govmade.common.utils.poi;

import java.io.FileInputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

public class ExcelUtil {
	private ExcelAdapter adapter;
	
	
	public ExcelUtil(ExcelAdapter adapter) {
		super();
		this.adapter = adapter;
	}

	public void excelToList(String fullPath,Integer page) {
		if(fullPath==null||adapter==null){
			System.out.println("路径为空或Adapter空");
			return;
		}
		// 解析excel
		Workbook wookbook = null;
		// 将Excel的各行记录放入ImpExcelBean的list里面
		try {
			// WorkbookFactory是用来将Excel内容导入数据库的一个类
			wookbook = WorkbookFactory.create(new FileInputStream(fullPath));
			Sheet sheet = wookbook.getSheetAt(page);// 统计excel的行数
			int rowLen = sheet.getPhysicalNumberOfRows();// excel总行数，记录数=行数-1
			for (int i = adapter.getStartRow(); i < rowLen; i++) {
				Row row = sheet.getRow(i);
				int startCol = 0;
				// 将Excel中各行记录依次导入到ImpExcelBean的list中
				if (row != null) {
					String [] str=new String[adapter.getClumnSize()];
					boolean isEmpty=true;
					for(int j=0;j<adapter.getClumnSize();j++){
						str[j]=getValue(row.getCell(j));
						if(StringUtils.isNotEmpty(str[j].trim())){
							isEmpty=false;
						}
					}
					if(!isEmpty){
						adapter.buildList(str,i);
					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private String getValue(Cell cell) {
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

	public ExcelAdapter getAdapter() {
		return adapter;
	}

	public void setAdapter(ExcelAdapter adapter) {
		this.adapter = adapter;
	}
}
