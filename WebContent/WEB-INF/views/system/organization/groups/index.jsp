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
        <div id="toolbar">
          <div class="form-inline">
            <div class="form-group">
              <input type="text" placeholder="输入名称" name="gname" class="form-control col-sm-8">
              <div class="input-group-btn col-sm-4">
                <button type="button" onclick=" $('#dicList').bootstrapTable('refresh');" class="btn btn-primary">搜索
                </button>
              </div>
            </div>
            <div class="form-group" style="margin-left: 5px;">
	          <div class="text-center">
	          	<c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/groups/index\") %>">
	            <a data-toggle="modal" class="btn btn-primary" onclick="openLayer();" href="#">新增</a>
	            </c:if>
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
        <label class="col-sm-3 control-label">编号：</label>
        <div class="col-sm-7">
          <input type="text" name="number" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">名称：</label>
        <div class="col-sm-7">
          <input type="text" name="name" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">所属单位：</label>
        <div class="col-sm-7">
          <select name="companyId" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company\")) %>">
            <option value="${obj.id}">${obj.companyName}</option>
            </c:forEach>
          </select>
        </div>
      </div> 
      <div class="form-group">
        <label class="col-sm-3 control-label">联系人：</label>
        <div class="col-sm-7">
          <input type="text" name="contract"  class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">联系电话：</label>
        <div class="col-sm-7">
          <input type="text" name="telephone"  class="form-control" required>
        </div>
      </div>
    </form>
  </div>

</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script>
var layerIndex; //layer 窗口对象
var title_name = "业务处室";
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var url = '${base}/backstage/groups/'; //controller 路径

//bootstrap-table 列数
var columns = [{
  field: 'number',
  title: '编号'
}, {
  field: 'name',
  title: '名称',
  sortable:true
}, {
  field: 'COMPANY_ID',
  title: '所属单位',
  formatter:'showFormatter',
  sortable:true
}, {
  field: 'id',
  title: '操作',
  formatter: 'doFormatter', //对本列数据做格式化
}];

function showFormatter(value, row, index) {
	  var html = '<span title="' + row.companyIdForShow + '">';
	  if ( row.companyIdForShow.length > 8) {
	    html +=  row.companyIdForShow.substring(0, 8) + "...";
	  } else {
	    html +=  row.companyIdForShow;
	  }
	  html += '</span>';
	  return html;
	}
//得到查询的参数
var queryParams = function(params) {
	var sort=params.sort;
	var order=params.order;
	if($('input[name="gname"]').val()!=null&&$('input[name="gname"]').val()!=""){
		sort="length(trim(name))";
		order="asc";
	}
  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
    sort:sort,
    order:order,
    name:$('input[name="gname"]').val()
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
	<c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/groups/index\") %>">
	html+='<button type="button" class="btn btn-white" id="edit"  onclick="editRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
	</c:if>
	<c:if test="<%=!ServiceUtil.haveDel(\"/backstage/groups/index\") %>">
	html+='<button type="button" class="btn btn-white" onclick="deleteRow(\''+row.idForShow+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
	</c:if>
	html+='</div>';
	return html;
}
</script>