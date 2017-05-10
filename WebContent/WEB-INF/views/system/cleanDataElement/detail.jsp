<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>

<!DOCTYPE html >
<html lang="en"> 
<head>
<c:set var="base" value="${pageContext.request.contextPath}"/>
 <link href="${base}/static/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
 <link href="${base}/static/css/style.css?v=4.1.0" rel="stylesheet">
<style type="text/css">
.c-list{
cursor: auto !important;
}

.c-list li.search-choice{
padding: 3px 5px 3px 5px !important;
}


</style>
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div id="layer_form" class="ibox-content">
  <form method="post" class="form-horizontal" id="eform">
    <div class="form-group">
      <label class="col-xs-4 control-label info-label" data-id="data1" style="margin-top: 10px;text-align:right;">内部标识符：</label>
      <span class="col-xs-7 dt-span">${dataElement.identifier}</span>
    </div>
   
        <c:forEach var="obj" items="<%=ServiceUtil.getService(\"DataElementFieldsService\").find(ServiceUtil.buildBean(\"DataElementFields@isDeleted=0\"),\"list_no\",\"asc\")%>">
        <div class="form-group">
          <label class="col-xs-4 control-label info-label"  data-id="data${obj.id}" style="margin-top: 10px;text-align:right;">${obj.name}：</label>
          <c:choose>
            <c:when test="${obj.inputType==1}">
                <span class="col-xs-7 dt-span">${dataElement.getValueByNo(obj.valueNo)}</span>
            </c:when>
            <c:when test="${obj.inputType==2}">
              <span class="col-xs-7 dt-span">${MyFunction:getDicValue(obj.inputValue,dataElement.getValueByNo(obj.valueNo))}</span>      
            </c:when>
            <c:when test="${obj.inputType==3}">
              <select name="value${obj.valueNo}" data-placeholder=" "
                class="chosen-select"
                <c:if test="${obj.required==1}" >required</c:if>>
                <option value=""></option>
                <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"ItemSortService\").find(ServiceUtil.buildBean(\"ItemSort@isDeleted=0\"))%>">
                <option value="${obj2.id}">${obj2.itemName}</option>
                </c:forEach>
              </select>
            </c:when>
            <c:when test="${obj.inputType==4}">
              <input type="hidden" name="value${obj.valueNo}"
                  class="form-control edit-hide detail-show"
                  >
              <input type="text" name="value${obj.valueNo}ForShow"
                  class="form-control edit-hide detail-show"
                  >
            </c:when>
            <c:when test="${obj.inputType==5}">
              <span class="col-xs-7 dt-span">${MyFunction:getCompanyNameById(dataElement.getValueByNo(obj.valueNo))}</span>
            </c:when>
            <c:otherwise>
            </c:otherwise>
          </c:choose>
          </div>
        </c:forEach>
     
     <c:choose>
      <c:when test="${dataElement.fatherId!=null}">
        <label class="col-xs-4 control-label info-label" data-id="data1" style="margin-top: 10px;text-align:right;">父级数据元：</label>
        <span class="col-xs-7 dt-span"><a href="${base}/backstage/cleanDataElement/detail?id=${father.id}">${father.chName}</a></span>
      </c:when>
      <c:otherwise>
      <c:if test="${childList!=null&&childList.size()>0}">
        <label class="col-xs-4 control-label info-label" data-id="data1" style="margin-top: 10px;text-align:right;">子级数据元：</label>
        <span class="col-xs-7 dt-span">
        <c:forEach var="obj" items="${childList}">
          <a href="${base}/backstage/cleanDataElement/detail?id=${obj.id}">${obj.chName}</a>&nbsp;&nbsp;
        </c:forEach>
        </span>
      </c:if>
      </c:otherwise>
    </c:choose>
    <div style="margin-top:50px;">&nbsp;</div>
    </form>
  </div>

</body>
</html>


