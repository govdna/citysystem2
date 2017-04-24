<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseHead.jsp"%>
<link href="${base}/static/css/plugins/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css" rel="stylesheet">
 <link rel="stylesheet" type="text/css" href="${base}/static/css/plugins/webuploader/webuploader.css">
   <link rel="stylesheet" type="text/css" href="${base}/static/css/demo/webuploader-demo.css">
</head>
<style>
.c-list{
cursor: auto !important;
}
.c-list li{
cursor: pointer !important;
}
.form_datetime.input-group[class*=col-]{float: left;padding-right: 15px;padding-left: 15px;}
</style>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
   <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline clearfix">
            <div class="form-group pull-left">
               <input type="text" placeholder="输入数据表名称" name="tableN" class="form-control col-sm-8">
              <div class="btn-group ml5">
                <button type="button" class="btn btn-primary" onclick=" $('#dicList').bootstrapTable('refresh');" style="border-right: rgba(255,255,255,.3);">搜索</button>
                <button type="button" class="btn btn-primary dropdown-toggle dropdown-btn">
                  <span class="caret"></span>
                </button>
              </div>
            </div>
          </div>
            <ul class="dropdown-menu1 dn form-inline clearfix" style="padding-left: 0; margin: 5px 0 0;">
			    <li class="form-group clearfix">	
				  <label class="pull-left">责任部门：</label>
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
				<label class="pull-left">所属数据库：</label>		
				 <div class="pull-left" style="width: 200px;">  
		        <select name="datab" data-placeholder=" " class="chosen-select" style="width:210px; display:inline-block;" tabindex="4" required>
	                 <option value=""></option>
	                 <option value="">&nbsp;</option>
	                 <c:forEach var="obj" items="<%=ServiceUtil.getService(\"GovDatabaseService\").find(ServiceUtil.buildBean(\"GovDatabase@isDeleted=0\"),\"id\",\"desc\") %>">
	                 <option value="${obj.id}">${obj.value2}</option>
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
      <c:set var="simpleFields" value="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=GovTable\"),\"list_no\",\"asc\")%>"/>
      <%@include file="../common/simpleFields.jsp"%>
      <div class="ibox-content" style="padding-left:0px;padding-right:0px;">
        <table id="table_fields"></table>
      </div>
    </form>
  </div>
  
  
  
   <!--生成信息资源layer -->  
   <div id="infor_div" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal eform1" id="infor_form">
      <input type="hidden" name="tableId" />
      <input type="hidden" name="companyId" />
      <!-- form input封装 -->
     <%@include file="../information/resource/form.jsp"%>
      <!-- form input封装 结束-->
      
      <div class="ibox-content" id="dicTree" style="padding-left:0px;padding-right:0px;">
        <div class="btn-group" id="toolbar" role="group" style="margin-bottom:15px;">
          <div class="text-center detail-hide">
            <a data-toggle="modal" class="btn btn-primary" id="addDM" onclick="openDicLayer();" href="#">选择信息项</a>
          </div>
        </div>
      <table id="infor_de_table"></table>
      </div>

 
    </form>
  </div>
 <!--生成信息资源layer结束 -->  
 
 
 <!--选择信息项layer --> 
  <div id="dic_form" style="display: none;" class="ibox-content">
    <div class="row form-horizontal" style="overflow: hidden;">
     
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
   <!--选择信息项layer结束 --> 
  

  <div id="sql_div" style="display: none;" class="ibox-content">
    <div id="dicTree" style="padding-left:0px;padding-right:0px;">
        <div class="btn-group" id="toolbar" role="group" style="margin-bottom:15px;">
          <div class="text-center detail-hide">
            <div id="spansql">
              <div class="tab-container-c">
                <nav class="tab-nav clearfix">
                  <a href="javascript:void(0);" class="pull-left active">oracle</a>
              	  <a href="javascript:void(0);" class="pull-left">mySql</a> 
                </nav>
                <div class="tab-wrapper text-left">
                  <div class="item">oracle</div>
                  <div class="item">mySql</div> 
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>
  </div>
  
  <!-- 新增数据元 -->		
	<div id="data_form" style="display: none;" class="ibox-content">
		<form method="post" class="form-horizontal" id="dataform"  >
			<input type="hidden" name="id"  class="form-control">
			<input type="hidden" name="idForShow"  class="form-control">
			<input type="hidden" name="identifier"  class="form-control">
			<input type="hidden" name="imported"  class="form-control">
			<input type="hidden" name="sourceId"  class="form-control">
			<input type="hidden" name="fatherId"  class="form-control">	
			<input type="hidden" name="companyId"  class="form-control">	
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
  
  <!--提示未导入的数据元开始-->
  <div id="notAddedDataElement" class="form-horizontal"
    style="overflow: hidden; display: none;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div class="alert alert-danger">
                 下列数据元还未导入，如需使用下列数据元，请先导入！   
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
  
  
</body>
</html>
<%@include file="../common/includeJS.jsp"%>
<script src="${base}/static/js/plugins/webuploader/webuploader.min.js"></script>
<script>
var userCompanyId = "<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>";
var cdata = {"companyId":userCompanyId};
var layerIndex;//layer 窗口对象
var title_name="数据表";
var layerContent='#layer_form';//layer窗口主体内容dom Id
var tableId='#dicList';//bootstrap-table id
var toolbar='#toolbar';//bootstrap-table 工具栏id
var formId='#eform';//form id
var url='${base}/backstage/govTable/';//controller 路径
var BASE_URL = '${base}/static/js/plugins/webuploader';
var $list=$("#fileList");
var uploader;
var inited=0;
var dicLayerIndex;
var checkedIds = ",";
var checkedEles;
var dataEles;//存放选中的数据元
var dicLayerContent = '#dic_form';
$('.dropdown-btn').on('click', function() {
	$('.dropdown-menu1').toggleClass('dn');
});
$("select[name='cId']").chosen({
  disable_search_threshold: 10,
  no_results_text: "没有匹配到这条记录",
    width: "100%"
});
$("select[name='datab']").chosen({
	  disable_search_threshold: 10,
	  no_results_text: "没有匹配到这条记录",
	    width: "100%"
	});
