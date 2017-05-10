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
    <c:if test="${jsa.size()>0}">   
    <div>
	    <div class="col-sm-6"  style="padding: 0 10px;">
	    	<div class="small-box box-1">
	    		<div class="icon-container text-center col-xs-4">
	    			<i class="fa fa-pie-chart"></i>
	    		</div>
	    		<div class="content text-center col-xs-8">数据元总数　<b><%=ServiceUtil.getService("DataElementService").count(ServiceUtil.buildBean("DataElement@classType=1&isDeleted=0"))%></b></div>
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
    </c:if>
    <div>
    <c:if test="${jsa.size()==0}">
      <h1 class="text-center">没数据了哦，赶紧去添加吧！</h1>
	</c:if>
   <c:forEach items="${jsa}" var="company" >
  		 <a href="${base}/backstage/echart/mubanCompare?cid=${company.cid}&cname=${company.cname}&dcount=${company.dcount}&icount=${company.icount}">
		   	<div class="panel-container col-xs-4">
		        <div class="panel panel-default  panel-item">
		          <div class="panel-heading text-center text-hidden">${company.cname}</div>
		          <div class="panel-body content">
		            <ul>
		              <li  >
		                <p class="col-xs-8 text-right">数据元数量：</p> 
		                <p class="col-xs-4 text-left"><span>${company.dcount}</span></p>
		              </li>
		             <li  >
		                <p class="col-xs-8 text-right">信息资源数量：</p> 
		                <p class="col-xs-4 text-left"><span>${company.icount}</span></p>
		              </li>
		             <li  >
		                <p class="col-xs-8 text-right">基础信息资源数量：</p> 
		                <p class="col-xs-4 text-left"><span>${company.bcount}</span></p>
		              </li>
		              <li  >
		                <p class="col-xs-8 text-right">主题信息资源数量：</p> 
		                <p class="col-xs-4 text-left"><span>${company.tcount}</span></p>
		              </li>	              
		            </ul>
		          </div>
		        </div>
		      </div>
		  </a>
	</c:forEach>
	    
	    
    </div>
  </div>
  </div>
  
</body>
</html>

