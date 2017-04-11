<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
var columns = [
<c:forEach var="obj" items="${simpleFields}">
	<c:if test="${obj.isShow==1}">
		<c:choose>
			<c:when test="${obj.inputType==1}">
			 	{field: 'value${obj.valueNo}',title: '${obj.name}'}, 
			</c:when>
			<c:when test="${obj.inputType==6}">
			 	{field: 'value${obj.valueNo}',title: '${obj.name}'}, 
			</c:when>
			<c:otherwise>
				{field: 'value${obj.valueNo}ForShow',title: '${obj.name}'},
        	</c:otherwise>
		</c:choose>
	</c:if>       
</c:forEach>
{
  field: 'id',
  title: '操作',
  formatter: 'doFormatter', //对本列数据做格式化
}];