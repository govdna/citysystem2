<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<style>
.data-info{
display:none;
}
</style>
<c:forEach var="obj" items="${simpleFields}">
		<c:if test="${obj.titleText!=null&&obj.titleText!=''}" >
		
			<div class="data-info" data-id="${obj.id}">
       		 ${obj.titleText}<br />
       	 	</div>
		</c:if>
 		
        
        <div class="form-group">
          <label class="col-sm-3 control-label info-label"  onmouseout="layer.close(infoLayer);" <c:if test="${obj.titleText!=null&&obj.titleText!=''}" >onmouseover="showInfo(${obj.id});"  </c:if> data-id="data${obj.id}">${obj.name}：</label>
          
            <c:choose>
              <c:when test="${obj.inputType==1}">
              	<div class="col-sm-8">
                <input type="text" name="value${obj.valueNo}"
                  class="form-control"
                <c:if test="${obj.required==1}" >required</c:if>>
                </div>
              </c:when>
              <c:when test="${obj.inputType==2}">
              <div class="col-sm-8">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="${MyFunction:dic(obj.inputValue)}">
                    <option value="${obj2.dicKey}">${obj2.dicValue}</option>
                  </c:forEach>
                </select>
                </div>
              </c:when>
              <c:when test="${obj.inputType==3}">
              <div class="col-sm-8">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"ItemSortService\").find(ServiceUtil.buildBean(\"ItemSort@isDeleted=0\"))%>">
                    <option value="${obj2.id}">${obj2.itemName}</option>
                  </c:forEach>
                </select>
                </div>
              </c:when>
              <c:when test="${obj.inputType==4}">
              <div class="col-sm-8">
                <input type="hidden" name="value${obj.valueNo}"
                    class="form-control edit-hide detail-show"
                    >
                <input type="text" name="value${obj.valueNo}ForShow"
                    class="form-control edit-hide detail-show"
                    >
                    </div>
              </c:when>
              <c:when test="${obj.inputType==5}">
              <div class="col-sm-8">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.companyName}</option>
                  </c:forEach>
                </select>
                </div>
              </c:when>
               <c:when test="${obj.inputType==6}">
               <div class="col-sm-8">
                <input type="text" name="value${obj.valueNo}"
                  class="form-control form_datetime" size="16" readonly
                <c:if test="${obj.required==1}" >required</c:if>>
             	</div>
              </c:when>
              <c:when test="${obj.inputType==7}">
              <div class="col-sm-8">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"GovServerService\").find(ServiceUtil.buildBean(\"GovServer@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.value1}</option>
                  </c:forEach>
                </select>
                </div>
              </c:when>
              <c:when test="${obj.inputType==8}">
              <div class="col-sm-8">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"GovMemorizerService\").find(ServiceUtil.buildBean(\"GovMemorizer@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.value1}</option>
                  </c:forEach>
                </select>
                </div>
              </c:when>
              <c:when test="${obj.inputType==9}">
              <div class="col-sm-8">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"GovComputerRoomService\").find(ServiceUtil.buildBean(\"GovComputerRoom@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.value1}</option>
                  </c:forEach>
                </select>
                </div>
              </c:when>
              <c:when test="${obj.inputType==10}">
              <div class="col-sm-8">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"GovApplicationSystemService\").find(ServiceUtil.buildBean(\"GovApplicationSystem@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.value1}</option>
                  </c:forEach>
                </select>
                </div>
              </c:when>
              <c:when test="${obj.inputType==11}">
              <div class="col-sm-8">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"InformationBusinessService\").find(ServiceUtil.buildBean(\"InformationBusiness\"))%>">
                    <option value="${obj2.id}">${obj2.value1}</option>
                  </c:forEach>
                </select>
                </div>
              </c:when>
              <c:when test="${obj.inputType==12}">
              <div class="col-sm-8">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"GovDatabaseService\").find(ServiceUtil.buildBean(\"GovDatabase@isDeleted=0\"))%>">
                    <option value="${obj2.id}">${obj2.value2}</option>
                  </c:forEach>
                </select>
                </div>
              </c:when>   
              
               <c:when test="${obj.inputType==13}">
                 <div class="col-sm-4">
                  <select name="database13" data-placeholder=" "
           			 data-param="value3" data-bind="select[data-name='table13']"
            		 class="chosen-select" >
            		<option value=""></option>
            		<c:forEach var="db" items="<%=ServiceUtil.getService(\"GovDatabaseService\").find(ServiceUtil.buildBean(\"GovDatabase@isDeleted=0\"))%>">
            			<option value="${db.id}">${db.value2}-${db.value1}</option>
           			 </c:forEach>
         		  </select>
         		</div>
       			<div class="col-sm-4">
                <select data-name="table13" name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select" data-level="2" data-url="${base}/backstage/govTable/listAjax?all=y"
            data-keyField="id" data-valueField="value1" formatter="chosenFormatter"
                  <c:if test="${obj.required==1}" >required</c:if>>
                </select>
                </div>
              </c:when>     
              
               <c:when test="${obj.inputType==14}">
                <div class="col-sm-4">
                  <select name="database14" data-placeholder=" "
           			 data-param="value3" data-bind="select[name='table14']"
            		 class="chosen-select" >
            		<option value=""></option>
            		<c:forEach var="db" items="<%=ServiceUtil.getService(\"GovDatabaseService\").find(ServiceUtil.buildBean(\"GovDatabase@isDeleted=0\"))%>">
            			<option value="${db.id}">${db.value2}-${db.value1}</option>
           			 </c:forEach>
         		  </select>
         		</div>
       			<div class="col-sm-4">
                <select   data-placeholder=" " name="table14"
                  class="chosen-select" data-level="2" data-url="${base}/backstage/govTable/listAjax?all=y"
            formatter="chosenFormatter" data-keyField="id" data-valueField="value1" data-param="value3" data-bind="select[name='value${obj.valueNo}']" >
                </select>
                </div>
                </div>
                <div class="form-group">
         		 <label class="col-sm-3 control-label info-label"  >&nbsp;</label>
          
               <div class="col-sm-8">
                <select  name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select" data-level="3" data-url="${base}/backstage/govTableField/listAjax?all=y"
            formatter="chosenFormatter" data-keyField="id" data-valueField="value1"
                  <c:if test="${obj.required==1}" >required</c:if>>
                </select>
                </div>
              </c:when>                     
              <c:otherwise>
              </c:otherwise>
            </c:choose>
          
        </div>
      </c:forEach>
      
      
<script>
var infoLayer;
function showInfo(id){
    layer.close(infoLayer);
    infoLayer=layer.tips($('.data-info[data-id="'+id+'"]').html(), 'label[data-id="data'+id+'"]',{
        tips: [1, '#999'],
        time: 10000
    });
  }
function chosenFormatter(value,obj,index){
	var str=obj.value1+"-"+obj.value2;
	if(str.length>30){
		str=str.substring(0,30)+"...";
	}
	return str;
}  
</script>