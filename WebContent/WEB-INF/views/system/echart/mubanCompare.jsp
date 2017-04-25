<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseLinkHead.jsp"%>
</head>
<style>
  ul,li {
    list-style: none;
  }
</style>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
<div class="container">
    <div class="row">
    	    <label class="control-label  pull-left">责任部门</label>
            <select name="cId" data-placeholder=" " class="chosen-select" style="width:350px; display:inline-block;" tabindex="4" required>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"),\"id\",\"desc\") %>">
            <option value="${obj.id}">${obj.companyName}</option>
            </c:forEach>                  
          </select>
		 <div class="btn-group">
         	<button type="button" class="btn btn-primary" onclick="compare();" style="border-right: rgba(255,255,255,.3);">搜索</button>
         </div>
	    <div>
		   	<div class="panel-container col-xs-4">
		        <div class="panel panel-default  panel-item">
		          <div class="panel-heading text-center text-hidden"><%= new String(request.getParameter("cname").getBytes("iso8859-1"),"utf-8")%></div>
		          <div class="panel-body content">
		            <ul>
			            <li>
			                <p class="col-xs-8 text-right">数据元数量：</p> 
			                <p class="col-xs-4 text-left"><span><%=request.getParameter("dcount") %></span></p>
			            </li>
			            <li>
			                <p class="col-xs-8 text-right">信息资源数量：</p> 
			                <p class="col-xs-4 text-left"><span><%=request.getParameter("icount") %></span></p>
			            </li>  
		            </ul>
		          </div>
		        </div>
		      </div>	    
	    </div>

  </div>
</div>  
</body>
</html>
<%@include file="../common/includeJS.jsp"%>
<script>
var mid;
$("select[name='cId']").chosen({
	  disable_search_threshold: 10,
	  no_results_text: "没有匹配到这条记录",
	  search_contains: true,
	  width: "100%"
	});
$("select[name='cId']").on('change', function(e, params) {
	  mid = params.selected;
	});
</script>
