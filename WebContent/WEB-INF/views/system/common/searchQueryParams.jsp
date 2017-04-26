<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>

<c:choose>
    <c:when test="${obj.inputType==1&&obj.searchType!=null&&obj.searchType!=0}">
     value${obj.valueNo}: $('input[name="search_value${obj.valueNo}"]').val(),
    </c:when>
    <c:when test="${obj.inputType==2&&obj.searchType!=null&&obj.searchType!=0}">
    	value${obj.valueNo}: $('select[name="search_value${obj.valueNo}"]').val(),
    </c:when>
    <c:when test="${obj.inputType==3&&obj.searchType!=null&&obj.searchType!=0}">
  		value${obj.valueNo}: $('select[name="search_value${obj.valueNo}"]').val(),
    </c:when>
    <c:when test="${obj.inputType==5&&obj.searchType!=null&&obj.searchType!=0}">
  		value${obj.valueNo}: $('select[name="search_value${obj.valueNo}"]').val(),
    </c:when>
    <c:when test="${obj.inputType==7&&obj.searchType!=null&&obj.searchType!=0}">
  		value${obj.valueNo}: $('select[name="search_value${obj.valueNo}"]').val(),
    </c:when>
    <c:when test="${obj.inputType==8&&obj.searchType!=null&&obj.searchType!=0}">
  		value${obj.valueNo}: $('select[name="search_value${obj.valueNo}"]').val(),
    </c:when>
    <c:when test="${obj.inputType==9&&obj.searchType!=null&&obj.searchType!=0}">
  		value${obj.valueNo}: $('select[name="search_value${obj.valueNo}"]').val(),
    </c:when>
    <c:when test="${obj.inputType==10&&obj.searchType!=null&&obj.searchType!=0}">
  		value${obj.valueNo}: $('select[name="search_value${obj.valueNo}"]').val(),
    </c:when>
    <c:when test="${obj.inputType==115&&obj.searchType!=null&&obj.searchType!=0}">
  		value${obj.valueNo}: $('select[name="search_value${obj.valueNo}"]').val(),
    </c:when>
    <c:otherwise></c:otherwise>
</c:choose>