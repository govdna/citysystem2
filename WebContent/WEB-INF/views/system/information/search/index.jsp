<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>

<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
</head>
<style type="text/css">
.c-list{
cursor: auto !important;
}
.c-list li{
cursor: pointer !important;
}


.data-info{
display:none;
}
.info-label{
cursor: pointer;
}
.i-checks{
margin-top:0px !important;
}
.hot-keyword{
cursor: pointer;
}
.hot-keyword:hover{
text-decoration:underline;
color:red;
}
.com-count{
padding: 0 15px 0 15px;
background-color: #737973;
color: #fff;
border-radius: 3px;
cursor: pointer;
margin: 5px;
 }
.com-count .badge{
margin-left:5px;
 }
</style>

<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="input-group">
            <input type="text" placeholder="输入关键字" name="keyword" class="form-control input-lg">
            <div class="input-group-btn">
              <button class="btn btn-lg btn-primary" type="submit" onclick="$(tableId).bootstrapTable('refresh');">
                    搜索
              </button>
            </div>
          </div>
          <div style="line-height:28px;"><span>热门搜词：</span>
            <c:forEach var="obj" items="${hotKeyWord}">
              <span class="hot-keyword">${obj.keyWord}</span>
            </c:forEach>
          </div>
          <div class="hr-line-dashed" style="margin-top:5px;margin-bottom:0px;"></div>
          <div class="input-group" style="margin:0 auto;">
            <div class="checkbox i-checks pull-left">
              <label>
              <input type="radio" name="inforTypes" value="" checked> <i></i> 全部</label>
            </div>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"SortManagerService\").find(ServiceUtil.buildBean(\"SortManager@isDeleted=0&level=1&belong=2\"))%>">
            <div class="checkbox i-checks pull-left">
              <label><input type="radio" name="inforTypes" value="${obj.id}"> <i></i> ${obj.sortName}</label>
            </div>
            </c:forEach>
            <button  class="btn btn-default btn-xs" style="margin-left:30px;" onclick="showComCount(this);">更多<i class="fa fa-sort-desc"></i></button>
          </div>
          <div style="display:none;" id="com_div">
            <input type="hidden" name="com-count" />
            <div class="pull-left com-count" data-id="">全部</div>
            <c:forEach var="obj" items="${companyCount}">
            <div class="pull-left com-count" data-id="${obj.id}">${obj.companyName}<span class="badge">${obj.address}</span></div>
            </c:forEach>
          </div>
        </div>
        <table id="dicList"></table>
      </div>
    </div>
  </div>
  <div id="layer_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal eform1" id="eform">
        <!-- form input封装 -->
     <%@include file="../resource/form.jsp"%>
      <!-- form input封装 结束-->
      <div class="ibox-content" id="dicTree" style="padding-left:0px;padding-right:0px;">
        <div class="btn-group" id="toolbar" role="group" style="margin-bottom:15px;">
          <div class="text-center detail-hide">
            <a data-toggle="modal" class="btn btn-primary" id="addDM" onclick="openDicLayer();" href="#">选择信息项</a>
          </div>
        </div>
        <table id="dm2"></table>
      </div>
    </form>
  </div>

  <!--查看数据元开始 -->
  <div id="dataElement-detail" class="form-horizontal"
    style="overflow: hidden;display:none;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div class="form-group">
          <label class="col-sm-4 control-label">内部标识符：</label>
          <span class="col-sm-7 dt-span" name="identifier"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">中文名称：</label>
          <span class="col-sm-7 dt-span" name="chName"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">英文名称：</label>
          <span class="col-sm-7 dt-span" name="egName"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">定义：</label>
          <span class="col-sm-7 dt-span" name="define"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">数据类型：</label>
          <span class="col-sm-7 dt-span" name="dataTypeForShow"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">数据长度：</label>
          <span class="col-sm-7 dt-span" name="dataFormat"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">对象类型：</label>
          <span class="col-sm-7 dt-span" name="objectTypeForShow"></span>
        </div>
      </div>
    </div>
  </div>
  <!-- 查看数据元结束 -->

  <!--资源申请开始 -->
  <div id="application-layer" class="form-horizontal"
    style="overflow: hidden;display:none;">
    <form method="post" class="form-horizontal eform1" id="applicationForm">
      <input type="hidden" name="informationId"/>
      <input type="hidden" name="informationCompany"/>
      <div class="ibox float-e-margins">
        <div class="ibox-content">
          <div class="form-group">
            <label class="col-sm-3 control-label">申请资源：</label>
            <span class="col-sm-8 dt-span" name="information"></span>
          </div>
          <div class="form-group">
            <label class="col-sm-3 control-label">经办人：</label>
            <span class="col-sm-8 dt-span" name="informationCompanyForShow"></span>
          </div>
          <div class="form-group">
            <label class="col-sm-3 control-label">申请用途：</label>
            <div class="col-sm-8" style="padding: 0px;">
              <textarea class="form-control" rows="7" name="applyReason" required></textarea>
            </div>
          </div>
        </div>
      </div>
    </form>
  </div>
  <!-- 资源申请结束 -->

  <!-- 上传数据开始 -->
  <div id="upload-data" style="overflow: hidden;display:none;">
    <input name="informationResourceId" type="hidden"/>
    <div class="ibox float-e-margins">
      <div class="ibox-content">
      <div class="form-group" >
        <table id="fileList"></table>
      </div>
      </div>
    </div>
  </div>
  <!-- 上传数据结束 -->
