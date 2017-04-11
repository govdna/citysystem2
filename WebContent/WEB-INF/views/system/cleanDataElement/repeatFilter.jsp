<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>

<!DOCTYPE html >
<html lang="en"> 
<head>
<%@include file="../common/includeBaseHead.jsp"%>
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
.com-count{
padding: 7px 15px 7px 15px;
background-color: #737973;
color: #fff;
border-radius: 3px;
cursor: pointer;
margin: 5px;
 }
.com-count .badge{
margin-left:5px;
 }
.label-info, .badge-info {
    font-size: 14px;
}
</style>
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
      
        	<div class="p-xs">
                 <h3>重复数据元：</h3>
            </div>         
       
     <c:if test="${list==null||list.size()==0}">
       	  <div class="alert alert-success" style="margin:10px;">
                   	暂无重复数据元需要清洗。
          </div>
       </c:if>
      
      <div>
      	<c:forEach var="obj" items="${list}">
     	  <div class="pull-left com-count" data-value="${obj.value1}">
     	${obj.value1}
     	  <span class="badge">${obj.counts}</span>
     	  </div>
      
      
      	</c:forEach>
      	<div class="clearfix"></div>
      </div>
      
      
      
      </div>
    </div>
  </div>



	<div id="layer_form" style="display: none;" class="ibox-content">
    	<form method="post" class="form-horizontal" id="repeatForm">
    	
    	</form>
    </div>


 <div id="inforDiv" style="display: none;" class="ibox-content">
    	<table id="inforTable"></table>
    </div>
    
</body>
</html>

<%@include file="../common/includeJS.jsp"%>
<script>
var layerIndex;
var formId = '#repeatForm';//form id
var url = '${base}/backstage/cleanDataElement/';

var loadingHtml=' <div class="ibox-content"> <div class="spiner-example"><div class="sk-spinner sk-spinner-wave"><div class="sk-rect1"></div><div class="sk-rect2"></div><div class="sk-rect3"></div><div class="sk-rect4"></div><div class="sk-rect5"></div></div></div></div>'


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

$('.com-count').on('click',function(e){
	$('#repeatForm').html(loadingHtml);
	layerIndex=layer.open({
	      type : 1,
	      area : [ '90%', '500px' ], //宽高
	      title : '统一重复数据元',
	      scrollbar : false,
	      btn : [ '保存', '关闭' ],
	      yes : function(index, layero) {
	    	  $('#repeatForm').submit();
	      },
	      cancel:function(index, layero){
	    	  submiting=0;
	      },
	      offset : '20px',
	      content : $('#layer_form')
	    //这里content是一个DOM
	  });
	$('.layui-layer-content').css("overflow","hidden");
	var sameName=$(this).attr('data-value');
	$.post('${base}/backstage/cleanDataElement/repeatList',{value1:sameName},function(r){
		$('#repeatForm').html(r);
		$('#repeatForm').validate( {ignore: ""});
		$('input[name="sameName"]').val(sameName);
		$('.different_value').each(function(i){
			var nm=$(this).attr('data-value');
			$('input[name="'+nm+'"]').parent('div').append('<span style="color:#23c6c8;font-size: 13px;"><i class="fa fa-info-circle"></i>&nbsp;存在分歧</span>');
			$('select[name="'+nm+'"]').parent('div').append('<span style="color:#23c6c8;font-size: 13px;"><i class="fa fa-info-circle"></i>&nbsp;存在分歧</span>');
		 });
		
		
		var chosen=$(".chosen-select").chosen({
			disable_search_threshold: 10,
			no_results_text: "没有匹配到这条记录",
			search_contains: true,
	        width: "100%"
	  	});
		
		chosen.on('change', function(e, params) {
			$('#repeatForm').valid();
		});
		
		chosen.on('click', function(e, params) {
			$('.different_value').hide();
			$('.different_value[data-value="'+$(this).attr('name')+'"]').show();
		
		});
		
		$("input").focus(function(){
			$('.different_value').hide();
			
			$('.different_value[data-value="'+$(this).attr('name')+'"]').show();
		});
		
		$(".chosen-select").trigger("chosen:updated");
		$('#repeatForm').valid();
	},'html');
	

});

$('#repeatForm').on('click','.value-span',function(){
	$('input[name="'+$(this).attr('data-key')+'"]').val($(this).attr('data-value'));
	$('#repeatForm').valid();
});

$('#repeatForm').on('click','.detail-span-i',function(){
	$('input[name="dataElementIds"]').val($(this).attr('data-ids'));
	openInforLayer();
});

