<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>

<!DOCTYPE html >
<html lang="en"> 
<head>
<%@include file="../common/includeBaseHead.jsp"%>
 <link rel="stylesheet" type="text/css" href="${base}/static/css/plugins/webuploader/webuploader.css">
   <link rel="stylesheet" type="text/css" href="${base}/static/css/demo/webuploader-demo.css">
<style type="text/css">
.c-list{
cursor: auto !important;
}

.c-list li.search-choice{
padding: 3px 5px 3px 5px !important;

}
.webuploader-pick{
background:#18a689;
}

</style>
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline clearfix">
            <div class="form-group pull-left">
              <input type="text" placeholder="输入中文名称" name="chN" class="form-control col-sm-8">
              <div class="btn-group">
              <button type="button" class="btn btn-primary ml5" onclick=" $('#dicList').bootstrapTable('refresh');" style="border-right: rgba(255,255,255,.3);">搜索</button>
              <button type="button" class="btn btn-primary dropdown-toggle dropdown-btn">
                <span class="caret"></span>
              </button>
            </div>
            </div>
            <div class="form-group pull-left" style="margin-left: 5px;">
              <div class="text-center">
               <c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/govRdataElement/index\") %>">
                <a data-toggle="modal" class="btn btn-primary" onclick="addNew();" href="#">自定义</a>
                <a data-toggle="modal" class="btn btn-primary" onclick="openDicLayer();" href="#">选择模板</a>
               </c:if>
               <c:if test="<%=!ServiceUtil.haveImp(\"/backstage/govRdataElement/index\") %>">
                <a data-toggle="modal" class="btn btn-primary" onclick="importFromExcel();" href="#">Excel导入</a>
               </c:if>
               <c:if test="<%=!ServiceUtil.haveExp(\"/backstage/govRdataElement/index\") %>">
	            <a data-toggle="modal" class="btn btn-primary" onclick="downloadData();" href="#">导出数据</a>
	           </c:if>
                <c:set var="roleid"   value="<%=AccountShiroUtil.getCurrentUser().getRoleId() %>"/>
                <c:if test="${roleid==1}">
                <a data-toggle="modal" class="btn btn-primary" onclick="deleteAllAfter();" href="#">批量删除</a>
                <a data-toggle="modal" class="btn btn-danger" onclick="cleanTable();" href="#">清空所有</a>
                </c:if>
              </div>
            </div>
          </div>
            <ul class="dropdown-menu1 dn form-inline clearfix" style="padding-left: 0; margin: 5px 0 0;">
			    <li class="form-group clearfix">	
				  <label class="pull-left">对象类型：</label>
				  <div class="pull-left" style="width: 200px;">
				  	<select name="obT" data-placeholder=" " class="chosen-select name1 form-control" style="width:350px; display:inline-block;" tabindex="4" required>
	                  <option value=""></option>
	                  <option value="">&nbsp;</option>
	                  <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"OBJECTTYPE\") %>">
		              <option value="${obj.dicKey}">${obj.dicValue}</option>
		              </c:forEach>
	                </select>		
				  </div>	                
				</li>
			    <li class="form-group" style="margin-left: 10px;">			    	    
				<label class="pull-left">来源部门：</label>		
				 <div class="pull-left" style="width: 200px;">  
		          <select name="cId" data-placeholder=" " class="chosen-select name1" style="width:350px;" tabindex="4" required>		            
		            <option value=""></option>
		            <option value="">&nbsp;</option>
		            <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"))%>">
                    <option value="${obj2.id}">${obj2.companyName}</option>
                    </c:forEach>
		          </select>
		        </div>				
			    </li>
			    <li class="form-group" style="margin-left: 10px;">			    	    
				<label class="pull-left">来源：</label>		
				 <div class="pull-left" style="width: 200px;">  
		          	<select name="sourceType_sel" data-placeholder=" " class="chosen-select name1 form-control" style="width:350px; display:inline-block;" tabindex="4" required>
	                  <option value=""></option>
	                  <option value="">&nbsp;</option>
	                  <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"SOURCETYPE\") %>">
		              <option value="${obj.dicKey}">${obj.dicValue}</option>
		              </c:forEach>
	                </select>		
		        </div>				
			    </li>
			 <!--    <li class="form-group">
				    <div class="form-group">
						<label class="control-label">高级3：</label>
						<input type="text" class="form-control">
					</div>
			    </li> -->
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
      <input type="hidden" name="identifier"  class="form-control">
      <input type="hidden" name="imported"  class="form-control">
      <input type="hidden" name="sourceId"  class="form-control">
      <input type="hidden" name="fatherId"  class="form-control">
       <c:forEach var="obj" items="<%=ServiceUtil.getService(\"DataElementFieldsService\").find(ServiceUtil.buildBean(\"DataElementFields@isDeleted=0\"),\"list_no\",\"asc\")%>">
        <div class="form-group">
          <label class="col-sm-3 control-label info-label"  data-id="data${obj.id}">${obj.name}：</label>
          <div class="col-sm-8">
            <c:choose>
              <c:when test="${obj.inputType==1}">
                <input type="text" name="value${obj.valueNo}"
                  class="form-control"
                <c:if test="${obj.required==1}" >required</c:if>>
              </c:when>
              <c:when test="${obj.inputType==2}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="${MyFunction:dic(obj.inputValue)}">
                    <option value="${obj2.dicKey}">${obj2.dicValue}</option>
                  </c:forEach>
                </select>
              </c:when>
              <c:when test="${obj.inputType==3}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"ItemSortService\").find(ServiceUtil.buildBean(\"ItemSort@isDeleted=0\"))%>">
                    <option value="${obj2.id}">${obj2.itemName}</option>
                  </c:forEach>
                </select>
              </c:when>
              <c:when test="${obj.inputType==4}">
                <input type="hidden" name="value${obj.valueNo}"
                    class="form-control edit-hide detail-show"
                    >
                <input type="text" name="value${obj.valueNo}ForShow"
                    class="form-control edit-hide detail-show"
                    >
              </c:when>
              <c:when test="${obj.inputType==5}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.companyName}</option>
                  </c:forEach>
                </select>
              </c:when>
              
              <c:when test="${obj.inputType==15}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"SortManagerService\").find(ServiceUtil.buildBean(\"SortManager@isDeleted=0&type=2\"))%>">
                  <option value="${obj2.sortName}">${obj2.sortCode}</option>
                  </c:forEach>
                </select>
              </c:when>
              
              <c:otherwise>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </c:forEach>
      
      <div>
           
                <table id="table_fields"></table>
         
      </div>
      
    </form>
  </div>

  <div id="child_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="childform">
      <div class="form-group">
        <label class="col-sm-3 control-label">中文名称：</label>
        <div class="col-sm-7">
          <input type="text" name="chName" class="form-control" required>
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
          <input type="text" name="define"  class="form-control" >
        </div>
      </div>
    </form>
  </div>
  
  <!-- 选择子数据元开始 -->
  <div id="single_form" style="display: none;" class="ibox-content">
    <div class="row form-horizontal" style="overflow: hidden;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div class="form-group">
          <label class="col-sm-2 control-label">对象类</label>
          <div class="col-sm-4">
            <select name="dxl-single" data-placeholder=" " class="chosen-select">
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
              <input type="text" placeholder="输入名称" name="keyword-single" class="form-control"> <span class="input-group-btn"> <button type="button" onclick=" $('#single_table').bootstrapTable('refresh');" class="btn btn-primary">搜索
              </button> </span>
            </div>
          </div>
        </div>
        <table id="single_table"></table>
        </div>
      </div>
    </div>
  </div>
  <!-- 选择子数据元结束 -->

  <div id="dic_form" style="display: none;" class="ibox-content">
    <div class="row form-horizontal" style="overflow: hidden;">
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


  <!-- excel导入开始 -->
  <div id="import_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="importForm">
      <div class="form-group" style="padding:10px;">
        <div class="alert alert-info">
              请先下载数据元模版，根据模版填写数据。 <a class="alert-link"  href="${base}/upload/excel/Excel.xls">Excel模版下载</a>.<br />
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

  <!--提示未导入的数据元开始-->
  <div id="notAddedDataElement" class="form-horizontal"
    style="overflow: hidden; display: none;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div class="alert alert-danger">
             下列数据元由于名字和已存在的相同无法导入！   
        </div>
        <div class="table-responsive">
          <table class="table table-striped table-hover">
            <tbody>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
  <!--提示未导入的数据元结束-->