</body>
</html>
<%@include file="../../common/includeJS.jsp"%>

<script>

var layerIndex; //layer 窗口对象
var layerContent = '#layer_form'; // layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var url = '${base}/backstage/information/resource/'; //controller 路径
var chosenInited = 0;
var isDetailed = 0;
var contentHtml;
var infoLayer;

function showInfo(id) {
  layer.close(infoLayer);
  infoLayer = layer.tips($('.data-info[data-id="' + id + '"]').html(), 'label[data-id="data' + id + '"]', {
    tips: [1, '#999'],
    time: 10000
  });
}



var queryParams2 = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    dataManagerId: $('input[name="id"]').val()

  };
  return temp;
};

//查看方法 参数（当前行的id,TableId,div,弹窗类型，默认小窗口）
function detail(id, tableId, divId, windowType) {
  if (divId && divId != '') {

  } else {
    divId = '#dataElement-detail';
  }
  var data;
  if (typeof(tableId) != "undefined") {
    data = $(tableId).bootstrapTable('getRowByUniqueId', id);
  } else {
    for (var j = 0; j < dataEles.length; j++) {
      if (dataEles[j].idForShow == id) {
        data = dataEles[j];
      }
    }
  }

  var sp = $(divId + ' span');
  if (sp.length) {
    for (var i = 0; i < sp.length; i++) {
      if ($(sp[i]).attr('name') && $(sp[i]).attr('name') != null) {
        var nm = $(sp[i]).attr('name');
        if (typeof(data[nm]) != "undefined") {
          $(sp[i]).html(data[nm]);
        }

      }
    }
  }
  var tables = $(divId + ' table');
  if (typeof(tables.length) != "undefined") {
    $('span[name="detail_id"]').html(data.id);
    for (var i = 0; i < tables.length; i++) {
      if ($(tables[i]).attr('data-url')) {
        initTable(tables[i], $(tables[i]).attr('data-url'), eval($(tables[i]).attr('data-queryParams')), eval($(tables[i]).attr('data-columns')));
      }

    }
  }
  if (windowType) {
    layer.open({
      type: 1,
      area: ['70%', '80%'], //宽高
      title: '查看',
      scrollbar: false,
      offset: '20px',
      content: $(divId)
    });
  } else {
    layer.open({
      type: 2,
      title: '数据元详情',
      shadeClose: true,
      shade: 0.1,
      area: ['620px', '80%'],
      content: base + '/backstage/dataElement/detail?idForShow=' + id
    });
  }


}