<%@include file="../common/simpleFieldsColumnsCompany.jsp"%>
  //得到查询的参数
  var queryParams = function(params) {
	var sort=params.sort;
	var order=params.order;
	if($('input[name="tableN"]').val()!=null&&$('input[name="tableN"]').val()!=""){
		sort="length(trim(value2))";
		order="asc";
	}
    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1,
      sort:sort,
      order:order,
      companyId:$('select[name="cId"]').val(),
      value2:$('input[name="tableN"]').val(),
      value3:$('select[name="datab"]').val(),
      <c:if test="${MyFunction:getMaxScope(\"/backstage/govTable/index\")==1}" >
       companyId:<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>,
        </c:if>
    };
    return temp;
  };
  

  
  

  var TableFieldInit = function() {
    var oTableInit = new Object();
    //初始化Table
    oTableInit.Init = function() {
      $('#table_fields').bootstrapTable({
        url: '${base}/backstage/govTableField/listAjax', //请求后台的URL（*）
        method: 'post', //请求方式（*）
        contentType: "application/x-www-form-urlencoded",
        iconSize: 'outline',
        striped: true, //是否显示行间隔色
        cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        pagination: false, //是否显示分页（*）
        sortable: false, //是否启用排序
        sortOrder: "asc", //排序方式
        queryParams: fieldsQueryParams, //传递参数（*）
        sidePagination: "server", //分页方式：client客户端分页，server服务端分页（*）
        pageNumber: 1, //初始化加载第一页，默认第一页
        pageSize: 20, //每页的记录行数（*）
        pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
        strictSearch: true,
        clickToSelect: false, //是否启用点击选中行
        uniqueId: "idForShow", //每一行的唯一标识，一般为主键列
        cardView: false, //是否显示详细视图
        detailView: false,
        queryParamsType: "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
        columns: [{
          field: 'value1',
          title: '字段名'
        }, {

          field: 'value2',
          title: '字段中文名'
        }, {
          field: 'value5',
          title: '类型'
        }, {
            field: 'value6',
            title: '长度'
          }]
      });
    };
    return oTableInit;
  };

  var fieldsQueryParams = function(params) {

	  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	    rows: 100,
	    page: 1,
	    value3: $('input[name="id"]').val()
	  };
	  return temp;
	};

