<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
<link href="${base}/static/css/plugins/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${base}/static/css/plugins/webuploader/webuploader.css">
<link rel="stylesheet" type="text/css" href="${base}/static/css/demo/webuploader-demo.css">
<style type="text/css">
.c-list{
cursor: auto !important;
}
.c-list li{
cursor: pointer !important;
}


.data-info{
display:none;
}
.info-label{
cursor: pointer;
}

.webuploader-pick{
background:#18a689;
}
.add-data-box {
	display: none;
}
</style>
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline clearfix">
            <div class="form-group pull-left">    
              <input type="text" placeholder="输入信息资源名称" name="val1" class="form-control col-sm-8"> 
              <div class="btn-group">
              <button type="button" class="btn btn-primary ml5" onclick=" $('#dicList').bootstrapTable('refresh');" style="border-right: rgba(255,255,255,.3);">搜索</button>
              <button type="button" class="btn btn-primary dropdown-toggle dropdown-btn">
                <span class="caret"></span>
              </button>
            </div>
            </div>
            <c:if test="${status==null}">
            <div class="form-group pull-left" style="margin-left: 5px;">
              <div class="text-center">
               <c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/information/resource/index\") %>">
                <a data-toggle="modal" class="btn btn-primary" onclick="addNew();" href="#">自定义</a>
               </c:if>
                <c:if test="<%=!ServiceUtil.havemod(\"/backstage/information/resource/index\") %>">
                <a data-toggle="modal" class="btn btn-primary" onclick="chooseInforRes();" href="#">参考模版</a>
               </c:if>
               <c:if test="<%=!ServiceUtil.haveImp(\"/backstage/information/resource/index\") %>">
                <a data-toggle="modal" class="btn btn-primary" onclick="importFromExcel();" href="#">Excel导入</a>
               </c:if>
                <a data-toggle="modal" class="btn btn-primary" onclick="downloadData();" href="#">导出数据</a>
                <c:set  var="roleid"   value="<%=AccountShiroUtil.getCurrentUser().getRoleId() %>"/>
                <c:if test="${roleid==1}">
                <a data-toggle="modal" class="btn btn-danger" onclick="cleanTable();" href="#">清空所有</a>
                </c:if>
              </div>
            </div>
            </c:if>
            <c:if test="${status!=null}">
            <div class="form-group" style="margin-left: 15px;">
              <div class="text-center">
              <c:if test="<%=!ServiceUtil.haveCheck(\"/backstage/information/resource/index\") %>">
                <a data-toggle="modal" class="btn btn-primary" onclick="statusPass();" href="#">审核通过</a>
                <a data-toggle="modal" class="btn btn-primary" onclick="allPass();" href="#">一键审核</a>
              </c:if>
              </div>
            </div>
            </c:if>
          </div>
             <ul class="dropdown-menu1 dn form-inline clearfix" style="padding-left: 0; margin: 5px 0 0;">
			    <li class="form-group clearfix">	
				  <label class="pull-left">涉及业务：</label>
				  <div class="pull-left" style="width: 200px;">
				  	<select name="val6" data-placeholder=" " class="chosen-select name1 form-control" style="width:350px; display:inline-block;" tabindex="4" required>
	                  <option value=""></option>
	                  <option value="">&nbsp;</option>
	                  <c:forEach var="obj" items="<%=ServiceUtil.getService(\"ItemSortService\").find(ServiceUtil.buildBean(\"ItemSort@isDeleted=0\"),\"id\",\"desc\") %>">
	                  <option value="${obj.id}">${obj.itemName}</option>
	                  </c:forEach>
	                </select>		
				  </div>	                
				</li>
				 <li class="form-group clearfix">	
				  <label class="pull-left">信息资源提供方：</label>
				  <div class="pull-left" style="width: 210px;">
				  <select name="cId" data-placeholder=" " class="chosen-select" style="width:210px; display:inline-block;" tabindex="4" required>
	                 <option value=""></option>
	                 <option value="">&nbsp;</option>
	                 <c:set var="roleid" value="<%=AccountShiroUtil.getCurrentUser().getRoleId() %>"/>
	                 <c:if test="${roleid==1}">
	                 <c:forEach var="obj" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"),\"id\",\"desc\") %>">
	                 <option value="${obj.id}">${obj.companyName}</option>
	                 </c:forEach>
	                 </c:if>
	                 <c:if test="${roleid!=1}">
	                 <c:set var="comid"  scope="session" value="<%=AccountShiroUtil.getCurrentUser().getCompanyId() %>"/>
	                 <c:forEach var="obj" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0&id=\"+session.getAttribute(\"comid\")),\"id\",\"desc\") %>">
	                 <option value="${obj.id}">${obj.companyName}</option>
	                 </c:forEach>
	                 </c:if>
                  </select>		
				  </div>                
				</li>
			    <li class="form-group" style="margin-left: 10px;">			    	    
				<label class="pull-left">共享类型：</label>		
				 <div class="pull-left" style="width: 200px;">  
		          <select name="val8" data-placeholder=" " class="chosen-select name1" style="width:350px;" tabindex="4" required>		            
		            <option value=""></option>
		            <option value="">&nbsp;</option>
		            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"SHARETYPE\") %>">
			        <option value="${obj.dicKey}">${obj.dicValue}</option>
			        </c:forEach>
		          </select>
		        </div>				
			    </li>
			 <!--    <li class="form-group">
				    <div class="form-group">
						<label class="control-label">高级3：</label>
						<input type="text" class="form-control">
					</div>
			    </li> -->
			  </ul>
        </div>
        <table id="dicList">
        </table>
      </div>
    </div>
  </div>
  <div id="layer_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal eform1" id="eform">
     
      <!-- form input封装 -->
     <%@include file="./form.jsp"%>
      <!-- form input封装 结束-->
      <div class="form-group">
          <label class="col-sm-3 control-label info-label" >来源：</label>
          <div class="col-sm-8">
   			 <input type="hidden" name="sourceType"
                    class="form-control edit-hide detail-show"
                    >
             <input type="text" name="sourceTypeForShow"
                    class="form-control edit-hide detail-show"
                    >
          </div>
      </div>    
                    
      <div class="ibox-content" id="dicTree" style="padding-left:0px;padding-right:0px;">
        <div class="btn-group" id="toolbar" role="group" style="margin-bottom:15px;">
          <div class="text-center detail-hide">
            <a data-toggle="modal" class="btn btn-primary" id="addDM" onclick="openDicLayer();" href="#">选择信息项</a>
          </div>
        </div>
      <table id="dm2"></table>
      </div>

 
    </form>
  </div>
  <div id="dic_form" style="display: none;" class="ibox-content">
    <div class="row form-horizontal" style="overflow: hidden;">
      <div class="form-group" style="margin-right: 15px;text-align:right;">
			<a data-toggle="modal" class="btn btn-primary"  href="#" onclick="openDataLayer();"><i class="fa fa-plus"></i>&nbsp;新增数据元</a>				
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">已选择：</label>
        <div class="col-sm-9">      
          <div class="chosen-container chosen-container-multi">
          <ul class="chosen-choices c-list">
          </ul>
          </div>
        </div>
      </div>
      <div class="ibox float-e-margins">
        <div class="ibox-content">
          <div class="form-group">
            <label class="col-sm-2 control-label">对象类</label>
            <div class="col-sm-4">
              <select name="dxl-select" data-placeholder=" " class="chosen-select">
                <option value=""></option>
                <option value="">全部</option>
                <c:forEach var="obj"
                  items="<%=ServiceUtil.getDicByDicNum(\"OBJECTTYPE\")%>">
                <option value="${obj.dicKey}">${obj.dicValue}</option>
                </c:forEach>
              </select>
            </div>
            <div class="col-sm-6">
              <div class="input-group">
                <input type="text" placeholder="输入名称" name="keyword" class="form-control"> <span class="input-group-btn"> <button type="button" onclick=" $('#dm3').bootstrapTable('refresh');" class="btn btn-primary">搜索
                </button> </span>
              </div>
            </div>
          </div>
          <table id="dm3"></table>
        </div>
      </div>
    </div>
  </div>
  
  <!-- 选取模版开始 -->
  <div id="choose-infor-res" style="overflow: hidden;display:none;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <c:set var="list" value="<%=ServiceUtil.getInformationResByLog() %>"/>
        <c:if test="${list!=null&&list.size()>0}">
          <div class="alert alert-success">
          最近操作的信息资源：
            <c:forEach var="res" items="${list}">
            <a class="alert-link search_name" onclick="searchName(this);"  href="#">${res.inforName}</a>&nbsp;&nbsp;
            </c:forEach> 
          </div>
        </c:if>
        <div class="form-group">
          <label class="col-sm-2 control-label" >信息分类：</label>
          <div class="col-sm-4">
            <select name="infoType" data-placeholder=" " class="chosen-select">
              <option value=""></option>
              <option value="">全部</option>
               <c:forEach var="obj" items="<%=ServiceUtil.getService(\"SortManagerService\").find(ServiceUtil.buildBean(\"SortManager@isDeleted=0&level=1&type=3\"))%>">
               <option value="${obj.id}"> ${obj.sortName}</option>
              </c:forEach>
            </select>
          </div>
          <label class="col-sm-2 control-label" >提供方：</label>
          <div class="col-sm-4">
            <select name="infoPro" data-placeholder=" " class="chosen-select">
              <option value=""></option>
              <option value="">全部</option>
              <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"ZYTGF\")%>">
              <option value="${obj.dicKey}"> ${obj.dicValue}</option>
              </c:forEach>
            </select>
          </div>
        </div>
        <div class="clearfix" style="padding:10px;"></div>
        <div class="form-group">
          <div class="col-sm-12">
            <div class="input-group">
              <input type="text" placeholder="输入名称" name="infoName" class="form-control"> <span class="input-group-btn"> <button type="button" onclick=" $('#resList').bootstrapTable('refresh');" class="btn btn-primary">搜索
              </button> </span>
            </div>
          </div>
        </div>
        <div class="clearfix" style="padding:10px;"></div>
        <table id="resList"></table>
      </div>
    </div>
  </div>
  <!-- 选取模版结束 -->
  
  
  <!--查看数据元开始 -->
  <div id="dataElement-detail" class="form-horizontal"
    style="overflow: hidden;display:none;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div class="form-group">
          <label class="col-sm-4 control-label">内部标识符：</label>
          <span class="col-sm-7 dt-span" name="identifier"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">中文名称：</label>
          <span class="col-sm-7 dt-span" name="chName"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">英文名称：</label>
          <span class="col-sm-7 dt-span" name="egName"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">定义：</label>
          <span class="col-sm-7 dt-span" name="define"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">数据类型：</label>
          <span class="col-sm-7 dt-span" name="dataTypeForShow"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">数据长度：</label>
          <span class="col-sm-7 dt-span" name="dataFormat"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">对象类型：</label>
          <span class="col-sm-7 dt-span" name="objectTypeForShow"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">来源部门：</label>
          <span class="col-sm-7 dt-span" name="companyIdForShow"></span>
        </div>
      </div>
    </div>
  </div>
  <!-- 查看数据元结束 -->


  <!--信息资源模版详情开始-->
  <div id="informationRes-detail" class="form-horizontal"
    style="overflow: hidden; display: none;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
      <span  class="dt-span" name="detail_id" style="display:none;"></span>
        <div class="form-group">
          <label class="col-sm-3 control-label">信息资源代码</label> <span
            class="col-sm-7 dt-span" name="inforCode"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">信息资源名称</label> <span
            class="col-sm-7 dt-span" name="inforName"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">信息资源提供方</label> <span
            class="col-sm-7 dt-span" name="value2ForShow"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">信息资源分类</label> <span
            class="col-sm-7 dt-span" name="inforTypesName"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">关联业务</label> <span
            class="col-sm-7 dt-span" name="businessIdForShow"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">信息资源摘要</label> <span
            class="col-sm-7 dt-span" name="inforRemark"></span>
        </div>
        <div class="ibox-content" 
          style="padding-left: 0px; padding-right: 0px;">
          <table data-url="${base}/backstage/dataElement/getDataElementByIRId" data-queryParams="detailQueryParams" data-columns="dataElementColumns" id="mb"></table>
        </div>
      </div>
    </div>
  </div>
  <!--信息资源模版详情结束-->
  
  <!--提示未导入的数据元开始-->
  <div id="notAddedDataElement" class="form-horizontal"
    style="overflow: hidden; display: none;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div class="alert alert-danger">
                 下列数据元无法导入，如需下列数据元，请先导入，待审核通过后即可使用！   
        </div>
        <div class="table-responsive">
          <table class="table table-striped table-hover">
            <tbody>
            </tbody>
          </table>
        </div>
        <div style="text-align:right;padding-right:10px;">
        <button type="button" id="importAll_btn" class="btn btn-primary btn-sm" onclick="importRow(this,1)"><i class="fa fa-download"></i>&nbsp;全部导入</button>
        </div>
      </div>
    </div>
  </div>
  <!--提示未导入的数据元结束-->
  
  <!-- excel导入开始 -->
  <div id="import_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="importForm">
      <div class="form-group" style="padding:10px;">
        <div class="alert alert-info">
                      请先下载信息资源模版，根据模版填写数据。 <a class="alert-link"  href="${base}/upload/excel/managementExcel.xls">Excel模版下载</a>.<br />
                    如导入数据量大，上传请耐心等待！
        </div>
        <div id="uploader-demo">
          <label class="col-sm-3 control-label"></label>
          <div class="col-sm-7">
            <label class="col-sm-3" id="img_label"> </label>
            <div class="col-sm-9" id="filePicker">上传数据文件</div>
          </div>
        </div>
      </div>
      <div class="ibox float-e-margins">
        <div class="ibox-content" id="error-msg">
        </div>
      </div>
    </form>
  </div>  
  <!-- excel导入结束 -->  
  
