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
    <div>
	    <div class="col-sm-6"  style="padding: 0 10px;">
	    	<div class="small-box box-1">
	    		<div class="icon-container text-center col-xs-4">
	    			<i class="fa fa-pie-chart"></i>
	    		</div>
	    		<div class="content text-center col-xs-8">数据元总数　<b><%=ServiceUtil.getService("DataElementService").count(ServiceUtil.buildBean("DataElement@status=0&isDeleted=0"))%></b></div>
	    	</div>
	    </div>
	    <div class="col-sm-6"  style="padding: 0 10px;">
	    	<div class="small-box box-2">
	    		<div class="icon-container text-center col-xs-4">
	    			<i class="fa fa-area-chart"></i>
	    		</div>
	    		<div class="content text-center col-xs-8">信息资源总数　<b><%=ServiceUtil.getService("InformationResourceService").count(ServiceUtil.buildBean("InformationResource@status=0&isDeleted=0"))%></b></div>
	    	</div>
	    </div>
    </div>
    <div>
   
   <c:forEach items="<%=ServiceUtil.getUseCount()%>" var="company" varStatus="i">
	   	<c:if test="${i.count<=20}">
	   	<div class="panel-container col-xs-4">
	        <div class="panel panel-default  panel-item">
	          <div class="panel-heading text-center text-hidden">${company.value1}</div>
	          <div class="panel-body content">
	            <ul>
	              <li  >
	                <p class="col-xs-8 text-right">涉及部门数量：</p> 
	                <p class="col-xs-4 text-left"><span>${company.companyId}</span></p>
	              </li>
	             <li  >
	                <p class="col-xs-8 text-right">信息资源使用 数量：</p> 
	                <p class="col-xs-4 text-left"><span>${company.counts}</span></p>
	              </li>
	              
	            </ul>
	          </div>
	        </div>
	      </div>
	      </c:if>
	</c:forEach>
	    
	    
    </div>
  </div>
  </div>
  
</body>
</html>
