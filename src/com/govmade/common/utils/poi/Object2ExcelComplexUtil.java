package com.govmade.common.utils.poi;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;

public class Object2ExcelComplexUtil {
	private Object2ExcelComplexAdapter adapter;

	public Object2ExcelComplexAdapter getAdapter() {
		return adapter;
	}

	public void setAdapter(Object2ExcelComplexAdapter adapter) {
		this.adapter = adapter;
	}

	public Object2ExcelComplexUtil(Object2ExcelComplexAdapter adapter) {
		super();
		this.adapter = adapter;
	}

	public void object2Excel(String fullPath) throws Exception {
		if (fullPath == null || adapter == null) {
			System.out.println("路径为空或Adapter空");
			return;
		}
		Workbook wb = null;
		File file = new File(fullPath);
		Sheet sheet = null;
		// 创建工作文档对象
		if (!file.exists()) {
			wb = new HSSFWorkbook();
			// 创建sheet对象
			sheet = (Sheet) wb.createSheet("Sheet1");
			OutputStream outputStream = new FileOutputStream(fullPath);
			wb.write(outputStream);
			outputStream.flush();
			outputStream.close();
		} else {
			wb = new HSSFWorkbook();
		}
		// 创建sheet对象
		if (sheet == null) {
			sheet = (Sheet) wb.createSheet("Sheet1");
		}
		CellStyle style = wb.createCellStyle(); // 样式对象
		// 设置单元格的背景颜色为淡蓝色
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND); // 填充单元格
		style.setFillForegroundColor(HSSFColor.LIGHT_GREEN.index); // 填暗红色
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);// 垂直
		style.setAlignment(CellStyle.ALIGN_CENTER);// 水平
		style.setWrapText(true);// 指定当单元格内容显示不下时自动换行
		CellStyle textStyle = wb.createCellStyle(); // 样式对象
		textStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);// 垂直
		textStyle.setAlignment(CellStyle.ALIGN_LEFT);// 水平
		textStyle.setWrapText(true);// 指定当单元格内容显示不下时自动换行

		// 添加表头
		Row row = sheet.createRow(0);
		String [] title= adapter.getTitle();
		
		for (int i = 0; i <title.length; i++) {
			Cell cell = row.createCell(i);
			cell.setCellValue(title[i]); // 创建第一行
			cell.setCellStyle(style); // 样式，居中
			sheet.setColumnWidth(i, title[i].length() * 512+2000);
		}
		row.setHeight((short) 540);
		int rowNum=1;
		int startNum;
		int endNum;
		for (int i = 0; i < adapter.getList().size(); i++) {
			List<String[]> list=adapter.object2List(adapter.getList().get(i));
			startNum=rowNum;
			for (String [] strArr:list) {
				Row rowi = sheet.createRow(rowNum);
				for(int j=0;j<strArr.length;j++){
					Cell cell = rowi.createCell(j);
					cell.setCellValue(strArr[j]); // 创建第一行
					cell.setCellStyle(textStyle); // 样式，居中
				}
				rowNum++;
			}
			endNum=rowNum-1;
			adapter.doAfterEveryTime(list, sheet, startNum, endNum);
		}
		// 创建文件流
		OutputStream stream = new FileOutputStream(fullPath);
		// 写入数据
		wb.write(stream);
		// 关闭文件流
		stream.close();
	}

}