<!-- 新增数据元 -->		
	<div id="data_form" style="display: none;" class="ibox-content">
		<form method="post" class="form-horizontal" id="dataform"  >
			<input type="hidden" name="id"  class="form-control">
			<input type="hidden" name="idForShow"  class="form-control">
			<input type="hidden" name="identifier"  class="form-control">
			<input type="hidden" name="imported"  class="form-control">
			<input type="hidden" name="sourceId"  class="form-control">
			<input type="hidden" name="fatherId"  class="form-control">	
			<div class="form-group">
				<label class="col-sm-3 control-label">中文名称：</label>
				<div class="col-sm-7">
					<input type="text" name="chName"  class="form-control" required>
				</div>
			</div>			
			<div class="form-group">
				<label class="col-sm-3 control-label">英文名称：</label>
				<div class="col-sm-7">
					<input type="text" name="egName"  class="form-control" >
				</div>
			</div>			
			
			<div class="form-group">
				<label class="col-sm-3 control-label">定义：</label>
				<div class="col-sm-7">
					<input type="text" name="define" class="form-control" >
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label">数据类型：</label>
				<div class="col-sm-7">
					<select name="dataType" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" >
                        <option value=""></option>
                        <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"DATATYPE\") %>">
                        <option value="${obj.dicKey}">${obj.dicValue}</option>
                        </c:forEach>
                 </select>  
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label">数据长度：</label>			
				<div class="col-sm-7">
					<input type="text" name="dataFormat" class="form-control" >
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label">对象类型：</label>
				<div class="col-sm-7">
					<select name="objectType" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
                                    <option value=""></option>
                                    <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"OBJECTTYPE\") %>">
                                    <option value="${obj.dicKey}">${obj.dicValue}</option>
                                    </c:forEach>
                             </select> 
				</div>
			</div>
		   <div class="form-group">
				<label class="col-sm-3 control-label">备注：</label>
				<div class="col-sm-7">
					<input type="text" name="notes" class="form-control" >
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label">来源部门：</label>
				<div class="col-sm-7">
					  <select id="deCompanyId" name="value8" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" >
                             <option value=""></option>
			                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"))%>">
			                  <option value="${obj2.id}">${obj2.companyName}</option>
                            </c:forEach>
                     </select>  
				</div>
			</div>
		</form>
	</div>