var dataElementColumns2 = [{
  field: 'identifier',
  title: '内部资源标识符'
}, {

  field: 'chName',
  title: '中文名称'
}, {

  field: 'egName',
  title: '英文名称'
}, {

  field: 'isShare',
  title: '是否共享',
  formatter: 'isShareFormatter', //对本列数据做格式化    
}, {
  field: 'id',
  title: '操作',
  formatter: 'doFormatter2', //对本列数据做格式化    
}];

function isShareFormatter(value, row, index) {
  if (typeof($(formId + ' .div_hidden').length) != 'undefined' && $(formId + ' .div_hidden').length > 0) {
    return row.isShareForShow;
  }
  var html = '<div class="checkbox checkbox-success"><input  type="checkbox" name="shareCheckBox" ';

  if (typeof(value) != "undefined" && value === 0) {
    html += ' checked="checked" ';
  }
  html += 'id="checkbox' + row.id + '" value="' + row.id + '"><label for="checkbox' + row.id + '">共享</label> </div>';

  return html;
}


//bootstrap-table 列数
var columns = [{
  field: 'value2',
  title: '信息资源代码'
}, {
  field: 'value1',
  title: '信息资源名称',
  formatter: 'longFormatter',
}, {
  field: 'value8',
  title: '共享状态',
  formatter: 'shareFormatter', //对本列数据做格式化
}, {
  field: 'id',
  title: '操作',
  formatter: 'doFormatter', //对本列数据做格式化
}];

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

var queryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
    status: 0,
    inforTypes: $("input[name='inforTypes']:checked").val(),
    keyword: $("input[name='keyword']").val(),
    value3: $("input[name='com-count']").val(),
  };
  return temp;
};


function doFormatter(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="datailRow(\'' + row.idForShow + '\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';

  if (typeof(row['value8']) != "undefined" && row['value8'] != 1) {
    if (typeof(row['applicationStatus']) != "undefined") {
      if (row['applicationStatus'] == 2 || row['applicationStatus'] == 10) {
        html += '<button type="button" class="btn btn-white" onclick="apply(\'' + row.idForShow + '\')"><i class="fa fa-share-alt"></i>&nbsp;申请共享</button>';
      }
    }
  }
  if (typeof(row['hasFile']) != "undefined") {
    html += '<button type="button" class="btn btn-white" onclick="openUpload(\'' + row.idForShow + '\')"><i class="fa fa-cloud-download"></i>&nbsp;查看数据</button>';

  }

  if (typeof(row['subscribe']) != "undefined" && row['subscribe'] != 0) {
    html += '<button type="button" class="btn btn-white" onclick="subscribe(\'' + row.idForShow + '\')"><i class="fa fa-rss"></i>&nbsp;订阅</button>';
  }

  html += '</div>';
  return html;
}


function show(id) {
  layer.open({
    type: 2,
    title: '预览',
    shadeClose: true,
    shade: 0.1,
    area: ['95%', '95%'],
    content: base + '/backstage/dataFile/show?idForShow=' + id
  });
}


function download(id) {
  window.open(base + '/backstage/io/downloadData?idForShow=' + id);
}

var showData;

function openUpload(id) {
  var data = $(tableId).bootstrapTable('getRowByUniqueId', id);
  showData = data;
  $('input[name="informationResourceId"]').val(data.id);
  layer.open({
    type: 1,
    area: ['70%', '80%'], //宽高
    title: '查看数据',
    scrollbar: false,
    offset: '20px',
    content: $('#upload-data')
  });

  $('#fileList').bootstrapTable('destroy');
  $('#fileList').bootstrapTable({
    url: base + '/backstage/dataFile/listAjax', //请求后台的URL（*）
    method: 'post', //请求方式（*）
    contentType: "application/x-www-form-urlencoded",
    iconSize: 'outline',
    striped: true, //是否显示行间隔色
    cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
    pagination: false, //是否显示分页（*）
    sortable: false, //是否启用排序
    sortOrder: "asc", //排序方式
    queryParams: fileQueryParams, //传递参数（*）
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
    columns: fileColumns,

  });

}

