<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
<style type="text/css">
.c-list{
cursor: auto !important;
}
.c-list li{
cursor: pointer !important;
}

.c-list li.search-choice{
padding: 3px 5px 3px 5px !important;

}
.data-info{
display:none;
}
.info-label{
cursor: pointer;
}
#tagTop {
	    width: 95%;
    margin: 0 auto;
}
#tagTop span{
	    display: inline-block;
    padding: 10px 20px;
    background: #fff;
    cursor: pointer;
}
#tagTop .red{
     background: #3389D4;
  border-color: #3389D4;
  color: #fff;
  cursor: default;
  margin: -1px 0;
  padding: 10px 20px;


}
</style>
</head>
<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content ibox-content-change">
      <div class="btn-group hidden-xs" id="toolbar" role="group"  style="display: block;">
         <div id="tagTop">
         <c:forEach items = "${uson}" var="sort" varStatus="i">  	
        	<span <c:if test="${i.count==1}">class="red"</c:if>>${sort.name}</span>   
        </c:forEach>
        </div>
        <div id = "tagList" >
        <c:forEach items = "${uson}" var="sort" varStatus="i">  
          	<ul id="deper" class="clearfix" <c:if test="${i.count!=1}">style="display: none;"</c:if>>
            <c:forEach items="${sort.children}" var="item" varStatus="i">
            <c:if test="${item.tp == 2}"> 
            <blockquote class="col-sm-12">            	
	            <span class="name label label-success fir" value="${item.id}" dt="${item.tp}" title="${item.name}">           
	            ${item.name}
	            <c:if test="${item.count > 0}">
	            	<i>${item.count}</i>
	            </c:if>
	            </span>	           
            </blockquote>
            </c:if>
            <c:if test="${item.tp == 3}"> 
            <li class="col-sm-4">            	
	            <span class="name label label-success fir" value="${item.id}" dt="${item.tp}" title="${item.name}">           
	            ${item.name}
	            <c:if test="${item.count > 0}">
	            	<i>${item.count}</i>
	            </c:if>
	            </span>	           
            </li>
            </c:if>
            </c:forEach>
          </ul>
          </c:forEach>
          </div>
          <div id="deperreturn" class="text-center" style="display: none;">
          </div>
      </div>
      <table name="dicList" id=""></table>
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
                <input type="text" placeholder="输入名称" name="keyword" class="form-control"> 
                <span class="input-group-btn"> 
                <button type="button" onclick=" $('#dm3').bootstrapTable('refresh');" class="btn btn-primary">搜索
                </button> 
                </span>
              </div>
            </div>
          </div>
          <table id="dm3"></table>
        </div>
      </div>
    </div>
  </div>

  <!-- 选取模版开始 -->
  <div id="choose-infor-res" style="overflow: hidden;display:none;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <table id="resList"></table>
      </div>
    </div>
  </div>
  <!-- 选取模版结束 -->

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


  <!--信息资源模版详情开始-->
  <div id="informationRes-detail" class="form-horizontal"
    style="overflow: hidden; display: none;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
      <span  class="dt-span" name="detail_id" style="display:none;"></span>
        <div class="form-group">
          <label class="col-sm-3 control-label">信息资源代码</label> <span
            class="col-sm-7 dt-span" name="inforCode"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">信息资源名称</label> <span
            class="col-sm-7 dt-span" name="inforName"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">信息资源提供方</label> <span
            class="col-sm-7 dt-span" name="inforProviderForShow"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">信息资源分类</label> <span
            class="col-sm-7 dt-span" name="inforTypesName"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">关联业务</label> <span
            class="col-sm-7 dt-span" name="businessIdForShow"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">信息资源摘要</label> <span
            class="col-sm-7 dt-span" name="inforRemark"></span>
        </div>
        <div class="ibox-content" 
          style="padding-left: 0px; padding-right: 0px;">
          <table data-url="${base}/backstage/dataElement/getDataElementByIRId" data-queryParams="detailQueryParams" data-columns="dataElementColumns" ></table>
        </div>
      </div>
    </div>
  </div>
  <!--信息资源模版详情结束-->
  
  <!--提示未导入的数据元开始-->
  <div id="notAddedDataElement" class="form-horizontal"
    style="overflow: hidden; display: none;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div class="alert alert-danger">
          下列数据元无法导入，如需下列数据元，请先导入，待审核通过后即可使用！   
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
</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script>

