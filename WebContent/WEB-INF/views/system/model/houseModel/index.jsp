<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
</head>
<body class="gray-bg  skin-<%=ServiceUtil.getThemeType(10)%>">
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
    <input type="hidden" name="id" class="form-control">
    <input type="hidden" name="idForShow" class="form-control">
    <div class="form-group">
      <label class="col-sm-3 control-label">库类：</label>
      <div class="col-sm-7">
        <select name="houseTypes" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
          <option value="1">人口库模型</option>
          <option value="2">法人库模型</option>
          <option value="3">地理库模型</option>
          <option value="4">信用库模型</option>
          <option value="5">证照库模型</option>
        </select>
      </div>
    </div>
    <div class="form-group">
      <label class="col-sm-3 control-label">信息类：</label>
      <div class="col-sm-7">
        <input type="text" name="infoTypes" class="form-control" required>
      </div>
    </div>
    <div class="form-group">
      <label class="col-sm-3 control-label">专项信息名称：</label>
      <div class="col-sm-7">
        <input type="text" name="infoName" class="form-control" required>
      </div>
    </div>
    <div class="form-group">
      <label class="col-sm-3 control-label">信息资源名称：</label>
      <div class="col-sm-7">
        <input type="text" name="informationResId" class="form-control" required>
      </div>
    </div>
    <div class="form-group">
      <label class="col-sm-3 control-label">信息资源代码：</label>
      <div class="col-sm-7">
        <input type="text" name="inforCode" class="form-control" required>
      </div>
    </div>
  </form>
</div>

</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script>
var layerIndex; //layer 窗口对象
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var url = '${base}/backstage/model/houseModel/'; //controller 路径

//bootstrap-table 列数
var columns = [{
  field: 'houseTypes',
  title: '库类'
}, {
  field: 'infoTypes',
  title: '信息类'
}, {
  field: 'infoName',
  title: '专项信息名称'
}, {
  field: 'informationResId',
  title: '信息资源名称'
}, {
  field: 'inforCode',
  title: '信息资源代码'
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
<%@include file="../../common/baseSystemJS.jsp"%>