var fileColumns = [{
  field: 'fileName',
  title: '文件名'
}, {

  field: 'timeCreate',
  title: '上传时间'
}, {
  field: 'id',
  title: '操作',
  formatter: 'fileFormatter', //对本列数据做格式化    
}];

var fileQueryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: 1000,
    page: 1,
    informationResourceId: $('input[name="informationResourceId"]').val()
  };
  return temp;
};

function fileFormatter(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="show(\'' + row.idForShow + '\')"><i class="fa fa-info-circle"></i>&nbsp;预览</button>';
  if (showData.value8 == 1 || showData.applicationStatus == 0) {
    html += '<button type="button" class="btn btn-white" onclick="download(\'' + row.idForShow + '\')"><i class="fa fa-cloud-download"></i>&nbsp;下载</button>';

  }

  html += '</div>';
  return html;
}


function shareFormatter(value, row, index) {
  if (value == 1) {
    return '无条件共享';
  } else {
    if (typeof(row['applicationStatus']) != "undefined") {
      if (row['applicationStatus'] == 0) {
        return '已成功申请共享';
      } else if (row['applicationStatus'] == 1) {
        return '申请共享中';
      } else if (row['applicationStatus'] == 2) {
        return '申请共享失败';
      } else if (row['applicationStatus'] == 10) {
        return '可申请共享';
      }
    }
  }
  return '';
}


var TableInit = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $(tableId).bootstrapTable({
      url: url + 'listAjax' + '?' + '<%=request.getQueryString()%>', //请求后台的URL（*）
      method: 'post', //请求方式（*）
      contentType: "application/x-www-form-urlencoded",
      toolbar: toolbar, //工具按钮用哪个容器
      iconSize: 'outline',
      striped: true, //是否显示行间隔色
      cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
      pagination: true, //是否显示分页（*）
      sortable: false, //是否启用排序
      sortOrder: "asc", //排序方式
      queryParams: queryParams, //传递参数（*）
      sidePagination: "server", //分页方式：client客户端分页，server服务端分页（*）
      pageNumber: 1, //初始化加载第一页，默认第一页
      pageSize: 10, //每页的记录行数（*）
      pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
      strictSearch: true,
      clickToSelect: false, //是否启用点击选中行
      uniqueId: "idForShow", //每一行的唯一标识，一般为主键列
      cardView: false, //是否显示详细视图
      detailView: false,
      showRefresh: false,
      showToggle: false,
      showColumns: false,
      queryParamsType: "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
      columns: columns
    });
  };
  return oTableInit;
};

$(function() {

  //1.初始化Table
  oTable = new TableInit();
  oTable.Init();

  oTable2 = new TableInit2();
  oTable2.Init();

});



//查看的额外处理覆盖此方法
function doBeforDetail(id, data) {
  var ip = $(".detail-show");
  if (ip.length) {
    for (var i = 0; i < ip.length; i++) {
      if ($(ip[i]).prop('tagName') != 'DIV') {
        $(ip[i]).parents('div .form-group').show();
      } else {
        $(ip[i]).show();
      }
    }
  }
}

//查看的额外处理
function doWithDetail(id, data) {
  $('#dm2').bootstrapTable('refresh', { url: '${base}/backstage/dataElement/getDataElementByIRId' });
  if (data.status == 2) {
    $('#status_div').html('<div class="alert alert-danger" >审核不通过：' + data.reason + '</div>');
  } else {
    $('#status_div').html('');
  }
  var val = $('select[name="value8"]').val();
  if (val == 2) {
    $('select[name="value9"]').parents('div .form-group').show();
  } else {
    $('select[name="value9"]').parents('div .form-group').hide();
  }

  var val = $('select[name="value11"]').val();
  if (val == 1) {
    $('input[name="value12"]').parents('div .form-group').show();
  } else {
    $('input[name="value12"]').parents('div .form-group').hide();
  }



}


