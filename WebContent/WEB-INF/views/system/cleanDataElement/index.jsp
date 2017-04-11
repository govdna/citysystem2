<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>

<!DOCTYPE html >
<html lang="en"> 
<head>
<%@include file="../common/includeBaseHead.jsp"%>
 <link rel="stylesheet" type="text/css" href="${base}/static/css/plugins/webuploader/webuploader.css">
   <link rel="stylesheet" type="text/css" href="${base}/static/css/demo/webuploader-demo.css">
<style type="text/css">
.c-list{
cursor: auto !important;
}

.c-list li.search-choice{
padding: 3px 5px 3px 5px !important;

}
.webuploader-pick{
background:#18a689;
}

</style>
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline">
            <div class="form-group">
              <input type="text" placeholder="输入中文名称" name="chN" class="form-control col-sm-8">
              <div class="btn-group">
              <button type="button" class="btn btn-primary ml5" onclick=" $('#dicList').bootstrapTable('refresh');" style="border-right: rgba(255,255,255,.3);">搜索</button>
              <button type="button" class="btn btn-primary dropdown-toggle dropdown-btn">
                <span class="caret"></span>
              </button>
            </div>
            </div>
            <div class="form-group" style="margin-left: 15px;">
              <div class="text-center">
              
				<c:if test="${pubDE==null}">
                <a data-toggle="modal" class="btn btn-primary" onclick="openDicLayer();" href="#">导入数据元</a>
				    <c:set var="roleid"   value="<%=AccountShiroUtil.getCurrentUser().getRoleId() %>"/>
                	<c:if test="${roleid==1}">
                	<a data-toggle="modal" class="btn btn-danger" onclick="deleteAll();" href="#">清空所有</a>
                	</c:if>
				</c:if>
				<c:if test="${pubDE!=null}">
                <a data-toggle="modal" class="btn btn-primary" onclick="openPubLayer();" href="#">添加公共数据元</a>
				</c:if>
				
               
              </div>
            </div>
          </div>
            <ul class="dropdown-menu1 dn form-inline clearfix" style="padding-left: 0; margin: 5px 0 0;">
			    <li class="form-group clearfix">	
				  <label class="pull-left">对象类型：</label>
				  <div class="pull-left" style="width: 200px;">
				  	<select name="obT" data-placeholder=" " class="chosen-select name1 form-control" style=" display:inline-block;width: 100%;" tabindex="4" required>
	                  <option value=""></option>
	                  <option value="">&nbsp;</option>
	                  <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"OBJECTTYPE\") %>">
		              <option value="${obj.dicKey}">${obj.dicValue}</option>
		              </c:forEach>
	                </select>		
				  </div>	                
				</li>
			    <li class="form-group" style="margin-left: 10px;">			    	    
				<label class="pull-left">来源部门：</label>		
				 <div class="pull-left" style="width: 200px;">  
		          <select name="cId" data-placeholder=" " class="chosen-select name1 form-control" style="width: 100%;" tabindex="4" required>		            
		            <option value=""></option>
		            <option value="">&nbsp;</option>
		            <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"))%>">
                    <option value="${obj2.id}">${obj2.companyName}</option>
                    </c:forEach>
		          </select>
		        </div>				
			   </li>
			  </ul>
        </div>
        <table id="dicList">
        </table>
      </div>
    </div>
  </div>

  <div id="layer_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="eform">
      <input type="hidden" name="id"  class="form-control">
      <input type="hidden" name="idForShow"  class="form-control">
      <input type="hidden" name="identifier"  class="form-control">
      <input type="hidden" name="imported"  class="form-control">
      <input type="hidden" name="sourceId"  class="form-control">
      <input type="hidden" name="fatherId"  class="form-control">
       <c:forEach var="obj" items="<%=ServiceUtil.getService(\"DataElementFieldsService\").find(ServiceUtil.buildBean(\"DataElementFields@isDeleted=0\"),\"list_no\",\"asc\")%>">
        <div class="form-group">
          <label class="col-sm-3 control-label info-label"  data-id="data${obj.id}">${obj.name}：</label>
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
              <c:when test="${obj.inputType==5}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.companyName}</option>
                  </c:forEach>
                </select>
              </c:when>
              
              <c:when test="${obj.inputType==15}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"SortManagerService\").find(ServiceUtil.buildBean(\"SortManager@isDeleted=0&type=2\"))%>">
                  <option value="${obj2.sortName}">${obj2.sortCode}</option>
                  </c:forEach>
                </select>
              </c:when>
              
              <c:otherwise>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </c:forEach>
      
      <div class="ibox-content" id="child_div" style="padding-left:0px;padding-right:0px;">
        <div class="btn-group" id="toolbar" role="group" style="margin-bottom:15px;">
          <div class="text-center detail-hide">
            <a data-toggle="modal" class="btn btn-primary" id="addDM" onclick="openSingleLayer();" href="#">选择子数据元</a>
          </div>
        </div>
        <table id="child_table"></table>
      </div>
      
    </form>
  </div>


  <div id="dic_form" style="display: none;" class="ibox-content">
     <form method="post" class="form-horizontal" id="importForm">
       <div class="alert alert-info">
                          将当前搜索结果的每一页数据全部导入。如导入数据量大，请耐心等待。 <a class="alert-link" href="javascript:importAll();" >导入全部</a>.
          </div>
    <div class="row form-horizontal" style="overflow: hidden;">
      <div class="ibox float-e-margins">
        <div class="ibox-content">
         <div class="form-group">
				  <label class="col-sm-2 control-label">来源：</label>
				 <div class="col-sm-4">
				  	<select name="sourceType_sel" data-placeholder=" " class="chosen-select name1 form-control" style="width:350px; display:inline-block;" tabindex="4" required>
	                  <option value=""></option>
	                  <option value="">&nbsp;</option>
	                  <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"SOURCETYPE\") %>">
		              <option value="${obj.dicKey}">${obj.dicValue}</option>
		              </c:forEach>
	                </select>		
				  </div>	        
				    
				 <label class="col-sm-2 control-label">来源部门：</label>		
				 <div class="col-sm-4">		
		          <select name="value8_sel" data-placeholder=" " class="chosen-select name1" style="width:350px;" tabindex="4" required>		            
		            <option value=""></option>
		            <option value="">&nbsp;</option>
		            <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"))%>">
                    <option value="${obj2.id}">${obj2.companyName}</option>
                    </c:forEach>
		          </select>
		        </div>				
			</div>
        
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
    </form>
  </div>



 <!-- 添加公共数据元开始 -->
  <div id="pubDiv" style="display: none;" class="ibox-content">
     <form method="post" class="form-horizontal" id="pubForm">
      
    <div class="row form-horizontal" style="overflow: hidden;">
      <div class="ibox float-e-margins">
        <div class="ibox-content">
         <div class="form-group">
				          
				    
				 <label class="col-sm-2 control-label">来源部门：</label>		
				 <div class="col-sm-4">		
		          <select name="value8_sel_p" data-placeholder=" " class="chosen-select name1" style="width:350px;" tabindex="4" required>		            
		            <option value=""></option>
		            <option value="">&nbsp;</option>
		            <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"))%>">
                    <option value="${obj2.id}">${obj2.companyName}</option>
                    </c:forEach>
		          </select>
		        </div>			
		        
		          <label class="col-sm-2 control-label">对象类</label>
            <div class="col-sm-4">
              <select name="dxl-select_p" data-placeholder=" " class="chosen-select">
                <option value=""></option>
                <option value="">全部</option>
                <c:forEach var="obj"
                  items="<%=ServiceUtil.getDicByDicNum(\"OBJECTTYPE\")%>">
                  <option value="${obj.dicKey}">${obj.dicValue}</option>
                </c:forEach>
              </select>
            </div>	
			</div>
        
          <div class="form-group">
          
            <div class="col-sm-12">
              <div class="input-group">
                <input type="text" placeholder="输入名称" name="keyword_p" class="form-control"> <span class="input-group-btn"> <button type="button" onclick=" $('#pubTable').bootstrapTable('refresh');" class="btn btn-primary">搜索
                </button> </span>
              </div>
            </div>
          </div>
        
          <table id="pubTable"></table>
        </div>
      </div>
    </div>
    </form>
  </div>
 <!-- 添加公共数据元结束 -->



  <!-- 选择子数据元开始 -->
  <div id="single_form" style="display: none;" class="ibox-content">
    <div class="row form-horizontal" style="overflow: hidden;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div class="form-group">
          <label class="col-sm-2 control-label">对象类</label>
          <div class="col-sm-4">
            <select name="dxl-single" data-placeholder=" " class="chosen-select">
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
              <input type="text" placeholder="输入名称" name="keyword-single" class="form-control"> <span class="input-group-btn"> <button type="button" onclick=" $('#single_table').bootstrapTable('refresh');" class="btn btn-primary">搜索
              </button> </span>
            </div>
          </div>
        </div>
        <table id="single_table"></table>
        </div>
      </div>
    </div>
  </div>
  <!-- 选择子数据元结束 -->