<!-- 导出数据开始 -->
  <div id="download_div" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="downloadForm">
      <div class="alert alert-info">
            如导出数据量大，下载请耐心等待！
        </div>
       <c:forEach var="obj" items="<%=ServiceUtil.getService(\"DataElementFieldsService\").find(ServiceUtil.buildBean(\"DataElementFields@isDeleted=0\"),\"list_no\",\"asc\")%>">
       	<input type="checkbox" name="xlsFields" value="value${obj.valueNo}"/> ${obj.name}
       </c:forEach>
    </form>
  </div>
  <!-- 导出数据结束 -->


</body>
</html>

<%@include file="../common/includeJS.jsp"%>
<script src="${base}/static/js/plugins/webuploader/webuploader.min.js"></script>
<script>
$('.dropdown-btn').on('click', function() {
	$('.dropdown-menu1').toggleClass('dn');
});
$(".name1").chosen({
	  disable_search_threshold: 10,
	  no_results_text: "没有匹配到这条记录",
	  width: "100%"
	});
$("input[name='value1']").blur(function (){
  if($("input[name='value1']").val()==""){
    return;
  }
  jQuery.post("${base}/backstage/dataElement/validation",{"classType":1,"chName":$("input[name='value1']").val(),"value8":$("select[name='value8']").val(),"id":$("input[name='id']").val()},function(data){
    if(data.results==1){
      layer.msg("此中文名称已存在，请重新填写");
      $("input[name='value1']").val("");
      $("input[name='value2']").val("");
    }else{
      $("input[name='value2']").val(data.egName);
    }
  },"json");
});