function openLayer() {
  $(formId).form('clear');
  initChosen();
  $('div .form-group').show();
  $('input[name="value14"]').val(getNowFormatDate());
  $(formId).valid();
  var ip = $(".edit-hide");
  if (ip.length) {
    for (var i = 0; i < ip.length; i++) {
      if ($(ip[i]).prop('tagName') != 'DIV') {
        $(ip[i]).parents('div .form-group').hide();
      } else {
        $(ip[i]).hide();
      }
    }
  }
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
      $('#status_div').html('');
      $(layerContent + ' .dt-span').remove();
      $(layerContent + ' .div_hidden').removeClass('div_hidden');
    },
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
  });
}



function initTable(tableId, url, queryParams, columns) {
  $(tableId).bootstrapTable('destroy');
  $(tableId).bootstrapTable({
    url: url, //请求后台的URL（*）
    method: 'post', //请求方式（*）
    contentType: "application/x-www-form-urlencoded",
    iconSize: 'outline',
    striped: true, //是否显示行间隔色
    cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
    pagination: false, //是否显示分页（*）
    sortable: false, //是否启用排序
    sortOrder: "asc", //排序方式
    queryParams: queryParams, //传递参数（*）
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
    columns: columns
  });
}

var TableInit2 = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $('#dm2').bootstrapTable({
      url: '${base}/backstage/dataElement/getDataElementByIRId', //请求后台的URL（*）
      method: 'post', //请求方式（*）
      contentType: "application/x-www-form-urlencoded",
      iconSize: 'outline',
      striped: true, //是否显示行间隔色
      cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
      pagination: false, //是否显示分页（*）
      sortable: false, //是否启用排序
      sortOrder: "asc", //排序方式
      queryParams: queryParams2, //传递参数（*）
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
      columns: dataElementColumns2

    });
  };
  return oTableInit;
};

function doFormatter2(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="detail(\'' + row.idForShow + '\',\'#dm2\',\'\')">查看</button>';
  html += '</div>';
  return html;
}


function openDetailLayer() {
  $(formId).form('clear');
  initChosen();
  $(formId).valid();
  layerIndex = layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '详情',
    scrollbar: false,
    cancel: function(index, layero) {
      $(layerContent + ' .dt-span').remove();
      $(layerContent + ' .div_hidden').removeClass('div_hidden');
    },
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
  });
}


function datailRow(id, la) {
  if (!la) {
    openDetailLayer();
    layer.title('详情', layerIndex);
  }
  $(layerContent + " div").removeClass("has-error");
  $(layerContent + " div").removeClass("has-success");
  $(layerContent + " .detail-hide").addClass('div_hidden');
  var data = $(tableId).bootstrapTable('getRowByUniqueId', id);
  doBeforDetail(id, data);
  $(formId).form('load', data);
  doWithDetail(id, data);
  //下拉级联显示
  var cs = $(layerContent + " .chosen-select");
  if (cs.length) {
    for (var i = 0; i < cs.length; i++) {
      if ($(cs[i]).attr('data-bind')) {
        var cid = $(cs[i]).attr('data-bind');
        var p = {};
        p[$(cs[i]).attr("data-param")] = $(cs[i]).val();
        initAjaxChosen(cid, $(cid).attr('data-url'), p, data[$(cid).attr('name')], true);
      }

    }
  }
  $(".chosen-select").trigger("chosen:updated");
  //替换input显示
  var inp = $(layerContent + ' input');
  if (inp.length) {
    for (var i = 0; i < inp.length; i++) {
      if ($(inp[i]).attr('type') != 'hidden' && $(inp[i]).hasClass('form-control')) {
        var cl = $(inp[i]).parent('div').attr('class');
        $(inp[i]).parent('div').addClass('div_hidden');
        var rootDiv = $(inp[i]).parents('.form-group');
        if ($(rootDiv).find('span .dt-span').length) {
          $(rootDiv).find('span .dt-span').html(data[$(inp[i]).attr('name')])
        } else {
          $(rootDiv).append('<span class="' + cl + ' dt-span">' + data[$(inp[i]).attr('name')] + '</span>');
        }
      }

    }
  }
  //替换select显示
  var sel = $(layerContent + ' select');
  if (sel.length) {
    for (var i = 0; i < sel.length; i++) {
      var vl = $(sel[i]).find('option[value="' + data[$(sel[i]).attr('name')] + '"]').html();
      var cl = $(sel[i]).parent('div').attr('class');
      $(sel[i]).parent('div').addClass('div_hidden');
      var rootDiv = $(sel[i]).parents('.form-group');
      if ($(rootDiv).find('span .dt-span').length) {
        $(rootDiv).find('span .dt-span').html(vl)
      } else {
        if (vl) {
          $(rootDiv).append('<span class="' + cl + ' dt-span" data-name="' + $(sel[i]).attr('name') + '" data-value="' + data[$(sel[i]).attr('name')] + '">' + vl + '</span>');
        } else {
          $(rootDiv).append('<span class="' + cl + ' dt-span" data-name="' + $(sel[i]).attr('name') + '" data-value="' + data[$(sel[i]).attr('name')] + '"></span>');
        }

      }
    }
  }

}