</script>
<%@include file="../common/baseSystemJS.jsp"%>
<script>
var fieldsInited=0;
function initFieldTable(){
	if(fieldsInited==0){
		fieldsInited=1;
		 oTable = new TableFieldInit();
		    oTable.Init();
	}else{
		 $("#table_fields").bootstrapTable('refresh');
	}
}
//修改的额外处理覆盖此方法
function doWithEdit(id,data){
	initFieldTable();
}
//查看的额外处理覆盖此方法
function doWithDetail(id,data){
	initFieldTable();
}
function doFormatter(value, row, index)
{
	var html='';
	html+='<div class="btn-group">';
	html+='<button type="button" class="btn btn-white" onclick="datailRow(\''+row.idForShow+'\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
	html+='<button type="button" class="btn btn-white" id="edit"  onclick="editRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
	html+='<button type="button" class="btn btn-white" onclick="deleteRow(\''+row.idForShow+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
	if(typeof(row.inforResId)=="undefined"||row.inforResId==""){
		html+='<button type="button" class="btn btn-white" onclick="checkFields('+row.id+',\''+row.idForShow+'\')"><i class="fa fa-paper-plane-o"></i>&nbsp;生成信息资源</button>';
	}
	if(row.inforResId!==""){
		html+='<button type="button" class="btn btn-white" onclick="updateFields('+row.id+',\''+row.inforResId+'\')"><i class="fa fa-paper-plane-o"></i>&nbsp;更新信息资源</button>';
	}
	html+='<button type="button" class="btn btn-white" onclick="createSql('+row.id+')"><i class="fa fa-paper-plane-o"></i>&nbsp;生成sql</button>';
	html+='</div>';
	return html;
}

function createSql(id){

	var data=$(tableId).bootstrapTable('getRowByUniqueId', id);
	  jQuery.post(url+"createSql",{"id":id},function(data){
		     console.log(data.oracle);

			layerIndex=layer.open({
			  type: 1,
			  area: ['70%', '70%'], //宽高
			  title: 'sql',
			  offset: '20px',
			  btn: ['下载'], 
			  yes: function(index, layero){
				  var types=$('.pull-left.active').html();
				  
				    var elemIF = document.createElement("iframe");     
				    elemIF.src = "${base}/upload/excel/"+types+"-"+data.tables+".sql";    
				    elemIF.style.display = "none";     
				    document.body.appendChild(elemIF);  
			  },
			  cancel:function(index, layero){				 
			  },
			  content: $('#sql_div') //这里content是一个DOM
			});
      var reg = /(,|;)/gi
      // var reg = /(\\n)*/gi
      data.oracle = data.oracle.replace(reg, '$1<br>');
      data.oracle = data.oracle.replace('"ID" NUMBER(12) NOT NULL', '<br>"ID" NUMBER(12) NOT NULL');
      data.oracle = data.oracle.replace('PRIMARY KEY ("ID")', 'PRIMARY KEY ("ID")<br> ');
      data.mySql = data.mySql.replace(reg, '$1<br>');
      data.mySql = data.mySql.replace('`id` int(12) NOT NULL', '<br>`id` int(12) NOT NULL');
      data.mySql = data.mySql.replace('PRIMARY KEY (`id`)', 'PRIMARY KEY (`id`)<br> ');
      $("#spansql .tab-wrapper .item").eq(0).html(data.oracle);
			$("#spansql .tab-wrapper .item").eq(1).html(data.mySql);
	  },'json');
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


var layerIndex;
var notLayer;
var tableId_im;
var tableUnId_im;
function checkFields(id,unid){
	tableId_im=id;
	tableUnId_im=unid;

	 jQuery.get("${base}/backstage/govTableField/listAjax",{value3 : id},function(r){
		 var html = '';
         r = r.rows;
         for (var i = 0; i < r.length; i++) {
           if (typeof(r[i].dataElementId)=='undefined'||r[i].dataElementId==='') {
             	html += '<tr><td>'
                 + r[i].value1
                 + '</td><td>'
                 + r[i].value2
                 + '</td><td>';
                 html+='<button type="button" class="btn btn-white btn-sm" data-id="'+r[i].id+'" data-idForShow="'+r[i].idForShow+'" data-type="importDE" onclick="importRow(this);"><i class="fa fa-download"></i>&nbsp;导入</button>';
                 
                 html +='</td></tr>';
           }
         }
         
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
            	 import2InfoRes(id,unid);
           	  return true; 
           	},
             content : $('#notAddedDataElement')
           });
           $('#notAddedDataElement tbody').html(html);
         }else{
        	 import2InfoRes(id,unid);
         }
		 
	 },'json');
}
//生成信息资源
function import2InfoRes(id,unid){
	$('#infor_form').form('clear');
	initChosen('#infor_form');
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

	$('input[name="tableId"]').val(id);
	$('input[name="value14"]').val(getNowFormatDate());
	 var data = $(dicList).bootstrapTable('getRowByUniqueId', unid);
	$('input[name="companyId"]').val(data.companyId);
	$('input[name="value3"]').val(data.companyId);
    $('#infor_form input[name="value1"]').val(data.value2);
    $('#infor_form').valid();
	checkedIds = ",";
	dataEles=new Array();
	initDETable();
	layerIndex=layer.open({
	      type: 1,
	      area: ['70%', '80%'], //宽高
	      title: '生成信息资源',
	      offset: '20px',
	      scrollbar: false,
		  btn: ['保存','关闭'], 
		  yes: function(index, layero){
			  $('#infor_form').submit();
		  },
		  cancel:function(index, layero){
			 
		  },
	      content: $('#infor_div') //这里content是一个DOM
	    });		
}

