<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
</head>
<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div class="btn-group hidden-xs" id="toolbar" role="group">
          <div class="text-center">
          	<c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/company/index\") %>">
            <a data-toggle="modal" class="btn btn-primary" onclick="openLayer();" href="#">新增</a>
            </c:if>
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
        <label class="col-sm-3 control-label">单位编号：</label>
        <div class="col-sm-7">
          <input type="text" name="companyNumber" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">单位名称：</label>
        <div class="col-sm-7">
          <input type="text" name="companyName" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">机构代码：</label>
        <div class="col-sm-7">
          <input type="text" name="companyCode" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">地址：</label>
        <div class="col-sm-7">
          <input type="text" name="address" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">所属城市：</label>
        <div class="col-sm-7">
          <select name="cityId" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"CityService\").find(ServiceUtil.buildBean(\"City\")) %>">
            <option value="${obj.id}">${obj.cityName}</option>
            </c:forEach>
          </select>
        </div>
      </div>
    </form>
  </div>

</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script>
var layerIndex; //layer 窗口对象
var title_name = "机构";
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var url = '${base}/backstage/company/'; //controller 路径

//bootstrap-table 列数
var columns = [{
  field: 'companyNumber',
  title: '单位编号'
}, {
  field: 'companyName',
  title: '单位名称'
}, {
  field: 'cityIdForShow',
  title: '所属城市'
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
<script>
function doFormatter(value, row, index)
{
	var html='';
	html+='<div class="btn-group">';
	html+='<button type="button" class="btn btn-white" onclick="datailRow(\''+row.idForShow+'\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
	<c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/company/index\") %>">
	html+='<button type="button" class="btn btn-white" id="edit"  onclick="editRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
	</c:if>
	<c:if test="<%=!ServiceUtil.haveDel(\"/backstage/company/index\") %>">
	html+='<button type="button" class="btn btn-white" onclick="deleteRow(\''+row.idForShow+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
	</c:if>
	html+='</div>';
	return html;
}
</script>