</body>
</html>

<%@include file="../common/includeJS.jsp"%>
<script src="${base}/static/js/plugins/webuploader/webuploader.min.js"></script>
<script>

var layerIndex;//layer 窗口对象
var title_name="数据元";
var layerContent='#layer_form';//layer窗口主体内容dom Id
var tableId='#dicList';//bootstrap-table id
var toolbar='#toolbar';//bootstrap-table 工具栏id
var formId='#eform';//form id
var dicLayerContent = '#dic_form';
var dicFormId = '#dicForm';
var url='${base}/backstage/cleanDataElement/';//controller 路径
var checkedIds=",";
var gdata = {"groupId":"<%=AccountShiroUtil.getCurrentUser().getGroupId()%>"};
var cdata = {"companyId":"<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>"};

$('.dropdown-btn').on('click', function() {
	$('.dropdown-menu1').toggleClass('dn');
});

//bootstrap-table 列数
var  columns=[{
    field: 'identifier',
    title: '内部标识符'
}, {
    field: 'chName',
    title: '中文名称',
    formatter: 'longFormatter',
}, {
    field: 'egName',
    title: '英文名称',
    formatter: 'longFormatter',
}, {
    field: 'systemType',
    title: '数据元类型',
    formatter: 'systemTypeFormatter',
}, {
    field: 'id',
    title: '操作',
    formatter: 'doFormatter',//对本列数据做格式化
}];

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