var layerIndex;//layer 窗口对象
var title_name="数据元";
var layerContent='#layer_form';//layer窗口主体内容dom Id
var tableId='#dicList';//bootstrap-table id
var toolbar='#toolbar';//bootstrap-table 工具栏id
var formId='#eform';//form id
var url='${base}/backstage/govRdataElement/';//controller 路径
var dicLayerContent = '#dic_form';
var dicFormId = '#dicForm';
var statusContent = '#statusform';
var dicLayerIndex;
var checkedIds=",";
var childLayerIndex;
var detailContent='#detailForm';
var BASE_URL = '${base}/static/js/plugins/webuploader';
var $list=$("#fileList");
var uploader;
var inited=0;
var gdata = {"groupId":"<%=AccountShiroUtil.getCurrentUser().getGroupId()%>"};
var cdata = {"companyId":"<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>","value8":"<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>"};
$("#dm3").on("click",'#allC',function(){
    var isChecked = $(this).prop("checked");
    $("input[name='dmname']").prop("checked", isChecked);   
});

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
    server: base+'/backstage/govRdataElement/importDataElement?t=2',
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

$(tableId).on("click",'#allC',function(){   
    var isChecked = $(this).prop("checked");
    $("input[name='statusid']").prop("checked", isChecked);   
});

  layer.config({
      extend: 'extend/layer.ext.js'
  });
var queryParams3 = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1,
      fatherId:0,
      imported:0,
      objectType:$('select[name="dxl-select"]').val(),
      chName:$('input[name="keyword"]').val()
  };
  return temp;
};

