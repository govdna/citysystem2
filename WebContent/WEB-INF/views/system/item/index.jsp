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
<style type="text/css">
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
          <div class="form-inline clearfix">
            <div class="form-group pull-left">
              <input type="text" placeholder="输入事项名称" name="itemN" class="form-control col-sm-8">
              <div class="btn-group ml5">
                <button type="button" class="btn btn-primary" onclick=" $('#dicList').bootstrapTable('refresh');" style="border-right: rgba(255,255,255,.3);">搜索</button>
                <button type="button" class="btn btn-primary dropdown-toggle dropdown-btn">
                  <span class="caret"></span>
                </button>
              </div>
            </div>
            <div class="form-group pull-left" style="margin-left: 5px;">
              <div class="text-center">
              <c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/itemSort/index\") %>">
                <a data-toggle="modal" class="btn btn-primary" onclick="addNew();" href="#">新增</a>
              </c:if>
              <c:if test="<%=!ServiceUtil.haveImp(\"/backstage/itemSort/index\") %>">
                <a data-toggle="modal" class="btn btn-primary" onclick="importFromExcel();" href="#">Excel导入</a>
                <a data-toggle="modal" class="btn btn-primary" onclick="downloadData();" href="#">导出数据</a>
              </c:if>
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
				<label class="pull-left">服务内容：</label>		
				 <div class="pull-left" style="width: 200px;">  
		          <select name="serC" data-placeholder=" " class="chosen-select name1" style="width:350px;" tabindex="4" required>		            
		            <option value=""></option>
		            <option value="">&nbsp;</option>
		            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"SERCONTENT\") %>">
		            <option value="${obj.dicKey}">${obj.dicValue}</option>
		            </c:forEach>
		          </select>
		        </div>				
			    </li>
			  </ul>
          </div>
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
      <div class="form-group">
        <label class="col-sm-3 control-label">事项名称：</label>
        <div class="col-sm-7">
          <input type="text" name="itemName"  class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">服务对象分类：</label>
        <div class="col-sm-7">
          <select name="serObjSort" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"SEROBJSORT\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>  
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">服务内容：</label>
        <div class="col-sm-7">
          <select name="serContent" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"SERCONTENT\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">前置审批事项：</label>
        <div class="col-sm-7">
          <select name="preApprovalMatter" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" >
            <option value=""></option>
            <option value="">&nbsp;</option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"ItemSortService\").find(ServiceUtil.buildBean(\"ItemSort@isDeleted=0\"),\"id\",\"desc\") %>">
            <option value="${obj.id}">${obj.itemName}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">时限：</label>
        <div class="col-sm-7">
        <select name="deadline" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
          <option value=""></option>
          <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"DEADLINE\") %>">
          <option value="${obj.dicKey}">${obj.dicValue}</option>
          </c:forEach>
        </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">责任部门：</label>
        <div class="col-sm-7">
          <select name="companyId" data-placeholder=" " data-param="companyId" class="chosen-select" data-bind="select[name='groupId']"required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"),\"id\",\"desc\") %>">
            <option value="${obj.id}">${obj.companyName}</option>
            </c:forEach>                          
          </select> 
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">所需证件名称：</label>
        <div class="col-sm-7">
          <input type="text" name="certificateName" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">办件结果文件类型：</label>
        <div class="col-sm-7">
          <select name="fileType" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"FILETYPE\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">办件结果文件名称：</label>
        <div class="col-sm-7">
          <input type="text" name="fileName"  class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">是否有应用系统支撑：</label>
        <div class=" pull-left" style="margin-left:10px;width:250px;">      
          <select id="yesorno" name="yesorno" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <option value="1">是</option>
            <option value="0">否</option>
          </select> 
        </div>
      </div>
      <div class="form-group"  id="asd" style="display: none;">
        <label class="col-sm-3 control-label">业务应用系统名称：</label>
        <div class="col-sm-7">
          <select name="busSystem" id="busSystem" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" >
            <option value=""></option>
            <option value="">&nbsp;</option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"GovApplicationSystemService\").find(ServiceUtil.buildBean(\"GovApplicationSystem@isDeleted=0\"),\"id\",\"desc\") %>">
            <option value="${obj.id}">${obj.value2}</option>
            </c:forEach>
          </select> 
        </div>
      </div>
      <div class="add-box">
        <div class="form-group detail-hide">
          <label class="col-sm-3 control-label">申请材料：</label>
          <div class="col-sm-2">
            <button class="btn btn-primary btn-block hook-btn-add" type="button" style="margin-top: 5px;">添加</button>
          </div>
        </div>
      </div>
    </form>
  </div>
  <!-- excel导入开始 -->
  <div id="import_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="importForm">
      <div class="form-group" style="padding:10px;">
        <div class="alert alert-info">请先下载业务事项模版，根据模版填写数据。
         <a class="alert-link"  href="${base}/upload/excel/itemsortExcel.xlsx">Excel模版下载</a>.<br /> 如导入数据量大，上传请耐心等待！
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
        <div class="ibox-content" id="error-msg"></div>
      </div>
    </form>
  </div>
  <!-- excel导入结束 -->
  
  <!-- 导出数据开始 -->
  <div id="download_div" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="downloadForm">
  	   <c:if test="${MyFunction:getMaxScope(\"/backstage/resource/status/index\")==1}" >
       		<input type="hidden" name="companyId" value="<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>"/>
       </c:if>
       <div class="alert alert-info">
            如导出数据量大，下载请耐心等待！
        </div>
        <input type="checkbox" name="xlsFields" value="itemName"/>  事项名称
        <input type="checkbox" name="xlsFields" value="serObjSort"/> 服务对象分类
        <input type="checkbox" name="xlsFields" value="serContent"/> 服务内容
        <input type="checkbox" name="xlsFields" value="preApprovalMatter"/> 前置审批事项
        <input type="checkbox" name="xlsFields" value="deadline"/>  时限
        <input type="checkbox" name="xlsFields" value="companyId"/> 责任部门
        <input type="checkbox" name="xlsFields" value="certificateName"/> 所需证件名称
        <br>
        <input type="checkbox" name="xlsFields" value="fileType"/> 办件结果文件类型
        <input type="checkbox" name="xlsFields" value="fileName"/>  办件结果文件名称
        <input type="checkbox" name="xlsFields" value="yesorno"/> 是否有应用系统支撑
        <input type="checkbox" name="xlsFields" value="busSystem"/> 业务应用系统名称
        <input type="checkbox" name="xlsFields" value="applicationMaterial"/> 申请材料
    </form>
  </div>
  <!-- 导出数据结束 -->
  