<!-- 新增数据元 -->	
	
<!-- 导出数据开始 -->
  <div id="download_div" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="downloadForm">
  	   <c:if test="${MyFunction:getMaxScope(\"/backstage/resource/status/index\")==1}" >
       		<input type="hidden" name="companyId" value="<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>"/>
       </c:if>
       <div class="alert alert-info">
            如导出数据量大，下载请耐心等待！
        </div>
          信息资源字段：<br/>
        <input type="checkbox" name="xlsFields" value="inforTypes"/>  类
        <input type="checkbox" name="xlsFields" value="inforTypes2"/> 项
        <input type="checkbox" name="xlsFields" value="inforTypes3"/> 目
        <input type="checkbox" name="xlsFields" value="inforTypes4"/> 细目 
       <c:forEach var="obj" items="<%=ServiceUtil.getService(\"DataManagerService\").find(ServiceUtil.buildBean(\"DataManager@isDeleted=0\"),\"list_no\",\"asc\")%>">
      	<input type="checkbox" name="xlsFields" value="value${obj.valueNo}"/> ${obj.dataName}
       	
       </c:forEach>
       <br/>
       <br/>
       数据元字段：<br/>
       <c:forEach var="obj" items="<%=ServiceUtil.getService(\"DataElementFieldsService\").find(ServiceUtil.buildBean(\"DataElementFields@isDeleted=0\"),\"list_no\",\"asc\")%>">
       	<input type="checkbox" name="deFields" value="value${obj.valueNo}"/> ${obj.name}
       </c:forEach>
    </form>
  </div>
  <!-- 导出数据结束 -->
	
</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script src="${base}/static/js/plugins/webuploader/webuploader.min.js"></script>
<script>
//验证名称重复
$("input[name='value1']").blur(function (){
  jQuery.post("${base}/backstage/information/resource/validation",{"value1":$("input[name='value1']").val(),"id":$("input[name='id']").val()},function(data){
    data=JSON.parse(data); 
    if(data.results==1){
      layer.msg("信息资源名称已存在，请重新填写");
      $("input[name='value1']").val("");
    }
  });
});

$("input[name='chName']").blur(function (){
	if($(this).val() != ""){
	  jQuery.post("${base}/backstage/govRdataElement/validation",{"classType":1,"chName":$("input[name='chName']").val(),"id":$("input[name='id']").val()},function(data){
	    console.log(data);
		  if(data.results==1){
	    	layer.open({
	    		  content: '此信息项已存在，是否勾选？'
	    		  ,btn: ['是', '否']
	    		  ,yes: function(index, layero){
	    			  
	    			  layer.close(index);
	    			  layer.close(dataLayerIndex);
	    			  
	    			  $('input[name="keyword"]').val($("input[name='chName']").val());
	    			  $('#dm3').bootstrapTable('refresh');
	    			  
	    			  //setTimeout(function () {
		    			  checkData(data.show);
					  //}, 300);
	    			  
	    		  },btn2: function(index, layero){
	    			  $("input[name='chName']").val('');
	    			  $("input[name='egName']").val('');
	    		  },cancel: function(){ 
	    			  $("input[name='chName']").val('');
	    			  $("input[name='egName']").val('');
	    		  }
	    	});
	    }else{
	      $("input[name='egName']").val(data.egName);
	    }
	  },"json");
	}
	});
	
$('.dropdown-btn').on('click', function() {
	$('.dropdown-menu1').toggleClass('dn');
});
$(".name1").chosen({
	  disable_search_threshold: 10,
	  no_results_text: "没有匹配到这条记录",
	  width: "100%"
	});