$(function () {
    //1.初始化Table
    oTable3 = new TableInit3();
    oTable3.Init();
    ot5=SingleTableInit();
    ot5.Init();
});
var showChilded=0;
function showChild(){
  console.log($('input[name="id"]').val()!="");
  if($('input[name="id"]').val()!=""){
    if(showChilded==0){
      showChilded=1;
      ot4= new ChildTableInit();
      ot4.Init();
    }else{
      $('#child_table').bootstrapTable('refresh');
    }
  }
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

//bootstrap-table 列数
var  columns=[{
	  field: 'id',
	  title: '<input id="allC" type="checkbox">',
	  formatter: 'checkFormatter2',
	}, {
    field: 'identifier',
    title: '内部标识符',
    sortable:true
}, 
<c:forEach var="obj" items="<%=ServiceUtil.getService(\"DataElementFieldsService\").find(ServiceUtil.buildBean(\"DataElementFields@isDeleted=0\"),\"list_no\",\"asc\")%>">
<c:if test="${obj.isShow==1}">
	<c:choose>
		<c:when test="${obj.inputType==1}">
		 	{field: 'value${obj.valueNo}',title: '${obj.name}',sortable:true}, 
		</c:when>
		<c:when test="${obj.inputType==6}">
		 	{field: 'value${obj.valueNo}',title: '${obj.name}',sortable:true}, 
		</c:when>
		<c:otherwise>
			{field: 'value${obj.valueNo}ForShow',title: '${obj.name}'},
    	</c:otherwise>
	</c:choose>
</c:if>       
</c:forEach>
{
    field: 'sourceTypeForShow',
    title: '来源'
},{
    field: 'id',
    title: '操作',
    formatter: 'doFormatter',//对本列数据做格式化
}];

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

function statussuss(id,s){  
  layer.open({
    type: 2,
      title: '数据元审核',
      shadeClose: true,
      shade: 0.1,
      area: ['620px', '80%'],
      content: base+'/backstage/dataElement/detail?idForShow='+id,
      btn: ['审核通过'],
      yes: function(index, layero){
        var d=$(tableId).bootstrapTable('getRowByUniqueId', id);
        var sid=d.id;
        jQuery.post("${base}/backstage/govRdataElement/toStatus",{"sid":sid,"status":s},function(){
          layer.msg("审核成功");
          $(tableId).bootstrapTable('refresh');
        });
        layer.close(index);
      },cancel: function(){ 
        //右上角关闭回调
      }
    });
}
function statuserro(id,s){
  var d=$(tableId).bootstrapTable('getRowByUniqueId', id);
  var sid=d.id;
  if(s==3){
    layer.prompt({
        formType: 2,
        value: '',
        title: '请填写原因'
      }, function(value, index, elem){
        //alert(value); //得到value
        jQuery.post("${base}/backstage/govRdataElement/toStatus",{"sid":sid,"status":3,"reason":value},function(){
          layer.msg("驳回成功");
          $(tableId).bootstrapTable('refresh');
        });
        layer.close(index);
      });
  }else{
    layer.confirm('确定注销吗？', {
        btn: ['注销', '不注销'] 
      }, function(index, layero){
        jQuery.post("${base}/backstage/govRdataElement/toStatus",{"sid":sid,"status":s},function(){
          layer.msg("注销成功");
          $(tableId).bootstrapTable('refresh');
        });
      });
  }
}
  //得到查询的参数
  var queryParams = function(params) {

    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1,
      sort:params.sort,
      order:params.order,
      chName:$('input[name="chN"]').val(),
      value5:$('select[name="obT"]').val(),
      value8:$('select[name="cId"]').val(),
      sourceType:$('select[name="sourceType_sel"]').val(),
      
      <c:if test="${MyFunction:getMaxScope(\"/backstage/govRdataElement/index\")==1}" >
        companyId:<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>,
      </c:if>
      status:99
    };
    return temp;
  };
  function openDicLayer() {
     $('#dm3').bootstrapTable('refresh');
     initChosen();
      $(formId).form('load',cdata);
      $(".chosen-select").trigger("chosen:updated");
    dicLayerIndex = layer.open({
      type : 1,
      area : [ '70%', '80%' ], //宽高
      title : '选择模板',
      scrollbar : false,
      btn : [ '保存', '关闭' ],
      yes : function(index, layero) {
        var adIds = "";  
            $("input:checkbox[name='dmname']:checked").each(function(i){  
                if(0==i){  
                    adIds = $(this).val();  
                }else{  
                    adIds += (","+$(this).val());  
                }  
            });
            $.ajax({
                 type: "POST",
                 url: "${base}/backstage/govRdataElement/insertList",
                 data: {ids:adIds},
                 dataType: "json",
                 success: function(result){
                             if(result.code==1){
                               layer.msg('导入成功');
                             }else{
                               var html = '';
                   r = result.rows;
                   for (var i = 0; i < r.length; i++) {
                       html += '<tr><td>'
                           + r[i].identifier
                           + '</td><td>'
                           + r[i].chName
                           + '</td><td>';
                           html+=doFormatter4(r[i].idForShow, r[i], i);
                           html +='</td></tr>';
                   }
                   
                   //未导入数据元处理
                   if (html != '') {
                     layer.open({
                       type : 1,
                       skin: 'layui-layer-molv',
                       shade : false,
                       offset: '40px',
                       area: ['400px', '70%'], //宽高
                       scrollbar : false,
                       title : '提示', //不显示标题
                       content : $('#notAddedDataElement')
                     });
                     $('#notAddedDataElement tbody').html(html);
                   }
                             }
                             layer.close(index);
                             $('#dicList').bootstrapTable('refresh');
                          }
             });
            },
      offset : '20px',
      content : $(dicLayerContent)
    //这里content是一个DOM
    });
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
          title : '<input id="allC" type="checkbox">',
          formatter : 'doFormatter3'
                },{
          field : 'identifier',
          title : '内部资源标识符'
        }, {

          field : 'chName',
          title : '中文名称'
        },{
          field : 'value8ForShow',
          title : '来源部门'
        },{
          field : 'id',
          title : '操作',
          formatter : 'doFormatter4'
        }]
      });
    };
    return oTableInit;
  };

  var SingleTableInit = function() {
    var oTableInit = new Object();
    //初始化Table
    oTableInit.Init = function() {
      $('#single_table').bootstrapTable({
        url : '${base}/backstage/govRdataElement/listSingle', //请求后台的URL（*）
        method : 'post', //请求方式（*）
        contentType : "application/x-www-form-urlencoded",
        iconSize : 'outline',
        striped : true, //是否显示行间隔色
        cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        pagination : true, //是否显示分页（*）
        sortable : false, //是否启用排序
        sortOrder : "asc", //排序方式
        queryParams : singleQueryParams,//传递参数（*）
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
          title : '<input id="allC-single" type="checkbox">',
          formatter : 'singleFormatter'
                },{
          field : 'identifier',
          title : '内部资源标识符'
        }, {

          field : 'chName',
          title : '中文名称'
        },{
          field : 'companyIdForShow',
          title : '来源部门'
        },{
          field : 'id',
          title : '操作',
          formatter : 'doFormatter4'
        }]
      });
    };
    return oTableInit;
  };

  var singleQueryParams = function(params) {

    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
        rows : params.limit,
        page : params.offset / params.limit + 1,
        status:0,
        objectType:$('select[name="dxl-single"]').val(),
        chName:$('input[name="keyword-single"]').val()
    };
    return temp;
  };

  $("#single_table").on("click",'#allC-single',function(){
      var isChecked = $(this).prop("checked");
      $("input[name='cb-single']").prop("checked", isChecked);   
  });
  
  function checkThis(t){
      var isChecked = $(t).prop("checked");
      if(isChecked){
        checkedIds+=$(t).val()+",";
      }else{
        checkedIds=checkedIds.replace(","+$(t).val()+",",",");
      }
  }

  function singleFormatter(value, row, index) {
    var html='';
    html+='<div class="btn-group">';
    if(row.id!=$('input[name="id"]').val()){
      if(checkedIds.indexOf(","+row.id+",")>-1){
        html+='<input type="checkbox" onclick="checkThis(this);" name="cb-single" value="'+row.id+'" checked="checked"/> ';
      }else{
        html+='<input type="checkbox" onclick="checkThis(this);" name="cb-single" value="'+row.id+'"/> ';
      }
    }
    html+='</div>';
    return html;
  }

  var ChildTableInit = function() {
    var oTableInit = new Object();
    //初始化Table
    oTableInit.Init = function() {
      $('#child_table').bootstrapTable({
        url : '${base}/backstage/govRdataElement/listAjax', //请求后台的URL（*）
        method : 'post', //请求方式（*）
        contentType : "application/x-www-form-urlencoded",
        iconSize : 'outline',
        striped : true, //是否显示行间隔色
        cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        pagination : false, //是否显示分页（*）
        sortable : false, //是否启用排序
        sortOrder : "asc", //排序方式
        queryParams : childQueryParams,//传递参数（*）
        sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
        pageNumber : 1, //初始化加载第一页，默认第一页
        pageSize : 20, //每页的记录行数（*）
        pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
        strictSearch : true,
        clickToSelect : false, //是否启用点击选中行
        uniqueId : "idForShow", //每一行的唯一标识，一般为主键列
        cardView : false, //是否显示详细视图
        detailView : false,
        queryParamsType : "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
        columns : [{
          field : 'identifier',
          title : '内部资源标识符'
        }, {

          field : 'chName',
          title : '中文名称'
        },{
          field : 'id',
          title : '操作',
          formatter : 'doFormatter4'
        }]
      });
    };
    return oTableInit;
  };

  var childQueryParams = function(params) {

    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : 100,
      page : 1,
      fatherId:$('input[name="id"]').val()
    };
    return temp;
  };
  
  function doFormatter3(value, row, index)
  {
    var html='';
    html+='<div class="btn-group">';
    html+='<input type="checkbox" name="dmname" value="'+row.id+'"/> ';
    html+='</div>';
    return html;
  }
  
  function doFormatter4(value, row, index) {
    var html = '';
    html += '<div class="btn-group">';
    html+='<button type="button" class="btn btn-white" onclick="detail(\''+row.idForShow+'\')">查看</button>';
    html += '</div>';
    return html;
  }
  
  function detail(id,tableId){
    datailRow(id);
  }


