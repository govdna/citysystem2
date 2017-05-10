<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseHead.jsp"%>
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
</style>
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">

<div class="wrapper wrapper-content animated fadeInRight">
  <div class="ibox float-e-margins">
    <div class="ibox-content">
      <div class="btn-group hidden-xs" id="toolbar" role="group">
        <div class="text-center">
          <a data-toggle="modal" class="btn btn-primary" onclick="addNew();" href="#">新增</a>
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
    <input type="hidden" name="dataElementId" />
    <div class="form-group">
      <label class="col-sm-3 control-label">名称：</label>
      <div class="col-sm-7">
        <input type="text" name="cname" class="form-control" required>
      </div>
    </div>
    <div class="form-group">
      <label class="col-sm-3 control-label">意义：</label>
      <div class="col-sm-7">
        <input type="text" name="meanting" class="form-control" required>
      </div>
    </div>
    <div class="form-group">
      <label class="col-sm-3 control-label">用途：</label>
      <div class="col-sm-7">
        <input type="text" name="application" class="form-control" required>
      </div>
    </div>
    <div class="ibox-content" id="dicTree" style="padding-left:0px;padding-right:0px;">
      <div class="btn-group" id="toolbar" role="group" style="margin-bottom:15px;">
        <div class="text-center detail-hide">
          <a data-toggle="modal" class="btn btn-primary" id="addDM" onclick="openDicLayer();" href="#">选择信息项</a>
        </div>
      </div>
      <table id="dm2"></table>
    </div>
</div>

<div id="dic_form" style="display: none;" class="ibox-content">
  <div class="row form-horizontal" style="overflow: hidden;">
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
    </div>
  </div>
</div>
</body>
</html>

<%@include file="../common/includeJS.jsp"%>
<script>
var oTable2Inited = 0;

$(function() {
  $('.senior button').on('click', function() {
    $('.senior-search').slideToggle();
  })
});
var dicLayerContent = '#dic_form';
var title_name = "自主设计模型";
var layerIndex; //layer 窗口对象
var layerContent = '#layer_form'; // layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var url = '${base}/backstage/customization/'; //controller 路径
var dicLayerIndex;
var checkedIds = ",";
var checkedEles;
var dataEles; //存放选中的数据元


function addNew() {
  dataEles = new Array();
  checkedIds = ",";
  $('#dm2').bootstrapTable('load', { rows: [] });
  openLayer();
  initDataElements();
  if (oTable2Inited == 0) {
    oTable2 = new TableInit2();
    oTable2.Init();
    oTable2Inited = 1;
  } else {
    $('#dm2').bootstrapTable('refresh');
  }
}
//或许所有数据元
function initDataElements() {
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
      html += '<li class="search-choice" onclick="detail(\'' + checkedEles[k].idForShow + '\');"><span>' + checkedEles[k].chName + '</span><a class="search-choice-close" onclick="unCheck(\'' + checkedEles[k].idForShow + '\');"></a></li>';
    }
    $('.c-list').html(html);
  } else {
    $('.c-list').html('');
  }

}
//bootstrap-table 列数
var columns = [{
  field: 'cname',
  title: '名称'
}, {
  field: 'meanting',
  title: '意义'
}, {
  field: 'application',
  title: '用途'
}, {
  //    field: 'effect',
  //      title: '效果'
  //  },{
  field: 'id',
  title: '操作',
  formatter: 'doFormatter', //对本列数据做格式化
}];
//得到查询的参数
var queryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
  };
  return temp;
};

var queryParams2 = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    id: $('input[name="id"]').val()
  };
  return temp;
};

var queryParams3 = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
    objectType: $('select[name="dxl-select"]').val(),
    chName: $('input[name="keyword"]').val(),
    status: 0,
    classType: 1,
    companyId: <%= AccountShiroUtil.getCurrentUser().getCompanyId() %>
  };
  return temp;
};

$(function() {
  oTable3 = new TableInit3();
  oTable3.Init();
});