</body>
</html>

<%@include file="../common/includeJS.jsp"%>
<script src="${base}/static/js/plugins/webuploader/webuploader.min.js"></script>

<script>
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
var inited=0;
var formId='#eform';//form id
var BASE_URL = '${base}/static/js/plugins/webuploader';
$(function(){
	$(document).delegate('#edit', 'click', function() {
		var theValue= $('select[name="yesorno"]').val()
		if(theValue==1){
			$('#asd').show();
		}else{
			$('#asd').hide();
			$("#busSystem").val("");
		}
		console.log('theValue:'+theValue);
	})

	$('select[name="yesorno"]').on('change', function(e, params) {
		var val=$(this).val();
		if(val==1){
			$('#asd').show();
		}else{
			$('#asd').hide();
			$("#busSystem").val("");
		}
		console.log("AAA="+val)
	});
})

$(function() {
  var html = '<div class="form-group aml">'+
                '<label class="col-sm-3 control-label">申请材料：</label>'+
                '<div class="col-sm-5">'+
                  '<input type="text" name="applicationMaterials" class="form-control" style="margin-top:5px;"></div>'+
                  '<div class="col-sm-2">'+
                    '<button class="btn btn-primary btn-block hook-btn-del" type="button" style="margin-top: 5px;">删除</button>'+
                  '</div>'+
              '<div>';

    $('.hook-btn-add').on('click', function() {
      $('.add-box').append(html);
    });
    $(document).delegate('.hook-btn-del', 'click', function(event) {
      $(this).parent().parent().remove();
    });
  });

  //验证名称重复
$("input[name='itemName']").blur(function (){
	jQuery.post("${base}/backstage/itemSort/validation",{"itemName":$("input[name='itemName']").val(),"id":$("input[name='id']").val()},function(data){
		data=JSON.parse(data); 
		if(data.results==1){
			layer.msg("事项名称已存在，请重新填写");
			$("input[name='itemName']").val("");
		}
	});
});

var layerIndex; //layer 窗口对象
var title_name="业务事项";
var layerContent='#layer_form'; //layer窗口主体内容dom Id
var tableId='#dicList'; //bootstrap-table id
var toolbar='#toolbar'; //bootstrap-table 工具栏id
var formId='#eform'; //form id
var datailContent='#layer_form'; //layer窗口主体内容dom Id
var datailId='#eform'; //form id
var url='${base}/backstage/itemSort/';//controller 路径

//bootstrap-table 列数
var  columns=[{
    field: 'ITEM_NAME',
    title: '事项名称',
    formatter: 'longFormatter',
    sortable:true
}, {
    field: 'serObjSortForShow',
    title: '服务对象分类'
}, {
    field: 'serContentForShow',
    title: '服务内容'
}, {
    field: 'companyIdForShow',
    title: '责任部门'
}, {
    field: 'yesorno',
    title: '是否有应用系统支撑',
    formatter: 'doFormatter11',
    sortable:true
},{
    field: 'id',
    title: '操作',
    formatter: 'doFormatter',//对本列数据做格式化
}];