$("select[name='cId']").chosen({
	  disable_search_threshold: 10,
	  no_results_text: "没有匹配到这条记录",
	  width: "100%"
	});
  var cdata = {"companyId":"<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>"};
  var dicLayerContent = '#dic_form';
  var title_name="信息资源";
  var layerIndex;//layer 窗口对象
  var inforResLayerIndex;//选择模版弹窗
  var layerContent = '#layer_form'; // layer窗口主体内容dom Id
  var tableId = '#dicList';//bootstrap-table id
  var toolbar = '#toolbar';//bootstrap-table 工具栏id
  var formId = '#eform';//form id
  var url = '${base}/backstage/information/resource/';//controller 路径
  var BASE_URL = '${base}/static/js/plugins/webuploader';
  var $list=$("#fileList");
  var gdata = {"groupId":"<%=AccountShiroUtil.getCurrentUser().getGroupId()%>"};
  var uploader;
  var inited=0;
  var dicLayerIndex;
  var checkedIds = ",";
  var checkedEles;
  var dataEles;//存放选中的数据元
  var infoLayer;
  var notLayer;
  function cleanTable(){
        layer.confirm('您确定要清空所有数据么？此操作不可恢复！', {
          btn: ['确定','取消'] //按钮
        }, function(){
          $.post(url+'cleanTable',function(r){
          var result = eval('('+r+')');
            if(result.code && result.code==1){
               $(tableId).bootstrapTable('refresh');
            }
            layer.msg(result.msg);
        });
        }, function(){
        });
  }
  
  function allPass(){
      layer.confirm('您确定要将全部待审核的数据审核通过么？', {
        btn: ['确定','取消'] //按钮
      }, function(){
        $.post(url+'allPass',function(r){
        var result = eval('('+r+')');
          if(result.code && result.code==1){
             $(tableId).bootstrapTable('refresh');
          }
          layer.msg(result.msg);
      });
      }, function(){
      });
  }

  function showInfo(id){
    layer.close(infoLayer);
    infoLayer=layer.tips($('.data-info[data-id="'+id+'"]').html(), 'label[data-id="data'+id+'"]',{
        tips: [1, '#999'],
        time: 10000
    });
  }

  function downLoads(){  
      window.open("${base}/upload/excel/managementExcel.xls");    
  }
  function importFromExcel(){
    $('#importForm').form('clear');
    initUploader();
    $('#importForm').valid();
    layerIndex=layer.open({
      type: 1,
      area: ['60%', '80%'], //宽高
      title: '从Excel导入',
      offset: '0',
      cancel:function(){
        $('#error-msg').html('');
      },
      content: $('#import_form') //这里content是一个DOM
    });
  }
  function initUploader(){
    if(inited==0){
      inited=1;
    }else{
      uploader.destroy();
    }
    uploader = WebUploader.create({
      // 选完文件后，是否自动上传。
      auto: true,
      // swf文件路径
      swf: BASE_URL + '/Uploader.swf',
      // 文件接收服务端。
      server: base+'/backstage/information/resource/importDataElement',
      // 选择文件的按钮。可选。
      // 内部根据当前运行是创建，可能是input元素，也可能是flash.
      pick: '#filePicker',
      // 只允许选择图片文件。
       timeout: 0,
      accept: {
          title: 'Excel',
          extensions: 'xls,xlsx',
          mimeTypes: 'Excel/*'
      }
    });    
    uploader.on( 'fileQueued', function( file ) {
    	var html = '<div class="zz"><p><i class="fa fa-refresh fa-spin" ></i><br><span style="font-size: 14px;font-weight: 700;">拼命上传中</span></p></div>';

        $('.layui-layer').append(html);
      $('#filePicker .webuploader-pick').addClass('grey').html('上传中<i class="fa fa-refresh fa-spin" style="margin-left:10px;"></i>');
      $('input[type="file"]').attr('disabled',true);
    });    
    // 文件上传成功，给item添加成功class, 用样式标记上传成功。
    uploader.on( 'uploadSuccess', function( file,response) {
        console.log(response);
        if(response.res==1){
          layer.close(layerIndex);
          layer.msg('导入成功');
          $(tableId).bootstrapTable('refresh');
        }else{
          $('#error-msg').html('<div class="alert alert-danger">'+response.resMsg+'</div>');
        }
        $('#filePicker .webuploader-pick').removeClass('grey').html('上传数据文件');
        $('input[type="file"]').attr('disabled',false);
        $('.zz').remove();
    });
    // 文件上传失败，显示上传出错。
    uploader.on( 'uploadError', function( file ) {
      layer.msg('上传失败');
        $('#filePicker .webuploader-pick').removeClass('grey').html('上传数据文件');
        $('input[type="file"]').attr('disabled',false);
        $('.zz').remove();
    });
      // 完成上传完了，成功或者失败，先删除进度条。
      uploader.on( 'uploadComplete', function( file ) {
          $( '#'+file.id ).find('.progress').remove();
      });

  }
  //选择模版弹窗
  function chooseInforRes() {
    initChosen();
    inforResLayerIndex = layer.open({
      type : 1,
      area : [ '70%', '80%' ], //宽高
      title : '选择模版',
      scrollbar : false,
      offset : '20px',
      content : $('#choose-infor-res')
    //这里content是一个DOM
    });
  }

  function addNew() {
    checkedIds = ",";
    dataEles=new Array();
    $('#dm2').bootstrapTable('load', {
      rows : []
    });
    openLayer();
    initInfortype();
    initDataElements();
  }

  function getNowFormatDate() {
      var date = new Date();
      var seperator1 = "-";
      var seperator2 = ":";
      var year = date.getFullYear();
      var month = date.getMonth() + 1;
      var strDate = date.getDate();
      if (month >= 1 && month <= 9) {
          month = "0" + month;
      }
      if (strDate >= 0 && strDate <= 9) {
          strDate = "0" + strDate;
      }
      var currentdate = year + seperator1 + month + seperator1 + strDate;
      return currentdate;
  }
  //或许所有数据元
  function initDataElements() {
    //  dataEles = $('#dm2').bootstrapTable('getData').rows;
    initText();
  }

  //加载选中框的内容
  function initText() {
    var ids = checkedIds.split(",");
    checkedEles = new Array();
    if (ids.length) {
      for (var i = 0; i < ids.length; i++) {

        if (ids[i] != "") {
          for (var j = 0; j < dataEles.length; j++) {
            if (ids[i] == dataEles[j].id) {
              checkedEles.push(dataEles[j]);
            }
          }
        }
      }
    }
    if (checkedEles.length) {
      var html = '';
      for (var k = 0; k < checkedEles.length; k++) {
        html += '<li class="search-choice">'
            +'<span onclick="detail(\'' + checkedEles[k].idForShow+'\');">'
            + checkedEles[k].chName + '</span><a class="search-choice-close" onclick="unCheck(\''
            + checkedEles[k].idForShow + '\');"></a></li>';
      }
      $('.c-list').html(html);
    } else {
      $('.c-list').html('');
    }

  }

  //bootstrap-table 列数
  var columns = [ 
  <c:if test="${status!=null}">
   {
    field : 'id',
    title : '<input id="allC" type="checkbox">',
    formatter : 'checkFormatter2',
  }, 
  </c:if>
  <c:forEach var="obj" items="<%=ServiceUtil.getService(\"DataManagerService\").find(ServiceUtil.buildBean(\"DataManager@isDeleted=0\"),\"list_no\",\"asc\")%>">
  <c:if test="${obj.isShow==1}">
  	<c:choose>
  		<c:when test="${obj.inputType==1}">
  		 	{field: 'value${obj.valueNo}',title: '${obj.dataName}',sortable:true,formatter : 'longFormatter'}, 
  		</c:when>
  		<c:when test="${obj.inputType==6}">
  		 	{field: 'value${obj.valueNo}',title: '${obj.dataName}',sortable:true}, 
  		</c:when>
  		<c:otherwise>
  			{field: 'value${obj.valueNo}ForShow',title: '${obj.dataName}'},
      	</c:otherwise>
  	</c:choose>
  </c:if>       
  </c:forEach>
  {
    field : 'status',
    title : '状态',
    formatter : 'statusFormatter',//对本列数据做格式化
  }, {
    field : 'id',
    title : '操作',
    formatter : 'doFormatter',//对本列数据做格式化
  } ];
  
  function longFormatter(value, row, index)
  {
    var html='<span title="'+value+'">';
    if(value.length>10){
      html+=value.substring(0,10)+"...";
    }else{
      html+=value;
    }
    html+='</span>';
    return html;
  }
  
  
  $("#dicList").on("click",'#allC',function(){
      var isChecked = $(this).prop("checked");
      $("input[data-type='plsp']").prop("checked", isChecked);   
  });
  
  function statusPass(){
    var ids = "";
      var c=$("input[data-type='plsp']:checked");
      for(var i=0;i<c.length;i++){
        ids+=","+$(c[i]).attr('data-inforId');
      }
      if(ids!=""){
          $.post(url+'updateStatus',{ids:ids,status:0},function(r){
          var result = eval('('+r+')');
            if(result.code && result.code==1){
               $(tableId).bootstrapTable('refresh');
            }
       
            layer.msg(result.msg);
        });
      }
  }

  //审核选择
  function checkFormatter2(value, row, index) {
    var html = '';
    html += '<input type="checkbox" data-type="plsp" data-inforId="'+value+'" value="' + row.idForShow + '" />';
    return html;
  }

  //得到查询的参数
  var queryParams = function(params) {
    var sort=params.sort;
	var order=params.order;
	if(params.sort==null){
		sort="value2";
		order="asc";
	}
	if($('input[name="val1"]').val()!=null&&$('input[name="val1"]').val()!=""){
		sort="length(trim(value1))";
		order="asc";
	}
    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1,
      sort:sort,
      order:order,
      value1 : $('input[name="val1"]').val(),
      value6: $('select[name="val6"]').val(),
      value8: $('select[name="val8"]').val(),
      value3: $('select[name="cId"]').val(),
      <c:choose>
        <c:when test="${status!=null}">
          status:${status},
        </c:when>
        <c:otherwise>
        <c:if test="${MyFunction:getMaxScope(\"/backstage/information/resource/index\")==1}" >
          companyId:<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>,
        </c:if>
        </c:otherwise>
      </c:choose>
      
    };
    return temp;
  };
  
  //得到查询的参数
  var resQueryParams = function(params) {

    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1,
      value1 : $('input[name="infoName"]').val(),
      inforTypes:$('select[name="infoType"]').val(),
      value2:$('select[name="infoPro"]').val(),
    };
    return temp;
  };

  var queryParams2 = function(params) {

    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      dataManagerId : $('input[name="id"]').val()
    };
    return temp;
  };

  var detailQueryParams = function(params) {

    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      informationResId : $('span[name="detail_id"]').html(),
      status : 0
    };
    return temp;
  };

  var queryParams3 = function(params) {
	  var sort1=null;
	  var order1=null;
	  if($('input[name="keyword"]').val()!=null && $('input[name="keyword"]').val()!=""){
		  sort1='length(trim(value1))';
		  order1='asc';
	  }
    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1,
      sort : sort1,
      order : order1,
      objectType : $('select[name="dxl-select"]').val(),
      //status : 0,
      chName : $('input[name="keyword"]').val(),
      <c:if test="${MyFunction:getMaxScope(\"/backstage/resource/status/index\")==1}" >
       companyId:<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>,
        </c:if>
    };
    return temp;
  };

  $(function() {

    //1.初始化Table
    oTable2 = new TableInit2();
    oTable2.Init();
    oTable3 = new TableInit3();
    oTable3.Init();
    //获取所有数据元
    //initDataElements();
    var resList = new ResList();
    resList.Init();
  });

  var ResList = function() {
    var oTableInit = new Object();
    //初始化Table
    oTableInit.Init = function() {
      $('#resList').bootstrapTable({
        url : '${base}/backstage/information/res/listAjax', //请求后台的URL（*）
        method : 'post', //请求方式（*）
        contentType : "application/x-www-form-urlencoded",
        iconSize : 'outline',
        striped : true, //是否显示行间隔色
        cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        pagination : true, //是否显示分页（*）
        sortable : false, //是否启用排序
        sortOrder : "asc", //排序方式
        queryParams : resQueryParams,//传递参数（*）
        sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
        pageNumber : 1, //初始化加载第一页，默认第一页
        pageSize : 10, //每页的记录行数（*）
        pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
        strictSearch : true,
        clickToSelect : false, //是否启用点击选中行
        uniqueId : "idForShow", //每一行的唯一标识，一般为主键列
        cardView : false, //是否显示详细视图
        detailView : false,
        queryParamsType : "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
        columns : [ {
          field : 'inforCode',
          title : '信息资源代码'
        }, {
          field : 'inforName',
          title : '信息资源名称'
        }, {
          field : 'id',
          title : '操作',
          formatter : 'resListFormatter',//对本列数据做格式化
        } ]
      });
    };
    return oTableInit;
  };

  function resListFormatter(value, row, index) {
    var html = '';
    html += '<div class="btn-group">';
    html += '<button type="button" class="btn btn-white" onclick="detail(\''
        + row.idForShow
        + '\',\'#resList\',\'#informationRes-detail\',1)">查看</button>';
    html += '<button type="button" class="btn btn-white" onclick="chooseIRYes(\''
        + row.idForShow + '\')">选择</button>';
    html += '</div>';
    return html;
  }

  function statusFormatter(value, row, index) {
    var st=['已发布','待审核','审核不通过','已撤回','注销待审核','已注销']
    return st[value];
  }
  //选择模版确认选择事件处理
  function chooseIRYes(id) {
    var data = $('#resList').bootstrapTable('getRowByUniqueId', id);
    layer.close(inforResLayerIndex);
    checkedIds = ",";
    $('#dm2').bootstrapTable('load', {
      rows : []
    });
    openLayer();
    $(formId).form('clear');
    checkedIds = ",";
    $('input[name="value14"]').val(getNowFormatDate());
    $(formId + ' input[name="sourceType"]').val(1);
    $(formId + ' input[name="value1"]').val(data.inforName);
    $(formId + ' input[name="value5"]').val(data.inforRemark);
    
    $(formId + ' select[name="inforTypes"]').val(data.inforTypes);
    $(formId + ' select[name="inforTypes2"]').val(data.inforTypes2);
    $(formId + ' select[name="inforTypes3"]').val(data.inforTypes3);
    $(formId + ' select[name="inforTypes4"]').val(data.inforTypes4);
     $(formId + ' select[name="inforTypes"]').find("option[value='"+data.inforTypes+"']").attr("selected",true);
     $(formId + ' select[name="inforTypes2"]').find("option[value='"+data.inforTypes2+"']").attr("selected",true);
     $(formId + ' select[name="inforTypes3"]').find("option[value='"+data.inforTypes3+"']").attr("selected",true);
     $(formId + ' select[name="inforTypes4"]').find("option[value='"+data.inforTypes4+"']").attr("selected",true);
     var cid=$(formId + ' select[name="inforTypes"]').attr('data-bind');
     $(cid).attr('disabled', false).trigger("chosen:updated")
     var  p = {};
     p[$(formId + ' select[name="inforTypes"]').attr("data-param")] =$(formId + ' select[name="inforTypes"]').val();
     var value=new Array();
     if(data.inforTypes2!=""){
       value.push(data.inforTypes2);
       if(data.inforTypes3!=""){
         value.push(data.inforTypes3);
         if(data.inforTypes4!=""){
           value.push(data.inforTypes4);
         }
       }
     }
     jlChosen(cid,$(cid).attr('data-url'),p,value,true);
     informationResId=data.id;
    jQuery.get(
            "${base}/backstage/govRdataElement/checkDataElementByIRId",
            {
              informationResId : data.id
            },
            function(r) {
              var arr = new Array();
              var html = '';
              r = r.rows;
              for (var i = 0; i < r.length; i++) {
                if (typeof(r[i].imported)!='undefined'&&r[i].imported===1) {
                  arr.push(r[i]);
                  checkedIds+=r[i].id+",";
                } else {
                  html += '<tr><td>'
                      + r[i].identifier
                      + '</td><td>'
                      + r[i].chName
                      + '</td><td>';
                      html+='<button type="button" class="btn btn-white btn-sm" data-id="'+r[i].id+'" data-idForShow="'+r[i].idForShow+'" data-type="importDE" onclick="importRow(this);"><i class="fa fa-download"></i>&nbsp;导入</button>';
                      
                      html +='</td></tr>';
                }
              }
              //initDataElements();
              $(formId + ' input[name="dataElementId"]').val(checkedIds);
              
              //未导入数据元处理
              if (html != '') {
                $('#importAll_btn').show();
                notLayer=layer.open({
                  type : 1,
                  shade : false,
                  area: ['450px', '70%'], //宽高
                   
                  offset: '40px',
                  scrollbar : false,
                  title : '提示', //不显示标题
                  cancel: function(index, layero){ 
                	  jQuery.get("${base}/backstage/govRdataElement/checkDataElementByIRId",{informationResId : data.id},function(r){
                		  var arr = new Array();
                          var html = '';
                          r = r.rows;
                          for (var i = 0; i < r.length; i++) {
                            if (typeof(r[i].imported)!='undefined'&&r[i].imported===1) {
                              arr.push(r[i]);
                              checkedIds+=r[i].id+",";
                            } 
                          }
                          //initDataElements();
                          $(formId + ' input[name="dataElementId"]').val(checkedIds);
                          $('#dm2').bootstrapTable('load', {
                              rows : arr
                            });
                            dataEles=arr;
                            initText();
                	  },'json');
                	  return true; 
                	},
                  content : $('#notAddedDataElement')
                });
                $('#notAddedDataElement tbody').html(html);
              }
              $('#dm2').bootstrapTable('load', {
                rows : arr
              });
              dataEles=arr;
              initText();
            }, "json");

    $(formId).valid();
  }
  
  var informationResId;

  //数据元导入
  function importRow(t,isAll){
    if(typeof(isAll)!="undefined"){
      //全部导入
      var ids=$('button[data-type="importDE"]');
      var str="";
      for(var i=0;i<ids.length;i++){
        var id=$(ids[i]).attr('data-id');        
        str+=id+',';
      }
      jQuery.post("${base}/backstage/govRdataElement/insertList",{"ids":str},function(){
        layer.msg('导入成功');
        layer.close(notLayer);
        jQuery.get("${base}/backstage/govRdataElement/checkDataElementByIRId",{informationResId : informationResId},function(r){
  		  var arr = new Array();
            var html = '';
            r = r.rows;
            for (var i = 0; i < r.length; i++) {
              if (typeof(r[i].imported)!='undefined'&&r[i].imported===1) {
                arr.push(r[i]);
                checkedIds+=r[i].id+",";
              } 
            }
            //initDataElements();
            $(formId + ' input[name="dataElementId"]').val(checkedIds);
            $('#dm2').bootstrapTable('load', {
                rows : arr
              });
              dataEles=arr;
              initText();
  	  	},'json');
        $('button[data-type="importDE"]').hide();
        $('#importAll_btn').hide();
      });
    }else{
      //导入单个
      var id=$(t).attr('data-id');
      
      jQuery.post("${base}/backstage/govRdataElement/insertList",{"ids":id},function(){
        layer.msg('导入成功');
        //layer.close(layerIndex);
        $(t).hide();
      });
    }
  }
  
  var TableInit2 = function() {
    var oTableInit = new Object();
    //初始化Table
    oTableInit.Init = function() {
      $('#dm2').bootstrapTable({
        url : '${base}/backstage/govRdataElement/getDataElementByIRId', //请求后台的URL（*）
        method : 'post', //请求方式（*）
        contentType : "application/x-www-form-urlencoded",
        iconSize : 'outline',
        striped : true, //是否显示行间隔色
        cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        pagination : false, //是否显示分页（*）
        sortable : false, //是否启用排序
        sortOrder : "asc", //排序方式
        queryParams : queryParams2,//传递参数（*）
        sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
        pageNumber : 1, //初始化加载第一页，默认第一页
        pageSize : 10, //每页的记录行数（*）
        pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
        strictSearch : true,
        clickToSelect : false, //是否启用点击选中行
        uniqueId : "idForShow", //每一行的唯一标识，一般为主键列
        cardView : false, //是否显示详细视图
        detailView : false,
        queryParamsType : "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
        columns : dataElementColumns2,
        onLoadSuccess:function(data){
          
          if(typeof(data.rows)!="undefined"){
            dataEles=data.rows;
            initText();
          }
        }
      });
    };
    return oTableInit;
  };

  var dataElementColumns = [{
    field : 'identifier',
    title : '内部资源标识符'
  }, {
    field : 'chName',
    title : '中文名称'
  },{
    field : 'objectTypeForShow',
    title : '对象类型'
  }, {
//    field : 'importedForShow',
//    title : '状态'
//  },{
    field : 'id',
    title : '操作',
    formatter : 'doFormatterDetail',//对本列数据做格式化    
  } ];

  var dataElementColumns2 = [ {
    field : 'identifier',
    title : '内部资源标识符'
  }, {
    field : 'chName',
    title : '中文名称'
  }, {
	    field : 'isShare',
	    title : '是否共享',
	    formatter : 'shareFormatter',//对本列数据做格式化    
	  },  {
    field : 'id',
    title : '操作',
    formatter : 'doFormatter2',//对本列数据做格式化    
  } ];


  
  function shareFormatter(value, row, index) {
	    if(typeof($(formId+' .div_hidden').length)!='undefined'&&$(formId+' .div_hidden').length>0){
	      return row.isShareForShow;
	    }
	    var html = '<div class="checkbox checkbox-success"><input  type="checkbox" name="shareCheckBox" onclick="sharecheck()" ';

	    if(typeof(value)=="undefined"||value===0||value==""){
	      html+=' checked="checked" ';
	    }
	    html+='id="checkbox'+row.id+'" value="'+row.id+'"><label for="checkbox'+row.id+'">共享</label> </div>';
	    return html;
	  }
  function sharecheck()  {
  $('input[name="dataElementId"]').val(checkedIds);
  }
  
  function openDicLayer() {
    $('#dm3').bootstrapTable('refresh');
    dicLayerIndex = layer.open({
      type : 1,
      area : [ '70%', '80%' ], //宽高
      title : '选择信息项',
      scrollbar : false,
      btn : [ '保存', '关闭' ],
      yes : function(index, layero) {
        $('#dm2').bootstrapTable('load', {
          rows : checkedEles
        });
        $('input[name="dataElementId"]').val(checkedIds);
        layer.close(dicLayerIndex);
      },
      offset : '20px',
      content : $(dicLayerContent)
    //这里content是一个DOM
    });
  }
  
	var dataLayerIndex;
	function openDataLayer() {
		$('#dataform').form('clear');
		$('#deCompanyId').val(cdata.companyId);
		$(".chosen-select").trigger("chosen:updated");
		  //initChosen();
		 $('#dataform').valid();
		dataLayerIndex = layer.open({
			type : 1,
			area : [ '50%', '80%' ], //宽高
			title : '新增信息项',
			scrollbar : false,
			btn : [ '保存', '关闭' ],
			yes : function(index, layero) {
				$('#dataform').submit();
			},
			offset : '20px',
			content : $('#data_form')
		});	
	}
	
	$('#dataform').form({
		  url: "${base}/backstage/govRdataElement/insertAjax",
		  onSubmit: function() {
		    return $('#dataform').valid();
		  },
		  success: function(result) {
			  var r = eval('(' + result + ')');
			  var id=r.show;
			   $('#dm3').bootstrapTable('refresh');
			   layer.close(dataLayerIndex);
   			  //setTimeout(function () {
	    			  checkData(id);
				//  }, 300);
		  }
		});
	
	
	
	function deEdit(id){
		openDataLayer();
		layer.title('信息项修改', layerIndex);
		var data=$('#dm3').bootstrapTable('getRowByUniqueId', id);
		$('#dataform').form('load',data);
		$(".chosen-select").trigger("chosen:updated");
		$('#dataform').valid();
	}
	function checkData(idforshow){
		
		//console.log("idforshow",idforshow[0].id);
		checkedIds=","+idforshow[0].id+","+checkedIds;
		dataEles.push(idforshow[0]);
		initDataElements();
		$('#dm3').bootstrapTable('refresh');/*
		setTimeout(function () {	
		    $('input[name="des"]').each(function(){
				if($(this).val()==idforshow){
					if($(this).is(':checked')) {
					}else{
						$(this).trigger('click');
					}
				}
			});
		}, 300);*/
	}
	
	
  var TableInit3 = function() {
    var oTableInit = new Object();
    //初始化Table
    oTableInit.Init = function() {
      $('#dm3').bootstrapTable({
        url : '${base}/backstage/govRdataElement/listAjax', //请求后台的URL（*）
        method : 'post', //请求方式（*）
        contentType : "application/x-www-form-urlencoded",
        iconSize : 'outline',
        striped : true, //是否显示行间隔色
        cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        pagination : true, //是否显示分页（*）
        sortable : false, //是否启用排序
        sortOrder : "asc", //排序方式
        queryParams : queryParams3,//传递参数（*）
        sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
        pageNumber : 1, //初始化加载第一页，默认第一页
        pageSize : 10, //每页的记录行数（*）
        pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
        strictSearch : true,
        clickToSelect : false, //是否启用点击选中行
        uniqueId : "idForShow", //每一行的唯一标识，一般为主键列
        cardView : false, //是否显示详细视图
        detailView : false,
        queryParamsType : "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
        columns : [ {
          field : 'id',
          title : '添加',
          formatter : 'checkFormatter'
        }, {
          field : 'identifier',
          title : '内部资源标识符'
        }, {

          field : 'chName',
          title : '中文名称'
        },{
          field : 'objectTypeForShow',
          title : '对象类型'
        }, {
          field : 'id',
          title : '操作',
          formatter : 'doFormatter3',//对本列数据做格式化    
        } ]
      });
    };
    return oTableInit;
  };

  function checkFormatter(value, row, index) {
    var html = '';
    if (checkedIds.indexOf("," + value + ",") > -1) {
      html += '<input type="checkbox" name="des" data-id="'+value+'" value="' + row.idForShow + '" data-name="'
          + row.chName
          + '" onclick="selectDE(this);" checked="checked"/>';
    } else {
      html += '<input type="checkbox" name="des" data-id="'+value+'" value="' + row.idForShow + '" data-name="'
          + row.chName + '" onclick="selectDE(this);"/>';
    }
    return html;
  }

  function selectDE(t) {
    if ($(t).is(':checked')) {
      checkedIds += $(t).attr('data-id') + ",";
      var data = $('#dm3').bootstrapTable('getRowByUniqueId', $(t).val());
      console.log(data,checkedIds);
      dataEles.push(data);
    } else {
      checkedIds = checkedIds.replace("," + $(t).val() + ",", ",");
      unCheck($(t).val());
    }
    initText();
  }

  function doFormatter2(value, row, index) {
    var html = '';
    html += '<div class="btn-group">';
    if(row.status==4){
      html +='已注销';
    }else{
      html += '<button type="button" class="btn btn-white" onclick="detail(\''
        + row.idForShow + '\',\'#dm2\',\'\')">查看</button>';
    }
    html += '</div>';
    return html;
  }
  
  function doFormatterDetail(value, row, index) {
    var html = '';
    html += '<div class="btn-group">';
    html += '<button type="button" class="btn btn-white" onclick="detail(\''
        + row.idForShow + '\',\'#mb\')">查看</button>';
    html += '</div>';
    return html;
  }

  function doFormatter3(value, row, index) {
    var html = '';
    html += '<div class="btn-group">';
    html += '<button type="button" class="btn btn-white" onclick="detail(\''
        + row.idForShow + '\',\'#dm3\')">查看</button>';
    html += '<button type="button" class="btn btn-white" onclick="deEdit(\''+row.idForShow+'\')">修改</button>';    
    html += '</div>';
    return html;
  }
