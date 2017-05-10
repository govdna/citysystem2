<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
.dt-span{
padding-top: 7px;
margin-bottom: 0;
text-align: left;
}
.rel {
position: relative;
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
            <c:if test="${item.tp == 1}">
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
          <a href='${base}/backstage/information/res/basis'><span class="label" >返回</span></a>  
          </div>
        </div>
      <table name="dicList" id=""></table>
      </div>
    </div>
  </div>

  <div id="layer_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal eform1" id="eform">
      <input type="hidden" name="id" class="form-control"> 
      <input type="hidden" name="idForShow" class="form-control">
      <input type="hidden" name="dataElementId" />
      <div class="form-group">
        <label class="col-sm-3 control-label">信息资源代码</label>
        <div class="col-sm-8">
          <input type="text" name="inforCode" class="form-control" required disabled="true"　readOnly="true" >
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">信息资源名称</label>
        <div class="col-sm-8">
          <input type="text" name="inforName" class="form-control" required disabled="true"　readOnly="true" >
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">信息资源提供方</label>
        <div class="col-sm-8">
          <select name="value2" class="chosen-select" data-placeholder=" " required disabled="true"　readOnly="true" >
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"ZYTGF\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">信息资源分类</label>
        <div class="col-sm-4">
          <select name="inforTypes" data-placeholder=" "
            data-param="sortId" data-bind="select[name='inforTypes2']"
            class="chosen-select" required   disabled="true"　readOnly="true">
            <option value=""></option>
            <c:forEach var="obj"
              items="<%=ServiceUtil.getService(\"SortManagerService\")
            .find(ServiceUtil.buildBean(\"SortManager@isDeleted=0&level=1\"))%>">
              <option value="${obj.id}">${obj.sortName}</option>
            </c:forEach>
          </select>
        </div>
        <div class="col-sm-4">
          <select name="inforTypes2" data-placeholder=" " data-param="sortId" data-bind="select[name='inforTypes3']"
            data-level="2" data-url="${base}/backstage/sortManager/listAjax?all=y&level=2"
            data-keyField="id" data-valueField="sortName"
            class="chosen-select" required  disabled="true"　readOnly="true">
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label"></label>
        <div class="col-sm-4">
          <select name="inforTypes3" data-placeholder=" " data-param="sortId" data-bind="select[name='inforTypes4']"
            data-level="3" data-url="${base}/backstage/sortManager/listAjax?all=y&level=3"
            data-keyField="id" data-valueField="sortName"
            class="chosen-select" required  disabled="true"　readOnly="true">
          </select>
        </div>
        <div class="col-sm-4">
          <select name="inforTypes4" data-placeholder=" " 
            data-level="4" data-url="${base}/backstage/sortManager/listAjax?all=y&level=4"
            data-keyField="id" data-valueField="sortName"
            class="chosen-select" required  disabled="true"　readOnly="true">
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">关联业务</label>
        <div class="col-sm-8">
          <select name="businessId" class="chosen-select" data-placeholder=" " required disabled="true"　readOnly="true" >
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"InformationBusinessService\").find(ServiceUtil.buildBean(\"InformationBusiness\"))%>">
            <option value="${obj.id}">${obj.busName}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">信息资源摘要</label>
        <div class="col-sm-8">
          <input type="text" name="inforRemark" class="form-control" required disabled="true"　readOnly="true" >
        </div>
      </div>
      <div class="ibox-content" id="dicTree" style="padding-left:0px;padding-right:0px;">
        <div class="btn-group" id="toolbar" role="group" style="margin-bottom:15px;">
        </div>
        <table id="dm2"></table>
      </div>
    </form>
  </div>

  <div id="dataElement-detail" class="form-horizontal" style="overflow: hidden;display:none;">
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

<%@include file="../../common/includeJS.jsp"%>
<script>
//$("#toolbar").on("click",'#deper',function(){ 
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



var layerContent = '#layer_form'; // layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var url = '${base}/backstage/information/res/'; //controller 路径
var dicLayerIndex;
var checkedIds = ",";
var checkedEles;
var dataEles; //存放选中的数据元
var inforTypes2;
var inforTypes3;
var inforProvider;
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

function addNew() {
  checkedIds = ",";
  $('#dm2').bootstrapTable('load', { rows: [] });
  openLayer();
  initDataElements();
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
//  field: 'inforCode',
//  title: '信息资源代码'
//}, {
  field: 'inforName',
  title: '信息资源名称',
  formatter: 'longFormatter',
}, {
  field: 'value2ForShow',
  title: '信息资源提供方'
}, {
  field: 'id',
  title: '操作',
  formatter: 'doFormatter5', //对本列数据做格式化
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
    rows: params.limit,
    page: params.offset / params.limit + 1,
    inforTypes2: inforTypes2,
    inforTypes3: inforTypes3,
    value2:inforProvider
  };
  return temp;
};

var queryParams2 = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    id: $('input[name="id"]').val()
  };
  return temp;
};

$(function() {

  //1.初始化Table
  oTable2 = new TableInit2();
  oTable2.Init();
  //获取所有数据元
  //initDataElements();

});

var TableInit2 = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $('#dm2').bootstrapTable({
      url: '${base}/backstage/dataElement/dmAjax', //请求后台的URL（*）
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

        field: 'egName',
        title: '英文名称'
      }, {
        field: 'id',
        title: '操作',
        formatter: 'doFormatter2', //对本列数据做格式化    
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

function doFormatter5(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="editRowr(\'' + row.idForShow + '\')"><i class="fa fa-pencil"></i>&nbsp;查看信息项</button>';
  html += '</div>';
  return html;
}

function doFormatter2(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="detail(\'' + row.idForShow + '\',\'#dm2\')">查看</button>';
  html += '</div>';
  return html;
}

function openLayer1() {
  $(formId).form('clear');
  initChosen();
  $(formId).valid();
  layerIndex = layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '新增',
    scrollbar: false,
    btn: ['关闭'],
    yes: function(index, layero) {
      layer.close(index);
    },
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
  });
}

function editRowr(id) {
  var data = $(tableId).bootstrapTable('getRowByUniqueId', id);
  $(formId).form('load', data);
  checkedIds = "," + data.dataElementId + ",";
  initDataElements();
  $('#dm2').bootstrapTable('refresh');
  //通知chosen下拉框更新
  datailRow(id);
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

</script>
<%@include file="../../common/baseSystemJS.jsp"%>