function systemTypeFormatter(value, row, index)
{
  if(typeof(value)!='undefined'&&value==1){
	  return '<span>公共数据元</span>';
  }
  return '<span>专用数据元</span>';
}

  //得到查询的参数
  var queryParams = function(params) {

    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1,
      sort:'identifier',
      order:'asc',
      chName:$('input[name="chN"]').val(),
      value5:$('select[name="obT"]').val(),
      <c:if test="${pubDE!=null}">
      systemType:1,
	  </c:if>
      value8:$('select[name="cId"]').val()
     
    };
    return temp;
  };

  
  $("#dm3").on("click",'#allC',function(){
	    var isChecked = $(this).prop("checked");
	    $("input[name='importDE']").prop("checked", isChecked);   
	});
  

  function openDicLayer() {
    
     $(importForm).form('clear');
     initChosen();
     $('#dm3').bootstrapTable('refresh');
      $(".chosen-select").trigger("chosen:updated");
     dicLayerIndex = layer.open({
      type : 1,
      area : [ '80%', '90%' ], //宽高
      title : '选择导入数据元',
      scrollbar : false,
      btn : [ '导入勾选项', '关闭' ],
      yes : function(index, layero) {
    	  if($('input[name="importDE"]:checked').length>0){
    		  $(importForm).submit();
    	  }
    	 
      },
      cancel:function(index, layero){
    	  submiting=0;
      },
      offset : '20px',
      content : $(dicLayerContent)
    //这里content是一个DOM
    });
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
        columns : [{
          field : 'id',
          title : '<input id="allC" type="checkbox">',
          formatter : 'doFormatter3'
                },{
          field : 'identifier',
          title : '内部资源标识符'
        }, {

          field : 'chName',
          title : '中文名称'
        },{
          field : 'value8ForShow',
          title : '来源部门'
        },{
          field : 'id',
          title : '操作',
          formatter : 'doFormatter5'
        }]
      });
    };
    return oTableInit;
  };

  var queryParams3 = function(params) {

	  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	      rows : params.limit,
	      page : params.offset / params.limit + 1,
	      fatherId:0,
	      imported:0,
	      objectType:$('select[name="dxl-select"]').val(),
	      value8:$('select[name="value8_sel"]').val(),
	      sourceType:$('select[name="sourceType_sel"]').val(),
	      
	      chName:$('input[name="keyword"]').val()
	  };
	  return temp;
	};
	
	
	//导入全部结果
  function importAll(){
		
	  var loadIndex =  layer.load(0, {
		  shade: [0.1,'#fff'] //0.1透明度的白色背景
	  });
	  var tm=$('#dm3').bootstrapTable('getOptions').totalRows/25;
	  if(tm>5){
		  layer.msg('整个导入过程预计需要'+parseInt(tm)+'秒，请耐心等待！', {time: 5000, icon:6});
	  }
	  $.post('${base}/backstage/cleanDataElement/importAll',{fatherId:0,imported:0,objectType:$('select[name="dxl-select"]').val(),value8:$('select[name="value8_sel"]').val(),sourceType:$('select[name="sourceType_sel"]').val(),chName:$('input[name="keyword"]').val()},function(result){
		  if(result.code && result.code==1){
	    		layer.close(dicLayerIndex);
	    		layer.close(loadIndex);
	    		 $(tableId).bootstrapTable('refresh');
	    	}
	    	layer.msg(result.msg);
	  },'json');
  }	
	
  function doFormatter3(value, row, index)
  {
    var html='';
    html+='<div class="btn-group">';
    html+='<input type="checkbox" name="importDE" value="'+row.id+'"/> ';
    html+='</div>';
    return html;
  }
  
  function doFormatter4(value, row, index) {
    var html = '';
    html += '<div class="btn-group">';
    html+='<button type="button" class="btn btn-white" onclick="datailRow(\''+row.idForShow+'\')">查看</button>';
    html+='<button type="button" class="btn btn-white" onclick="unLink(\''+row.idForShow+'\')">解除关系</button>';
    html += '</div>';
    return html;
  }
  
  function doFormatterSee(value, row, index) {
	    var html = '';
	    html += '<div class="btn-group">';
	    html+='<button type="button" class="btn btn-white" onclick="datailRow(\''+row.idForShow+'\')">查看</button>';
	    html += '</div>';
	    return html;
	  }

  function doFormatter5(value, row, index) {
	    var html = '';
	    html += '<div class="btn-group">';
	    html+='<button type="button" class="btn btn-white" onclick="datailRow2(\''+row.idForShow+'\')">查看</button>';
	    html += '</div>';
	    return html;
	  }

  var ChildTableInit = function() {
    var oTableInit = new Object();
    //初始化Table
    oTableInit.Init = function() {
      $('#child_table').bootstrapTable({
        url : '${base}/backstage/cleanDataElement/listAjax', //请求后台的URL（*）
        method : 'post', //请求方式（*）
        contentType : "application/x-www-form-urlencoded",
        iconSize : 'outline',
        striped : true, //是否显示行间隔色
        cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        pagination : false, //是否显示分页（*）
        sortable : false, //是否启用排序
        sortOrder : "asc", //排序方式
        queryParams : childQueryParams,//传递参数（*）
        sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
        pageNumber : 1, //初始化加载第一页，默认第一页
        pageSize : 20, //每页的记录行数（*）
        pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
        strictSearch : true,
        clickToSelect : false, //是否启用点击选中行
        uniqueId : "idForShow", //每一行的唯一标识，一般为主键列
        cardView : false, //是否显示详细视图
        detailView : false,
        queryParamsType : "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
        columns : [{
          field : 'identifier',
          title : '内部资源标识符'
        }, {

          field : 'chName',
          title : '中文名称'
        },{
          field : 'id',
          title : '操作',
          formatter : 'doFormatter4'
        }]
      });
    };
    return oTableInit;
  };

  var childQueryParams = function(params) {

    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : 100,
      page : 1,
      fatherId:$('input[name="id"]').val()
    };
    return temp;
  };
  
  var showChilded=0;
  function showChild(){
    if($('input[name="id"]').val()!=""){
      if(showChilded==0){
        showChilded=1;
        ot4= new ChildTableInit();
        ot4.Init();
      }else{
        $('#child_table').bootstrapTable('refresh');
      }
    }
  }
  
  $(function () {
      //1.初始化Table
      oTable3 = new TableInit3();
      oTable3.Init();
      oTable4 = new PubTableInit();
      oTable4.Init();
  });
  
  $(importForm).form({  
	    url: url+'importList',  
	    onSubmit: function(){
	    	var v=submiting==0;
	    	if(v){
	    		submiting=1;
	    		$('#layui-layer'+dicLayerIndex).find('.layui-layer-btn0').html('导入中...');
	    	}
	    	return v;
	    },
	    success: function(result){ 
	    	var result = eval('('+result+')');
	    	if(result.code && result.code==1){
	    		layer.close(dicLayerIndex);
	    		 $(tableId).bootstrapTable('refresh');
	    	}
	    	submiting=0;
	    	$('#layui-layer'+dicLayerIndex).find('.layui-layer-btn0').html('导入');
	    	layer.msg(result.msg);
	    }  
	});

  

  var SingleTableInit = function() {
    var oTableInit = new Object();
    //初始化Table
    oTableInit.Init = function() {
      $('#single_table').bootstrapTable({
        url : '${base}/backstage/cleanDataElement/listSingle', //请求后台的URL（*）
        method : 'post', //请求方式（*）
        contentType : "application/x-www-form-urlencoded",
        iconSize : 'outline',
        striped : true, //是否显示行间隔色
        cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        pagination : true, //是否显示分页（*）
        sortable : false, //是否启用排序
        sortOrder : "asc", //排序方式
        queryParams : singleQueryParams,//传递参数（*）
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
        columns : [{
          field : 'id',
          title : '<input id="allC-single" type="checkbox">',
          formatter : 'singleFormatter'
                },{
          field : 'identifier',
          title : '内部资源标识符'
        }, {

          field : 'chName',
          title : '中文名称'
        },{
          field : 'value8ForShow',
          title : '来源部门'
        },{
          field : 'id',
          title : '操作',
          formatter : 'doFormatterSee'
        }]
      });
    };
    return oTableInit;
  };

  var singleQueryParams = function(params) {

    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
        rows : params.limit,
        page : params.offset / params.limit + 1,
        status:0,
        objectType:$('select[name="dxl-single"]').val(),
        chName:$('input[name="keyword-single"]').val()
    };
    return temp;
  };

  $("#single_table").on("click",'#allC-single',function(){
      var isChecked = $(this).prop("checked");
      $("input[name='cb-single']").prop("checked", isChecked);   
  });
  
  function checkThis(t){
      var isChecked = $(t).prop("checked");
      if(isChecked){
        checkedIds+=$(t).val()+",";
      }else{
        checkedIds=checkedIds.replace(","+$(t).val()+",",",");
      }
  }

  function singleFormatter(value, row, index) {
    var html='';
    html+='<div class="btn-group">';
    if(row.id!=$('input[name="id"]').val()){
      if(checkedIds.indexOf(","+row.id+",")>-1){
        html+='<input type="checkbox" onclick="checkThis(this);" name="cb-single" value="'+row.id+'" checked="checked"/> ';
      }else{
        html+='<input type="checkbox" onclick="checkThis(this);" name="cb-single" value="'+row.id+'"/> ';
      }
    }
    html+='</div>';
    return html;
  }


  var singleLayerIndex;

  function openSingleLayer() {
    checkedIds = ",";
    $('#single_table').bootstrapTable('refresh');
    singleLayerIndex = layer.open({
      type: 1,
      area: ['70%', '80%'], //宽高
      title: '添加子数据元',
      scrollbar: false,
      btn: ['保存', '关闭'],
      yes: function(index, layero) {
        $('#child_table').bootstrapTable('refresh');


        $.post(base + '/backstage/cleanDataElement/setChild', { id: $('input[name="id"]').val(), ids: checkedIds }, function(result) {
          if (result.code && result.code == 1) {
            layer.close(singleLayerIndex);
            $(tableId).bootstrapTable('refresh');
          }
          $('#child_table').bootstrapTable('refresh');
          layer.msg(result.msg);
        }, 'json');
      },
      offset: '20px',
      content: $('#single_form')

    });
  }
  
  $(function () {
	   
	    ot5=SingleTableInit();
	    ot5.Init();
	});
  