$(".fir").click(function() {
  inforTypes2 = $(this).attr('value');
})
$(".sed").click(function() {
  inforTypes3 = $(this).attr('value');
})
$("#deper span").click(function() {
  $("table[name='dicList']").attr("id", "dicList");
  oTable = new TableInit();
  oTable.Init();
  $("table[name='dicList']").bootstrapTable('refresh');
  $("#deperreturn").show();
  $("#tagList ul").hide();
  $("#tagTop span").hide();
})

$("#tagTop span").click(function() {
		$("#tagTop span").removeClass('red');
		$(this).addClass('red');    // 应用样式以突出
        n = $(this).index();
        $("#tagList ul").hide();
        $("#tagList ul").eq(n).show();
    });

var inforTypes2 = "";
var inforTypes3 = "";
var dicLayerContent = '#dic_form';
var layerIndex; //layer 窗口对象
var inforResLayerIndex; //选择模版弹窗
var layerContent = '#layer_form'; // layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var url = '${base}/backstage/information/resource/'; //controller 路径

var dicLayerIndex;
var checkedIds = ",";
var checkedEles;
var dataEles; //存放选中的数据元
var infoLayer;
$(".label-success").click(function() {
	  var dt = $(this).attr("dt");
	  var val = $(this).attr("value");
	  inforTypes2 = "";
	  inforTypes3 = "";
	  inforProvider = "";
	  if (dt == "2") {
	    inforTypes2 = val;
	  } else if(dt == "1"){
		  inforProvider = val;
	  } else if(dt == "3"){
		  inforTypes3 = val;
	  }
	  oTable2 = new TableInit();
	  oTable2.Init();
	  $('#dicList').bootstrapTable('refresh');
	});
function showInfo(id) {
  layer.close(infoLayer);
  infoLayer = layer.tips($('.data-info[data-id="' + id + '"]').html(), 'label[data-id="data' + id + '"]', {
    tips: [1, '#999'],
    time: 10000
  });
}


//选择模版弹窗
function chooseInforRes() {
  inforResLayerIndex = layer.open({
    type: 1,
    area: ['70%', '80%'], //宽高
    title: '选择模版',
    scrollbar: false,
    offset: '20px',
    content: $('#choose-infor-res')
      //这里content是一个DOM
  });
}

function addNew() {
  checkedIds = ",";
  $('#dm2').bootstrapTable('load', {
    rows: []
  });
  openLayer();
  initDataElements();
}

function getNowFormatDate() {
  var date = new Date();
  var seperator1 = "-";
  var seperator2 = ":";
  var year = date.getFullYear();
  var month = date.getMonth() + 1;
  var strDate = date.getDate();
  if (month >= 1 && month <= 9) {
    month = "0" + month;
  }
  if (strDate >= 0 && strDate <= 9) {
    strDate = "0" + strDate;
  }
  var currentdate = year + seperator1 + month + seperator1 + strDate;
  return currentdate;
}
//或许所有数据元
function initDataElements() {
  jQuery.get("${base}/backstage/dataElement/listAjax?all=y", function(r) {
    dataEles = r;
    initText();
  }, "json");
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
      html += '<li class="search-choice" onclick="detail(\'' + checkedEles[k].idForShow + '\');"><span>' + checkedEles[k].chName + '</span></li>';
    }
    $('.c-list').html(html);
  } else {
    $('.c-list').html('');
  }

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
  field: 'status',
  title: '状态',
  formatter: 'statusFormatter', //对本列数据做格式化
}, {
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

//得到查询的参数
var queryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows : params.limit,
    page : params.offset / params.limit + 1,
    inforTypes2:inforTypes2,
    inforTypes3:inforTypes3,
    status:0,
    <c:set var="roleid"   value="<%=AccountShiroUtil.getCurrentUser().getRoleId() %>"/>
        <c:if test="${roleid!=1}">
         companyId : <%=AccountShiroUtil.getCurrentUser().getCompanyId() %>
        </c:if>
  };
  return temp;
};

var queryParams2 = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    dataManagerId : $('input[name="id"]').val()

  };
  return temp;
};

var detailQueryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    dataManagerId : $('span[name="detail_id"]').html(),
    status : 0
  };
  return temp;
};

var queryParams3 = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows : params.limit,
    page : params.offset / params.limit + 1,
    objectType : $('select[name="dxl-select"]').val(),
    status : 0,
    chName : $('input[name="keyword"]').val()
  };
  return temp;
};

  $(function() {

  //1.初始化Table
  oTable2 = new TableInit2();
  oTable2.Init();
  oTable3 = new TableInit3();
  oTable3.Init();
  //获取所有数据元
  //initDataElements();
  var resList = new ResList();
  resList.Init();
});