function openInforLayer(){
	initInfor();
	layer.open({
	      type : 1,
	      area : [ '70%', '70%' ], //宽高
	      title : '相关信息资源',
	      scrollbar : false,
	      offset : '20px',
	      content : $('#inforDiv')
	    //这里content是一个DOM
	  });

}



var InforTableInit = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $('#inforTable').bootstrapTable({
      url : '${base}/backstage/information/resource/getInforResByDataElementIds', //请求后台的URL（*）
      method : 'post', //请求方式（*）
      contentType : "application/x-www-form-urlencoded",
      iconSize : 'outline',
      striped : true, //是否显示行间隔色
      cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
      pagination : false, //是否显示分页（*）
      sortable : false, //是否启用排序
      sortOrder : "asc", //排序方式
      queryParams : inforQueryParams,//传递参数（*）
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
    	    field : 'value2',
    	    title : '信息资源代码'
    	  }, {
    	    field : 'value1',
    	    title : '信息资源名称',
    	    formatter : 'longFormatter',
    	  },{
    	    field : 'value14',
    	    title : '发布日期'
    	  }, {
    	    field : 'status',
    	    title : '状态',
    	    formatter : 'statusFormatter',//对本列数据做格式化
    	  }, {
    	    field : 'id',
    	    title : '操作',
    	    formatter : 'inforDoFormatter',//对本列数据做格式化
    	  } ]
    });
  };
  return oTableInit;
};


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

function statusFormatter(value, row, index) {
    var st=['已发布','待审核','审核不通过','已撤回','注销待审核','已注销']
    return st[value];
  }
  
function inforDoFormatter(value, row, index) {
	 var html = '';
	    html += '<div class="btn-group">';
	    html+='<button type="button" class="btn btn-white" onclick="informationResourceDetail(\''+row.id+'\')">查看</button>';
	    html += '</div>';
	    return html;
}


function dataElementDetail(id) {
	  layer.open({
	    type: 2,
	    title: '数据元详情',
	    shadeClose: true,
	    shade: 0.1,
	    area: ['620px', '80%'],
	    content: base + '/backstage/dataElement/detail?id=' + id
	  });

	}
	
	
function informationResourceDetail(id) {
	  layer.open({
	    type: 2,
	    title: '信息资源详情',
	    shadeClose: true,
	    shade: 0.1,
	    area: ['70%', '70%'],
	    content: base + '/backstage/information/resource/detail?id=' + id
	  });

	}

var inforQueryParams = function(params) {

	  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	    rows : 100,
	    page : 1,
	    ids:$('input[name="dataElementIds"]').val()
	  };
	  return temp;
	};

	var inforInit=0;
	function initInfor(){
		if(inforInit==0){
			inforInit=1;
			var cc=new InforTableInit();
			cc.Init();
		}else{
			$('#inforTable').bootstrapTable('refresh');
		}
	}

$('#repeatForm').on('click','.value-span',function(){
	$('input[name="'+$(this).attr('data-key')+'"]').val($(this).attr('data-value'));
	$('#repeatForm').valid();
});


$('#repeatForm').on('click','.select-value-span',function(){
	$('select[name="'+$(this).attr('data-key')+'"]').val($(this).attr('data-value'));
	$(".chosen-select").trigger("chosen:updated");
	$('#repeatForm').valid();
});

$('#repeatForm').on('click','.chosen-single',function(){
	var vl=$(this).parent('div').parent('div.col-sm-8').attr('data-value');
	$('.value-span[data-key="'+vl+'"]').each(function(i){
		   $(this).addClass("select-value-span").removeClass("value-span");
		   var value=$('select[name="'+vl+'"]').find('option[value="'+$(this).attr("data-value")+'"]').html();
		   $(this).html(value+'('+ $(this).attr("data-count")+')');
	 });
	
	$('.different_value').hide();
	$('.different_value[data-value="'+vl+'"]').show();
});




var submiting=0;

$(formId).form({  
    url: url+'insertAjax',  
    onSubmit: function(){
    	var v=$(formId).valid()&&submiting==0;
    	if(v){
    		submiting=1;
    		$('#layui-layer'+layerIndex).find('.layui-layer-btn0').html('保存中...');
    	}
    	return v;
    },  
    success: function(result){ 
    	var result = eval('('+result+')');
    	if(result.code && result.code==1){
    		$('div[data-value="'+$('input[name="sameName"]').val()+'"]').remove();
    		layer.close(layerIndex);
    		layer.msg('清洗成功!');
    	}else{
    		layer.msg(result.msg);
    	}
    	submiting=0;
    	$('#layui-layer'+layerIndex).find('.layui-layer-btn0').html('保存');
    	
    }  
});

</script>