</script>
<%@include file="../../common/baseSystemJS.jsp"%>
<script type="text/javascript">

function doFormatter(value, row, index)
{
  var html='';
  html+='<div class="btn-group">';
  //待审核
  if(row['status']==1){
    <c:if test="<%=ServiceUtil.isHaveRole(61)%>">
    html+='<button type="button" class="btn btn-white" onclick="openStatusLayerNew(\''+row.id+'\')"><i class="fa fa-eye"></i>&nbsp;发布审核</button>';
    </c:if>
    if(row['groupId']==gdata['groupId']){
      html+='<button type="button" class="btn btn-white" onclick="backRow(\''+row.idForShow+'\')"><i class="fa fa-mail-reply-all"></i>&nbsp;撤回</button>';
    }
  }else if(row['status']==4){
    <c:if test="<%=ServiceUtil.isHaveRole(61)%>">
    html+='<button type="button" class="btn btn-white" onclick="updateStatusRow(\''+row.idForShow+'\',1)"><i class="fa fa-eye"></i>&nbsp;注销审核</button>';
    </c:if>
    if(row['groupId']==gdata['groupId']){
      html+='<button type="button" class="btn btn-white" onclick="backRow(\''+row.idForShow+'\',0)"><i class="fa fa-mail-reply-all"></i>&nbsp;撤回</button>';
    }
  }
  html+='<button type="button" class="btn btn-white" onclick="datailRow(\''+row.idForShow+'\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
  <c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/information/resource/index\") %>">
  html+='<button type="button" class="btn btn-white" onclick="editRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
  </c:if>
  if(row['status']==0){
    html+='<button type="button" class="btn btn-white" onclick="statusAfter(\''+row.idForShow+'\',\''+row.id+'\',\'您确定要注销么？\')"><i class="fa fa-ban"></i>&nbsp;注销</button>';
  }
  
  if(row['status']==2||row['status']==3||row['status']==5){
    html+='<button type="button" class="btn btn-white" onclick="deleteAfter(\''+row.idForShow+'\',\''+ row.id +'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
  }
  
  html+='</div>';
  return html;
}
function statusAfter(idForShow,id,title){
	if(<%=ServiceUtil.isHaveScope(8)%>){
		console.log("statusAfter yesssssss");
		  $.post('${base}/backstage/model/houseModel/isUse',{informationResourceId:id},function(result){ 
			    if(result.code && result.code==1){
			      layer.msg('注销失败！请先删除关联模型库！');
			      }else{
			        backRow(idForShow,4,title);
			    }
			    },'json');
	}else{
		console.log("statusAfter noooooooo");
		backRow(idForShow,4,title);
	}

}

