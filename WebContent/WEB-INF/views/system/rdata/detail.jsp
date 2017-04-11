<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>

<!DOCTYPE html >
<html lang="en"> 
<head>
<c:set var="base" value="${pageContext.request.contextPath}"/>
<link href="${base}/static/css/main.css" rel="stylesheet">
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
    <c:choose>
      <c:when test="${dataElement.classType==0}">
        <div class="form-group">
          <label class="col-xs-4 control-label info-label" data-id="data1" style="margin-top: 10px;text-align:right;">中文名称：</label>
          <span class="col-xs-7 dt-span">${dataElement.value1}</span>
        </div>
        <div class="form-group">
          <label class="col-xs-4 control-label info-label" data-id="data2" style="margin-top: 10px;text-align:right;">英文名称：</label>
          <span class="col-xs-7 dt-span">${dataElement.value2}</span>
        </div>
        <div class="form-group">
          <label class="col-xs-4 control-label info-label" data-id="data3" style="margin-top: 10px;text-align:right;">定义：</label>
          <span class="col-xs-7 dt-span">${dataElement.value3}</span>
        </div>
        <div class="form-group">
          <label class="col-xs-4 control-label info-label" data-id="data4" style="margin-top: 10px;text-align:right;">数据类型：</label>
           <span class="col-xs-7 dt-span">${MyFunction:getDicValue("DATATYPE", dataElement.dataType)}</span>
        </div>
        <div class="form-group">
          <label class="col-xs-4 control-label info-label" data-id="data7" style="margin-top: 10px;text-align:right;">数据长度：</label>
          <span class="col-xs-7 dt-span">${dataElement.value7}</span>
        </div>
        <div class="form-group">
          <label class="col-xs-4 control-label info-label" data-id="data5" style="margin-top: 10px;text-align:right;">对象类型：</label>
          <span class="col-xs-7 dt-span">${MyFunction:getDicValue("OBJECTTYPE", dataElement.objectType)}
          </span>
        </div>
        <div class="form-group">
          <label class="col-xs-4 control-label info-label" data-id="data6" style="margin-top: 10px;text-align:right;">备注：</label>
          <span class="col-xs-7 dt-span">${dataElement.notes}</span>
        </div>
        <div class="form-group">
          <label class="col-xs-4 control-label info-label" data-id="data8" style="margin-top: 10px;text-align:right;">来源部门：</label>
          <span class="col-xs-7 dt-span">${MyFunction:getDicValue("ZYTGF", dataElement.value8)}</span>
        </div>
      </c:when>
      <c:otherwise>
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
      </c:otherwise>
     </c:choose>
     <c:if test="${dataElement.classType==1}">
      <div class="form-group">
          <label class="col-xs-4 control-label info-label"  style="margin-top: 10px;text-align:right;">来源：</label>
          <span class="col-xs-7 dt-span">${MyFunction:getDicValue("SOURCETYPE",dataElement.sourceType)}</span>
      </div>
     </c:if>
     <c:choose>
      <c:when test="${dataElement.fatherId!=null}">
        <label class="col-xs-4 control-label info-label" data-id="data1" style="margin-top: 10px;text-align:right;">父级数据元：</label>
        <span class="col-xs-7 dt-span"><a href="${base}/backstage/dataElement/detail?id=${father.id}">${father.chName}</a></span>
      </c:when>
      <c:otherwise>
      <c:if test="${childList!=null&&childList.size()>0}">
        <label class="col-xs-4 control-label info-label" data-id="data1" style="margin-top: 10px;text-align:right;">子级数据元：</label>
        <span class="col-xs-7 dt-span">
        <c:forEach var="obj" items="${childList}">
          <a href="${base}/backstage/dataElement/detail?id=${obj.id}">${obj.chName}</a>&nbsp;&nbsp;
        </c:forEach>
        </span>
      </c:if>
      </c:otherwise>
    </c:choose>
      <c:if test="${fieldList!=null&&fieldList.size()>0}">
       
				<div class="bootstrap-table">
				<div class="fixed-table-toolbar"></div>
				<div class="fixed-table-container" style="padding-bottom: 0px;"><div class="fixed-table-header" style="display: none;"><table></table></div>
				<table  class="table table-hover table-striped">
				<thead><tr><th style="" data-field="tableName" tabindex="0"><div class="th-inner ">表名</div><div class="fht-cell"></div></th><th style="" data-field="value1" tabindex="0"><div class="th-inner ">字段名</div><div class="fht-cell"></div></th><th style="" data-field="value2" tabindex="0"><div class="th-inner ">字段中文名</div><div class="fht-cell"></div></th><th style="" data-field="value5" tabindex="0"><div class="th-inner ">类型</div><div class="fht-cell"></div></th><th style="" data-field="value6" tabindex="0"><div class="th-inner ">长度</div><div class="fht-cell"></div></th></tr></thead>
				<tbody>
				<c:forEach var="obj" items="${fieldList}">
					<c:set var="table" value="${MyFunction:getGovTableById(obj.value3)}"></c:set>
        			<tr><td title="${table.value1}(${table.value2})">${table.value1}</td>
        			<td>${obj.value1}</td>
        			<td>${obj.value2}</td>
        			<td>${obj.value5}</td>
        			<td>${obj.value6}</td></tr>
			   </c:forEach>
			</tbody></table></div>
		</div>
		
	</c:if>
    <div style="margin-top:50px;">&nbsp;</div>
    </form>
  </div>

</body>
</html>