</script>
<%@include file="../common/baseSystemJS.jsp"%>
<script>
function datailRow(id,la){
	layer.open({
	    type: 2,
	    title: '数据元详情',
	    shadeClose: true,
	    shade: 0.1,
	    area: ['620px', '80%'],
	    content: base + '/backstage/cleanDataElement/detail?idForShow=' + id
	  });
}

function datailRow2(id,la){
	layer.open({
	    type: 2,
	    title: '数据元详情',
	    shadeClose: true,
	    shade: 0.1,
	    area: ['620px', '80%'],
	    content: base + '/backstage/govRdataElement/detail?idForShow=' + id
	  });
}

//修改的额外处理覆盖此方法
function doWithEdit(id, data) {
  if (data.fatherId > 0) {
    $('#child_div').hide();
  } else {
    $('#child_div').show();
    showChild();
  }

}

function unLink(id, data){
	layer.confirm('您确定要解除关系么？', {
		  btn: ['确定','取消'] //按钮
		}, function(){
			$.post(base + '/backstage/cleanDataElement/unLink', { idForShow: id }, function(result) {
			    $('#child_table').bootstrapTable('refresh');
		        layer.msg(result.msg);
		      }, 'json');
		}, function(){
		    
		});

}



$('#pubForm').form({  
	    url: url+'updateSystemType',  
	    onSubmit: function(){
	    	var v=submiting==0;
	    	if(v){
	    		submiting=1;
	    		$('#layui-layer'+dicLayerIndex).find('.layui-layer-btn0').html('提交中...');
	    	}
	    	return v;
	    },  
	    success: function(result){ 
	    	var result = eval('('+result+')');
	    	if(result.code && result.code==1){
	    		layer.close(dicLayerIndex);
	    		 $(tableId).bootstrapTable('refresh');
	    	}
	    	submiting=0;
	    	$('#layui-layer'+dicLayerIndex).find('.layui-layer-btn0').html('添加勾选项');
	    	layer.msg(result.msg);
	    }  
	});




