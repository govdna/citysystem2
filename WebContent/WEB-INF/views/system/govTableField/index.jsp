<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseHead.jsp"%>
</head>
<style>
.form_datetime.input-group[class*=col-]{float: left;padding-right: 15px;padding-left: 15px;}
</style>
<body class="white-bg">
 <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
      
<div id="toolbar">
          <div class="form-inline clearfix">
            <div class="form-group pull-left">
               <c:forEach var="obj" items="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=GovTableField&searchType=1\"),\"list_no\",\"asc\")%>">      
              	<%@include file="../common/searchBase.jsp"%>         
              </c:forEach>
              <div class="btn-group">
               <button type="button" class="btn btn-primary" onclick=" $('#dicList').bootstrapTable('refresh');" style="border-right: rgba(255,255,255,.3);">搜索</button>
               <button type="button" class="btn btn-primary dropdown-toggle dropdown-btn">
                 <span class="caret"></span>
               </button>
             </div>
            </div>
          </div>
            <ul class="dropdown-menu1 dn form-inline clearfix" style="padding-left: 0; margin: 5px 0 0;">
            
			    <c:forEach var="obj" items="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=GovTableField&searchType=2\"),\"list_no\",\"asc\")%>">      
            	  <%@include file="../common/searchBase.jsp"%>          
              </c:forEach>
			  </ul>
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
      <c:set var="simpleFields" value="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=GovTableField\"),\"list_no\",\"asc\")%>"/>
      <%@include file="../common/simpleFields.jsp"%>
    </form>
  </div>
</body>
</html>
<%@include file="../common/includeJS.jsp"%>
<script>
var cdata = {"companyId":"<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>"};
var layerIndex;//layer 窗口对象
var title_name="表字段";
var layerContent='#layer_form';//layer窗口主体内容dom Id
var tableId='#dicList';//bootstrap-table id
var toolbar='#toolbar';//bootstrap-table 工具栏id
var formId='#eform';//form id
var url='${base}/backstage/govTableField/';//controller 路径
var userCompanyId = <%=request.getParameter("companyId") %>;
$('.dropdown-btn').on('click', function() {
	$('.dropdown-menu1').toggleClass('dn');
});
$("select[name='cId']").chosen({
  disable_search_threshold: 10,
  no_results_text: "没有匹配到这条记录",
    width: "100%"
});
$("select[name='tableN']").chosen({
	  disable_search_threshold: 10,
	  no_results_text: "没有匹配到这条记录",
	    width: "100%"
	});
$("select[name='cId']").on('change', function(e, params) {
	userCompanyId = params.selected;
	});
<%@include file="../common/simpleFieldsColumnsCompany.jsp"%>

$(function () {
    initChosen();
});

  var queryParams = function(params) {
    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1,
      companyId:userCompanyId,
      sort:params.sort,
      order:params.order,

      <c:forEach var="obj" items="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=GovTableField\"),\"list_no\",\"asc\")%>">  
    	 <%@include file="../common/searchQueryParams.jsp"%>
   	</c:forEach>
      
      <c:if test="${MyFunction:getMaxScope(\"/backstage/govTableField/index\")==100}" >
       companyId:<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>,
        </c:if>
    };
    return temp;
  };
</script>
<%@include file="../common/baseSystemJS.jsp"%>