$(function () {
	oTable3 = new TableInit3();
	oTable3.Init();
    $('#infor_form').validate( {ignore: ""});
});

$('#infor_form').form({  
    url: '${base}/backstage/information/resource/insertAjax',  
    onSubmit: function(){
    	var v=$('#infor_form').valid()&&submiting==0;
    	if(v){
    		submiting=1;
    		$('#layui-layer'+layerIndex).find('.layui-layer-btn0').html('保存中...');
    	}
    	return v;
    },  
    success: function(result){ 
    	var result = eval('('+result+')');
    	if(result.code && result.code==1){
    		layer.close(layerIndex);
    		 $(tableId).bootstrapTable('refresh');
    	}
    	submiting=0;
    	$('#layui-layer'+layerIndex).find('.layui-layer-btn0').html('保存');
    	layer.msg(result.msg);
    }  
});



var DETableFInit = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $('#infor_de_table').bootstrapTable({
      url: '${base}/backstage/govRdataElement/getDataElementListByTableId', //请求后台的URL（*）
      method: 'post', //请求方式（*）
      contentType: "application/x-www-form-urlencoded",
      iconSize: 'outline',
      striped: true, //是否显示行间隔色
      cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
      pagination: false, //是否显示分页（*）
      sortable: false, //是否启用排序
      sortOrder: "asc", //排序方式
      queryParams: deQueryParams, //传递参数（*）
      sidePagination: "server", //分页方式：client客户端分页，server服务端分页（*）
      pageNumber: 1, //初始化加载第一页，默认第一页
      pageSize: 20, //每页的记录行数（*）
      pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
      strictSearch: true,
      clickToSelect: false, //是否启用点击选中行
      uniqueId: "idForShow", //每一行的唯一标识，一般为主键列
      cardView: false, //是否显示详细视图
      detailView: false,
      queryParamsType: "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
	  onLoadSuccess:function(data){
		  checkedIds=",";
          if(typeof(data.rows)!="undefined"){
            dataEles=data.rows;
            for(var i=0;i<dataEles.length;i++){
            	checkedIds+=dataEles[i].id+",";
            }
            $('input[name="dataElementId"]').val(checkedIds);
            initText();
          }
        },

      columns: [{
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
    	  }]
    });
  };
  return oTableInit;
};


function shareFormatter(value, row, index) {
	 
  var html = '<div class="checkbox checkbox-success"><input  type="checkbox" name="shareCheckBox" ';
  if(typeof(value)=="undefined"||value===0||value==""){
	 html+=' checked="checked" ';
  }
  html+='id="checkbox'+row.id+'" value="'+row.id+'"><label for="checkbox'+row.id+'">共享</label> </div>';
	   
  return html;
}

function updateFields(tid,inid){
	 $.ajax({
         type: "GET",
         url: url+"updateFields",
         data: {value1:tid, value2:inid},
         dataType: "json",
         success: function(data){
        	 if(data.status==0){
                     layer.msg("更新成功!");
        	 }
        }
     });
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
    if(row.companyId==userCompanyId){
    	html += '<button type="button" class="btn btn-white" onclick="deEdit(\''
            + row.idForShow + '\',0)">编辑</button>';
    }
    html += '</div>';
    return html;
  }
