package com.govmade.controller.system.io;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.govmade.common.ajax.AjaxRes;
import com.govmade.common.lucene.DocParameter;
import com.govmade.common.lucene.LuceneConfig;
import com.govmade.common.lucene.LuceneUtils;
import com.govmade.common.utils.SecurityUtil;
import com.govmade.common.utils.base.Const;
import com.govmade.common.utils.echarts.Data;
import com.govmade.common.utils.security.AccountShiroUtil;
import com.govmade.common.utils.tree.MenuTreeUtil;
import com.govmade.common.utils.webpage.PageData;
import com.govmade.controller.base.BaseController;
import com.govmade.entity.base.IdBaseEntity;
import com.govmade.entity.system.account.Account;
import com.govmade.entity.system.information.DataFile;
import com.govmade.entity.system.information.Notice;
import com.govmade.service.system.information.DataFileService;
import com.govmade.service.system.information.NoticeService;

import org.apache.commons.io.FileUtils;

@Controller
@RequestMapping("/backstage/io/")
public class IOController extends BaseController<Object> {
	
	@Autowired
	private DataFileService dataFileService;
	
	@Autowired
	private NoticeService noticeService;
	
	@RequestMapping("upload")
	@ResponseBody
	public AjaxRes upload(@RequestParam(value = "file", required = false) MultipartFile file, Model model) {

		AjaxRes ar = getAjaxRes();
		try {

			String path = getRequest().getSession().getServletContext().getRealPath("upload/icon");
			String fileName = file.getOriginalFilename().trim();
			String icon = System.currentTimeMillis() + "/";
			File targetFile = new File(path+"/"+icon, fileName);
			if (!targetFile.exists()) {
				targetFile.mkdirs();
			}
			file.transferTo(targetFile);
			ar.setSucceed("/upload/icon/"+icon + fileName);
		} catch (Exception e) {
			e.printStackTrace();
			ar.setFailMsg(Const.DATA_FAIL);
		}

		return ar;
	}
	
	@RequestMapping("uploadData")
	@ResponseBody
	public AjaxRes uploadData(@RequestParam(value = "file", required = false) MultipartFile file,HttpServletRequest req,Model model) {

		AjaxRes ar = getAjaxRes();
		try {

			String path = getRequest().getSession().getServletContext().getRealPath(LuceneConfig.getDocPath());
			String fileName = file.getOriginalFilename().trim();
			String icon = System.currentTimeMillis() + "/";
			File targetFile = new File(path+"/"+icon, fileName);
			if (!targetFile.exists()) {
				targetFile.mkdirs();
			}
			file.transferTo(targetFile);
			DataFile df=new DataFile();
			df.setFileName(fileName);
			df.setInformationResourceId(Integer.valueOf(req.getParameter("informationResourceId")));
			df.setRealPath(targetFile.getAbsolutePath());
			dataFileService.insert(df);
			DocParameter parameter=new DocParameter();
			parameter.setMode(DocParameter.FILE_MODE);
			parameter.setFile(df);
			LuceneUtils.createIndex(targetFile.getAbsolutePath(),LuceneConfig.getLucenePath(), parameter);
			ar.setSucceed(targetFile.getPath());
			Notice notice=new Notice();
			notice.setInformationResourceId(df.getInformationResourceId());
			notice.setMsg("上传了数据文件 "+df.getFileName());
			notice.setNoticeType(1);
			notice.setNoticeId(df.getId());
			noticeService.sendNotice(notice);
		} catch (Exception e) {
			e.printStackTrace();
			ar.setFailMsg(Const.DATA_FAIL);
		}

		return ar;
	}
	
	@RequestMapping("downloadData")
	public ResponseEntity<byte[]> downloadData(DataFile df,HttpServletRequest req, HttpServletResponse response) throws Exception {
		if (StringUtils.isNotEmpty(req.getParameter("idForShow"))) {
			df.setId(Integer.valueOf(SecurityUtil.decrypt(req.getParameter("idForShow"))));
		}
		df=dataFileService.findById(df);
		File file=new File(df.getRealPath());  
        HttpHeaders headers = new HttpHeaders();    
        String fileName=new String(df.getFileName().getBytes("UTF-8"),"iso-8859-1");//为了解决中文名称乱码问题  
        headers.setContentDispositionFormData("attachment", fileName);   
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);   
        return new ResponseEntity<byte[]>(FileUtils.readFileToByteArray(file),headers, HttpStatus.CREATED);    
	}
}