function deleteAfter(idForShow,id){
	if(<%=ServiceUtil.isHaveScope(7)%>){
		console.log("deleteAfter yesssssss");
		  $.post('${base}/backstage/model/houseModel/isUse',{informationResourceId:id},function(result){     
			    if(result.code && result.code==1){
			      layer.msg('删除失败！请先删除关联模型库！');
			      }else{
			        //layer.msg('删除！');
			        deleteRow(idForShow);
			      }

			    },'json');
	}else{
		console.log("deleteAfter noooooooo");
		deleteRow(idForShow);
	}
}

function openDetailLayer(){
  $(formId).form('clear');
  initChosen();
  $(formId).form('load',cdata);
  $(".chosen-select").trigger("chosen:updated");
  $(formId).valid();
  layerIndex=layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '详情',
    scrollbar: false,
    cancel:function(index, layero){
      $('#status_div').html('');
      $(layerContent+' .dt-span').remove();
      $(layerContent+' .div_hidden').removeClass('div_hidden');
    },
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
  });
}
  
function updateStatusRow(id,iszx){
  openStatusLayer(iszx);
  datailRow(id,1);
}

function openStatusLayer(iszx){
  $(formId).form('clear');
  initChosen();
  $(formId).valid();
  layerIndex=layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '详情',
    scrollbar: false,
    btn: ['审核通过','审核不通过'], 
    yes:function(index, layero){
      if(iszx){
        updateStatus(5,'');
      }else{
        updateStatus(0,'');
      }
      $('#status_div').html('');
      $(layerContent+' .dt-span').remove();
      $(layerContent+' .div_hidden').removeClass('div_hidden');
    },
    btn2:function(index, layero){
      var ii=layer.prompt({title: '审核不通过理由', formType: 2}, function(text, index){
          layer.close(index);
          if(iszx){
            updateStatus(0,'');
          }else{
            updateStatus(2,text);
          }
          
      });
      $('#status_div').html('');
      $(layerContent+' .dt-span').remove();
      $(layerContent+' .div_hidden').removeClass('div_hidden');
    },
    cancel:function(index, layero){
      $('#status_div').html('');
      $(layerContent+' .dt-span').remove();
      $(layerContent+' .div_hidden').removeClass('div_hidden');
    },
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
  });
}

