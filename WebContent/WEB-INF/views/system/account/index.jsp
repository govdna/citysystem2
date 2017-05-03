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
        <div id="toolbar">
          <div class="form-inline">
            <div class="form-group">
              <input type="text" placeholder="输入用户名" name="Name1" class="form-control col-sm-8">
              <div class="input-group-btn col-sm-4">
                <button type="button" onclick=" $('#dicList').bootstrapTable('refresh');" class="btn btn-primary">搜索
                </button>
              </div>
            </div>
            <div class="form-group" style="margin-left: 15px;">
              <div class="text-center">
                <a data-toggle="modal" class="btn btn-primary" onclick="openLayer();" href="#">新增</a>
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
      <input type="hidden" name="id"  class="form-control">
      <input type="hidden" name="idForShow"  class="form-control">        
      <div class="form-group">
        <label class="col-sm-3 control-label">登录名：</label>
        <div class="col-sm-7">
          <input type="text" name="loginName"  class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">角色：</label>
        <div class="col-sm-7">
          <select name="roleId" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required >
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"RoleService\").find(ServiceUtil.buildBean(\"Role@isDeleted=0\"),\"id\",\"desc\") %>">
            <option value="${obj.id}">${obj.name}</option>
            </c:forEach>
          </select> 
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">用户名：</label>
        <div class="col-sm-7">
          <input type="text" name="name" class="form-control" required>
        </div>
      </div>
      <div class="form-group detail-hide">
        <label class="col-sm-3 control-label">密码：</label>
        <div class="col-sm-7">
          <input type="password" name="password" class="form-control" placeholder="******">
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">状态：</label>
        <div class="col-sm-7">
          <select name="isValid" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value="1">启用</option>
            <option value="0">禁用</option>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">联系电话：</label>
        <div class="col-sm-7">
          <input type="text" name="tel" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">政府机构：</label>
        <div class="col-sm-7">        
          <select name="companyId" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" data-param="companyId" data-bind="select[name='groupId']" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"),\"id\",\"desc\") %>">
            <option value="${obj.id}">${obj.companyName}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">业务处室：</label>
        <div class="col-sm-7">        
          <select name="groupId" data-placeholder=" " data-url="${base}/backstage/groups/listAjax?all=y"
      data-keyField="id" data-valueField="name" class="chosen-select" style="width:350px;" tabindex="4" required>
          </select>
        </div>
      </div>
    </form>
  </div>
</body>
</html>

<%@include file="../common/includeJS.jsp"%>
<script>
var layerIndex; //layer 窗口对象
var title_name = "用户";
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var url = '${base}/backstage/account/'; //controller 路径

//bootstrap-table 列数
var columns = [{
  field: 'name',
  title: '用户名'
}, {
  field: 'loginName',
  title: '登录名'
}, {
  field: 'companyIdForShow',
  title: '机构'
}, {
  field: 'groupIdForShow',
  title: '业务处室'
}, {
  field: 'id',
  title: '操作',
  formatter: 'doFormatter', //对本列数据做格式化
}];


//得到查询的参数
var queryParams = function(params) {
		if($('input[name="Name1"]').val()!=null&&$('input[name="Name1"]').val()!=""){
			sort="length(trim(name))";
			order="asc";
		}
  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
    name: $('input[name="Name1"]').val()
  };
  return temp;
};

//验证名称重复
$("input[name='loginName']").blur(function (){
	jQuery.post("${base}/backstage/account/validation",{"loginName":$("input[name='loginName']").val(),"id":$("input[name='id']").val()},function(data){
		data=JSON.parse(data); 
		if(data.results==1){
			layer.msg("登录名已存在，请重新填写");
			$("input[name='loginName']").val("");
		}
	});
});
</script>
<%@include file="../common/baseSystemJS.jsp"%>
