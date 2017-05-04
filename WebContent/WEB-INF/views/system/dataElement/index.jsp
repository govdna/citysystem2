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
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=DataElement&searchType=1\"),\"list_no\",\"asc\")%>">      
              	<%@include file="../common/searchBase.jsp"%>         
              </c:forEach>
             <div class="btn-group">
               <button type="button" class="btn btn-primary" onclick=" $('#dicList').bootstrapTable('refresh');" style="border-right: rgba(255,255,255,.3);">搜索</button>
               <button type="button" class="btn btn-primary dropdown-toggle dropdown-btn">
                 <span class="caret"></span>
               </button>
             </div>
          </div>
          <div class="form-group pull-left" style="margin-left: 5px;">
            <div class="text-center">
             <c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/dataElement/index\") %>">
              <a data-toggle="modal" class="btn btn-primary" onclick="addNew();" href="#">新增</a>
             </c:if>
             <c:if test="<%=!ServiceUtil.haveImp(\"/backstage/dataElement/index\") %>">
              <a data-toggle="modal" class="btn btn-primary" onclick="importFromExcel();" href="#">Excel导入</a>
              </c:if>
             <c:if test="<%=!ServiceUtil.haveDel(\"/backstage/dataElement/index\") %>">
              <a data-toggle="modal" class="btn btn-primary" onclick="deleteAll();" href="#">批量删除</a>
             </c:if>             	   	   
              <c:set var="roleid" value="<%=AccountShiroUtil.getCurrentUser().getRoleId() %>" />
              <c:if test="${roleid==1}">
                <a data-toggle="modal" class="btn btn-danger" onclick="cleanTable();" href="#">清空所有</a>
              </c:if>
            </div>         
          </div>
        </div>
        <ul class="dropdown-menu1 dn form-inline clearfix" style="padding-left: 0; margin: 5px 0 0;">
			    <c:forEach var="obj" items="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=DataElement&searchType=2\"),\"list_no\",\"asc\")%>">      
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
    <input type="hidden" name="identifier"  class="form-control">
    <input type="hidden" name="imported"  class="form-control">
    <input type="hidden" name="sourceId"  class="form-control">
    <input type="hidden" name="fatherId"  class="form-control">

<c:set var="simpleFields" value="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=DataElement\"),\"list_no\",\"asc\")%>"/>
      <%@include file="../common/simpleFields.jsp"%>


    <div class="ibox-content" id="child_div" style="padding-left:0px;padding-right:0px;">
        <div class="btn-group" id="toolbar" role="group" style="margin-bottom:15px;">
          <div class="text-center detail-hide">
            <a data-toggle="modal" class="btn btn-primary" id="addDM" onclick="openChildLayer();" href="#">添加子数据元</a>
            <a data-toggle="modal" class="btn btn-primary" id="addDM" onclick="openSingleLayer();" href="#">选择子数据元</a>
          </div>
        </div>
        <table id="child_table"></table>
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
              <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"OBJECTTYPE\")%>">
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
<div id="dataElement-detail" class="form-horizontal" style="overflow: hidden;display:none;">
  <div class="ibox float-e-margins">
    <div class="ibox-content">
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
<div id="child_form" style="display: none;" class="ibox-content">
  <form method="post" class="form-horizontal" id="childform">
    <div class="form-group">
      <label class="col-sm-3 control-label">中文名称：</label>
      <div class="col-sm-7">
        <input type="text" name="chName2"  class="form-control" required>
      </div>
    </div>
    <div class="form-group">
      <label class="col-sm-3 control-label">英文名称：</label>
      <div class="col-sm-7">
        <input type="text" name="egName2"  class="form-control" >
      </div>
    </div>
  </form>
</div>
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
  //验证名称重复
$("input[name='value1']").blur(function() {
  if ($("input[name='value1']").val() == "") {
    return;
  }
  jQuery.post("${base}/backstage/dataElement/validation", { "classType": 0, "chName": $("input[name='value1']").val(), "id": $("input[name='id']").val() }, function(data) {
    //data=JSON.parse(data); 
    if (data.results == 1) {
      layer.msg("此中文名称已存在，请重新填写");
      $("input[name='value1']").val("");
      $("input[name='value2']").val("");
    } else {
      $("input[name='value2']").val(data.egName);
    }
  }, "json");
});
var cdata = { "companyId": "<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>" };
var title_name = "数据元模板";
var layerIndex; //layer 窗口对象
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var datailContent = '#layer_form'; //layer窗口主体内容dom Id
var datailId = '#eform'; //form id
var url = '${base}/backstage/dataElement/'; //controller 路径
var BASE_URL = '${base}/static/js/plugins/webuploader';
var $list = $("#fileList");
var childLayerIndex;
var uploader;
var inited = 0;
var isCheckedInit = 0;
var selectHtml;
var checkedIds = ",";



