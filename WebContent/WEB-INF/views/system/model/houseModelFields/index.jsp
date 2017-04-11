<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">

<head>
<%@include file="../../common/includeBaseHead.jsp"%>
<link href="${base}/static/plugins/jqgrid/ui.jqgrid.css" rel="stylesheet">
    <link href="${base}/static/css/plugins/chosen/chosen.css" rel="stylesheet">
  <link href="${base}/static/css/style.css?v=4.1.0" rel="stylesheet">
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
	<div class="wrapper wrapper-content  animated fadeInRight">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox">
					<div class="ibox-content">
			           <div class="btn-group hidden-xs" id="toolbar" role="group">
                            <div class="text-center">
		                      <a data-toggle="modal" class="btn btn-primary" onclick="addNew();" href="#">新增</a>
		                     </div>          
		               </div>
		               <div class="clearfix" style="margin-bottom: 20px;"></div>
					  <div class="jqGrid_wrapper">
							<table id="table_list_2"></table>
					  </div>
					</div>
			   </div>    
					
			</div>
		</div>
	</div>
	<div id="layer_form" style="display: none;" class="ibox-content">
		<form method="post" class="form-horizontal" id="eform">
			<input type="hidden" name="id"  class="form-control">
			<input type="hidden" name="idForShow" >
				<input type="hidden" name="fatherId">
				<input type="hidden" name="level">
				<input type="hidden" name="modelType">
			<div class="form-group father">
				<label class="col-sm-3 control-label">模型名称：</label>
				<div class="col-sm-7">
					<input type="text" name="modelName" class="form-control" required>
				</div>
			</div>
<!-- 			
			<div class="form-group father">
				<label class="col-sm-3 control-label">模型编码：</label>
				<div class="col-sm-7">
					<input type="text" name="modelType" class="form-control" required>
				</div>
			</div>	
 -->			
			<div class="form-group father">
				<label class="col-sm-3 control-label">模型代码：</label>
				<div class="col-sm-7">
					<input type="text" name="modelCode" class="form-control" required>
				</div>
			</div>				
		</form>
	</div>
	<div id="s_form" style="display: none;" class="ibox-content">
		<form method="post" class="form-horizontal" id="sform">
			<input type="hidden" name="id"  class="form-control">
			<input type="hidden" name="idForShow" >
				<input type="hidden" name="fatherId">
				<input type="hidden" name="level">
				<input type="hidden" name="modelType">
			<div class="form-group son">
				<label class="col-sm-3 control-label">字段名称：</label>
				<div class="col-sm-7">
					<input type="text" name="name" class="form-control" required>
				</div>
			</div>
<!-- 
			<div class="form-group son">
				<label class="col-sm-3 control-label">字段编码：</label>
				<div class="col-sm-7">
					<input type="text" name="valueNo" class="form-control" required>
				</div>
			</div>
 -->			
			<div class="form-group father">
				<label class="col-sm-3 control-label">字段代码：</label>
				<div class="col-sm-7">
					<input type="text" name="modelCode" class="form-control" required>
				</div>
			</div>							
			<div class="form-group son">
				<label class="col-sm-3 control-label">是否必填：</label>
				<div class="col-sm-7">
					<select name="required" data-placeholder=" " class="form-control" style="width:350px;" tabindex="4" required>
                                    <option value=""></option>
                                    <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"REQUIRED\") %>">
                                    <option value="${obj.dicKey}">${obj.dicValue}</option>
                                    </c:forEach>
                    </select>  
				</div>
			</div>
			<div class="form-group son">
				<label class="col-sm-3 control-label">是否显示：</label>
				<div class="col-sm-7">
					<select name="isShow" data-placeholder=" " class="form-control" style="width:350px;" tabindex="4" required>
                           <option value="0">否</option>
                           <option value="1">是</option>
                    </select>  
				</div>
			</div>
			<div class="form-group son">
				<label class="col-sm-3 control-label">输入框类型：</label>
				<div class="col-sm-7">
					<select name="inputType" data-placeholder=" " class="form-control" style="width:350px;" tabindex="4" required>
                                    <option value=""></option>
                                    <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"INPUTTYPE\") %>">
                                    <option value="${obj.dicKey}">${obj.dicValue}</option>
                                    </c:forEach>
                    </select>  
				</div>
			</div>
			<div class="form-group son" id="inputValue_Div" style="display:none;">
				<label class="col-sm-3 control-label">输入框取值：</label>
				<div class="col-sm-7">
					<select name="inputValue" data-placeholder=" " class="form-control" style="width:350px;" tabindex="4" >
                                    <option value=""></option>
                                    <c:forEach var="obj" items="<%=ServiceUtil.getService(\"GovmadeDicService\").find(ServiceUtil.buildBean(\"GovmadeDic@isDeleted=0&level=1\"))%>">
                                    <option value="${obj.dicNum}">${obj.dicName}</option>
                                    </c:forEach>
                    </select>  
				</div>
			</div>
			<div class="form-group son">
				<label class="col-sm-3 control-label">排序：</label>
				<div class="col-sm-7">
					<input type="text" name="listNo" class="form-control" required>
				</div>
			</div>

		</form>
	</div>
