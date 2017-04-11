<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseLinkHead.jsp"%>
</head>
<style>
  ul,li {
    list-style: none;
  }
  .panel-item ul span {
    min-height: 40px;
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
          <c:forEach items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"),\"id\",\"asc\")%>" var="company" ><div class="panel-container col-xs-4">
                <div class="panel panel-default panel-item small">
                  <div class="panel-heading text-center text-hidden">${company.companyName}</div>
                  <c:set var="cid" value="${company.id}"/>
                  <c:set var="dataTime" value="<%=ServiceUtil.dataLatestTime(\"\"+pageContext.getAttribute(\"cid\"))%>" />
                  <c:set var="resTime" value="<%=ServiceUtil.resLatestTime(\"\"+pageContext.getAttribute(\"cid\"))%>" />
                  <div class="panel-body">
                    <ul>
                      <li>
                        <span class="col-xs-12 text-center">数据元最新更新时间</span>                  
                        <span class="number col-xs-12 text-center"><c:choose><c:when test="${dataTime!=null}"><fmt:formatDate value="${dataTime}" pattern="yyyy年MM月dd日" /></c:when><c:otherwise>暂无更新信息！</c:otherwise></c:choose></span>
                      </li>
                     <li>
                        <span class="col-xs-12 text-center">信息资源最新更新时间</span>                 
                        <span class="number  col-xs-12 text-center"><c:choose><c:when test="${resTime!=null}"><fmt:formatDate value="${resTime}" pattern="yyyy年MM月dd日" /></c:when><c:otherwise>暂无更新信息！</c:otherwise></c:choose></span>
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