function doFormatter22(value, row, index) {
    var html = '';
    html += '<div class="btn-group">';
    if(row.status==4){
      html +='已注销';
    }else{
      html += '<button type="button" class="btn btn-white" onclick="detail(\''
        + row.idForShow + '\',\'#dm2\',\'\')">查看</button>';
    }
    if(row.companyId==userCompanyId){
    	html += '<button type="button" class="btn btn-white" onclick="deEdit(\''
            + row.idForShow + '\',1)">编辑</button>';
    }
    html += '</div>';
    return html;
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
		   $('#infor_de_table').bootstrapTable('refresh');
		   $('#dm3').bootstrapTable('refresh');
		   layer.close(dataLayerIndex);
			  //setTimeout(function () {
    			  //checkData(id);
			//  }, 300);
	  }
	});
function deEdit(id,i){
	openDataLayer();
	layer.title('信息项修改', layerIndex);
	if(i==0){
		var data=$('#infor_de_table').bootstrapTable('getRowByUniqueId', id);
	}else {
		var data=$('#dm3').bootstrapTable('getRowByUniqueId', id);
	}
	$('#dataform').form('load',data);
	$(".chosen-select").trigger("chosen:updated");
	$('#dataform').valid();
}
function checkData(idforshow){
	
	//console.log("idforshow",idforshow[0].id);
	checkedIds=","+idforshow[0].id+","+checkedIds;
	dataEles.push(idforshow[0]);
	initDataElements();
	$('#infor_de_table').bootstrapTable('refresh');
	$('#dm3').bootstrapTable('refresh');
}



var deQueryParams = function(params) {

	  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	    rows: 100,
	    page: 1,
	    id: $('input[name="tableId"]').val()
	  };
	  return temp;
	};
	
var deInited=0;
function initDETable(){
	if(deInited==0){
		deInited=1;
		 oTable = new DETableFInit();
		    oTable.Init();
	}else{
		 $("#infor_de_table").bootstrapTable('refresh');
	}
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
        $('#infor_de_table').bootstrapTable('load', {
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
      }, {
        field : 'id',
        title : '操作',
        formatter : 'doFormatter22',//对本列数据做格式化    
      } ]
    });
  };
  return oTableInit;
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
    jQuery.post("${base}/backstage/govTable/fields2DataElement",{"id":str},function(){
      layer.msg('导入成功');
      layer.close(notLayer);
      $('button[data-type="importDE"]').hide();
      $('#importAll_btn').hide();
 	 import2InfoRes(tableId_im,tableUnId_im);
    });
  }else{
    //导入单个
    var id=$(t).attr('data-id');
    
    jQuery.post("${base}/backstage/govTable/fields2DataElement",{"id":id},function(){
      layer.msg('导入成功');
      //layer.close(layerIndex);
      $(t).hide();
    });
  }
}

//选中信息项
function selectDE(t) {
  if ($(t).is(':checked')) {
    checkedIds += $(t).attr('data-id') + ",";
    var data = $('#dm3').bootstrapTable('getRowByUniqueId', $(t).val());
    dataEles.push(data);
  } else {
    checkedIds = checkedIds.replace("," + $(t).val() + ",", ",");
    unCheck($(t).val());
  }
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
      html += '<li class="search-choice" onclick="detail(\''
          + checkedEles[k].idForShow + '\');"><span>'
          + checkedEles[k].chName + '</span><a class="search-choice-close" onclick="unCheck(\''
          + checkedEles[k].idForShow + '\');"></a></li>';
    }
    $('.c-list').html(html);
  } else {
    $('.c-list').html('');
  }

}

//选择信息项取消选中
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
	  event.stopPropagation();
}
	
//查看数据元方法 
function detail(id){
  
    layer.open({
        type: 2,
        title: '数据元详情',
        shadeClose: true,
        shade: 0.1,
        area: ['620px', '80%'],
        content: base+'/backstage/dataElement/detail?idForShow='+id
      }); 
  
}
//获得当前日期
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

// tab
$('.tab-container-c .tab-nav a').on('click', function () {
  var index = $(this).index();
  $(this).addClass('active').siblings().removeClass('active');
  $('.tab-container-c .tab-wrapper .item').eq(index).show().siblings().hide();
});
</script>