function openStatusLayerNew(id){
	 layerIndex=layer.open({
		    type: 2,
		    area: ['70%', '70%'], //宽高
		    title: '详情',
		    scrollbar: false,
		    btn: ['审核通过','审核不通过'], 
		    yes:function(index, layero){
		    	updateStatusNew(id,0,'');
		    },
		    btn2:function(index, layero){
		      var ii=layer.prompt({title: '审核不通过理由', formType: 2}, function(text, index){
		          layer.close(index);
		          updateStatusNew(id,2,text);
		      });
		    },
		    offset: '20px',
		    content: base + '/backstage/information/resource/detail?id=' + id
		  });
}

function openLayer(){
  $(formId).form('clear');
  initChosen();
  $('div .form-group').show();
  $('input[name="value14"]').val(getNowFormatDate());
  $(formId).form('load',cdata);
  $(".chosen-select").trigger("chosen:updated");
  $(formId).valid();
  var ip=$(".edit-hide");
  if(ip.length){
    for(var i=0;i<ip.length;i++){
      if($(ip[i]).prop('tagName')!='DIV'){
        $(ip[i]).parents('div .form-group').hide();
      }else{
        $(ip[i]).hide();
      }
    }
  }
  layerIndex=layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '新增',
    scrollbar: false,
    btn: ['保存','关闭'], 
    yes: function(index, layero){
      $(formId).submit();
    },
    cancel:function(index, layero){
      $('#status_div').html('');
      $(layerContent+' .dt-span').remove();
      $(layerContent+' .div_hidden').removeClass('div_hidden');
    },
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
  });
}

function backRow(id,status,title){
  if(typeof(status)=="undefined"){
    status=3;
  }
  if(typeof(title)=="undefined"){
    title='您确定要撤回提交的操作么？';
  }
  layer.confirm(title, {
      btn: ['确定','取消'] //按钮
    }, function(){
      $.post(url+'updateStatus',{idForShow:id,status:status},function(r){
        var result = eval('('+r+')');
          if(result.code && result.code==1){
            layer.close(layerIndex);
             $(tableId).bootstrapTable('refresh');
          }
          layer.msg(result.msg);
      });
    }, function(){
        
    });
}

function updateStatus(st,text){
  $.post(url+'updateStatus',{idForShow:$('input[name="idForShow"]').val(),status:st,reason:text},function(r){
    var result = eval('('+r+')');
      if(result.code && result.code==1){
        layer.close(layerIndex);
         $(tableId).bootstrapTable('refresh');
      }
      layer.msg(result.msg);
  });
} 