var TableInit2 = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $('#dm2').bootstrapTable({
      url: '${base}/backstage/dataElement/getDataElementAjax', //请求后台的URL（*）
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
      columns: [{
        field: 'identifier',
        title: '内部资源标识符'
      }, {

        field: 'chName',
        title: '中文名称'
      }, {

        //  field : 'companyIdForShow',
        //  title : '来源部门'
        //},{
        field: 'id',
        title: '操作',
        formatter: 'doFormatter2', //对本列数据做格式化    
      }],
      onLoadSuccess: function(data) {

        if (typeof(data.rows) != "undefined") {
          dataEles = data.rows;
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
    type: 1,
    area: ['70%', '80%'], //宽高
    title: '选择信息项',
    scrollbar: false,
    btn: ['保存', '关闭'],
    yes: function(index, layero) {
      $('#dm2').bootstrapTable('load', { rows: checkedEles });
      //$(dicFormId).submit();
      //console.log(checkedEles);
      $('input[name="dataElementId"]').val(checkedIds);
      layer.close(dicLayerIndex);
    },
    offset: '20px',
    content: $(dicLayerContent)
      //这里content是一个DOM
  });
}

var TableInit3 = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $('#dm3').bootstrapTable({
      url: '${base}/backstage/govRdataElement/listAjax', //请求后台的URL（*）
      method: 'post', //请求方式（*）
      contentType: "application/x-www-form-urlencoded",
      iconSize: 'outline',
      striped: true, //是否显示行间隔色
      cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
      pagination: true, //是否显示分页（*）
      sortable: false, //是否启用排序
      sortOrder: "asc", //排序方式
      queryParams: queryParams3, //传递参数（*）
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
        title: '添加',
        formatter: 'checkFormatter'
      }, {
        field: 'identifier',
        title: '内部资源标识符'
      }, {

        field: 'chName',
        title: '中文名称'
      }, {

        //  field : 'companyIdForShow',
        //  title : '来源部门'
        //},{
        field: 'id',
        title: '操作',
        formatter: 'doFormatter3', //对本列数据做格式化    
      }]
    });
  };
  return oTableInit;
};


function checkFormatter(value, row, index) {
  var html = '';
  if (checkedIds.indexOf("," + value + ",") > -1) {
    html += '<input type="checkbox" data-id="' + value + '" value="' + row.idForShow + '" data-name="' + row.chName + '" onclick="selectDE(this);" checked="checked"/>';
  } else {
    html += '<input type="checkbox" data-id="' + value + '" value="' + row.idForShow + '" data-name="' + row.chName + '" onclick="selectDE(this);"/>';
  }
  return html;

}

function selectDE(t) {
  if ($(t).is(':checked')) {
    checkedIds += $(t).attr('data-id') + ",";
    var data = $('#dm3').bootstrapTable('getRowByUniqueId', $(t).val());
    console.log(data);
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
  html += '<button type="button" class="btn btn-white" onclick="detail(\'' + row.idForShow + '\',\'#dm2\')">查看</button>';
  html += '</div>';
  return html;
}

function doFormatter3(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="detail(\'' + row.idForShow + '\',\'#dm3\')">查看</button>';
  html += '</div>';
  return html;
}

</script>
<%@include file="../common/baseSystemJS.jsp"%>
<script type="text/javascript">
function editRow(id) {
  openLayer();

  layer.title('修改', layerIndex);

  var data = $(tableId).bootstrapTable('getRowByUniqueId', id);
  $(formId).form('load', data);
  dataEles = data.dataElementIds;
  checkedIds = "," + data.dataElementIds + ",";
  initDataElements();
  if (oTable2Inited == 0) {
    oTable2 = new TableInit2();
    oTable2.Init();
    oTable2Inited = 1;
  } else {
    $('#dm2').bootstrapTable('refresh');
  }

  //通知chosen下拉框更新
  var cs = $(".chosen-select");
  if (cs.length) {
    for (var i = 0; i < cs.length; i++) {
      if ($(cs[i]).attr('data-bind')) {
        var cid = $(cs[i]).attr('data-bind');
        var p = {};
        p[$(cs[i]).attr("data-param")] = $(cs[i]).val();
        initAjaxChosen(cid, $(cid).attr('data-url'), p, data[$(cid).attr('name')]);
      }

    }
  }
  $(".chosen-select").trigger("chosen:updated");
  $(formId).valid();

}

function detail(id, tableId) {
  var data;
  if (!tableId) {
    for (var j = 0; j < dataEles.length; j++) {
      if (dataEles[j].idForShow == id) {
        data = dataEles[j];
      }
    }
  } else {
    data = $(tableId).bootstrapTable('getRowByUniqueId', id);
  }

  var sp = $('#dataElement-detail span');
  if (sp.length) {
    for (var i = 0; i < sp.length; i++) {
      if ($(sp[i]).attr('name') && $(sp[i]).attr('name') != null) {
        var nm = $(sp[i]).attr('name');
        var value = data[nm];
        $(sp[i]).html(value);
      }
    }
  }
  layer.open({
    type: 1,
    shade: false,
    area: ['400px', '380px'], //宽高
    scrollbar: false,
    title: false, //不显示标题
    content: $('#dataElement-detail')
  });

}

function unCheck(id) {
  var arr = new Array();
  var ck = ",";
  for (var j = 0; j < dataEles.length; j++) {
    if (dataEles[j].idForShow != id) {
      arr.push(dataEles[j]);
      ck += dataEles[j].id + ",";
    }
  }
  $('#dm3 input[value="' + id + '"]').removeAttr("checked");
  checkedIds = ck;
  dataEles = arr;
  initText();

}

//查看的额外处理
function doWithDetail(id, data) {
  if (oTable2Inited == 0) {
    oTable2 = new TableInit2();
    oTable2.Init();
    oTable2Inited = 1;
  } else {
    $('#dm2').bootstrapTable('refresh', { url: '${base}/backstage/dataElement/getDataElementAjax' });
  }
}

</script>
