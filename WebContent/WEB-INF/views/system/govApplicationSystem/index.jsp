<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseHead.jsp"%>
<link rel="stylesheet" type="text/css" href="${base}/static/css/plugins/webuploader/webuploader.css">
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
<div class="wrapper wrapper-content animated fadeInRight">
  <div class="ibox float-e-margins">
    <div class="ibox-content">
      <div id="toolbar">
        <div class="form-inline clearfix">
          <div class="form-group pull-left">
              <c:forEach var="obj" items="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=GovApplicationSystem&searchType=1\"),\"list_no\",\"asc\")%>">                    
             			 <%@include file="../common/searchBase.jsp"%>                           
              </c:forEach>
             <div class="btn-group">
               <button type="button" class="btn btn-primary" onclick=" $('#dicList').bootstrapTable('refresh');" style="border-right: rgba(255,255,255,.3);">搜索</button>
               <button type="button" class="btn btn-primary dropdown-toggle dropdown-btn">
                 <span class="caret"></span>
               </button>
             </div>
              
              <div class="form-group"  style="margin-left:10px;">
              	<c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/govApplicationSystem/index\") %>">
                  <a data-toggle="modal" class="btn btn-primary" onclick="openLayer('新增');" href="#">新增</a>
                </c:if>
                <c:if test="<%=!ServiceUtil.haveExp(\"/backstage/govApplicationSystem/index\") %>">
                  <a data-toggle="modal" class="btn btn-primary" onclick="downloadData();" href="#">导出数据</a>
                </c:if>
                <a data-toggle="modal" class="btn btn-primary" onclick="importFromExcel();" href="#">Excel导入</a>
              </div>    
            </div>
          </div>
          <ul class="dropdown-menu1 dn form-inline clearfix" style="padding-left: 0; margin: 5px 0 0;">
			    <c:forEach var="obj" items="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=GovApplicationSystem&searchType=2\"),\"list_no\",\"asc\")%>">                    
						<%@include file="../common/searchBase.jsp"%>         
              </c:forEach>
			  </ul>
        </div>
        <table id="dicList">
        </table>
      </div>
    </div>
  </div>
  <div id="layer_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="eform">
      <input type="hidden" name="id"  class="form-control">
      <input type="hidden" name="idForShow"  class="form-control">
       <c:set var="simpleFields" value="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=GovApplicationSystem\"),\"list_no\",\"asc\")%>"/>
      <%@include file="../common/simpleFields.jsp"%>
    </form>
  </div>
   <!-- 导出数据开始 -->
  <div id="download_div" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="downloadForm">

      <c:if test = "${MyFunction:getMaxScope(\"/backstage/govApplicationSystem/index\")==100}" >
       		<input type="hidden" name="companyId" value="<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>"/>
      </c:if>
      
      <div class="alert alert-info">
            如导出数据量大，下载请耐心等待！
        </div>
       <c:forEach var="obj" items="${simpleFields}">
       	<div class="col-md-3"><input type="checkbox" name="xlsFields" value="value${obj.valueNo}"/> ${obj.name}</div>
       </c:forEach>
    </form>
  </div>
  <!-- 导出数据结束 -->
   <!-- excel导入开始 -->
  <div id="import_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="importForm">
      <div class="form-group" style="padding:10px;">
        <div class="alert alert-info">请先下载应用系统清单模版，根据模版填写数据。
         <a class="alert-link"  href="${base}/upload/excel/appExcel.xlsx">Excel模版下载</a>.<br /> 如导入数据量大，上传请耐心等待！
        </div>
        <div id="uploader-demo">
          <label class="col-sm-3 control-label"></label>
          <div class="col-sm-7">
            <label class="col-sm-3" id="img_label"> </label>
            <div class="col-sm-9" id="filePicker">上传数据文件</div>
          </div>
        </div>
      </div>
      <div class="ibox float-e-margins">
        <div class="ibox-content" id="error-msg"></div>
      </div>
    </form>
  </div>
  <!-- excel导入结束 -->
</body>
</html>
<%@include file="../common/includeJS.jsp"%>
<script src="${base}/static/js/plugins/webuploader/webuploader.min.js"></script>
<script>
//验证名称重复
$('.dropdown-btn').on('click', function() {
	$('.dropdown-menu1').toggleClass('dn');
});
$("select[name='cId']").chosen({
	  disable_search_threshold: 10,
	  no_results_text: "没有匹配到这条记录",
	  search_contains: true,
	  width: "100%"
	});
$("select[name='cId']").on('change', function(e, params) {
	userCompanyId = params.selected;
	});
$("select[name='innet']").chosen({
	  disable_search_threshold: 10,
	  no_results_text: "没有匹配到这条记录",
	  width: "100%"
	});
$("input[name='value2']").blur(function() {
  jQuery.post("${base}/backstage/govApplicationSystem/validation", { "value2": $("input[name='value2']").val(), "id": $("input[name='id']").val() }, function(data) {
    data = JSON.parse(data);
    if (data.results == 1) {
      layer.msg("应用系统名称已存在，请重新填写");
      $("input[name='value2']").val("");
    }
  });
});
var title_name = "应用系统资料";
var cdata = { "companyId": "<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>" };
var layerIndex; //layer 窗口对象
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var url = '${base}/backstage/govApplicationSystem/'; //controller 路径
var inited=0;
var BASE_URL = '${base}/static/js/plugins/webuploader';
var userCompanyId = <%=request.getParameter("value3") %>;
//bootstrap-table 列数
<%@include file="../common/simpleFieldsColumns.jsp"%>
function longFormatter(value, row, index) {
  var html = '<span title="' + value + '">';
  if (value.length > 10) {
    html += value.substring(0, 10) + "...";
  } else {
    html += value;
  }
  html += '</span>';
  return html;
}

