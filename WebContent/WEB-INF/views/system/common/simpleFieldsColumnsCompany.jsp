<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
var columns = [
<c:forEach var="obj" items="${simpleFields}">
	<c:if test="${obj.isShow==1}">
		<c:choose>
			<c:when test="${obj.inputType==1}">
			 	{field: 'value${obj.valueNo}',title: '${obj.name}', formatter: 'longFormatter'}, 
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
  field: 'companyIdForShow',
  title: '所属部门',
  formatter: 'companyFormatter', //对本列数据做格式化
},
{
  field: 'id',
  title: '操作',
  formatter: 'doFormatter', //对本列数据做格式化
}];

function companyFormatter(value, row, index)
  {
    var html='<span title="'+value+'">';
    if(value.length>6){
      html+=value.substring(0,6)+"...";
    }else{
      html+=value;
    }
    html+='</span>';
    return html;
  }

  
  function longFormatter(value, row, index)
  {
    var html='<span title="'+value+'">';
    if(value.length>8){
      html+=value.substring(0,8)+"...";
    }else{
      html+=value;
    }
    html+='</span>';
    return html;
  }
  