</script>
<%@include file="../common/baseSystemJS.jsp"%>
<script>
function doFormatter(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="datailRow(\'' + row.idForShow + '\')"><i class="fa fa-info-circle"></i>&nbsp;查看</button>';
  <c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/govRdataElement/index\") %>">
  html += '<button type="button" class="btn btn-white" onclick="editRow(\'' + row.idForShow + '\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
  </c:if>
  <c:if test="<%=!ServiceUtil.haveDel(\"/backstage/govRdataElement/index\") %>">
  html += '<button type="button" class="btn btn-white" onclick="deleteAfter(\'' + row.idForShow + '\',\'' + row.id + '\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
  </c:if>
  html += '</div>';
  return html;
}

function deleteAfter(idForShow, id) {
  $.post("${base}/backstage/dataList/isUse", { dataElementId: id }, function(result) {

    if (result.code && result.code == 1) {
      layer.msg('删除失败！此数据元被调用，请先删除相关数据！');
    } else {
      //layer.msg('删除！');
      deleteRow(idForShow);
    }

  }, 'json');
}

//---------批量删除开始---------
$("#dicList").on("click", '#allC', function() {
  var isChecked = $(this).prop("checked");
  $("input[data-type='plsp']").prop("checked", isChecked);
});
function checkFormatter2(value, row, index) {
  var html = '';
  html += '<input type="checkbox" data-type="plsp" data-id="' + value + '" value="' + row.idForShow + '"  />';
  return html;
}
function deleteAllAfter() {
	  var ids = "";
	  var c = $("input[data-type='plsp']:checked");
	  for (var i = 0; i < c.length; i++) {
	    ids += "," + $(c[i]).attr('data-id');
	  }
	  if (ids != "") {
		  
		  $.post("${base}/backstage/dataList/isUse", { dataElementId: ids }, function(result) {

			    if (result.code && result.code == 1) {
			      layer.msg('删除失败！ '+result.errName+' 被调用，请先删除相关数据！');
			    } else {
			      //layer.msg('删除！');
					  deleteAll(ids)
			    }
			  }, 'json');
		  
	  }else{
		  layer.msg("未选中任何数据！");
	  }
}
function deleteAll(ids) {
    layer.confirm('您确定要删除么？', {
      btn: ['确定', '取消'] //按钮
    }, function() {
      $.post(url + 'deleteAjax', { ids: ids }, function(r) {
        var result = eval('(' + r + ')');
        if (result.code && result.code == 1) {
          $(tableId).bootstrapTable('refresh');

        }
        layer.msg(result.msg);
      });
    }, function() {});
}

