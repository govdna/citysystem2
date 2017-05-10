<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
  <%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseHead.jsp"%>
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline">
            <div class="form-group" style="margin-left: 15px;">
              <div class="text-center">
                <a data-toggle="modal" class="btn btn-primary" onclick="openLayer();" href="#">新增</a>
              </div>
            </div>
          </div>
        </div>
        <table id="dataList" class="ft14">
        </table>
      </div>
    </div>
  </div>

  <div id="layer_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="eform">
      <input type="hidden" name="id"  class="form-control">
      <input type="hidden" name="idForShow"  class="form-control">
      <input type="hidden" name="valueNo"  class="form-control">
      <div class="form-group">
        <label class="col-sm-3 control-label">名称：</label>
        <div class="col-sm-7">
          <input type="text" name="name" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">是否必填：</label>
        <div class="col-sm-7">
          <select name="required" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"REQUIRED\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>  
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">输入框类型：</label>
        <div class="col-sm-7">
          <select name="inputType" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"INPUTTYPE\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>  
        </div>
      </div>
      <div class="form-group" id="inputValue_Div" style="display:none;">
        <label class="col-sm-3 control-label">输入框取值：</label>
        <div class="col-sm-7">
          <select name="inputValue" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" >
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"GovmadeDicService\").find(ServiceUtil.buildBean(\"GovmadeDic@isDeleted=0&level=1\"))%>">
            <option value="${obj.dicNum}">${obj.dicName}</option>
            </c:forEach>
          </select>  
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">是否为显示列：</label>
        <div class="col-sm-7">
          <select name="isShow" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"YESORNO\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>  
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">搜索框类型：</label>
        <div class="col-sm-7">
          <select name="searchType" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"SEARCHTYPE\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>  
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">排序：</label>
        <div class="col-sm-7">
          <input type="number" name="listNo" class="form-control" required>
        </div>
      </div>
    </form>
  </div>
</body>
</html>

<%@include file="../common/includeJS.jsp"%>
<script>
var layerIndex; //layer 窗口对象
var title_name = "数据元配置";
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var tableId = '#dataList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var datailContent = '#datail_form'; //layer窗口主体内容dom Id
var datailId = '#datailform'; //form id

var dicLayerIndex;
var checkedIds = ",";
var checkedEles;
var dataEles; //存放选中的数据元
var url = '${base}/backstage/dataElementFields/'; //controller 路径

//bootstrap-table 列数
var columns = [{
  field: 'name',
  title: '名称',
  sortable:true
}, {
  field: 'listNo',
  title: '排序',
  sortable:true
},{
  field: 'id',
  title: '操作',
  formatter: 'doFormatterL', //对本列数据做格式化
}];

function doFormatterL(value, row, index){
	var html='';
	html+='<div class="btn-group">';
	html+='<button type="button" class="btn btn-white" onclick="datailRow(\''+row.idForShow+'\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
	html+='<button type="button" class="btn btn-white" id="edit"  onclick="editRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
	if(row.valueNo>9){
		html+='<button type="button" class="btn btn-white" onclick="deleteRow(\''+row.idForShow+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';	
	}	
	html+='</div>';
	return html;
}

var queryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
    sort:params.sort,
    order:params.order,
  };
  return temp;
};
$('select[name="inputType"]').on('change', function(e, params) {
  var val = $(this).val();
  if (val == 2) {
    $('#inputValue_Div').show();
  } else {
    $('#inputValue_Div').hide();
  }
});

</script>
<%@include file="../common/baseSystemJS.jsp"%>