function openPubLayer(){
  
   $('#pubForm').form('clear');
   initChosen();
   $('#pubTable').bootstrapTable('refresh');
    $(".chosen-select").trigger("chosen:updated");
   dicLayerIndex = layer.open({
    type : 1,
    area : [ '70%', '90%' ], //宽高
    title : '选择数据元',
    scrollbar : false,
    btn : [ '添加勾选项', '关闭' ],
    yes : function(index, layero) {
  	  if($('input[name="publicDE"]:checked').length>0){
  		  $('#pubForm').submit();
  	  }
  	 
    },
    cancel:function(index, layero){
  	  submiting=0;
    },
    offset : '20px',
    content : $('#pubDiv')
  //这里content是一个DOM
  });
}

$("#pubTable").on("click",'#allP',function(){
    var isChecked = $(this).prop("checked");
    $("input[name='publicDE']").prop("checked", isChecked);   
});


var PubTableInit = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $('#pubTable').bootstrapTable({
      url : '${base}/backstage/cleanDataElement/listUseCount', //请求后台的URL（*）
      method : 'post', //请求方式（*）
      contentType : "application/x-www-form-urlencoded",
      iconSize : 'outline',
      striped : true, //是否显示行间隔色
      cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
      pagination : true, //是否显示分页（*）
      sortable : false, //是否启用排序
      sortOrder : "asc", //排序方式
      queryParams : queryParamsP,//传递参数（*）
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
      columns : [{
        field : 'id',
        title : '<input id="allP" type="checkbox">',
        formatter : 'doFormatterP'
              },{

        field : 'chName',
        title : '中文名称'
      },{
        field : 'counts',
        title : '信息资源使用次数'
      },{
          field : 'companyId',
          title : '涉及部门数量'
        },{
        field : 'id',
        title : '操作',
        formatter : 'doFormatterSee'
      }]
    });
  };
  return oTableInit;
};

function doFormatterP(value, row, index)
{
  var html='';
  html+='<div class="btn-group">';
  html+='<input type="checkbox" name="publicDE" value="'+row.id+'"/> ';
  html+='</div>';
  return html;
}


var queryParamsP = function(params) {

	  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	      rows : params.limit,
	      page : params.offset / params.limit + 1,
	      systemType:0,
	      objectType:$('select[name="dxl-select_p"]').val(),
	      value8:$('select[name="value8_sel_p"]').val(),
	      
	      chName:$('input[name="keyword_p"]').val()
	  };
	  return temp;
	};
	
	
	function deleteAll(){
		  
	      layer.confirm('您确定要清空所有数据么？此操作不可恢复！', {
	        btn: ['确定','取消'] //按钮
	      }, function(){
	        $.post(url+'deleteAll',function(r){
	        var result = eval('('+r+')');
	          if(result.code && result.code==1){
	             $(tableId).bootstrapTable('refresh');
	          }
	          layer.msg(result.msg);
	      });
	      }, function(){
	      });
	}
</script>