//初始化下拉框
function initChosen() {
  disableChosen();
  if (chosenInited == 0) {
    chosenInited = 1;
  } else {
    $(".chosen-select").val("");
    $(".chosen-select").trigger("chosen:updated");
    return;
  }
  var chosen = $(".chosen-select").chosen({
    disable_search_threshold: 10,
    no_results_text: "没有匹配到这条记录",
    width: "100%"
  });

  chosen.on('change', function(e, params) {
    if ($(this).attr('data-bind')) {
      var cid = $(this).attr('data-bind');
      if ($(this).val() == '') {
        $(cid).val('');
        $(cid).attr('disabled', true).trigger("chosen:updated");
      } else {
        $(cid).attr('disabled', false).trigger("chosen:updated")
        var p = {};
        p[$(this).attr("data-param")] = $(this).val();
        initAjaxChosen(cid, $(cid).attr('data-url'), p);
      }

    }
    $(formId).valid();
  });

  $(".chosen-select").trigger("chosen:updated");

}

//notValid不进行验证
function initAjaxChosen(cid, url, p, value, notValid, isEdit) {
  $.get(url, p, function(r) {
    if (typeof(isEdit) != "undefined") {
      var th = cid;
      while ($(th).attr('data-bind')) {
        th = $(th).attr('data-bind');
        $(th).val('');
        $(th).attr('disabled', true).trigger("chosen:updated");
      }
    }



    var html = '<option value=""></option>';
    var keyField = $(cid).attr('data-keyField');
    var valueField = $(cid).attr('data-valueField');
    for (var i = 0; i < r.length; i++) {
      var item = r[i];
      html += '<option value="' + item[keyField] + '">' + item[valueField] + '</option>';
    }
    $(cid).html(html);
    $(cid).val(value);
    if ($(layerContent + ' span[data-name="' + $(cid).attr('name') + '"]')) {
      var vl = $(cid).find('option[value="' + value + '"]').html();
      $(layerContent + ' span[data-name="' + $(cid).attr('name') + '"]').html(vl);
    }
    $(".chosen-select").trigger("chosen:updated");
    disableChosen();
    if (!notValid) {
      $(formId).valid();
    }

  }, 'json');
}


