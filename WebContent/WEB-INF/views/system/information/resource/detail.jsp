<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>

<!DOCTYPE html >
<html lang="en"> 
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
<style type="text/css">
.c-list{
cursor: auto !important;
}

.c-list li.search-choice{
padding: 3px 5px 3px 5px !important;

}

.data-info{
display:none;
}
.info-label{
cursor: pointer;
}
.has-change{
border-color: #FF0000;
}
.old-version{
display:none;
}
</style>
</head>
<body class="white-bg">
  <div id="layer_form" class="ibox-content">
  <form method="post" class="form-horizontal" id="eform">
   		 <div class="form-group">
        <label class="col-xs-4 control-label" style="margin-top: 10px;text-align:right;">信息资源分类</label>
        	<c:choose>
        	<c:when test="${oldVersion!=null && oldVersion.inforTypes!=informationResource.inforTypes}">
            			<div class="old-version" data-id="101">
							之前版本：${MyFunction:findServiceValue("SortManagerService","SortManager@isDeleted=0&id=".concat(oldVersion.inforTypes),"sortName")}
       					</div>
            			<span class="col-xs-3 dt-span has-change" onmouseout="layer.close(infoLayer);" onmouseover="showChange(101);" data-id="data101">
            		</c:when>
            		<c:otherwise>
             				<span class="col-xs-3 dt-span">
            		</c:otherwise>
        	
        	</c:choose>
        	${MyFunction:findServiceValue("SortManagerService","SortManager@isDeleted=0&id=".concat(informationResource.inforTypes),"sortName")}
       		 </span>
       		 <span class="col-xs-1">&nbsp;</span>
       		<c:choose>
        	<c:when test="${oldVersion!=null && oldVersion.inforTypes2!=informationResource.inforTypes2}">
            			<div class="old-version" data-id="102">
							之前版本：${MyFunction:findServiceValue("SortManagerService","SortManager@isDeleted=0&id=".concat(oldVersion.inforTypes2),"sortName")}
       					</div>
            			<span class="col-xs-3 dt-span has-change" onmouseout="layer.close(infoLayer);" onmouseover="showChange(102);" data-id="data102">
            		</c:when>
            		<c:otherwise>
             				<span class="col-xs-3 dt-span">
            		</c:otherwise>
        	
        	</c:choose>
        	${MyFunction:findServiceValue("SortManagerService","SortManager@isDeleted=0&id=".concat(informationResource.inforTypes2),"sortName")}
       		 </span>
      </div>
      <div class="form-group">
        <label class="col-xs-4 control-label">&nbsp;</label>
        	<c:choose>
        			<c:when test="${oldVersion!=null && oldVersion.inforTypes3!=informationResource.inforTypes3}">
            			<div class="old-version" data-id="103">
							之前版本：${MyFunction:findServiceValue("SortManagerService","SortManager@isDeleted=0&id=".concat(oldVersion.inforTypes3),"sortName")}
       					</div>
            			<span class="col-xs-3 dt-span has-change" onmouseout="layer.close(infoLayer);" onmouseover="showChange(103);" data-id="data103">
            		</c:when>
            		<c:otherwise>
             				<span class="col-xs-3 dt-span">
            		</c:otherwise>
        	
        	</c:choose>
        	${MyFunction:findServiceValue("SortManagerService","SortManager@isDeleted=0&id=".concat(informationResource.inforTypes3),"sortName")}
       		 </span>
       		 <span class="col-xs-1">&nbsp;</span>
       		<c:choose>
        			<c:when test="${oldVersion!=null && oldVersion.inforTypes4!=informationResource.inforTypes4}">
            			<div class="old-version" data-id="104">
							之前版本：${MyFunction:findServiceValue("SortManagerService","SortManager@isDeleted=0&id=".concat(oldVersion.inforTypes4),"sortName")}
       					</div>
            			<span class="col-xs-3 dt-span has-change" onmouseout="layer.close(infoLayer);" onmouseover="showChange(104);" data-id="data104">
            		</c:when>
            		<c:otherwise>
             				<span class="col-xs-3 dt-span">
            		</c:otherwise>
        	
        	</c:choose>
        	${MyFunction:findServiceValue("SortManagerService","SortManager@isDeleted=0&id=".concat(informationResource.inforTypes4),"sortName")}
       		 </span>
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
        <div class="form-group" data-no="${obj.valueNo}">
          <label class="col-xs-4 control-label info-label" onmouseout="layer.close(infoLayer);" onmouseover="showInfo(${obj.id});" data-id="data${obj.id}" style="margin-top: 10px;text-align:right;">${obj.dataName}：</label>
          <c:choose>
            <c:when test="${obj.inputType==1}">
                <c:choose>
             		<c:when test="${oldVersion!=null&&!oldVersion.equals(informationResource,obj.valueNo)}">
            			<div class="old-version" data-id="${obj.id}">
							之前版本：${oldVersion.getValueByNo(obj.valueNo)}
       					</div>
            			<span class="col-xs-7 dt-span has-change" onmouseout="layer.close(infoLayer);" onmouseover="showChange(${obj.id});" data-id="data${obj.id}">
            		</c:when>
            		<c:otherwise>
             				<span class="col-xs-7 dt-span">
            		</c:otherwise>
            	</c:choose>
            	${informationResource.getValueByNo(obj.valueNo)}</span>
            </c:when>
            <c:when test="${obj.inputType==2}">
             	<c:choose>
             		<c:when test="${oldVersion!=null&&!oldVersion.equals(informationResource,obj.valueNo)}">
            			<div class="old-version" data-id="${obj.id}">
							之前版本：${MyFunction:getDicValue(obj.inputValue,oldVersion.getValueByNo(obj.valueNo))}
       					</div>
            			<span class="col-xs-7 dt-span has-change" onmouseout="layer.close(infoLayer);" onmouseover="showChange(${obj.id});" data-id="data${obj.id}">
            		</c:when>
            		<c:otherwise>
             				<span class="col-xs-7 dt-span">
            		</c:otherwise>
            	</c:choose>
            	${MyFunction:getDicValue(obj.inputValue,informationResource.getValueByNo(obj.valueNo))}</span>      
            </c:when>
            <c:when test="${obj.inputType==3}">
            	<c:choose>
             		<c:when test="${oldVersion!=null&&!oldVersion.equals(informationResource,obj.valueNo)}">
            			<div class="old-version" data-id="${obj.id}">
							
            					之前版本：
            					<c:if test="${oldVersion.getValueByNo(6)!=''}">
            					${MyFunction:findServiceValue("ItemSortService","ItemSort@isDeleted=0&id=".concat(oldVersion.getValueByNo(6)),"itemName")}
            					</c:if>
            				
       					</div>
            			<span class="col-xs-7 dt-span has-change" onmouseout="layer.close(infoLayer);" onmouseover="showChange(${obj.id});" data-id="data${obj.id}" >
            		</c:when>
            		<c:otherwise>
             				<span class="col-xs-7 dt-span">
            		</c:otherwise>
            	</c:choose>
            	<c:if test="${informationResource.getValueByNo(6)!=null}">
            		${MyFunction:findServiceValue("ItemSortService","ItemSort@isDeleted=0&id=".concat(informationResource.getValueByNo(6)),"itemName")}
            	</c:if>
            	</span>      
            </c:when>
            <c:when test="${obj.inputType==4}">
             	<c:choose>
             		<c:when test="${oldVersion!=null&&!oldVersion.equals(informationResource,obj.valueNo)}">
            			<div class="old-version" data-id="${obj.id}">
						之前版本：
						<c:choose>
            				<c:when test="${obj.valueNo=='3'}">
                				${MyFunction:getCompanyNameById(oldVersion.getValueByNo(obj.valueNo))}
            				</c:when>
            				<c:when test="${obj.valueNo=='4'}">
                				${MyFunction:getCompanyCodeById(oldVersion.getValue3())}
            				</c:when>
            				<c:otherwise>
            			 		${oldVersion.getValueByNo(obj.valueNo)}
            				</c:otherwise>
            			</c:choose>
       					</div>
            			
            			<span class="col-xs-7 dt-span has-change" onmouseout="layer.close(infoLayer);" onmouseover="showChange(${obj.id});" data-id="data${obj.id}">
            		</c:when>
            		<c:otherwise>
             				<span class="col-xs-7 dt-span">
            		</c:otherwise>
            	</c:choose>
            	 	<c:choose>
            			
            			<c:when test="${obj.valueNo=='3'}">
                			${MyFunction:getCompanyNameById(informationResource.getValueByNo(obj.valueNo))}
            			</c:when>
            			<c:when test="${obj.valueNo=='4'}">
                			${MyFunction:getCompanyCodeById(informationResource.getValue3())}
            			</c:when>
            			<c:otherwise>
            			 	${informationResource.getValueByNo(obj.valueNo)}
            			</c:otherwise>
            		</c:choose>
            	</span>
            	
            </c:when>
            <c:when test="${obj.inputType==5}">
             	<c:choose>
             		<c:when test="${oldVersion!=null&&!oldVersion.equals(informationResource,obj.valueNo)}">
            			<div class="old-version" data-id="${obj.id}">
							之前版本：${MyFunction:getCompanyNameById(oldVersion.getValueByNo(obj.valueNo))}
       					</div>
            			<span class="col-xs-7 dt-span has-change" onmouseout="layer.close(infoLayer);" onmouseover="showChange(${obj.id});" data-id="data${obj.id}">
            		</c:when>
            		<c:otherwise>
             			<span class="col-xs-7 dt-span">
            		</c:otherwise>
            	</c:choose>
            	${MyFunction:getCompanyNameById(informationResource.getValueByNo(obj.valueNo))}</span>
            </c:when>
            <c:otherwise>
            </c:otherwise>
          </c:choose>
          </div>
        </c:forEach>
        <div class="form-group" data-no="1">
          <label class="col-xs-4 control-label info-label"  style="margin-top: 10px;text-align:right;">来源：</label>
          	<span class="col-xs-7 dt-span">${MyFunction:getDicValue("SOURCETYPE",informationResource.sourceType)}</span>
          </div>
    	 <div class="col-sm-12" style="padding:0px;">
    	<div class="tabs-container">
                    <ul class="nav nav-tabs">
                     	<c:if test="${dataElementList!=null&&dataElementList.size()>0}">
							<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">当前版本信息项</a></li>
                        </c:if>
                        	<li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false">之前版本</a></li>
                      
                    </ul>
                    <div class="tab-content">
                        <div id="tab-1" class="tab-pane active">
                            <div class="panel-body">
                               <c:if test="${dataElementList!=null&&dataElementList.size()>0}">
									<div class="bootstrap-table">
									<div class="fixed-table-toolbar"></div>
									<div class="fixed-table-container" style="padding-bottom: 0px;"><div class="fixed-table-header" style="display: none;"><table></table></div>
									<table  class="table table-hover table-striped">
										<thead><tr><th style="" data-field="identifier" tabindex="0"><div class="th-inner">内部资源标识符</div><div class="fht-cell"></div></th><th style="" data-field="chName" tabindex="0"><div class="th-inner">中文名称</div><div class="fht-cell"></div></th><th style="" data-field="companyIdForShow" tabindex="0"><div class="th-inner">来源部门</div><div class="fht-cell"></div></th><th style="" data-field="companyIdForShow" tabindex="0"><div class="th-inner">是否共享</div><div class="fht-cell"></div></th><th style="" data-field="id" tabindex="0"><div class="th-inner">操作</div><div class="fht-cell"></div></th></tr></thead>
										<tbody>
										<c:forEach var="obj" items="${dataElementList}">
        									<tr><td>${obj.identifier}</td><td>${obj.chName}</td><td>${MyFunction:getCompanyNameById(obj.value8)}</td>
        									<td><c:choose><c:when test="${obj.isShare!=null&&obj.isShare==0}">共享</c:when><c:otherwise>不共享</c:otherwise></c:choose></td>
        								
        									<td><div class="btn-group"><button type="button" class="btn btn-white" onclick="window.parent.dataElementDetail(${obj.id})">查看</button></div></td></tr>
										</c:forEach>
										</tbody></table></div>
									</div>
								</c:if>
                            </div>
                        </div>
                        <div id="tab-2" class="tab-pane">
                            <div class="panel-body">
                               <c:if test="${oldDataElementList!=null&&oldDataElementList.size()>0}">
								<div class="bootstrap-table">
								<div class="fixed-table-toolbar"></div>
								<div class="fixed-table-container" style="padding-bottom: 0px;"><div class="fixed-table-header" style="display: none;"><table></table></div>
								<table  class="table table-hover table-striped">
									<thead><tr><th style="" data-field="identifier" tabindex="0"><div class="th-inner">内部资源标识符</div><div class="fht-cell"></div></th><th style="" data-field="chName" tabindex="0"><div class="th-inner">中文名称</div><div class="fht-cell"></div></th><th style="" data-field="companyIdForShow" tabindex="0"><div class="th-inner">来源部门</div><div class="fht-cell"></div></th><th style="" data-field="companyIdForShow" tabindex="0"><div class="th-inner">是否共享</div><div class="fht-cell"></div></th><th style="" data-field="id" tabindex="0"><div class="th-inner">操作</div><div class="fht-cell"></div></th></tr></thead>
									<tbody>
									<c:forEach var="obj" items="${oldDataElementList}">
        								<tr><td>${obj.identifier}</td><td>${obj.chName}</td><td>${MyFunction:getCompanyNameById(obj.value8)}</td>
        								<td><c:choose><c:when test="${obj.isShare!=null&&obj.isShare==0}">共享</c:when><c:otherwise>不共享</c:otherwise></c:choose></td>
        								
        								<td><div class="btn-group"><button type="button" class="btn btn-white" onclick="window.parent.dataElementDetail(${obj.id})">查看</button></div></td></tr>
									</c:forEach>
									</tbody></table></div>
								</div>
								</c:if>
                            </div>
                        </div>
                    </div>

 				</div>
          </div>
                
    	
		
	 </form>
  </div>
</body>
</html>
<script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
<script src="${base}/static/js/bootstrap.min.js?v=3.3.6"></script>
<!-- layer javascript -->
<script src="${base}/static/js/plugins/layer/layer.js"></script>
<script>
var infoLayer;
function showInfo(id){
    layer.close(infoLayer);
    infoLayer=layer.tips($('.data-info[data-id="'+id+'"]').html(), 'label[data-id="data'+id+'"]',{
        tips: [1, '#999'],
        time: 10000
    });
  }
function showChange(id){
    layer.close(infoLayer);
    infoLayer=layer.tips($('.old-version[data-id="'+id+'"]').html(), 'span[data-id="data'+id+'"]',{
        tips: [1, '#999'],
        time: 10000
    });
  }
</script>

