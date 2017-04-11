<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<div class="row">
	<div class="col-sm-8 b-r" style="height:400px;overflow-y: scroll;">
      <input type="hidden" name="sameName"  class="form-control">
      <input type="hidden" name="dataElementIds"  class="form-control">
      <input type="hidden" name="id"  class="form-control">
      <input type="hidden" name="idForShow"  class="form-control">
      <input type="hidden" name="identifier"  class="form-control">
      <input type="hidden" name="imported"  class="form-control">
      <input type="hidden" name="sourceId"  class="form-control">
      <input type="hidden" name="fatherId"  class="form-control">
       <c:forEach var="obj" items="<%=ServiceUtil.getService(\"DataElementFieldsService\").find(ServiceUtil.buildBean(\"DataElementFields@isDeleted=0\"),\"list_no\",\"asc\")%>">
        <div class="form-group">
          <label class="col-sm-3 control-label info-label"  data-id="data${obj.id}">${obj.name}：</label>
          <div class="col-sm-8" data-value="value${obj.valueNo}">
            <c:choose>
              <c:when test="${obj.inputType==1}">
                <input type="text" name="value${obj.valueNo}"
                  class="form-control"
                <c:if test="${obj.required==1}" >required</c:if>
                
                
                value="${dataElement.getValueByNo(obj.valueNo)}"
                
                >
              </c:when>
              <c:when test="${obj.inputType==2}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select" 
                value="${dataElement.getValueByNo(obj.valueNo)}"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="${MyFunction:dic(obj.inputValue)}">
                    <option value="${obj2.dicKey}" <c:if test="${obj2.dicKey==dataElement.getValueByNo(obj.valueNo)}"> selected="selected"</c:if>>${obj2.dicValue}</option>
                  </c:forEach>
                </select>
              </c:when>
              <c:when test="${obj.inputType==3}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select" value="${dataElement.getValueByNo(obj.valueNo)}"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"ItemSortService\").find(ServiceUtil.buildBean(\"ItemSort@isDeleted=0\"))%>">
                    <option value="${obj2.id}" <c:if test="${obj2.id==dataElement.getValueByNo(obj.valueNo)}"> selected="selected"</c:if>>${obj2.itemName}</option>
                  </c:forEach>
                </select>
              </c:when>
              <c:when test="${obj.inputType==4}">
                <input type="hidden" name="value${obj.valueNo}"
                    class="form-control edit-hide detail-show"  value="${dataElement.getValueByNo(obj.valueNo)}"
                    >
                <input type="text" name="value${obj.valueNo}ForShow"
                    class="form-control edit-hide detail-show"
                    >
              </c:when>
              <c:when test="${obj.inputType==5}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select" value="${dataElement.getValueByNo(obj.valueNo)}"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"))%>">
                  <option value="${obj2.id}" <c:if test="${obj2.id==dataElement.getValueByNo(obj.valueNo)}"> selected="selected"</c:if>>${obj2.companyName}</option>
                  </c:forEach>
                </select>
              </c:when>
              
              <c:when test="${obj.inputType==15}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select" value="${dataElement.getValueByNo(obj.valueNo)}"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"SortManagerService\").find(ServiceUtil.buildBean(\"SortManager@isDeleted=0&type=2\"))%>">
                  <option value="${obj2.sortName}" <c:if test="${obj2.sortName==dataElement.getValueByNo(obj.valueNo)}"> selected="selected"</c:if>>${obj2.sortCode}</option>
                  </c:forEach>
                </select>
              </c:when>
              
              <c:otherwise>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </c:forEach>               
	</div>
	
	<style>
	.different_value{
		display:none;
	
	}
	.value-span{
	cursor: pointer;
	}
	.select-value-span{
	cursor: pointer;
	}
	.detail-span-i{
	cursor: pointer;
	padding: 5px 0px 5px 2px;
	}
	</style>
	<div class="col-sm-4" style="height:400px;overflow-y: scroll;">
	<c:forEach var="obj" items="${map}">
		<div class="different_value" data-value="${obj.key}">
			
			<div class="alert alert-info">
                      点击<i class="fa fa-gg detail-span" ></i>查看相关信息资源<br/>点击文字快速复制。
            </div>
			<c:forEach var="mp" items="${obj.value}">
			
			<p ><span class="label label-info"><span class="value-span" data-key="${obj.key}" data-value="${mp.key}" data-count="${mp.value}">${mp.key}(${mp.value})</span>
             <c:set var="ids" value="${MyFunction:getDataElementIdsByValue(dataElementList,obj.key,mp.key)}"></c:set>
             <c:if test="${ids!=''}">
             	<i class="fa fa-gg detail-span-i" data-ids="${ids}"></i>
             </c:if>
             </span></p>
				
			</c:forEach>
		</div>
	</c:forEach>
                                
	</div>
</div>

      

