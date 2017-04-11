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
   
   <c:forEach items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"),\"id\",\"asc\")%>" var="company" >
	   	<div class="panel-container col-xs-4">
	        <div class="panel panel-default  panel-item">
	          <div class="panel-heading text-center text-hidden">${company.companyName}</div>
	          <c:set var="cid" value="${company.id}"/>
	          <div class="panel-body content">
	            <ul>
	              <li  >
	                <p class="col-xs-8 text-right">需求数量：</p> 
	                <p class="col-xs-4 text-left"><span><%=ServiceUtil.getService("ResourceDemandService").count(ServiceUtil.buildBean("ResourceDemand@isDeleted=0&companyId="+pageContext.getAttribute("cid")))%></span></p>
	              </li>
	              
	            </ul>
	          </div>
	        </div>
	      </div>
	</c:forEach>
	    
	    
    </div>
  </div>
  </div>
  
</body>
</html>
