<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
<link href="${base}/static/css/plugins/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${base}/static/css/plugins/webuploader/webuploader.css">
<link rel="stylesheet" type="text/css" href="${base}/static/css/demo/webuploader-demo.css">
<style type="text/css">
.c-list{
cursor: auto !important;
}
.c-list li{
cursor: pointer !important;
}

.dt-span{
padding-top: 7px;
margin-bottom: 0;
text-align: left;
}
.webuploader-pick{
background:#18a689;
}
.add-data-box {
	display: none;
}
</style>
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline">
            <label class="control-label  pull-left">信息资源提供方:</label>
              <div class=" pull-left" style="margin-left:10px;width:200px;">
                <select name="inforPder" data-placeholder=" " class="chosen-select" style="width:350px; display:inline-block;" tabindex="4" required>
                  <option value=""></option>
                  <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"ZYTGF\") %>">
                  <option value="${obj.dicKey}">${obj.dicValue}</option>
                  </c:forEach>
                </select>
              </div>
            <div class="form-group">    
              <input type="text" placeholder="输入信息资源名称" name="inforn" class="form-control" style="margin-bottom: 5px;width:150px;"> 
              <button type="button" onclick=" $('#dicList').bootstrapTable('refresh');" class="btn btn-primary" style="margin-bottom: 5px;">搜索
              </button> 
            </div>
            <div class="form-group" style="margin-left: 15px;">
              <div class="text-center">
                 <c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/information/res/index\") %>">
                  <a data-toggle="modal" class="btn btn-primary" onclick="addNew();" href="#">新增</a>
                 </c:if>
                 <c:if test="<%=!ServiceUtil.haveImp(\"/backstage/information/res/index\") %>">
                  <a data-toggle="modal" class="btn btn-primary" onclick="importFromExcel();" href="#">Excel导入</a>
                  <a data-toggle="modal" class="btn btn-primary" onclick="downloadData();" href="#">导出数据</a>
                 </c:if>
                 <c:if test="<%=!ServiceUtil.haveDel(\"/backstage/information/res/index\") %>">
                  <a data-toggle="modal" class="btn btn-primary" onclick="deleteAll();" href="#">批量删除</a>
                 </c:if>
                  <c:set  var="roleid"   value="<%=AccountShiroUtil.getCurrentUser().getRoleId() %>"/>
                  <c:if test="${roleid==1}">
                  <a data-toggle="modal" class="btn btn-danger" onclick="cleanTable();" href="#">清空所有</a>
                  </c:if>
              </div>
            </div>
          </div>
        </div>
        <table id="dicList"></table>
      </div>
    </div>
  </div>

  <div id="layer_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal eform1" id="eform">
      <input type="hidden" name="id" class="form-control"> 
      <input type="hidden" name="idForShow" class="form-control">
      <input type="hidden" name="inforCode"  class="form-control">
      <input type="hidden" name="dataElementId" />
      
      <div class="form-group">
        <label class="col-sm-3 control-label">信息资源分类</label>
        <div class="col-sm-4">
          <select name="inforTypes" data-placeholder=" "
            data-param="sortId" data-bind="select[name='inforTypes2']"
            class="chosen-select" required>
            <option value=""></option>
            <c:forEach var="obj"
              items="<%=ServiceUtil.getService(\"SortManagerService\")
            .find(ServiceUtil.buildBean(\"SortManager@isDeleted=0&level=1&type=3\"))%>">
            <option value="${obj.id}">${obj.sortName}</option>
            </c:forEach>
          </select>
        </div>
        <div class="col-sm-4">
          <select name="inforTypes2" data-placeholder=" " data-param="sortId" data-bind="select[name='inforTypes3']"
            data-level="2" data-url="${base}/backstage/sortManager/listAjax?all=y&level=2&type=3"
            data-keyField="id" data-valueField="sortName"
            class="chosen-select" required>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label"></label>
        <div class="col-sm-4">
          <select name="inforTypes3" data-placeholder=" " data-param="sortId" data-bind="select[name='inforTypes4']"
            data-level="3" data-url="${base}/backstage/sortManager/listAjax?all=y&level=3&type=3"
            data-keyField="id" data-valueField="sortName"
            class="chosen-select" >
          </select>
        </div>
        <div class="col-sm-4">
          <select name="inforTypes4" data-placeholder=" " 
            data-level="4" data-url="${base}/backstage/sortManager/listAjax?all=y&level=4&type=3"
            data-keyField="id" data-valueField="sortName"
            class="chosen-select">
          </select>
        </div>
      </div>      
       
	  <c:set var="simpleFields" value="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=InformationRes\"),\"list_no\",\"asc\")%>"/>
      <%@include file="../../common/simpleFields.jsp"%>

      
      
	<div class="ibox-content" id="dicTree" style="padding-left:0px;padding-right:0px;">
        <div class="btn-group" id="toolbar" role="group" style="margin-bottom:15px;">
          <div class="text-center detail-hide">
            <a data-toggle="modal" class="btn btn-primary" id="addDM" onclick="openDicLayer();" href="#">选择信息项</a>
          </div>
        </div>
        <table id="dm2"></table>
      </div>
      
       </div>
    </div>

 <div id="dic_form" style="display: none;" class="ibox-content">
    <div class="row form-horizontal" style="overflow: hidden;">
      <div class="form-group" style="margin-right: 15px;text-align:right;">
			<a data-toggle="modal" class="btn btn-primary"  href="#" onclick="openDataLayer();"><i class="fa fa-plus"></i>&nbsp;新增数据元</a>				
      </div>    
      <div class="form-group">
        <label class="col-sm-3 control-label">已选择：</label>
        <div class="col-sm-9">      
          <div class="chosen-container chosen-container-multi">
          <ul class="chosen-choices c-list">
          </ul>
          </div>
        </div>
      </div>
      <div class="ibox float-e-margins">
        <div class="ibox-content">
          <div class="form-group">
            <label class="col-sm-2 control-label">对象类</label>
            <div class="col-sm-4">
              <select name="dxl-select" data-placeholder=" " class="chosen-select">
                <option value=""></option>
                <option value="">全部</option>
                <c:forEach var="obj"
                  items="<%=ServiceUtil.getDicByDicNum(\"OBJECTTYPE\")%>">
                <option value="${obj.dicKey}">${obj.dicValue}</option>
                </c:forEach>
              </select>
            </div>
            <div class="col-sm-6">
              <div class="input-group">
                <input type="text" placeholder="输入名称" name="keyword" class="form-control"> <span class="input-group-btn"> <button type="button" onclick=" $('#dm3').bootstrapTable('refresh');" class="btn btn-primary">搜索
                </button> </span>
              </div>
            </div>
          </div>
          <table id="dm3"></table>
        </div>
      </div>
    </div>
  </div>
  <div id="dataElement-detail" class="form-horizontal"
    style="overflow: hidden;display:none;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div class="form-group">
          <label class="col-sm-4 control-label">内部标识符：</label>
          <span class="col-sm-8 dt-span" name="identifier"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">中文名称：</label>
          <span class="col-sm-8 dt-span" name="chName"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">英文名称：</label>
          <span class="col-sm-8 dt-span" name="egName"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">定义：</label>
          <span class="col-sm-8 dt-span" name="define"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">数据类型：</label>
          <span class="col-sm-8 dt-span" name="dataTypeForShow"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">数据长度：</label>
          <span class="col-sm-8 dt-span" name="dataFormat"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">对象类型：</label>
          <span class="col-sm-8 dt-span" name="objectTypeForShow"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">来源部门：</label>
          <span class="col-sm-7 dt-span" name="companyIdForShow"></span>
        </div>
      </div>
    </div>
  </div> 

  <!-- excel导入开始 -->
  <div id="import_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="importForm">
      <div class="form-group" style="padding:10px;">
        <div class="alert alert-info">
                      请先下载信息资源模版，根据模版填写数据。 <a class="alert-link"  href="${base}/upload/excel/templateExcel.xls">Excel模版下载</a>.<br />
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

   <!-- 导出数据开始 -->
  <div id="download_div" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="downloadForm">
      <div class="alert alert-info">
            如导出数据量大，下载请耐心等待！
        </div>
       <c:forEach var="obj" items="${simpleFields}">
       	<div class="col-md-3"><input type="checkbox" name="xlsFields" value="value${obj.valueNo}"/> ${obj.name}</div>
       </c:forEach>
    </form>
  </div>
  <!-- 导出数据结束 -->

<!-- 新增数据元 -->		
	<div id="data_form" style="display: none;" class="ibox-content">
		<form method="post" class="form-horizontal" id="dataform"  >
			<input type="hidden" name="id"  class="form-control">
			<input type="hidden" name="idForShow"  class="form-control">
			<input type="hidden" name="identifier"  class="form-control">
			<input type="hidden" name="imported"  class="form-control">
			<input type="hidden" name="sourceId"  class="form-control">
			<input type="hidden" name="fatherId"  class="form-control">	
			<div class="form-group">
				<label class="col-sm-3 control-label">中文名称：</label>
				<div class="col-sm-7">
					<input type="text" name="chName"  class="form-control" required>
				</div>
			</div>			
			<div class="form-group">
				<label class="col-sm-3 control-label">英文名称：</label>
				<div class="col-sm-7">
					<input type="text" name="egName"  class="form-control" >
				</div>
			</div>			
			
			<div class="form-group">
				<label class="col-sm-3 control-label">定义：</label>
				<div class="col-sm-7">
					<input type="text" name="define" class="form-control" >
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label">数据类型：</label>
				<div class="col-sm-7">
					<select name="dataType" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" >
                        <option value=""></option>
                        <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"DATATYPE\") %>">
                        <option value="${obj.dicKey}">${obj.dicValue}</option>
                        </c:forEach>
                 </select>  
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label">数据长度：</label>			
				<div class="col-sm-7">
					<input type="text" name="dataFormat" class="form-control" >
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label">对象类型：</label>
				<div class="col-sm-7">
					<select name="objectType" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
                                    <option value=""></option>
                                    <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"OBJECTTYPE\") %>">
                                    <option value="${obj.dicKey}">${obj.dicValue}</option>
                                    </c:forEach>
                             </select> 
				</div>
			</div>
		   <div class="form-group">
				<label class="col-sm-3 control-label">备注：</label>
				<div class="col-sm-7">
					<input type="text" name="notes" class="form-control" >
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label">来源部门：</label>
				<div class="col-sm-7">
					  <select id="deCompanyId" name="value8" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" >
                            <option value=""></option>
                            <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"))%>">
			                  <option value="${obj2.id}">${obj2.companyName}</option>
                            </c:forEach>
                     </select>  
				</div>
			</div>
		</form>
	</div>
<!-- 新增数据元 -->	

</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script src="${base}/static/js/plugins/webuploader/webuploader.min.js"></script>
<script>

var oTable2Inited=0;
//验证名称重复
$("input[name='value1']").blur(function (){
  jQuery.post("${base}/backstage/information/res/validation",{"value1":$("input[name='value1']").val(),"id":$("input[name='id']").val()},function(data){
    data=JSON.parse(data); 
    if(data.results==1){
      layer.msg("信息资源名称已存在，请重新填写");
      $("input[name='value1']").val("");
    }
  });
});

$("input[name='chName']").blur(function (){
	if($(this).val() != ""){
	  jQuery.post("${base}/backstage/govRdataElement/validation",{"classType":0,"chName":$("input[name='chName']").val(),"id":$("input[name='id']").val()},function(data){
	    console.log(data);
		  if(data.results==1){
	    	layer.open({
	    		  content: '此信息项已存在，是否勾选？'
	    		  ,btn: ['是', '否']
	    		  ,yes: function(index, layero){
	    			  
	    			  layer.close(index);
	    			  layer.close(dataLayerIndex);
	    			  
	    			  $('input[name="keyword"]').val($("input[name='chName']").val());
	    			  $('#dm3').bootstrapTable('refresh');
	    			  
	    			  //setTimeout(function () {
		    			  checkData(data.show);
					  //}, 300);
	    			  
	    		  },btn2: function(index, layero){
	    			  $("input[name='chName']").val('');
	    			  $("input[name='egName']").val('');
	    		  },cancel: function(){ 
	    			  $("input[name='chName']").val('');
	    			  $("input[name='egName']").val('');
	    		  }
	    	});
	    }else{
	      $("input[name='egName']").val(data.egName);
	    }
	  },"json");
	}
	});
$("select[name='inforPder']").chosen({
	  disable_search_threshold: 10,
	  no_results_text: "没有匹配到这条记录",
	  width: "100%"
	});
$(function() {
  $('.senior button').on('click', function() {
    $('.senior-search').slideToggle();
  })
});
var dicLayerContent = '#dic_form';
var title_name="信息资源模板";
var layerIndex;//layer 窗口对象
var layerContent = '#layer_form'; // layer窗口主体内容dom Id
var tableId = '#dicList';//bootstrap-table id
var toolbar = '#toolbar';//bootstrap-table 工具栏id
var formId = '#eform';//form id
var url = '${base}/backstage/information/res/';//controller 路径
var dicLayerIndex;
var checkedIds=",";
var checkedEles;
var dataEles;//存放选中的数据元
var BASE_URL = '${base}/static/js/plugins/webuploader';
var uploader;
var inited=0;
var userCompanyId = <%=AccountShiroUtil.getCurrentUser().getCompanyId()%>;

$('#downloadForm').form({  
    url: url+'downloadData',  
    success: function(result){ 
    	 
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

function cleanTable(){
  
      layer.confirm('您确定要清空所有数据么？此操作不可恢复！', {
        btn: ['确定','取消'] //按钮
      }, function(){
        $.post(url+'cleanTable',function(r){
        var result = eval('('+r+')');
          if(result.code && result.code==1){
             $(tableId).bootstrapTable('refresh');
      
          }
          layer.msg(result.msg);
      });
      }, function(){
      });

}

function importFromExcel(){
  //$('#importForm').form('clear');
  initUploader();
  //$('#importForm').valid();
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
    server: base+'/backstage/information/res/importDataElement',
    // 选择文件的按钮。可选。
    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
    pick: '#filePicker',
    // 只允许选择图片文件。
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

function addNew(){
	  dataEles=new Array();
	  checkedIds=",";
	  $('#dm2').bootstrapTable('load',{rows:[]});
	  openLayer();
	  initDataElements();
	  if(oTable2Inited==0){
	    oTable2 = new TableInit2();
	    oTable2.Init();
	    oTable2Inited=1;
	  }else{
	     $('#dm2').bootstrapTable('refresh');
	  }
	}
	//或许所有数据元
	function initDataElements(){
	  initText();
	}


	//加载选中框的内容
	function initText() {
	  var ids = checkedIds.split(",");
	  checkedEles = new Array();
	  if (ids.length) {
	    for (var i = 0; i < ids.length; i++) {

	      if (ids[i] != "") {
	        for (var j = 0; j < dataEles.length; j++) {
	          if (ids[i] == dataEles[j].id) {
	            checkedEles.push(dataEles[j]);
	          }
	        }
	      }
	    }
	  }
	  if (checkedEles.length) {
	    var html = '';
	    for (var k = 0; k < checkedEles.length; k++) {
	    	html += '<li class="search-choice">'
	            +'<span onclick="detail(\'' + checkedEles[k].idForShow+'\');">'
	            + checkedEles[k].chName + '</span><a class="search-choice-close" onclick="unCheck(\''
	            + checkedEles[k].idForShow + '\');"></a></li>';
	    }
	    $('.c-list').html(html);
	  } else {
	    $('.c-list').html('');
	  }

	}


//bootstrap-table 列数
var columns = [ {
    field: 'id',
    title : '<input id="allC" type="checkbox">',
  formatter : 'checkFormatter2'
},
<c:forEach var="obj" items="${simpleFields}">
<c:if test="${obj.isShow==1}">
	<c:choose>
		<c:when test="${obj.inputType==1}">
		 	{field: 'value${obj.valueNo}',title: '${obj.name}',sortable:true,formatter:'longFormatter'}, 
		</c:when>
		<c:otherwise>
			{field: 'value${obj.valueNo}ForShow',title: '${obj.name}'},
    	</c:otherwise>
	</c:choose>
</c:if>       
</c:forEach>
{
  field : 'id',
  title : '操作',
  formatter : 'doFormatter',//对本列数据做格式化
} ];

function longFormatter(value, row, index)
{
  var html='<span title="'+value+'">';
  if(value.length>10){
    html+=value.substring(0,10)+"...";
  }else{
    html+=value;
  }
  html+='</span>';
  return html;
}

//---------批量删除开始---------
$("#dicList").on("click",'#allC',function(){
    var isChecked = $(this).prop("checked");
    $("input[data-type='plsp']").prop("checked", isChecked);   
});

//选择
function checkFormatter2(value, row, index) {
  var html = '';
  html += '<input type="checkbox" data-type="plsp" data-id="'+value+'" value="' + row.idForShow + '"  />';
  return html;
}

function deleteAll(){
  var ids = "";
    var c=$("input[data-type='plsp']:checked");
    for(var i=0;i<c.length;i++){
      ids+=","+$(c[i]).attr('data-id');
    }
    if(ids!=""){
      layer.confirm('您确定要删除么？', {
        btn: ['确定','取消'] //按钮
      }, function(){
        $.post(url+'deleteAjax',{ids:ids},function(r){
        var result = eval('('+r+')');
          if(result.code && result.code==1){
             $(tableId).bootstrapTable('refresh');
      
          }
          layer.msg(result.msg);
      });
      }, function(){
      });
    }
}
//-------批量删除结束---------


//得到查询的参数
var queryParams = function(params) {
	var sort=params.sort;
	var order=params.order;
	if($('input[name="inforn"]').val()!=null&&$('input[name="inforn"]').val()!=""){
		sort="length(trim(value1))";
		order="asc";
	}
  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows : params.limit,
    page : params.offset / params.limit + 1,
    value1:$('input[name="inforn"]').val(),
    sort:sort,
    order:order,
    value2:$('select[name="inforPder"]').val()
  };
  return temp;
};

var queryParams2 = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    id : $('input[name="id"]').val()
  };
  return temp;
};

var queryParams3 = function(params) {
	  var sort1=null;
	  var order1=null;
	  if($('input[name="keyword"]').val()!=null && $('input[name="keyword"]').val()!=""){
		  sort1='length(trim(value1))';
		  order1='asc';
	  }
  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1,
      sort : sort1,
      order : order1,
      objectType:$('select[name="dxl-select"]').val(),
      chName:$('input[name="keyword"]').val()
  };
  return temp;
};

$(function() {
	  oTable3 = new TableInit3();
	  oTable3.Init();
	  $('#dataform').validate( {ignore: ""});
	});

	var TableInit2 = function() {
	  var oTableInit = new Object();
	  //初始化Table
	  oTableInit.Init = function() {
	    $('#dm2').bootstrapTable({
	      url : '${base}/backstage/dataElement/dmAjax', //请求后台的URL（*）
	      method : 'post', //请求方式（*）
	      contentType : "application/x-www-form-urlencoded",
	      iconSize : 'outline',
	      striped : true, //是否显示行间隔色
	      cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
	      pagination : false, //是否显示分页（*）
	      sortable : true, //是否启用排序
	      sortOrder : "asc", //排序方式
	      queryParams : queryParams2,//传递参数（*）
	      sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
	      pageNumber : 1, //初始化加载第一页，默认第一页
	      pageSize : 10, //每页的记录行数（*）
	      pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
	      strictSearch : true,
	      clickToSelect : false, //是否启用点击选中行
	      uniqueId : "idForShow", //每一行的唯一标识，一般为主键列
	      cardView : false, //是否显示详细视图
	      detailView : false,
	      queryParamsType : "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
	      columns : [ {
	        field : 'identifier',
	        title : '内部资源标识符'
	      }, {

	        field : 'chName',
	        title : '中文名称'
	      },{
	        field : 'objectTypeForShow',
	        title : '对象类型'
	      },{
	        field : 'id',
	        title : '操作',
	        formatter : 'doFormatter2',//对本列数据做格式化    
	      } ],
	      onLoadSuccess:function(data){
	        
	        if(typeof(data.rows)!="undefined"){
	          dataEles=data.rows;
	          initText();
	        }
	        
	      }
	    });
	  };
	  return oTableInit;
	};

	function openDicLayer() {
	   $('#dm3').bootstrapTable('refresh');
	  dicLayerIndex = layer.open({
	    type : 1,
	    area : [ '70%', '80%' ], //宽高
	    title : '选择信息项',
	    scrollbar : false,
	    btn : [ '保存', '关闭' ],
	    yes : function(index, layero) {
	      $('#dm2').bootstrapTable('load',{rows:checkedEles});
	      //$(dicFormId).submit();
	      //console.log(checkedEles);
	      $('input[name="dataElementId"]').val(checkedIds);
	      layer.close(dicLayerIndex);
	    },
	    offset : '20px',
	    content : $(dicLayerContent)
	  //这里content是一个DOM
	  });
	}

	var dataLayerIndex;
	function openDataLayer() {
		$('#dataform').form('clear');
		$('#deCompanyId').val(userCompanyId);
		$(".chosen-select").trigger("chosen:updated");
		  //initChosen();
		 $('#dataform').valid();
		dataLayerIndex = layer.open({
			type : 1,
			area : [ '50%', '80%' ], //宽高
			title : '新增信息项',
			scrollbar : false,
			btn : [ '保存', '关闭' ],
			yes : function(index, layero) {
				$('#dataform').submit();
			},
			offset : '20px',
			content : $('#data_form')
		});	
	}
	
	$('#dataform').form({
		  url: "${base}/backstage/dataElement/insertAjax",
		  onSubmit: function() {
		    return $('#dataform').valid();
		  },
		  success: function(result) {
			  var r = eval('(' + result + ')');
			  var id=r.show;
			   $('#dm3').bootstrapTable('refresh');
			   layer.close(dataLayerIndex);
   			 // setTimeout(function () {
	    			  checkData(id);
			//	  }, 300);
		  }
		});
	function deEdit(id){
		openDataLayer();
		layer.title('信息项修改', layerIndex);
		var data=$('#dm3').bootstrapTable('getRowByUniqueId', id);
		$('#dataform').form('load',data);
		$(".chosen-select").trigger("chosen:updated");
		//$('#dataform').valid();
	}
	function checkData(idforshow){
		checkedIds=","+idforshow[0].id+","+checkedIds;
		dataEles.push(idforshow[0]);
		initDataElements();
		$('#dm3').bootstrapTable('refresh');
/*		
	    $('input[name="des"]').each(function(){
			if($(this).val()==idforshow){
				if($(this).is(':checked')) {
				}else{
					$(this).trigger('click');
				}
			}
		});*/
	}
	
	
	var TableInit3 = function() {
	  var oTableInit = new Object();
	  //初始化Table
	  oTableInit.Init = function() {
	    $('#dm3').bootstrapTable({
	      url : '${base}/backstage/dataElement/listAjax', //请求后台的URL（*）
	      method : 'post', //请求方式（*）
	      contentType : "application/x-www-form-urlencoded",
	      iconSize : 'outline',
	      striped : true, //是否显示行间隔色
	      cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
	      pagination : true, //是否显示分页（*）
	      sortable : false, //是否启用排序
	      sortOrder : "asc", //排序方式
	      queryParams : queryParams3,//传递参数（*）
	      sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
	      pageNumber : 1, //初始化加载第一页，默认第一页
	      pageSize : 10, //每页的记录行数（*）
	      pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
	      strictSearch : true,
	      clickToSelect : false, //是否启用点击选中行
	      uniqueId : "idForShow", //每一行的唯一标识，一般为主键列
	      cardView : false, //是否显示详细视图
	      detailView : false,
	      queryParamsType : "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
	      columns : [{
	        field : 'id',
	        title : '添加',
	        formatter : 'checkFormatter'
	               },{
	        field : 'identifier',
	        title : '内部资源标识符'
	      }, {

	        field : 'chName',
	        title : '中文名称'
	      },{
	    	field : 'objectTypeForShow',
		    title : '对象类型'
	      },{
	        field : 'id',
	        title : '操作',
	        formatter : 'doFormatter3',//对本列数据做格式化    
	      } ]
	    });
	  };
	  return oTableInit;
	};


	function checkFormatter(value, row, index) {
	  var html = '';
	  if (checkedIds.indexOf("," + value + ",") > -1) {
	    html += '<input type="checkbox" name="des" data-id="'+value+'" value="' + row.idForShow + '" data-name="'
	        + row.chName
	        + '" onclick="selectDE(this);" checked="checked"/>';
	  } else {
	    html += '<input type="checkbox" name="des" data-id="'+value+'" value="' + row.idForShow + '" data-name="'
	        + row.chName + '" onclick="selectDE(this);"/>';
	  }
	  return html;

	}

	function selectDE(t) {
	  if ($(t).is(':checked')) {
	    checkedIds += $(t).attr('data-id') + ",";
	    var data = $('#dm3').bootstrapTable('getRowByUniqueId', $(t).val());
	    console.log(data,checkedIds);
	    dataEles.push(data);
	  } else {
	    checkedIds = checkedIds.replace("," + $(t).val() + ",", ",");
	    unCheck($(t).val());
	  }
	  initText();
	}

	function doFormatter2(value, row, index) {
	  var html = '';
	  html += '<div class="btn-group">';
	  html+='<button type="button" class="btn btn-white" onclick="detail(\''+row.idForShow+'\',\'#dm2\')">查看</button>';
	  html += '</div>';
	  return html;
	}

	function doFormatter3(value, row, index) {
	  var html = '';
	  html += '<div class="btn-group">';
	  html+='<button type="button" class="btn btn-white" onclick="detail(\''+row.idForShow+'\',\'#dm3\')">查看</button>';
	  html += '<button type="button" class="btn btn-white" onclick="deEdit(\''+row.idForShow+'\')">修改</button>';    	  
	  html += '</div>';
	  return html;
	}
</script>
<%@include file="../../common/baseSystemJS.jsp"%>
<script type="text/javascript">

function doFormatter(value, row, index)
{
	var html='';
	html+='<div class="btn-group">';
	html+='<button type="button" class="btn btn-white" onclick="datailRow(\''+row.idForShow+'\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
    <c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/information/res/index\") %>">
	html+='<button type="button" class="btn btn-white" id="edit"  onclick="editRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
    </c:if>
	<c:if test="<%=!ServiceUtil.haveDel(\"/backstage/information/res/index\") %>">
	html+='<button type="button" class="btn btn-white" onclick="deleteRow(\''+row.idForShow+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
	</c:if>
	html+='</div>';
	return html;
}

function editRow(id){
  openLayer();
  
  layer.title('修改', layerIndex);
  
  var data=$(tableId).bootstrapTable('getRowByUniqueId', id);
  $(formId).form('load',data);
  dataEles=data.dataElementIds;
  checkedIds=","+data.dataElementIds+",";
  initDataElements();
  if(oTable2Inited==0){
    oTable2 = new TableInit2();
    oTable2.Init();
    oTable2Inited=1;
  }else{
     $('#dm2').bootstrapTable('refresh');
  }
  //通知chosen下拉框更新
  var cs=$(".chosen-select");
  if(cs.length){
    for(var i=0;i<cs.length;i++){
      if($(cs[i]).attr('data-bind')){
        var cid=$(cs[i]).attr('data-bind');
        var  p = {};
        p[$(cs[i]).attr("data-param")] =$(cs[i]).val();
        initAjaxChosen(cid,$(cid).attr('data-url'),p,data[$(cid).attr('name')]);
      }      
    }
  }
  $(".chosen-select").trigger("chosen:updated");
  $(formId).valid();  
}

function detail(id,tableId){
	  layer.open({
	      type: 2,
	      title: '数据元详情',
	      shadeClose: true,
	      shade: 0.1,
	      area: ['620px', '80%'],
	      content: base+'/backstage/dataElement/detail?idForShow='+id
	    }); 
	}

	function unCheck(id){
	  var arr=new Array();
	  var ck=",";
	  for(var j=0;j<dataEles.length;j++){
	    if(dataEles[j].idForShow!=id){
	      arr.push(dataEles[j]);
	      ck+=dataEles[j].id+",";
	    }
	  }
	  $('#dm3 input[value="'+id+'"]').removeAttr("checked");
	  checkedIds =ck;
	  dataEles=arr;
	  initText();

	}

	//查看的额外处理
	function doWithDetail(id,data){
	  if(oTable2Inited==0){
	    oTable2 = new TableInit2();
	    oTable2.Init();
	    oTable2Inited=1;
	  }else{
	     $('#dm2').bootstrapTable('refresh',{url:'${base}/backstage/dataElement/dmAjax'});
	  }
	}
</script>