function updateStatusNew(id,st,text){
	  $.post(url+'updateStatus',{id:id,status:st,reason:text},function(r){
	    var result = eval('('+r+')');
	      if(result.code && result.code==1){
	        layer.close(layerIndex);
	         $(tableId).bootstrapTable('refresh');
	      }
	      layer.msg(result.msg);
	  });
	} 
	
function initInfortype(){
	var sel=$('select[name="inforTypes"]').val();
	var html=$('select[name="inforTypes"]').html();
	$('select[name="binforTypes"]').html(html);
	$('select[name="binforTypes"]').find('option[value="'+sel+'"]').remove();
	$('select[name="binforTypes"]').val('');
	$('select[name="binforTypes"]').trigger("chosen:updated");
}	

$('select[name="inforTypes"]').on('change', function(e, params) {
	initInfortype();
	});
	
	

function editRow(id){
  openLayer();
  layer.title('修改', layerIndex);
  var data=$(tableId).bootstrapTable('getRowByUniqueId', id);
  if(data.status==2){
     $('#status_div').html('<div class="alert alert-danger" >审核不通过：'+data.reason+'</div>');
   }else{
     $('#status_div').html('');
   }
  $(formId).form('load',data);
  initInfortype();
  var val=$('select[name="value8"]').val();
  if(val==2){
    $('input[name="value9"]').parents('div .form-group').show();
  }else{
    $('input[name="value9"]').parents('div .form-group').hide();
  }
  
  var val=$('select[name="value11"]').val();
  if(val==1){
    $('input[name="value12"]').parents('div .form-group').show();
  }else{
    $('input[name="value12"]').parents('div .form-group').hide();
  }
  checkedIds=","+data.dataElementIds+",";
  initDataElements();
   $('#dm2').bootstrapTable('refresh',{url:'${base}/backstage/govRdataElement/getDataElementByIRId'});
  //通知chosen下拉框更新
  var cs=$(".chosen-select");
  if(cs.length){
    for(var i=0;i<cs.length;i++){
      if($(cs[i]).attr('data-bind')){
        var cid=$(cs[i]).attr('data-bind');
        var  p = {};
        p[$(cs[i]).attr("data-param")] =$(cs[i]).val();
        initAjaxChosen(cid,$(cid).attr('data-url'),p,data[$(cid).attr('name')]);
      }
    }
  }
  $(".chosen-select").trigger("chosen:updated");
  $(formId).valid();
}

//查看的额外处理覆盖此方法
function doBeforDetail(id,data){
   var ip=$(".detail-show");
    if(ip.length){
      for(var i=0;i<ip.length;i++){
        if($(ip[i]).prop('tagName')!='DIV'){
          $(ip[i]).parents('div .form-group').show();
        }else{
          $(ip[i]).show();
        }
      }
    }
}

//查看的额外处理
function doWithDetail(id,data){
   $('#dm2').bootstrapTable('refresh',{url:'${base}/backstage/govRdataElement/getDataElementByIRId'});
   if(data.status==2){
     $('#status_div').html('<div class="alert alert-danger" >审核不通过：'+data.reason+'</div>');
   }else{
     $('#status_div').html('');
   }
   var val=$('select[name="value8"]').val();
    if(val==2){
      $('input[name="value9"]').parents('div .form-group').show();
    }else{
      $('input[name="value9"]').parents('div .form-group').hide();
    }
    
    var val=$('select[name="value11"]').val();
    if(val==1){
      $('input[name="value12"]').parents('div .form-group').show();
    }else{
      $('input[name="value12"]').parents('div .form-group').hide();
    }
}

function unCheck(id){
  var arr=new Array();
  var ck=",";
  for(var j=0;j<dataEles.length;j++){
    if(dataEles[j].idForShow!=id){
      arr.push(dataEles[j]);
      ck+=dataEles[j].id+",";
    }
  }
  $('#dm3 input[value="'+id+'"]').removeAttr("checked");
  checkedIds =ck;
  dataEles=arr;
  initText();
}

//查看方法 参数（当前行的id,TableId,div,弹窗类型，默认小窗口）
function detail(id,tableId,divId,windowType){
  if(divId&&divId!=''){
  }else{
    divId='#dataElement-detail';
  }
  var data;
  if(typeof(tableId)!="undefined"){
    data=$(tableId).bootstrapTable('getRowByUniqueId', id);
  }else{
    for(var j=0;j<dataEles.length;j++){
      if(dataEles[j].idForShow==id){
        data=dataEles[j];
      }
    }
  }
  var sp=$(divId+' span');
  if(sp.length){
    for(var i=0;i<sp.length;i++){
      if($(sp[i]).attr('name')&&$(sp[i]).attr('name')!=null){
        var nm=$(sp[i]).attr('name');
        if(typeof(data[nm])!="undefined"){
          $(sp[i]).html(data[nm]);
        }
      }
    }
  }
  var tables=$(divId+' table');
  if(typeof(tables.length)!="undefined"){
    $('span[name="detail_id"]').html(data.id);
    for(var i=0;i<tables.length;i++){
      if($(tables[i]).attr('data-url')){   
        initTable(tables[i],$(tables[i]).attr('data-url'), eval($(tables[i]).attr('data-queryParams')),eval($(tables[i]).attr('data-columns')));
      }
    }
  }
  if(windowType){
    layer.open({
    type : 1,
    area : [ '70%', '80%' ], //宽高
    title : '查看',
    scrollbar : false,
    offset : '20px',
    content : $(divId)
    });
  }else{
    layer.open({
        type: 2,
        title: '数据元详情',
        shadeClose: true,
        shade: 0.1,
        area: ['620px', '80%'],
        content: base+'/backstage/dataElement/detail?idForShow='+id
      }); 
  }
}

function initTable(tableId,url,queryParams,columns){
  $(tableId).bootstrapTable('destroy');
  $(tableId).bootstrapTable({
    url : url, //请求后台的URL（*）
    method : 'post', //请求方式（*）
    contentType : "application/x-www-form-urlencoded",
    iconSize : 'outline',
    striped : true, //是否显示行间隔色
    cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
    pagination : false, //是否显示分页（*）
    sortable : false, //是否启用排序
    sortOrder : "asc", //排序方式
    queryParams : queryParams,//传递参数（*）
    sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
    pageNumber : 1, //初始化加载第一页，默认第一页
    pageSize : 10, //每页的记录行数（*）
    pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
    strictSearch : true,
    clickToSelect : false, //是否启用点击选中行
    uniqueId : "idForShow", //每一行的唯一标识，一般为主键列
    cardView : false, //是否显示详细视图
    detailView : false,
    queryParamsType : "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
    columns :columns
  });
}

$('select[name="value8"]').on('change', function(e, params) {
  var val=$(this).val();
  console.log(val);
  if(val==2){
    $('input[name="value9"]').parents('div .form-group').show();
  }else{
    $('input[name="value9"]').parents('div .form-group').hide();
  }
});

$('select[name="value11"]').on('change', function(e, params) {
  var val=$(this).val();
  if(val==1){
    $('input[name="value12"]').parents('div .form-group').show();
  }else{
    $('input[name="value12"]').parents('div .form-group').hide();
  }
});


function searchName(t){
   $('input[name="infoName"]').val($(t).html());
   $('#resList').bootstrapTable('refresh');
}

$(function () {
	$('#dataform').validate( {ignore: ""});
});


$('#downloadForm').form({  
    url: url+'downloadData',  
    success: function(result){ 
    	 
    }  
});
function downloadData(){
	  //$('#downloadForm').form('clear');
	  layerIndex=layer.open({
	    type: 1,
	    area: ['60%', '400px'], //宽高
	    title: '选择导出字段',
	    offset: '100px',
	    btn: ['导出', '关闭'],
	    yes: function(index, layero) {
	    	 $('#downloadForm').submit();
	    	 layer.close(layerIndex);
	    },
	    content: $('#download_div') //这里content是一个DOM
	  });
}

</script>