var ResList = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $('#resList').bootstrapTable({
      url: '${base}/backstage/information/res/listAjax', //请求后台的URL（*）
      method: 'post', //请求方式（*）
      contentType: "application/x-www-form-urlencoded",
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
      queryParamsType: "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
      columns: [{
        field: 'inforCode',
        title: '信息资源代码'
      }, {
        field: 'inforName',
        title: '信息资源名称'
      }, {
        field: 'id',
        title: '操作',
        formatter: 'resListFormatter', //对本列数据做格式化
      }]
    });
  };
  return oTableInit;
};

function resListFormatter(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="detail(\'' + row.idForShow + '\',\'#resList\',\'#informationRes-detail\',1)">查看</button>';
  html += '<button type="button" class="btn btn-white" onclick="chooseIRYes(\'' + row.idForShow + '\')">选择</button>';
  html += '</div>';
  return html;
}

function statusFormatter(value, row, index) {
  var st = ['已发布', '待审核', '审核不通过', '已撤回', '注销待审核', '已注销']
  return st[value];


}
//选择模版确认选择事件处理
function chooseIRYes(id) {
  var data = $('#resList').bootstrapTable('getRowByUniqueId', id);
  layer.close(inforResLayerIndex);
  checkedIds = ",";
  $('#dm2').bootstrapTable('load', {
    rows: []
  });
  openLayer();
  $(formId).form('clear');

  checkedIds = "," + data.dataElementId + ",";
  $('input[name="value14"]').val(getNowFormatDate());
  initDataElements();
  $(formId + ' input[name="dataElementId"]').val(checkedIds);
  $(formId + ' input[name="value1"]').val(data.inforName);
  $(formId + ' input[name="value5"]').val(data.inforRemark);
  jQuery
    .get(
      "${base}/backstage/dataElement/getDataElementByInforResId", {
        inforResId: data.id
      },
      function(r) {
        var arr = new Array();
        var html = '';
        r = r.rows;
        for (var i = 0; i < r.length; i++) {
          if (r[i].status == 0) {
            arr.push(r[i]);
          } else {
            html += '<tr><td>' + r[i].identifier + '</td><td>' + r[i].chName + '</td><td><span class="label label-warning">' + r[i].statusForShow + '</span></td></tr>';
          }
        }
        //未导入数据元处理
        if (html != '') {
          layer.open({
            type: 1,
            skin: 'layui-layer-molv',
            shade: false,

            scrollbar: false,
            title: '提示', //不显示标题
            content: $('#notAddedDataElement')
          });
          $('#notAddedDataElement tbody').html(html);

        }
        $('#dm2').bootstrapTable('load', {
          rows: arr
        });
      }, "json");

  $(formId).valid();
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

var dataElementColumns = [{
  field: 'identifier',
  title: '内部资源标识符'
}, {

  field: 'chName',
  title: '中文名称'
}, {
  field: 'statusForShow',
  title: '状态'
}, {
  field: 'id',
  title: '操作',
  formatter: 'doFormatter2', //对本列数据做格式化    
}];

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
  field: 'id',
  title: '操作',
  formatter: 'doFormatter2', //对本列数据做格式化    
}];

function openDicLayer() {
  $('#dm3').bootstrapTable('refresh');
  dicLayerIndex = layer.open({
    type: 1,
    area: ['70%', '80%'], //宽高
    title: '选择信息项',
    scrollbar: false,
    btn: ['保存', '关闭'],
    yes: function(index, layero) {
      $('#dm2').bootstrapTable('load', {
        rows: checkedEles
      });
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
      url: '${base}/backstage/dataElement/listAjax', //请求后台的URL（*）
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

        field: 'egName',
        title: '英文名称'
      }, {
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
    html += '<input type="checkbox" value="' + value + '" data-name="' + row.chName + '" onclick="selectDE(this);" checked="checked"/>';
  } else {
    html += '<input type="checkbox" value="' + value + '" data-name="' + row.chName + '" onclick="selectDE(this);"/>';
  }
  return html;
}

function selectDE(t) {
  if ($(t).is(':checked')) {
    checkedIds += $(t).val() + ",";
  } else {
    checkedIds = checkedIds.replace("," + $(t).val() + ",", ",");
  }
  initText();
}

function doFormatter2(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="detail(\'' + row.idForShow + '\',\'#dm2\',\'\')">查看</button>';
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
<%@include file="../../common/baseSystemJS.jsp"%>
<script type="text/javascript">

  function doFormatter(value, row, index) {
    var html = '';
    html += '<div class="btn-group">';
    html += '<button type="button" class="btn btn-white" onclick="datailRow(\'' + row.idForShow + '\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
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
      $('#status_div').html('');
      $(layerContent + ' .dt-span').remove();
      $(layerContent + ' .div_hidden').removeClass('div_hidden');
    },
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
  });
}

