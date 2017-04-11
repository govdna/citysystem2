<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
 <input type="hidden" name="id" class="form-control"> <input
        type="hidden" name="idForShow" class="form-control">
      <input type="hidden" name="dataElementId" />
      <div id="status_div"></div>
      <div class="form-group">
        <label class="col-sm-3 control-label">信息资源分类</label>
        <div class="col-sm-4">
          <select name="inforTypes" data-placeholder=" "
            data-param="sortId" data-bind="select[name='inforTypes2']"
            class="chosen-select" required>
            <option value=""></option>
            <c:forEach var="obj"
              items="<%=ServiceUtil.getService(\"SortManagerService\")
            .find(ServiceUtil.buildBean(\"SortManager@isDeleted=0&level=1&belong=2\"))%>">
            <option value="${obj.id}">${obj.sortName}</option>
            </c:forEach>
          </select>
        </div>
        <div class="col-sm-4">
          <select name="inforTypes2" data-placeholder=" " data-param="sortId" data-bind="select[name='inforTypes3']"
            data-level="2" data-url="${base}/backstage/sortManager/listAjax?all=y&level=2&belong=2"
            data-keyField="id" data-valueField="sortName"
            class="chosen-select" required>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label"></label>
        <div class="col-sm-4">
          <select name="inforTypes3" data-placeholder=" " data-param="sortId" data-bind="select[name='inforTypes4']"
            data-level="3" data-url="${base}/backstage/sortManager/listAjax?all=y&level=3&belong=2"
            data-keyField="id" data-valueField="sortName"
            class="chosen-select" >
          </select>
        </div>
        <div class="col-sm-4">
          <select name="inforTypes4" data-placeholder=" " 
            data-level="4" data-url="${base}/backstage/sortManager/listAjax?all=y&level=4&belong=2"
            data-keyField="id" data-valueField="sortName"
            class="chosen-select">
          </select>
        </div>
      </div>
      <c:forEach var="obj" items="<%=ServiceUtil.getService(\"DataManagerService\").find(ServiceUtil.buildBean(\"DataManager@isDeleted=0\"),\"list_no\",\"asc\")%>">
        <div class="data-info" data-id="${obj.id}">
          定义：${obj.define}<br />

          数据类型：${MyFunction:getDicValue("DATATYPE",obj.dataType)}<br />
          值域：${obj.ranges}<br />
          短名：${obj.shortName}<br />
          注解：${obj.note}<br />
          取值示例：${obj.valueCase}<br />
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label info-label" onmouseout="layer.close(infoLayer);" onmouseover="showInfo(${obj.id});" data-id="data${obj.id}">${obj.dataName}：</label>
          <div class="col-sm-8">
            <c:choose>
              <c:when test="${obj.inputType==1}">
                <input type="text" name="value${obj.valueNo}"
                  class="form-control"
                <c:if test="${obj.required==1}" >required</c:if>>
              </c:when>
              <c:when test="${obj.inputType==2}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="${MyFunction:dic(obj.inputValue)}">
                  <option value="${obj2.dicKey}">${obj2.dicValue}</option>
                  </c:forEach>
                </select>
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
              <c:otherwise>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </c:forEach>
     
