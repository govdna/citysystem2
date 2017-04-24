<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseHead.jsp"%>
 <link rel="stylesheet" type="text/css" href="${base}/static/css/plugins/webuploader/webuploader.css">
   <link rel="stylesheet" type="text/css" href="${base}/static/css/demo/webuploader-demo.css">
</head>
<style>
.form_datetime.input-group[class*=col-]{float: left;padding-right: 15px;padding-left: 15px;}
</style>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">\
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline clearfix">
            <div class="form-group pull-left">
              <input type="text" placeholder="输入数据库名称" name="dataBN" class="form-control col-sm-8">
              <div class="btn-group ml5">
                <button type="button" class="btn btn-primary" onclick=" $('#dicList').bootstrapTable('refresh');" style="border-right: rgba(255,255,255,.3);">搜索</button>
                <button type="button" class="btn btn-primary dropdown-toggle dropdown-btn">
                  <span class="caret"></span>
                </button>
              </div>
            </div>
            <div class="form-group pull-left" style="margin-left: 5px;">
              <div class="text-center">
                <c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/govDatabase/index\") %>">
                <a data-toggle="modal" class="btn btn-primary" onclick="openLayer('新增');" href="#">新增</a>
                </c:if>
                <c:if test="<%=!ServiceUtil.haveImp(\"/backstage/govDatabase/index\") %>">
                <a data-toggle="modal" class="btn btn-primary" onclick="importFromExcel();" href="#">Excel导入</a>
                </c:if>
                <a data-toggle="modal" class="btn btn-primary" href="${base}/backstage/sql/index">数据库连接</a>
              </div>
            </div>  
		   	   <ul class="dropdown-menu1 dn form-inline clearfix" style="padding-left: 0; margin: 5px 0 0;">
			    <li class="form-group clearfix">	
				  <label class="pull-left">所属部门：</label>
				  <div class="pull-left" style="width: 210px;">
				  <select name="cId" data-placeholder=" " class="chosen-select" style="width:210px; display:inline-block;" tabindex="4" required>
	                 <option value=""></option>
	                 <option value="">&nbsp;</option>
	                 <c:set var="roleid" value="<%=AccountShiroUtil.getCurrentUser().getRoleId() %>"/>
	                 <c:if test="${roleid==1}">
	                 <c:forEach var="obj" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"),\"id\",\"desc\") %>">
	                 <option value="${obj.id}">${obj.companyName}</option>
	                 </c:forEach>
	                 </c:if>
	                 <c:if test="${roleid!=1}">
	                 <c:set var="comid"  scope="session" value="<%=AccountShiroUtil.getCurrentUser().getCompanyId() %>"/>
	                 <c:forEach var="obj" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0&id=\"+session.getAttribute(\"comid\")),\"id\",\"desc\") %>">
	                 <option value="${obj.id}">${obj.companyName}</option>
	                 </c:forEach>
	                 </c:if>
                  </select>		
				  </div>                
				</li>
			  </ul>
          </div>
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
      <c:set var="simpleFields" value="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=GovDatabase\"),\"list_no\",\"asc\")%>"/>
      <%@include file="../common/simpleFields.jsp"%>
    </form>
  </div>

  <!-- excel导入开始 -->
  <div id="import_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="importForm">
      <div class="form-group" style="padding:10px;">
        <div class="alert alert-info">
              请先下载模版，根据模版填写数据。 <a class="alert-link"  href="${base}/upload/excel/DBExcel.xls">Excel模版下载</a>.<br />
            如导入数据量大，上传请耐心等待！
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
        <div class="ibox-content" id="error-msg">
        </div>
      </div>
    </form>
  </div>
  <!-- excel导入结束 -->
  
</body>
</html>
<%@include file="../common/includeJS.jsp"%>
<script src="${base}/static/js/plugins/webuploader/webuploader.min.js"></script>
<script>
var cdata = {"companyId":"<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>"};
var layerIndex;//layer 窗口对象
var title_name="服务器资料";
var layerContent='#layer_form';//layer窗口主体内容dom Id
var tableId='#dicList';//bootstrap-table id
var toolbar='#toolbar';//bootstrap-table 工具栏id
var formId='#eform';//form id
var url='${base}/backstage/govDatabase/';//controller 路径
var BASE_URL = '${base}/static/js/plugins/webuploader';
var $list=$("#fileList");
var uploader;
var inited=0;

$('.dropdown-btn').on('click', function() {
	$('.dropdown-menu1').toggleClass('dn');
});
$("select[name='cId']").chosen({
  disable_search_threshold: 10,
  no_results_text: "没有匹配到这条记录",
    width: "100%"
});
<%@include file="../common/simpleFieldsColumnsCompany.jsp"%>
  //得到查询的参数
  var queryParams = function(params) {
	var sort=params.sort;
	var order=params.order;
	if($('input[name="dataBN"]').val()!=null&&$('input[name="dataBN"]').val()!=""){
		sort="length(trim(value2))";
		order="asc";
	}
    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1,
      sort:sort,
      order:order,
      value2:$('input[name="dataBN"]').val(),
      companyId:$('select[name="cId"]').val(),
      <c:if test="${MyFunction:getMaxScope(\"/backstage/govDatabase/index\")==1}" >
       companyId:<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>,
        </c:if>
    };
    return temp;
  };
  
  

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
      server: base+'/backstage/govTable/importDB',
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
function doFormatter(value, row, index)
{
	var html='';
	html+='<div class="btn-group">';
	html+='<button type="button" class="btn btn-white" onclick="datailRow(\''+row.idForShow+'\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
	<c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/govDatabase/index\") %>">
	html+='<button type="button" class="btn btn-white" id="edit"  onclick="editRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
	</c:if>
	<c:if test="<%=!ServiceUtil.haveDel(\"/backstage/govDatabase/index\") %>">
	html+='<button type="button" class="btn btn-white" onclick="deleteRow(\''+row.idForShow+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
	</c:if>
	html+='</div>';
	return html;
}
</script>