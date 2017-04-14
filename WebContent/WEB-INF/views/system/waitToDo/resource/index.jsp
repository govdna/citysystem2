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
</style>
</head>
<body class="white-bg">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline">
            <div class="form-group">
              <input type="text" placeholder="输入信息资源名称" name="val1" class="form-control col-sm-8">
              <div class="input-group-btn col-sm-4">
                <button type="button" onclick=" $('#dicList').bootstrapTable('refresh');" class="btn btn-primary">搜索
                </button>
              </div>
            </div>
          </div>
        </div>
        <table id="dicList">
        </table>
      </div>
    </div>
  </div>

  <div id="layer_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal eform1" id="eform">
      <input type="hidden" name="id" class="form-control"> <input
        type="hidden" name="idForShow" class="form-control">
      <input type="hidden" name="dataElementId" />
      <div id="status_div"></div>
      <div class="form-group">
        <label class="col-sm-3 control-label">信息资源分类</label>
        <div class="col-sm-4">
          <select name="inforTypes" data-placeholder=" "
            data-param="sortId" data-bind="select[name='inforTypes2']"
            class="chosen-select" required>
            <option value=""></option>
            <c:forEach var="obj"
              items="<%=ServiceUtil.getService(\"SortManagerService\")
            .find(ServiceUtil.buildBean(\"SortManager@isDeleted=0&level=1&belong=2\"))%>">
            <option value="${obj.id}">${obj.sortName}</option>
            </c:forEach>
          </select>
        </div>
        <div class="col-sm-4">
          <select name="inforTypes2" data-placeholder=" " data-param="sortId" data-bind="select[name='inforTypes3']"
            data-level="2" data-url="${base}/backstage/sortManager/listAjax?all=y&level=2&belong=2"
            data-keyField="id" data-valueField="sortName"
            class="chosen-select" required>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label"></label>
        <div class="col-sm-4">
          <select name="inforTypes3" data-placeholder=" " data-param="sortId" data-bind="select[name='inforTypes4']"
            data-level="3" data-url="${base}/backstage/sortManager/listAjax?all=y&level=3&belong=2"
            data-keyField="id" data-valueField="sortName"
            class="chosen-select" >
          </select>
        </div>
        <div class="col-sm-4">
          <select name="inforTypes4" data-placeholder=" " 
            data-level="4" data-url="${base}/backstage/sortManager/listAjax?all=y&level=4&belong=2"
            data-keyField="id" data-valueField="sortName"
            class="chosen-select">
          </select>
        </div>
      </div>
      <c:forEach var="obj" items="<%=ServiceUtil.getService(\"DataManagerService\").find(ServiceUtil.buildBean(\"DataManager@isDeleted=0\"),\"list_no\",\"asc\")%>">
        <div class="data-info" data-id="${obj.id}">
          定义：${obj.define}<br />

          数据类型：${MyFunction:getDicValue("DATATYPE",obj.dataType)}<br />
          值域：${obj.ranges}<br />
          短名：${obj.shortName}<br />
          注解：${obj.note}<br />
          取值示例：${obj.valueCase}<br />
        </div>   
        <div class="form-group">
          <label class="col-sm-3 control-label info-label" onmouseout="layer.close(infoLayer);" onmouseover="showInfo(${obj.id});" data-id="data${obj.id}">${obj.dataName}：</label>
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
              <c:otherwise>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </c:forEach>
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
                </button> </span>
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
  <div id="informationRes-detail" class="form-horizontal" style="overflow: hidden; display: none;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <span class="dt-span" name="detail_id" style="display:none;"></span>
        <div class="form-group">
          <label class="col-sm-3 control-label">信息资源代码</label> <span class="col-sm-7 dt-span" name="inforCode"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">信息资源名称</label> <span class="col-sm-7 dt-span" name="inforName"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">信息资源提供方</label> <span class="col-sm-7 dt-span" name="inforProviderForShow"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">信息资源分类</label> <span class="col-sm-7 dt-span" name="inforTypesName"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">关联业务</label> <span class="col-sm-7 dt-span" name="businessIdForShow"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">信息资源摘要</label> <span class="col-sm-7 dt-span" name="inforRemark"></span>
        </div>
        <div class="ibox-content" style="padding-left: 0px; padding-right: 0px;">
          <table data-url="${base}/backstage/dataElement/getDataElementByIRId" data-queryParams="detailQueryParams" data-columns="dataElementColumns"></table>
        </div>
      </div>
    </div>
  </div>

  <!--信息资源模版详情结束-->
  
  <!--提示未导入的数据元开始-->
  <div id="notAddedDataElement" class="form-horizontal" style="overflow: hidden; display: none;">
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
   title: '信息资源代码',
   sortable:true
 }, {
   field: 'value1',
   title: '信息资源名称',
   formatter: 'longFormatter',
   sortable:true
 }, {
   field: 'status',
   title: '状态',
   formatter: 'statusFormatter', //对本列数据做格式化
   sortable:true
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
     rows: params.limit,
     page: params.offset / params.limit + 1,
     sort:params.sort,
     order:params.order,
     value1: $('input[name="val1"]').val(),
   };
   return temp;
 };

 var queryParams2 = function(params) {

   var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
     dataManagerId: $('input[name="id"]').val()
   };
   return temp;
 };

 var detailQueryParams = function(params) {

   var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
     dataManagerId: $('span[name="detail_id"]').html(),
     status: 0
   };
   return temp;
 };

  var queryParams3 = function(params) {

    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1,
      objectType : $('select[name="dxl-select"]').val(),
      status : 0,
      chName : $('input[name="keyword"]').val(),
      <c:if test="${MyFunction:getMaxScope(\"/backstage/resource/waitToDo/index\")==1}" >
    companyId:<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>,
  </c:if>
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
        url : '${base}/backstage/information/res/listAjax', //请求后台的URL（*）
        method : 'post', //请求方式（*）
        contentType : "application/x-www-form-urlencoded",
        iconSize : 'outline',
        striped : true, //是否显示行间隔色
        cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        pagination : true, //是否显示分页（*）
        sortable : false, //是否启用排序
        sortOrder : "asc", //排序方式
        queryParams : queryParams,//传递参数（*）
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
          field : 'inforCode',
          title : '信息资源代码'
        }, {
          field : 'inforName',
          title : '信息资源名称'
        }, {
          field : 'id',
          title : '操作',
          formatter : 'resListFormatter',//对本列数据做格式化
        } ]
      });
    };
    return oTableInit;
  };

  function resListFormatter(value, row, index) {
    var html = '';
    html += '<div class="btn-group">';
    html += '<button type="button" class="btn btn-white" onclick="detail(\''
        + row.idForShow
        + '\',\'#resList\',\'#informationRes-detail\',1)">查看</button>';
    html += '<button type="button" class="btn btn-white" onclick="chooseIRYes(\''
        + row.idForShow + '\')">选择</button>';
    html += '</div>';
    return html;
  }

  function statusFormatter(value, row, index) {
    var st=['已发布','待审核','审核不通过','已撤回','注销待审核','已注销']
    return st[value];
  }
  //选择模版确认选择事件处理
  function chooseIRYes(id) {
    var data = $('#resList').bootstrapTable('getRowByUniqueId', id);
    layer.close(inforResLayerIndex);
    checkedIds = ",";
    $('#dm2').bootstrapTable('load', {
      rows : []
    });
    openLayer();
    $(formId).form('clear');
    checkedIds = "," + data.dataElementId + ",";

    initDataElements();
    $(formId + ' input[name="dataElementId"]').val(checkedIds);
    $(formId + ' input[name="value1"]').val(data.inforName);
    $(formId + ' input[name="value5"]').val(data.inforRemark);
    jQuery
        .get(
            "${base}/backstage/dataElement/getDataElementByInforResId",
            {
              inforResId : data.id
            },
            function(r) {
              var arr = new Array();
              var html = '';
              r = r.rows;
              for (var i = 0; i < r.length; i++) {
                if (r[i].status == 0) {
                  arr.push(r[i]);
                } else {
                  html += '<tr><td>'
                      + r[i].identifier
                      + '</td><td>'
                      + r[i].chName
                      + '</td><td><span class="label label-warning">'
                      + r[i].statusForShow
                      + '</span></td></tr>';
                }
              }
              //未导入数据元处理
              if (html != '') {
                layer.open({
                  type : 1,
                  skin: 'layui-layer-molv',
                  shade : false,
                  
                  scrollbar : false,
                  title : '提示', //不显示标题
                  content : $('#notAddedDataElement')
                });
                $('#notAddedDataElement tbody').html(html);

              }
              $('#dm2').bootstrapTable('load', {
                rows : arr
              });
            }, "json");

    $(formId).valid();
  }

  var TableInit2 = function() {
    var oTableInit = new Object();
    //初始化Table
    oTableInit.Init = function() {
      $('#dm2').bootstrapTable({
        url : '${base}/backstage/dataElement/getDataElementByIRId', //请求后台的URL（*）
        method : 'post', //请求方式（*）
        contentType : "application/x-www-form-urlencoded",
        iconSize : 'outline',
        striped : true, //是否显示行间隔色
        cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        pagination : false, //是否显示分页（*）
        sortable : false, //是否启用排序
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
        columns : dataElementColumns2
      });
    };
    return oTableInit;
  };

  var dataElementColumns = [ {
    field : 'identifier',
    title : '内部资源标识符'
  }, {

    field : 'chName',
    title : '中文名称'
  }, {

    field : 'egName',
    title : '英文名称'
  }, {
    field : 'statusForShow',
    title : '状态'
  }, {
    field : 'id',
    title : '操作',
    formatter : 'doFormatter2',//对本列数据做格式化    
  } ];

  var dataElementColumns2 = [ {
    field : 'identifier',
    title : '内部资源标识符'
  }, {

    field : 'chName',
    title : '中文名称'
  }, {

    field : 'egName',
    title : '英文名称'
  },  {
    field : 'id',
    title : '操作',
    formatter : 'doFormatter2',//对本列数据做格式化    
  } ];

  function openDicLayer() {
    $('#dm3').bootstrapTable('refresh');
    dicLayerIndex = layer.open({
      type : 1,
      area : [ '70%', '80%' ], //宽高
      title : '选择信息项',
      scrollbar : false,
      btn : [ '保存', '关闭' ],
      yes : function(index, layero) {
        $('#dm2').bootstrapTable('load', {
          rows : checkedEles
        });
        $('input[name="dataElementId"]').val(checkedIds);
        layer.close(dicLayerIndex);
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
        columns : [ {
          field : 'id',
          title : '添加',
          formatter : 'checkFormatter'
        }, {
          field : 'identifier',
          title : '内部资源标识符'
        }, {

          field : 'chName',
          title : '中文名称'
        }, {

          field : 'egName',
          title : '英文名称'
        },  {
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
      html += '<input type="checkbox" value="' + value + '" data-name="'
          + row.chName
          + '" onclick="selectDE(this);" checked="checked"/>';
    } else {
      html += '<input type="checkbox" value="' + value + '" data-name="'
          + row.chName + '" onclick="selectDE(this);"/>';
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
    html += '<button type="button" class="btn btn-white" onclick="detail(\''
        + row.idForShow + '\',\'#dm2\',\'\')">查看</button>';
    html += '</div>';
    return html;
  }

  function doFormatter3(value, row, index) {
    var html = '';
    html += '<div class="btn-group">';
    html += '<button type="button" class="btn btn-white" onclick="detail(\''
        + row.idForShow + '\',\'#dm3\')">查看</button>';
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
  html+='</div>';
  return html;
}

function openDetailLayer(){
  $(formId).form('clear');
  initChosen();
  $(formId).valid();
  layerIndex=layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '详情',
    scrollbar: false,
    cancel:function(index, layero){
      $('#status_div').html('');
      $(layerContent+' .dt-span').remove();
      $(layerContent+' .div_hidden').removeClass('div_hidden');
    },
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
  });
}
  
function updateStatusRow(id){
  openStatusLayer();
  datailRow(id,1);
}

function openStatusLayer(){
  $(formId).form('clear');
  initChosen();
  $(formId).valid();
  layerIndex=layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '详情',
    scrollbar: false,
    btn: ['审核通过','审核不通过'], 
    yes:function(index, layero){
      updateStatus(0,'');
    },
    btn2:function(index, layero){
      var ii=layer.prompt({title: '审核不通过理由', formType: 2}, function(text, index){
          layer.close(index);
          updateStatus(2,text);
      });
    },
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
  });
}

function openLayer(){
  $(formId).form('clear');
  initChosen();
  $(formId).valid();
  layerIndex=layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '新增',
    scrollbar: false,
    btn: ['保存','关闭'], 
    yes: function(index, layero){
      $(formId).submit();
    },
    cancel:function(index, layero){
      $('#status_div').html('');
      $(layerContent+' .dt-span').remove();
      $(layerContent+' .div_hidden').removeClass('div_hidden');
    },
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
  });
}