$(function() {
    initChosen();
  });

//得到查询的参数
var queryParams = function(params) {
  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
    value3:userCompanyId,
    sort:params.sort,
    order:params.order,

    <c:forEach var="obj" items="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=GovApplicationSystem\"),\"list_no\",\"asc\")%>">  
    <%@include file="../common/searchQueryParams.jsp"%>
    </c:forEach>
    
    <c:if test = "${MyFunction:getMaxScope(\"/backstage/govApplicationSystem/index\")==100}" >
    companyId: <%=AccountShiroUtil.getCurrentUser().getCompanyId()%>,
    </c:if>
  };
  return temp;
};

</script>
<%@include file="../common/baseSystemJS.jsp"%>
<script>
function openLayer() {
  $(formId).form('clear');
  initChosen();
  $(formId).form('load', cdata);
  $(".chosen-select").trigger("chosen:updated");
  $(formId).valid();
  layerIndex = layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '新增',
    scrollbar: false,
    btn: ['保存', '关闭'],
    yes: function(index, layero) {
      $(formId).submit();
    },
    cancel: function(index, layero) {
      $(layerContent + ' .dt-span').remove();
      $(layerContent + ' .div_hidden').removeClass('div_hidden');
    },
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
  });
}
$('#downloadForm').form({  
    url: url+'downloadData',  
    success: function(result){ 
    },
    onSubmit: function(param){
		var qp=queryParams(param);
		 for(var p in qp){
			 if(p!='rows'&&p!='page'){
				 param[p]=qp[p];
			 }
	     }
    }  
});


function downloadData(){
	  //$('#downloadForm').form('clear');
	  layerIndex=layer.open({
	    type: 1,
	    area: ['60%', '300px'], //宽高
	    title: '选择导出字段',
	    offset: '100px',
	    btn: ['导出', '关闭'],
	    yes: function(index, layero) {
	    	 $('#downloadForm').submit();
	    	 layer.close(layerIndex);
	    },
	    content: $('#download_div') //这里content是一个DOM
	  });
}
function doFormatter(value, row, index)
{
	var html='';
	html+='<div class="btn-group">';
	html+='<button type="button" class="btn btn-white" onclick="datailRow(\''+row.idForShow+'\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
	<c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/govApplicationSystem/index\") %>">
	html+='<button type="button" class="btn btn-white" id="edit"  onclick="editRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
	</c:if>
	<c:if test="<%=!ServiceUtil.haveDel(\"/backstage/govApplicationSystem/index\") %>">
	html+='<button type="button" class="btn btn-white" onclick="deleteRow(\''+row.idForShow+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
	</c:if>
	html+='</div>';
	return html;
}
function importFromExcel(){
	$('#importForm').form('clear');
	initUploader();
	$('#importForm').valid();
	layerIndex=layer.open({
	  type: 1,
	  area: ['60%', '80%'], //宽高
	  title: '从Excel导入',
	  offset: '0',
	  cancel:function(){
			$('#error-msg').html('');
	  },
	  content: $('#import_form') //这里content是一个DOM
	});
}
function initUploader(){
	if(inited==0){
		inited=1;
	}else{
		uploader.destroy();
	}
	uploader = WebUploader.create({

    // 选完文件后，是否自动上传。
    auto: true,

    // swf文件路径
    swf: BASE_URL + '/Uploader.swf',
    timeout: 0,
    // 文件接收服务端。
    server: url+'import',
    threads :1,
    fileNumLimit:1,
    // 选择文件的按钮。可选。
    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
    pick: '#filePicker',

    // 只允许选择Excel文件。
    accept: {
        title: 'Excel',
        extensions: 'xls,xlsx',
        mimeTypes: 'Excel/*'
    }
	});
	
	uploader.on( 'fileQueued', function( file ) {
		var html = '<div class="zz"><p><i class="fa fa-refresh fa-spin" ></i><br><span style="font-size: 14px;font-weight: 700;">拼命上传中</span></p></div>';

	    $('.layui-layer').append(html);
		$('#filePicker .webuploader-pick').addClass('grey').html('上传中<i class="fa fa-refresh fa-spin" style="margin-left:10px;"></i>');
		$('input[type="file"]').attr('disabled',true);
	});
	
	
	
	
	// 文件上传成功，给item添加成功class, 用样式标记上传成功。
	uploader.on( 'uploadSuccess', function( file,response) {
	    console.log(response);
	    if(response.res==1){
	    	layer.close(layerIndex);
	    	layer.msg('导入成功');
	   	 $(tableId).bootstrapTable('refresh');
	    }else{
	    	$('#error-msg').html('<div class="alert alert-danger">'+response.resMsg+'</div>');
	    }
	    $('#filePicker .webuploader-pick').removeClass('grey').html('上传数据文件');
	    $('input[type="file"]').attr('disabled',false);
	    $('.zz').remove();
	});

	// 文件上传失败，显示上传出错。
	uploader.on( 'uploadError', function( file ) {
		layer.msg('上传失败');
	    $('#filePicker .webuploader-pick').removeClass('grey').html('上传数据文件');
	    $('input[type="file"]').attr('disabled',false);
	    $('.zz').remove();
	});
	
		// 完成上传完了，成功或者失败，先删除进度条。
		uploader.on( 'uploadComplete', function( file ) {
	    	$( '#'+file.id ).find('.progress').remove();
		});
	}
</script>