function updateStatusRow(id, iszx) {
  openStatusLayer(iszx);
  datailRow(id, 1);
}

function openStatusLayer(iszx) {
  $(formId).form('clear');
  initChosen();
  $(formId).valid();
  layerIndex = layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '详情',
    scrollbar: false,
    btn: ['审核通过', '审核不通过'],
    yes: function(index, layero) {
      if (iszx) {
        updateStatus(5, '');
      } else {
        updateStatus(0, '');
      }

    },
    btn2: function(index, layero) {
      var ii = layer.prompt({ title: '审核不通过理由', formType: 2 }, function(text, index) {
        layer.close(index);
        if (iszx) {
          updateStatus(0, '');
        } else {
          updateStatus(2, text);
        }

      });
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

function backRow(id, status, title) {
  if (typeof(status) == "undefined") {
    status = 3;
  }
  if (typeof(title) == "undefined") {
    title = '您确定要撤回提交的操作么？';
  }
  layer.confirm(title, {
    btn: ['确定', '取消'] //按钮
  }, function() {
    $.post(url + 'updateStatus', { idForShow: id, status: status }, function(r) {
      var result = eval('(' + r + ')');
      if (result.code && result.code == 1) {
        layer.close(layerIndex);
        $(tableId).bootstrapTable('refresh');
      }
      layer.msg(result.msg);
    });
  }, function() {

  });

}

function updateStatus(st, text) {
  $.post(url + 'updateStatus', { idForShow: $('input[name="idForShow"]').val(), status: st, reason: text }, function(r) {
    var result = eval('(' + r + ')');
    if (result.code && result.code == 1) {
      layer.close(layerIndex);
      $(tableId).bootstrapTable('refresh');
    }
    layer.msg(result.msg);
  });
}

function editRow(id) {
  openLayer();
  layer.title('修改', layerIndex);
  var data = $(tableId).bootstrapTable('getRowByUniqueId', id);
  if (data.status == 2) {
    $('#status_div').html('<div class="alert alert-danger" >审核不通过：' + data.reason + '</div>');
  } else {
    $('#status_div').html('');
  }
  $(formId).form('load', data);


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



  checkedIds = "," + data.dataElementId + ",";
  initDataElements();
  $('#dm2').bootstrapTable('refresh', { url: '${base}/backstage/dataElement/getDataElementByIRId' });
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

//查看方法 参数（当前行的id,TableId,div,弹窗类型，默认小窗口）
function detail(id, tableId, divId, windowType) {
  if (divId && divId != '') {

  } else {
    divId = '#dataElement-detail';
  }
  var data;
  console.log(tableId);
  if (tableId && tableId != '') {
    data = $(tableId).bootstrapTable('getRowByUniqueId', id);
  } else {
    for (var j = 0; j < dataEles.length; j++) {
      if (dataEles[j].idForShow == id) {
        data = dataEles[j];
      }
    }
  }
  //console.log(data);
  var sp = $(divId + ' span');
  if (sp.length) {
    for (var i = 0; i < sp.length; i++) {
      if ($(sp[i]).attr('name') && $(sp[i]).attr('name') != null) {
        var nm = $(sp[i]).attr('name');
        if (data[nm] && data[nm] != null) {
          $(sp[i]).html(data[nm]);
        }

      }
    }
  }
  var tables = $(divId + ' table');
  if (tables.length) {
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
	        content: base+'/backstage/dataElement/detail?idForShow='+id
	      }); 
  }


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

$('select[name="value8"]').on('change', function(e, params) {
  var val = $(this).val();
  if (val == 2) {
    $('select[name="value9"]').parents('div .form-group').show();
  } else {
    $('select[name="value9"]').parents('div .form-group').hide();
  }
});

$('select[name="value11"]').on('change', function(e, params) {
  var val = $(this).val();
  if (val == 1) {
    $('input[name="value12"]').parents('div .form-group').show();
  } else {
    $('input[name="value12"]').parents('div .form-group').hide();
  }
});

</script>