function backRow(id){
  layer.confirm('您确定要撤回么？', {
      btn: ['确定','取消'] //按钮
    }, function(){
      $.post(url+'updateStatus',{idForShow:id,status:3},function(r){
        var result = eval('('+r+')');
          if(result.code && result.code==1){
            layer.close(layerIndex);
             $(tableId).bootstrapTable('refresh');
          }
          layer.msg(result.msg);
      });
    }, function(){
        
    });
}

function updateStatus(st,text){
  $.post(url+'updateStatus',{idForShow:$('input[name="idForShow"]').val(),status:st,reason:text},function(r){
    var result = eval('('+r+')');
      if(result.code && result.code==1){
        layer.close(layerIndex);
         $(tableId).bootstrapTable('refresh');
      }
      layer.msg(result.msg);
  });
} 

function editRow(id){
  openLayer();
  layer.title('修改', layerIndex);
  var data=$(tableId).bootstrapTable('getRowByUniqueId', id);
  if(data.status==2){
     $('#status_div').html('<div class="alert alert-danger" >审核不通过：'+data.reason+'</div>');
   }else{
     $('#status_div').html('');
   }
  $(formId).form('load',data);
  checkedIds=","+data.dataElementId+",";
  initDataElements();
   $('#dm2').bootstrapTable('refresh',{url:'${base}/backstage/dataElement/getDataElementByIRId'});
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

//查看的额外处理
function doWithDetail(id,data){
   $('#dm2').bootstrapTable('refresh',{url:'${base}/backstage/dataElement/getDataElementByIRId'});
   if(data.status==2){
     $('#status_div').html('<div class="alert alert-danger" >审核不通过：'+data.reason+'</div>');
   }else{
     $('#status_div').html('');
   }
}

//查看方法 参数（当前行的id,TableId,div,弹窗类型，默认小窗口）
function detail(id,tableId,divId,windowType){
  if(divId&&divId!=''){
    
  }else{
    divId='#dataElement-detail';
  }
  var data;
  console.log(tableId);
  if(tableId&&tableId!=''){
    data=$(tableId).bootstrapTable('getRowByUniqueId', id);
  }else{
    for(var j=0;j<dataEles.length;j++){
      if(dataEles[j].idForShow==id){
        data=dataEles[j];
      }
    }
  }
  //console.log(data);
  var sp=$(divId+' span');
  if(sp.length){
    for(var i=0;i<sp.length;i++){
      if($(sp[i]).attr('name')&&$(sp[i]).attr('name')!=null){
        var nm=$(sp[i]).attr('name');
        if(data[nm]&&data[nm] != null){
          $(sp[i]).html(data[nm]);
        }
        
      }
    }
  }
  var tables=$(divId+' table');
  if(tables.length){
    for(var i=0;i<tables.length;i++){
      if($(tables[i]).attr('data-url')){   
        initTable(tables[i],$(tables[i]).attr('data-url'), eval($(tables[i]).attr('data-queryParams')),eval($(tables[i]).attr('data-columns')));
      }
    }
  }
  if(windowType){
    layer.open({
    type : 1,
    area : [ '70%', '80%' ], //宽高
    title : '查看',
    scrollbar : false,
    offset : '20px',
    content : $(divId)
    });
  }else{
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

function initTable(tableId,url,queryParams,columns){
  $(tableId).bootstrapTable('destroy');
  $(tableId).bootstrapTable({
    url : url, //请求后台的URL（*）
    method : 'post', //请求方式（*）
    contentType : "application/x-www-form-urlencoded",
    iconSize : 'outline',
    striped : true, //是否显示行间隔色
    cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
    pagination : false, //是否显示分页（*）
    sortable : false, //是否启用排序
    sortOrder : "asc", //排序方式
    queryParams : queryParams,//传递参数（*）
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
    columns :columns
  });
}

</script>