</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script src="${base}/static/plugins/jqgrid/i18n/grid.locale-cn.js"></script>
<script src="${base}/static/plugins/jqgrid/jquery.jqGrid.min.js"></script>
  <!-- Chosen -->
    <script src="${base}/static/js/plugins/chosen/chosen.jquery.js"></script>
<script>


var layerIndex;//layer 窗口对象
var layerContent='#layer_form';//layer窗口主体内容dom Id
var formId='#eform';//form id
var url='${base}/backstage/model/houseModelFields/';//controller 路径
var tableId='#table_list_2';
var treeData;
var dicLayerIndex;
var chosenInited=0;



$('select[name="inputType"]').on('change', function(e, params) {
	var val=$(this).val();
	if(val==2){
		$('#inputValue_Div').show();
	}else{
		$('#inputValue_Div').hide();
	}
});


//得到查询的参数
var queryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1
  };
  return temp;
};

$('select[name="inputType"]').on('change', function(e, params) {
  var val = $(this).val();
  if (val == 2) {
    $('#inputValue_Div').show();
  } else {
    $('#inputValue_Div').hide();
  }
});


	$(document).ready(function () {
        $.jgrid.defaults.styleUI = 'Bootstrap';

        $(tableId).jqGrid({
        	treeGrid: true,
            treeGridModel: 'adjacency', //treeGrid模式，跟json元数据有关 ,adjacency/nested
            ExpandColumn : 'modelName',
            ExpandColClick: true,
            scroll: true,
            autowidth: true,
            shrinkToFit: false,//是否默认宽度
            forceFit: true,
            url: url+"/jqGridTreeJson",
            datatype: 'json',
            colNames:['模型名称','字段名称','操作'],
            colModel:[
                {name:'modelName',index:'modelName', width:200,sortable: false},
                {name:'name',index:'name', width:170,sortable: false},
                {name:'id',index:'id', width:400, align:'center',sortable: false, formatter:button}
            ],//name 列显示的名称；index 传到服务器端用来排序用的列名称；width 列宽度；align 对齐方式；sortable 是否可以排序
            pager: "false",
            treeReader : {
                level_field: "level",//层次结构中的级别
                parent_id_field: "fatherId",//记录父类id
                leaf_field: "isLeaf",//是否叶节点
                icon_field:"_icon",
                expanded_field: "expanded"//是否该元素在加载过程中应展开
            },
            // caption: "前台菜单",
            hidegrid: false,
            mtype: "get",
            height: 550,    // 设为具体数值则会根据实际记录数出现垂直滚动条
            rowNum : "-1",     // 显示全部记录
            shrinkToFit:true,  // 控制水平滚动条
            loadComplete:function(data){
            	treeData=data;
            }
        });

        function button(cellvalue, options, rowObject){
        	var html='';
        	html+='<div class="btn-group">';

        	if(rowObject.fatherId==0){
            	html+='<button type="button" class="btn btn-white" onclick="addSon(\''+rowObject.idForShow+'\')"><i class="fa fa-plus"></i>&nbsp;添加子级</button>';
        	}
        	html+='<button type="button" class="btn btn-white" onclick="editRow(\''+rowObject.idForShow+'\',\''+rowObject.fatherId+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
        	html+='<button type="button" class="btn btn-white" onclick="deleteRow(\''+rowObject.idForShow+'\',\''+rowObject.fatherId+'\',\''+rowObject.level+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';

        	html+='</div>';
        	return html;
        }

         $(window).resize(function(){   
         $(tableId).setGridWidth($('.ibox-content').width());
        });    
    });
	
	$.validator.setDefaults({
	    highlight: function (element) {
	        $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
	    },
	    success: function (element) {
	        element.closest('.form-group').removeClass('has-error').addClass('has-success');
	    },
	    errorElement: "span",
	    errorPlacement: function (error, element) {
	        if (element.is(":radio") || element.is(":checkbox")) {
	            error.appendTo(element.parent().parent().parent());
	        } else {
	            error.appendTo(element.parent());
	        }
	    },
	    errorClass: "help-block m-b-none",
	    validClass: "help-block m-b-none"
	});

	function openLayer(){
		$(formId).form('clear');
		$(formId).valid();
		layerIndex=layer.open({
		  type: 1,
		  area: ['60%', '80%'], //宽高
		  title: '新增',
		  scrollbar: false,
		  btn: ['保存','关闭'], 
		  yes: function(index, layero){
			  $(formId).submit();
		  },
		  offset: '0',
		  content: $(layerContent) //这里content是一个DOM
		});
	}
	var layersonIndex;
	function opensonLayer(){
		$('#sform').form('clear');
		$('#sform').valid();
		layersonIndex=layer.open({
		  type: 1,
		  area: ['60%', '80%'], //宽高
		  title: '新增',
		  scrollbar: false,
		  btn: ['保存','关闭'], 
		  yes: function(index, layero){
			  $('#sform').submit();
		  },
		  offset: '0',
		  content: $('#s_form') //这里content是一个DOM
		});
	}
	
	$(function () {
		$(formId).validate( {ignore: ""});
		$('#sform').validate( {ignore: ""});
	});

	function addNew(){
		openLayer();
		$('input[name="fatherId"]').val(0);
		$('input[name="level"]').val(1);
//		$('.son').hide();
//		$('.father').show();
	}
	
	function addSon(id){console.log("treeData",treeData);
		opensonLayer();
		for(var i=0;i<treeData.length;i++){
			if(treeData[i].idForShow==id){
				$('input[name="fatherId"]').val(treeData[i].id);
				$('input[name="level"]').val(++treeData[i].level);
				$('input[name="modelType"]').val(treeData[i].modelType);
				$('#sform').valid();
			}
		}	
//		$('input[name="modelName"]').val('　');
//		$('.son').show();
//		$('.father').hide();
	}
	
	function editRow(id,fatherId){
		if(fatherId==0){
			openLayer();
			for(var i=0;i<treeData.length;i++){
				if(treeData[i].idForShow==id){
					$(formId).form('load',treeData[i]);
					$(formId).valid();
				}
			}	
		}else{
			opensonLayer();
			for(var i=0;i<treeData.length;i++){
				if(treeData[i].idForShow==id){
					$('#sform').form('load',treeData[i]);
					$('#sform').valid();
				}
			}	
		}
		

	}


