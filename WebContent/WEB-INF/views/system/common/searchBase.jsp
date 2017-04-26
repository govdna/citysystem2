<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>

<c:choose>
              <c:when test="${obj.inputType==1}">
                <input type="text" placeholder="请输入${obj.name}" name="search_value${obj.valueNo}"
                  class="form-control"
                >
              </c:when>
              <c:when test="${obj.inputType==2}">
              <label class="control-label  pull-left">${obj.name}</label>
              <div class=" pull-left" style="margin-left:10px;width:250px;">              
                <select name="search_value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select">
                  <option value=""></option>
                  <option value="">&nbsp;</option>
                  <c:forEach var="obj2" items="${MyFunction:dic(obj.inputValue)}">
                  <option value="${obj2.dicKey}">${obj2.dicValue}</option>
                  </c:forEach>
                </select>
                </div>
              </c:when>
              <c:when test="${obj.inputType==3}">
              <label class="control-label  pull-left">${obj.name}</label>
              <div class=" pull-left" style="margin-left:10px;width:250px;">              
                <select name="search_value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select">
                  <option value=""></option>
                   <option value="">&nbsp;</option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"ItemSortService\").find(ServiceUtil.buildBean(\"ItemSort@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.itemName}</option>
                  </c:forEach>
                </select>
                 </div>
              </c:when>
              
              <c:when test="${obj.inputType==5}">
              <label class="control-label  pull-left">${obj.name}</label>
              <div class=" pull-left" style="margin-left:10px;width:250px;">              
                <select name="search_value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select">
                  <option value=""></option>
                   <option value="">&nbsp;</option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.companyName}</option>
                  </c:forEach>
                </select>
                 </div>
              </c:when>
              
              <c:when test="${obj.inputType==7}">
              <label class="control-label  pull-left">${obj.name}</label>
              <div class=" pull-left" style="margin-left:10px;width:250px;">              
                <select name="search_value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select">
                  <option value=""></option>
                   <option value="">&nbsp;</option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"GovServerService\").find(ServiceUtil.buildBean(\"GovServer@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.value1}</option>
                  </c:forEach>
                </select>
                 </div>
              </c:when>
              <c:when test="${obj.inputType==8}">
              <label class="control-label  pull-left">${obj.name}</label>
              <div class=" pull-left" style="margin-left:10px;width:250px;">              
                <select name="search_value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select">
                  <option value=""></option>
                   <option value="">&nbsp;</option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"GovMemorizerService\").find(ServiceUtil.buildBean(\"GovMemorizer@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.value1}</option>
                  </c:forEach>
                </select>
                 </div>
              </c:when>
              <c:when test="${obj.inputType==9}">
              <label class="control-label  pull-left">${obj.name}</label>
              <div class=" pull-left" style="margin-left:10px;width:250px;">              
                <select name="search_value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select">
                  <option value=""></option>
                   <option value="">&nbsp;</option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"GovComputerRoomService\").find(ServiceUtil.buildBean(\"GovComputerRoom@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.value1}</option>
                  </c:forEach>
                </select>
                 </div>
              </c:when>
              <c:when test="${obj.inputType==10}">
              <label class="control-label  pull-left">${obj.name}</label>
              <div class=" pull-left" style="margin-left:10px;width:250px;">              
                <select name="search_value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select">
                  <option value=""></option>
                   <option value="">&nbsp;</option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"GovApplicationSystemService\").find(ServiceUtil.buildBean(\"GovApplicationSystem@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.value1}</option>
                  </c:forEach>
                </select>
                 </div>
              </c:when>
              <c:when test="${obj.inputType==11}">
              <label class="control-label  pull-left">${obj.name}</label>
              <div class=" pull-left" style="margin-left:10px;width:250px;">              
                <select name="search_value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select">
                  <option value=""></option>
                   <option value="">&nbsp;</option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"InformationBusinessService\").find(ServiceUtil.buildBean(\"InformationBusiness\"))%>">
                    <option value="${obj2.id}">${obj2.value1}</option>
                  </c:forEach>
                </select>
                 </div>
              </c:when>
              
              <c:otherwise>
              </c:otherwise>
            </c:choose> 