function longFormatter(value, row, index)
{
	var html='<span title="'+row.itemName+'">';
	if(row.itemName.length>10){
		html+=row.itemName.substring(0,10)+"...";
	}else{
		html+=row.itemName;
	}
	html+='</span>';
	return html;
}

function doFormatter11(value, row, index)
{
	if(row.yesorno==1){
		return "是";
	}else if(row.yesorno==0){
		return "否";
	}
}

	//得到查询的参数
	var queryParams = function(params) {
		var sort=params.sort;
		var order=params.order;
		if($('input[name="itemN"]').val()!=null&&$('input[name="itemN"]').val()!=""){
			sort="length(trim(ITEM_NAME))";
			order="asc";
		}
		var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
			rows : params.limit,
			page : params.offset / params.limit + 1,
		    sort:sort,
		    order:order,
			itemName:$('input[name="itemN"]').val(),
			companyId: $('select[name="cId"]').val(),
			serContent: $('select[name="serC"]').val(),
			<c:if test="${MyFunction:getMaxScope(\"/backstage/itemSort/index\")==1}" >
	     	companyId:<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>,
	        </c:if>
		};
		return temp;
	};
var isCheckedInit=0;
var selectHtml;

//获得对应申请材料
function amJson(id){
	$('.aml').remove();
	var html = '';
	jQuery.post("${base}/backstage/dataList/getAmJsonByIsId",{"itemSortId":id},function(data){
		data=JSON.parse(data); 
		console.log(data.jsonsize);
		console.log(data.applicationMaterials);
		for(var i=0;i<data.jsonsize;i++){
			html+='<div class="form-group aml" >'+
			'<label class="col-sm-3 control-label">申请材料：</label>'+
			'<div class="col-sm-5">'+
			  '<input type="text" name="applicationMaterials" value="'+ data.applicationMaterials[i] +'" class="form-control" style="margin-top:5px;"></div>'+
			  '<div class="col-sm-2">'+
			    '<button class="btn btn-primary btn-block hook-btn-del" type="button" style="margin-top: 5px;">删除</button>'+
			  '</div>'+
			'</div>';
		}
		if(html!=''){
			$('.add-box').append(html);	
		}		
	});		
}
function amDetail(id){
	$('.aml').remove();
	var html = '';
	jQuery.post("${base}/backstage/dataList/getAmJsonByIsId",{"itemSortId":id},function(data){
		data=JSON.parse(data); 
		console.log(data);
		console.log(data.applicationMaterials);
		for(var i=0;i<data.jsonsize;i++){
			html+='<div class="form-group aml" >'+
			'<label class="col-sm-3 control-label">申请材料：</label>'+
			'<span class="col-sm-7 dt-span">'+ data.applicationMaterials[i] +'</span>'+
			'</div>';
		}
		if(html!=''){
			$('.add-box').append(html);	
		}
	});		
}

function addNew(){
	$('select[name="preApprovalMatter"]').html(selectHtml);
	openLayer();
	$('.aml').remove();	
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
$('select[name="yesorno"]').on('change', function(e, params) {
	var val=$(this).val();
	if(val==1){
		$('#asd').show();
	}else{
		$('#asd').hide();
		$("#busSystem").val("");
	}
});

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
    timeout: 0,
    // 文件接收服务端。
    server: url+'import',
    threads :1,
    fileNumLimit:1,
    // 选择文件的按钮。可选。
    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
    pick: '#filePicker',

    // 只允许选择Excel文件。
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

</script>
<%@include file="../common/baseSystemJS.jsp"%>
<script>
function editRow(id){
	if(isCheckedInit==0){
		isCheckedInit=1;
		selectHtml=$('select[name="preApprovalMatter"]').html();
	}
	openLayer();
	layer.title('修改', layerIndex);

	
	var data=$(tableId).bootstrapTable('getRowByUniqueId', id);
	$('select[name="preApprovalMatter"]').html(selectHtml);
	$('select[name="preApprovalMatter"]').find('option[value="'+data.id+'"]').remove();	
	$(formId).form('load',data);
	$('.hook-btn-del').parent().parent().remove();
	amJson(data.id);
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

function doFormatter(value, row, index)
{
	var html='';
	html+='<div class="btn-group">';
	html+='<button type="button" class="btn btn-white" onclick="datailRow(\''+row.idForShow+'\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
	<c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/itemSort/index\") %>">
	html+='<button type="button" class="btn btn-white" id="edit"  onclick="editRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
    </c:if>
	<c:if test="<%=!ServiceUtil.haveDel(\"/backstage/itemSort/index\") %>">
	html+='<button type="button" class="btn btn-white" onclick="deleteRow(\''+row.idForShow+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
	</c:if>
	html+='</div>';
	return html;
}

function doWithDetail(id,data){
	$('.aml').remove();	//
	amDetail(data.id);//
}

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