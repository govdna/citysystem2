<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
 <link rel="stylesheet" type="text/css" href="${base}/static/css/plugins/webuploader/webuploader.css">
   <link rel="stylesheet" type="text/css" href="${base}/static/css/demo/webuploader-demo.css">
<style type="text/css">
.c-list{
cursor: auto !important;
}
.c-list li{
cursor: pointer !important;
}
.data-info{
display:none;
}
.info-label{
cursor: pointer;
}
.webuploader-pick{
background:#18a689;
}
</style>
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
<c:choose >
  <c:when test="${json==null||json.size()==0}">
          该文件没有数据！    
  </c:when>
  <c:otherwise>
  <div class="ibox float-e-margins">
    <div class="ibox-content">
      <div class="alert alert-danger">
              预览只显示前五条数据，更多数据请下载。
      </div>
      <div class="bootstrap-table">
        <div class="fixed-table-container">
          <div class="fixed-table-body">
            <table class="table table-hover table-striped">
              <thead>
              <tr>
              <c:forEach var="col" items="${json.get(0)}">
              <th><div class="th-inner ">${col}</div><div class="fht-cell"></div></th>
              </c:forEach>
              </tr>
              </thead>
              <tbody>
                <c:forEach var="obj" items="${json}" varStatus="status">
                  <c:if test="${status.index>0}">
                    <tr>
                      <c:forEach var="col" items="${obj}">
                        <td>${col}</td>
                      </c:forEach>
                    </tr>
                  </c:if>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
  </c:otherwise>
</c:choose>

</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
