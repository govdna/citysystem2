<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
<link href="${base}/static/plugins/jqgrid/ui.jqgrid.css" rel="stylesheet">
</head>
<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline">
            <div class="form-group">
              <input type="text" placeholder="输入名称" name="apiName" class="form-control col-sm-8">
              <div class="input-group-btn col-sm-4">
                <button type="button" onclick=" $('#dicList').bootstrapTable('refresh');" class="btn btn-primary">搜索
                </button>
              </div>
            </div>
            <div class="form-group" style="margin-left: 15px;">
              <div class="text-center">
                <a data-toggle="modal" class="btn btn-primary" onclick="addNew();" href="#">新增</a>
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
    <form method="post" class="form-horizontal" id="eform">
      <input type="hidden" name="id" class="form-control"> 
      <input type="hidden" name="idForShow" class="form-control">
       <div class="form-group">
        <label class="col-sm-4 control-label">名称：</label>
        <div class="col-sm-7">
          <input type="text" name="name" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">改动通知接口url：</label>
        <div class="col-sm-7">
          <input type="text" name="listenerUrl" class="form-control" required>
        </div>
      </div>
       <div class="form-group">
        <label class="col-sm-4 control-label">appKey：</label>
        <div class="col-sm-7">
          <input type="text" name="appKey" class="form-control" readonly>
        </div>
      </div>
       <div class="form-group">
        <label class="col-sm-4 control-label">secret：</label>
        <div class="col-sm-7">
          <input type="text" name="secret" class="form-control" readonly>
        </div>
      </div>
      
    </form>
  </div>

  

</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script>
var layerIndex; //layer 窗口对象
var title_name = "同义词配置";
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var dicLayerContent = '#dic_form'; //layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var dicFormId = '#dicForm'; //form id
var url = '${base}/backstage/apiAccount/'; //controller 路径
var dicLayerIndex;
var treeData;
var treeInited = 0;
//bootstrap-table 列数
var columns = [{
  field: 'name',
  title: '名称'
}, {
  field: 'appKey',
  title: 'appKey'
}, 
{
  field: 'secret',
  title: 'secret'
}, {
  field: 'id',
  title: '操作',
  formatter: 'doFormatter', //对本列数据做格式化
}];

//得到查询的参数
var queryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: 10,
    page: 1,
    name: $('input[name="apiName"]').val()
  };
  return temp;
};


function addNew() {
  openLayer();
}


</script>
<%@include file="../../common/baseSystemJS.jsp"%>