//-------批量删除结束---------

function statusAfter(idForShow, id, s) {
  $.post("${base}/backstage/dataList/isUse", { dataElementId: id }, function(result) {
    if (result.code && result.code == 1) {
      layer.msg('注销失败！此数据元被调用，请先删除相关数据！');
    } else {
      //layer.msg('删除！');
      statuserro(idForShow, s);
    }
  }, 'json');
}

//修改的额外处理覆盖此方法
function doWithEdit(id, data) {
  initFieldTable();
  if (data.fatherId > 0) {
    $('#child_div').hide();
  } else {
    $('#child_div').show();
    showChild();
  }

}

//查看的额外处理覆盖此方法
function doWithDetail(id,data){
	initFieldTable();
}

function openLayer() {
  $(formId).form('clear');
  initChosen();
  $(formId).form('load', cdata);
  $(".chosen-select").trigger("chosen:updated");

  $(formId).valid();
  layerIndex = layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '自定义',
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

function intArray(str) {
  var ids = new Array();
  ids = str.split(",");
  console.log(ids);
  return ids;
}



var singleLayerIndex;

function openSingleLayer() {
  checkedIds = ",";
  $('#single_table').bootstrapTable('refresh');
  singleLayerIndex = layer.open({
    type: 1,
    area: ['70%', '80%'], //宽高
    title: '添加子数据元',
    scrollbar: false,
    btn: ['保存', '关闭'],
    yes: function(index, layero) {
      $('#child_table').bootstrapTable('refresh');


      $.post(base + '/backstage/dataElement/setChild', { id: $('input[name="id"]').val(), ids: checkedIds }, function(result) {
        if (result.code && result.code == 1) {
          layer.close(singleLayerIndex);
          $(tableId).bootstrapTable('refresh');
        }
        $('#child_table').bootstrapTable('refresh');
        layer.msg(result.msg);
      }, 'json');
    },
    offset: '20px',
    content: $('#single_form')

  });
}


function openChildLayer() {
  $('input[name="chName"]').val('');
  $('input[name="egName"]').val('');
  childLayerIndex = layer.open({
    type: 1,
    area: ['70%', '80%'], //宽高
    title: '添加子数据元',
    scrollbar: false,
    btn: ['保存', '关闭'],
    yes: function(index, layero) {

      $.post(base + '/backstage/dataElement/addChild', { id: $('input[name="id"]').val(), value1: $('input[name="chName"]').val(), value2: $('input[name="egName"]').val(), value3: $('input[name="define"]').val() }, function(result) {
        if (result.code && result.code == 1) {
          layer.close(childLayerIndex);

          $(tableId).bootstrapTable('refresh');
        }
        $('#child_table').bootstrapTable('refresh');
        layer.msg(result.msg);
      }, 'json');
    },
    offset: '20px',
    content: $('#child_form')

  });
}

function datailRow(id) {
  layer.open({
    type: 2,
    title: '数据元详情',
    shadeClose: true,
    shade: 0.1,
    area: ['620px', '80%'],
    content: base + '/backstage/dataElement/detail?idForShow=' + id
  });

}

function addNew() {
  $('#child_div').hide();
  openLayer();
}



var TableFieldInit = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $('#table_fields').bootstrapTable({
      url: '${base}/backstage/govTableField/listAjax', //请求后台的URL（*）
      method: 'post', //请求方式（*）
      contentType: "application/x-www-form-urlencoded",
      iconSize: 'outline',
      striped: true, //是否显示行间隔色
      cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
      pagination: false, //是否显示分页（*）
      sortable: false, //是否启用排序
      sortOrder: "asc", //排序方式
      queryParams: fieldsQueryParams, //传递参数（*）
      sidePagination: "server", //分页方式：client客户端分页，server服务端分页（*）
      pageNumber: 1, //初始化加载第一页，默认第一页
      pageSize: 20, //每页的记录行数（*）
      pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
      strictSearch: true,
      clickToSelect: false, //是否启用点击选中行
      uniqueId: "idForShow", //每一行的唯一标识，一般为主键列
      cardView: false, //是否显示详细视图
      detailView: false,
      queryParamsType: "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
      columns: [{
          field: 'tableName',
          title: '表名',
          formatter:tableNameFormatter
        },{
        field: 'value1',
        title: '字段名'
      }, {

        field: 'value2',
        title: '字段中文名'
      }, {
        field: 'value5',
        title: '类型'
      }, {
          field: 'value6',
          title: '长度'
        }]
    });
  };
  return oTableInit;
};

function tableNameFormatter(value, row, index)
{
 return row.value3ForShow+'('+row.tableName+')';
}

var fieldsQueryParams = function(params) {

	  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	    rows: 100,
	    page: 1,
	    dataElementId: $('input[name="id"]').val()
	  };
	  return temp;
	};
	
var fieldsInited=0;
function initFieldTable(){
	if(fieldsInited==0){
		fieldsInited=1;
		 oTable = new TableFieldInit();
		    oTable.Init();
	}else{
		 $("#table_fields").bootstrapTable('refresh');
	}
}



$('#downloadForm').form({  
    url: url+'downloadData',  
    success: function(result){ 
    	 
    }  
});


function downloadData(){
	  $('#downloadForm').form('clear');
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

</script>