function initUploader() {
  if (inited == 0) {
    inited = 1;
  } else {
    uploader.destroy();
  }
  uploader = WebUploader.create({

    // 选完文件后，是否自动上传。
    auto: true,

    // swf文件路径
    swf: BASE_URL + '/Uploader.swf',
    timeout: 0,
    // 文件接收服务端。
    server: base + '/backstage/dataElement/importDataElement?t=1',

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

  uploader.on('fileQueued', function(file) {
    var html = '<div class="zz"><p><i class="fa fa-refresh fa-spin" ></i><br><span style="font-size: 14px;font-weight: 700;">拼命上传中</span></p></div>';

    $('.layui-layer').append(html);
    $('#filePicker .webuploader-pick').addClass('grey').html('上传中<i class="fa fa-refresh fa-spin" style="margin-left:10px;"></i>');
    $('input[type="file"]').attr('disabled', true);
  });


  // 文件上传成功，给item添加成功class, 用样式标记上传成功。
  uploader.on('uploadSuccess', function(file, response) {
    console.log(response);
    if (response.res == 1) {
      layer.close(layerIndex);
      layer.msg('导入成功');
      $(tableId).bootstrapTable('refresh');
    } else {
      $('#error-msg').html('<div class="alert alert-danger">' + response.resMsg + '</div>');
    }
    $('#filePicker .webuploader-pick').removeClass('grey').html('上传数据文件');
    $('input[type="file"]').attr('disabled', false);
    $('.zz').remove();
  });

  // 文件上传失败，显示上传出错。
  uploader.on('uploadError', function(file) {
    layer.msg('上传失败');
    $('#filePicker .webuploader-pick').removeClass('grey').html('上传数据文件');
    $('input[type="file"]').attr('disabled', false);
    $('.zz').remove();
  });



  // 完成上传完了，成功或者失败，先删除进度条。
  uploader.on('uploadComplete', function(file) {
    $('#' + file.id).find('.progress').remove();
  });

}

function importFromExcel() {
  $('#importForm').form('clear');
  initUploader();
  $('#importForm').valid();
  layerIndex = layer.open({
    type: 1,
    area: ['60%', '80%'], //宽高
    title: '从Excel导入',
    offset: '0',
    cancel: function() {
      $('#error-msg').html('');
    },
    content: $('#import_form') //这里content是一个DOM
  });
}
//bootstrap-table 列数
var columns = [{
  field: 'id',
  title: '<input id="allC" type="checkbox">',
  formatter: 'checkFormatter2',
}, {
  field: 'identifier',
  title: '内部标识符'
}, 
<c:forEach var="obj" items="${simpleFields}">
<c:if test="${obj.isShow==1}">
	<c:choose>
		<c:when test="${obj.inputType==1}">
		 	{field: 'value${obj.valueNo}',title: '${obj.name}'}, 
		</c:when>
		<c:otherwise>
			{field: 'value${obj.valueNo}ForShow',title: '${obj.name}'},
    	</c:otherwise>
	</c:choose>
</c:if>       
</c:forEach>
{
  field: 'id',
  title: '操作',
  formatter: 'doFormatter', //对本列数据做格式化
}];


function longFormatter(value, row, index) {
  var html = '<span title="' + value + '">';
  if (value.length > 8) {
    html += value.substring(0, 8) + "...";
  } else {
    html += value;
  }
  html += '</span>';
  return html;
}
//---------批量删除开始---------
$("#dicList").on("click", '#allC', function() {
  var isChecked = $(this).prop("checked");
  $("input[data-type='plsp']").prop("checked", isChecked);
});

//选择
function checkFormatter2(value, row, index) {
  var html = '';
  html += '<input type="checkbox" data-type="plsp" data-id="' + value + '" value="' + row.idForShow + '"  />';
  return html;
}


function deleteAll() {
  var ids = "";
  var c = $("input[data-type='plsp']:checked");
  for (var i = 0; i < c.length; i++) {
    ids += "," + $(c[i]).attr('data-id');
  }
  if (ids != "") {
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
}

//-------批量删除结束---------



function cleanTable() {

  layer.confirm('您确定要清空所有数据么？此操作不可恢复！', {
    btn: ['确定', '取消'] //按钮
  }, function() {
    $.post(url + 'cleanTable', function(r) {
      var result = eval('(' + r + ')');
      if (result.code && result.code == 1) {
        $(tableId).bootstrapTable('refresh');

      }
      layer.msg(result.msg);
    });
  }, function() {});

}


//得到查询的参数
var queryParams = function(params) {
	var sort=params.sort;
	var order=params.order;
if(params.sort==null){
	sort="identifier";
	order="asc";
}
if($('input[name="chN"]').val()!=null&&$('input[name="chN"]').val()!=""){
	sort="length(trim(value1))";
	order="asc";
}
  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
    sort : sort,
    order : order,
   

    <c:forEach var="obj" items="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=DataElement\"),\"list_no\",\"asc\")%>">  
   	 <%@include file="../common/searchQueryParams.jsp"%>
  	</c:forEach>
  
  };
  return temp;
};


var ChildTableInit = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $('#child_table').bootstrapTable({
      url: '${base}/backstage/dataElement/listAjax', //请求后台的URL（*）
      method: 'post', //请求方式（*）
      contentType: "application/x-www-form-urlencoded",
      iconSize: 'outline',
      striped: true, //是否显示行间隔色
      cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
      pagination: false, //是否显示分页（*）
      sortable: false, //是否启用排序
      sortOrder: "asc", //排序方式
      queryParams: childQueryParams, //传递参数（*）
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
        field: 'identifier',
        title: '内部资源标识符'
      }, {

        field: 'chName',
        title: '中文名称'
      }, {
        field: 'id',
        title: '操作',
        formatter: 'doFormatter4'
      }]
    });
  };
  return oTableInit;
};

var childQueryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: 100,
    page: 1,
    fatherId: $('input[name="id"]').val()
  };
  return temp;
};

</script>
<%@include file="../common/baseSystemJS.jsp"%>
<script>
function doFormatter(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="datailRow(\'' + row.idForShow + '\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
  <c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/dataElement/index\") %>">
  html += '<button type="button" class="btn btn-white" onclick="editRow(\'' + row.idForShow + '\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
  </c:if>
  <c:if test="<%=!ServiceUtil.haveDel(\"/backstage/dataElement/index\") %>">
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

$(function() {
  ot5 = SingleTableInit();
  ot5.Init();
  initChosen();
});

var showChilded = 0;

function showChild() {
  console.log($('input[name="id"]').val() != "");
  if ($('input[name="id"]').val() != "") {
    if (showChilded == 0) {
      showChilded = 1;
      ot4 = new ChildTableInit();
      ot4.Init();
    } else {
      $('#child_table').bootstrapTable('refresh');
    }
  }
}

function addNew() {
  $('select[name="dataElementId"]').html(selectHtml);
  $('#child_div').hide();
  openLayer();
}


//修改的额外处理覆盖此方法
function doWithEdit(id, data) {
  console.log(data.fatherId > 0);
  if (data.fatherId > 0) {
    $('#child_div').hide();
  } else {
    $('#child_div').show();
    showChild();
  }

}

function doFormatter4(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="datailRow(\'' + row.idForShow + '\')">查看</button>';
  html += '</div>';
  return html;
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
      $('#child_table').bootstrapTable('refresh');
      $.post(base + '/backstage/dataElement/addChild', { id: $('input[name="id"]').val(), value1: $('input[name="chName2"]').val(), value2: $('input[name="egName2"]').val() }, function(result) {
        if (result.code && result.code == 1) {
          layer.close(childLayerIndex);
          $('#child_table').bootstrapTable('refresh');
        }
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
    area: ['500px', '70%'],
    content: base + '/backstage/dataElement/detail?idForShow=' + id
  });

}


var SingleTableInit = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $('#single_table').bootstrapTable({
      url: '${base}/backstage/dataElement/listSingle', //请求后台的URL（*）
      method: 'post', //请求方式（*）
      contentType: "application/x-www-form-urlencoded",
      iconSize: 'outline',
      striped: true, //是否显示行间隔色
      cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
      pagination: true, //是否显示分页（*）
      sortable: false, //是否启用排序
      sortOrder: "asc", //排序方式
      queryParams: singleQueryParams, //传递参数（*）
      sidePagination: "server", //分页方式：client客户端分页，server服务端分页（*）
      pageNumber: 1, //初始化加载第一页，默认第一页
      pageSize: 10, //每页的记录行数（*）
      pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
      strictSearch: true,
      clickToSelect: false, //是否启用点击选中行
      uniqueId: "idForShow", //每一行的唯一标识，一般为主键列
      cardView: false, //是否显示详细视图
      detailView: false,
      queryParamsType: "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
      columns: [{
        field: 'id',
        title: '<input id="allC-single" type="checkbox">',
        formatter: 'singleFormatter'
      }, {
        field: 'identifier',
        title: '内部资源标识符'
      }, {

        field: 'chName',
        title: '中文名称'
      }, {
        field: 'companyIdForShow',
        title: '来源部门'
      }, {
        field: 'id',
        title: '操作',
        formatter: 'doFormatter4'
      }]
    });
  };
  return oTableInit;
};

function doFormatter4(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="datailRow(\'' + row.idForShow + '\')">查看</button>';
  html += '</div>';
  return html;
}

var singleQueryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
    objectType: $('select[name="dxl-single"]').val(),
    chName: $('input[name="keyword-single"]').val()
  };
  return temp;
};

$("#single_table").on("click", '#allC-single', function() {
  var isChecked = $(this).prop("checked");
  $("input[name='cb-single']").prop("checked", isChecked);
});


function checkThis(t) {
  var isChecked = $(t).prop("checked");
  if (isChecked) {
    checkedIds += $(t).val() + ",";
  } else {
    checkedIds = checkedIds.replace("," + $(t).val() + ",", ",");
  }
}


function singleFormatter(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  if (row.id != $('input[name="id"]').val()) {
    if (checkedIds.indexOf("," + row.id + ",") > -1) {
      html += '<input type="checkbox" onclick="checkThis(this);" name="cb-single" value="' + row.id + '" checked="checked"/> ';
    } else {
      html += '<input type="checkbox" onclick="checkThis(this);" name="cb-single" value="' + row.id + '"/> ';
    }
  }
  html += '</div>';
  return html;

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

</script>