function disableChosen() {
  var cs = $(".chosen-select");
  if (cs.length) {
    for (var i = 0; i < cs.length; i++) {
      if ($(cs[i]).attr('data-bind')) {
        var cid = $(cs[i]).attr('data-bind');
        if (!$(cs[i]).val()) {
          $(cid).attr('disabled', true).trigger("chosen:updated");
        } else {
          $(cid).attr('disabled', false).trigger("chosen:updated");
        }
      }

    }
  }
  var cs = $(".chosen-select[data-level='2']");
  if (cs.length) {
    for (var i = 0; i < cs.length; i++) {
      if ($(cs[i]).attr('data-bind')) {
        var cid = $(cs[i]).attr('data-bind');
        if (!$(cs[i]).val()) {
          $(cid).attr('disabled', true).trigger("chosen:updated");
        } else {
          $(cid).attr('disabled', false).trigger("chosen:updated");
        }
      }

    }
  }
  var cs = $(".chosen-select[data-level='3']");
  if (cs.length) {
    for (var i = 0; i < cs.length; i++) {
      if ($(cs[i]).attr('data-bind')) {
        var cid = $(cs[i]).attr('data-bind');
        if (!$(cs[i]).val()) {
          $(cid).attr('disabled', true).trigger("chosen:updated");
        } else {
          $(cid).attr('disabled', false).trigger("chosen:updated");
        }
      }

    }
  }
  var cs = $(".chosen-select[data-level='4']");
  if (cs.length) {
    for (var i = 0; i < cs.length; i++) {
      if ($(cs[i]).attr('data-bind')) {
        var cid = $(cs[i]).attr('data-bind');
        if (!$(cs[i]).val()) {
          $(cid).attr('disabled', true).trigger("chosen:updated");
        } else {
          $(cid).attr('disabled', false).trigger("chosen:updated");
        }
      }

    }
  }
}


function apply(id) {
  $('#applicationForm').form('clear');
  var data = $(tableId).bootstrapTable('getRowByUniqueId', id);
  $('span[name="information"]').html(data.value1);
  $('span[name="informationCompanyForShow"]').html(data.value3ForShow);
  $('input[name="informationId"]').val(data.id);
  $('input[name="informationCompany"]').val(data.companyId);

  layerIndex = layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '申请共享',
    scrollbar: false,
    btn: ['提交', '关闭'],
    yes: function(index, layero) {
      $('#applicationForm').submit();
    },
    cancel: function(index, layero) {

    },
    offset: '20px',
    content: $('#application-layer') //这里content是一个DOM
  });

}


$('#applicationForm').form({
  url: base + '/backstage/application/insertAjax',
  onSubmit: function() {
    return $('#applicationForm').valid();
  },
  success: function(result) {
    var result = eval('(' + result + ')');
    if (result.code && result.code == 1) {
      layer.close(layerIndex);
      $(tableId).bootstrapTable('refresh');
      layer.msg('申请已提交！');
    } else {
      layer.msg(result.msg);
    }

  }
});

//鼠标悬浮显示元数据
function showInfo(id) {
  layer.close(infoLayer);
  infoLayer = layer.tips($('.data-info[data-id="' + id + '"]').html(), 'label[data-id="data' + id + '"]', {
    tips: [1, '#999'],
    time: 10000
  });
}

//回车搜索
$('input[name="keyword"]').on('keydown', function() {
  var event = window.event || arguments.callee.caller.arguments[0];
  if (event.keyCode == 13) {
    $(tableId).bootstrapTable('refresh');
  }
});

//热词点击事件
$('.hot-keyword').on('click', function() {
  if ($('input[name="keyword"]').val() != $(this).html()) {
    $('input[name="keyword"]').val($(this).html());
    $(tableId).bootstrapTable('refresh');
  }

});


$('.com-count').on('click', function() {
  if ($('input[name="com-count"]').val() != $(this).attr('data-id')) {
    $('input[name="com-count"]').val($(this).attr('data-id'));
    $(tableId).bootstrapTable('refresh');
    //$('input[name="com-count"]').val('');
  }

});

//显示统计fa fa-sort-asc
function showComCount(t) {
  if ($(t).html().indexOf('收起') > -1) {
    $('#com_div').hide();
    $(t).html('更多<i class="fa fa-sort-desc"></i>');
  } else {
    $('#com_div').show();
    $(t).html('收起<i class="fa fa-sort-asc"></i>');
  }

}
//信息资源订阅
function subscribe(id) {
  var data = $(tableId).bootstrapTable('getRowByUniqueId', id);

  $.post(base + '/backstage/subscribe/insertAjax', { informationResourceId: data.id }, function(result) {
    if (typeof(result.code) != "undefined" && result.code == 1) {
      layer.msg('订阅成功');
      $(tableId).bootstrapTable('refresh');
    } else {
      layer.msg('操作失败');
    }

  }, 'json');
}

</script>
