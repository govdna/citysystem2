<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseHead.jsp"%>
</head>
<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div class="btn-group hidden-xs" id="toolbar" role="group">
          <div class="text-center">
            <a data-toggle="modal" class="btn btn-primary" onclick="openLayer();" href="#">新增</a>
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
      <div class="form-group">
        <label class="col-sm-3 control-label">dataElementId：</label>
        <div class="col-sm-7">
          <input type="text" name="dataElementId"  class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">dataManagerId：</label>
        <div class="col-sm-7">
          <input type="text" name="dataManagerId"  class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">informationResId：</label>
        <div class="col-sm-7">
          <input type="text" name="informationResId" class="form-control" required>
        </div>
      </div>
    </form>
  </div>

</body>
</html>

<%@include file="../common/includeJS.jsp"%>
<script>
var layerIndex; //layer 窗口对象
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var url = '${base}/backstage/dataList/'; //controller 路径

//bootstrap-table 列数
var columns = [{
  field: 'dataElementId',
  title: 'dataElementId'
}, {
  field: 'dataManagerId',
  title: 'dataManagerId'
}, {
  field: 'informationResId',
  title: 'informationResId'
}, {
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

</script>
<%@include file="../common/baseSystemJS.jsp"%>