</script>

<script>
function disableChosen(){
	var cs=$(".chosen-select");
	if(cs.length){
		for(var i=0;i<cs.length;i++){
			if($(cs[i]).attr('data-bind')){
				var cid=$(cs[i]).attr('data-bind');
				if(!$(cs[i]).val()){
					$(cid).attr('disabled', true).trigger("chosen:updated");
				}else{
					$(cid).attr('disabled', false).trigger("chosen:updated");
				}
			}
			
		}
	}
	var cs=$(".chosen-select[data-level='2']");
	if(cs.length){
		for(var i=0;i<cs.length;i++){
			if($(cs[i]).attr('data-bind')){
				var cid=$(cs[i]).attr('data-bind');
				if(!$(cs[i]).val()){
					$(cid).attr('disabled', true).trigger("chosen:updated");
				}else{
					$(cid).attr('disabled', false).trigger("chosen:updated");
				}
			}
			
		}
	}
	var cs=$(".chosen-select[data-level='3']");
	if(cs.length){
		for(var i=0;i<cs.length;i++){
			if($(cs[i]).attr('data-bind')){
				var cid=$(cs[i]).attr('data-bind');
				if(!$(cs[i]).val()){
					$(cid).attr('disabled', true).trigger("chosen:updated");
				}else{
					$(cid).attr('disabled', false).trigger("chosen:updated");
				}
			}
			
		}
	}
	var cs=$(".chosen-select[data-level='4']");
	if(cs.length){
		for(var i=0;i<cs.length;i++){
			if($(cs[i]).attr('data-bind')){
				var cid=$(cs[i]).attr('data-bind');
				if(!$(cs[i]).val()){
					$(cid).attr('disabled', true).trigger("chosen:updated");
				}else{
					$(cid).attr('disabled', false).trigger("chosen:updated");
				}
			}
			
		}
	}
}
function initChosen(){
	disableChosen();
	if(chosenInited==0){
		chosenInited=1;
	}else{
		$(".chosen-select").val("");
		$(".chosen-select").trigger("chosen:updated");
		return;
	}
	var chosen=$(".chosen-select").chosen({
		disable_search_threshold: 10,
		no_results_text: "没有匹配到这条记录",
        width: "100%"
  });
	
	chosen.on('change', function(e, params) {
		if($(this).attr('data-bind')){
			var cid=$(this).attr('data-bind');
			if($(this).val()==''){
				$(cid).val('');
				$(cid).attr('disabled', true).trigger("chosen:updated");
			}else{
				$(cid).attr('disabled', false).trigger("chosen:updated")
				var  p = {};
				p[$(this).attr("data-param")] =$(this).val();
				initAjaxChosen(cid,$(cid).attr('data-url'),p);
			}
			
		}
		$(formId).valid();
		});
	
	$(".chosen-select").trigger("chosen:updated");	
}
$(formId).form({  
    url: url+'insertAjax',  
    onSubmit: function(){
    	
    	return $(formId).valid();
    },  
    success: function(result){ 
    	var result = eval('('+result+')');
    	if(result.code && result.code==1){
    		layer.close(layerIndex);
    		$(tableId).trigger('reloadGrid');
    	}
    	layer.msg(result.msg);
    }  
});
$('#sform').form({  
    url: url+'insertAjax',  
    onSubmit: function(){
    	
    	return $('#sform').valid();
    },  
    success: function(result){ 
    	var result = eval('('+result+')');
    	if(result.code && result.code==1){
    		layer.close(layersonIndex);
    		$(tableId).trigger('reloadGrid');
    	}
    	layer.msg(result.msg);
    }  
});
function deleteRow(id,fatherId,level){
	layer.confirm('您确定要删除么？', {
		  btn: ['确定','取消'] //按钮
		}, function(){
			$.post(url+'deleteAjax',{idForShow:id,fatherId:fatherId,level:level},function(result){  
				if(result.code && result.code==1){
		    		layer.close(layerIndex);
		    		$(tableId).trigger('reloadGrid');
		    	}
		    	layer.msg(result.msg);
	        },'json');
		}, function(){
		    
		});
}


</script>