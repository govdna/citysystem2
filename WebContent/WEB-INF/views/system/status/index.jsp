<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
              <div class="input-group-btn col-sm-4"> 
                <button type="button" onclick=" $('#dicList').bootstrapTable('refresh');" class="btn btn-primary">搜索
                </button> 
              </div>
            </div>
            <div class="form-group" style="margin-left: 15px;">
              <div class="text-center">
                <% if(ServiceUtil.isHaveRole(61)){
                  out.println("<a id='roleBool' data-toggle='modal' class='btn btn-primary' onclick='statussuccess();' class='btn btn-primary'>批量审批</a>");
                } %>
              <a data-toggle="modal" class="btn btn-primary" onclick="statusAll();" href="#">一键审核</a>
              </div>
            </div>
          </div>
        </div>
        <table id="dicList">
        </table>
      </div>
    </div>
  </div>
</body>
</html>

<%@include file="../common/includeJS.jsp"%>
<script>
var layerIndex; //layer 窗口对象
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var url = '${base}/backstage/govRdataElement/'; //controller 路径
var dicLayerContent = '#dic_form';
var dicFormId = '#dicForm';
var statusContent = '#statusform';
var dicLayerIndex;
var checkedIds = ",";
var checkedEles;
var dataEles; //存放选中的数据元
var roleBool = $("#roleBool").html();


$(tableId).on("click", '#allC', function() {
  var isChecked = $(this).prop("checked");
  $("input[name='statusid']").prop("checked", isChecked);
});

jQuery.get("${base}/backstage/dataElement/listAjax?all=y", function(r) {
  dataEles = r;
}, "json");

layer.config({
  extend: 'extend/layer.ext.js'
});


//bootstrap-table 列数
var columns = [{
  field: 'id',
  title: '<input id="allC" type="checkbox">',
  formatter: 'doFormattersid'
}, {
  field: 'identifier',
  title: '内部标识符'
}, {
  field: 'chName',
  title: '中文名称'
}, {
  field: 'egName',
  title: '英文名称'
}, {
  field: 'dataTypeForShow',
  title: '数据类型'
}, {
  field: 'dataFormat',
  title: '数据长度'
}, {
  field: 'objectTypeForShow',
  title: '对象类型'
}, {
  field: 'statusForShow',
  title: '状态'
}, {
  field: 'id',
  title: '操作',
  formatter: 'doFormatters', //对本列数据做格式化
}];


//得到查询的参数
var queryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
    chName: $('input[name="chN"]').val()
  };
  return temp;
};

function statusAll() {
  layer.open({
    title: '审核',
    content: '是否全部审核通过？',
    btn: ['确定', '取消'],
    yes: function(index, layero) {
      jQuery.get("${base}/backstage/govRdataElement/statusAll", function(r) {
        var result = eval('(' + r + ')');
        $(tableId).bootstrapTable('refresh');
        layer.msg(result.msg);
      });
      layer.close(index);

    },
    btn2: function(index, layero) {
      //按钮【按钮二】的回调
    },
    cancel: function() {
      //右上角关闭回调
    }
  });
}

function openStatus() {
  $('#statusTbale').bootstrapTable('refresh');
  initChosen();
  dicLayerIndex = layer.open({
    type: 1,
    area: ['70%', '80%'], //宽高
    title: '审核',
    scrollbar: false,
    btn: ['关闭'],
    yes: function(index, layero) {
      layer.close(index);
    },
    offset: '20px',
    content: $(statusContent)
      //这里content是一个DOM
  });
}

function doFormatters(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="datailRow(\'' + row.idForShow + '\')"><i class="fa fa-info-circle"></i>&nbsp;查看</button>';
  if (row['status'] == 1 || row['status'] == 2) { <c:if test = "<%=ServiceUtil.isHaveRole(61)%>" >
      html += '<button type="button" class="btn btn-white" onclick="statussuss(\'' + row.idForShow + '\',0)"><i class="fa fa-eye"></i>&nbsp;发布审核</button>';
    html += '<button type="button" class="btn btn-white" onclick="statuserro(\'' + row.idForShow + '\',3)"><i class="fa fa-eye"></i>&nbsp;驳回</button>'; </c:if>
  } else if (row['status'] == 5) { <c:if test = "<%=ServiceUtil.isHaveRole(61)%>" >
      html += '<button type="button" class="btn btn-white" onclick="statuserro(\'' + row.idForShow + '\',4)"><i class="fa fa-eye"></i>&nbsp;注销审核</button>'; </c:if>
  }
  html += '</div>';
  return html;
}

function deleteAfter(idForShow, id) {
  $.post("${base}/backstage/dataList/isUse", { dataElementId: id }, function(result) {

    if (result.code && result.code == 1) {
      layer.msg('删除失败！此数据元被调用，请先删除相关数据！');
    } else {
      //layer.msg('删除！');
      deleteRow(idForShow);
    }

  }, 'json');
}

function statusAfter(idForShow, id) {
  $.post("${base}/backstage/dataList/isUse", { dataElementId: id }, function(result) {
    if (result.code && result.code == 1) {
      layer.msg('注销失败！此数据元被调用，请先删除相关数据！');
    } else {
      //layer.msg('删除！');
      statuserro(idForShow, 5);
    }
  }, 'json');
}

function doFormattersid(value, row, index) {
  if (row.status == 1 || row.status == 2) {
    if (roleBool == null || roleBool == "") {
      return "";
    } else {
      var html = '';
      html += '<div class="btn-group">';
      html += '<input type="checkbox" name="statusid" value="' + row.id + '"/> ';
      html += '</div>';
      return html;
    }
  } else {
    return "";
  }

}
function statussuccess(){
	var adIds = "";  
    $("input:checkbox[name='statusid']:checked").each(function(i){  
        if(0==i){  
            adIds = ","+$(this).val();  
        }else{  
            adIds += (","+$(this).val());  
        }  
    });
    //alert(adIds);
    if(adIds==""){
    	layer.msg("未选择任何信息");
    }else{
                    
        layer.open({
        	  title:'审核',
        	  content: '是否审核通过?'
        	  ,btn: ['通过', '不通过']
        	  ,yes: function(index, layero){
        		  statussuss(adIds,0);
        	  },btn2: function(index, layero){
        	    //按钮【按钮二】的回调
        	  }  ,cancel: function(){ 
        	    //右上角关闭回调
        	  }
        	});
        
    }
}
function statussuss(id,s){	
	if(id.split(",").length>1){
		var sid=id;
		jQuery.post("${base}/backstage/govRdataElement/toStatus",{"sid":sid,"status":s},function(){
			if(s==0){
				layer.msg("操作成功");
			}else if(s==4){
				layer.msg("注销成功");
			}			
			$(tableId).bootstrapTable('refresh');
		});
	}else{
		layer.open({
			type: 2,
			  title: '数据元审核',
			  shadeClose: true,
			  shade: 0.1,
			  area: ['620px', '80%'],
			  content: base+'/backstage/dataElement/detail?idForShow='+id,
			  btn: ['审核通过'],
			  yes: function(index, layero){
				  var d=$(tableId).bootstrapTable('getRowByUniqueId', id);
					var sid=d.id;
					jQuery.post("${base}/backstage/govRdataElement/toStatus",{"sid":sid,"status":s},function(){
						layer.msg("审核成功");
						$(tableId).bootstrapTable('refresh');
					});
					layer.close(index);
			  },cancel: function(){ 
			    //右上角关闭回调
			  }
			});
		
	}
	//alert(sid);

}
function statuserro(id,s){
	var d=$(tableId).bootstrapTable('getRowByUniqueId', id);
	var sid=d.id;
	if(s==3){
		layer.prompt({
			  formType: 2,
			  value: '',
			  title: '请填写原因'
			}, function(value, index, elem){
			  //alert(value); //得到value
			  jQuery.post("${base}/backstage/govRdataElement/toStatus",{"sid":sid,"status":3,"reason":value},function(){
					layer.msg("驳回成功");
					$(tableId).bootstrapTable('refresh');
				});
			  layer.close(index);
			});
	}else{
		layer.confirm('确定注销吗？', {
			  btn: ['注销', '不注销'] 
			}, function(index, layero){
				jQuery.post("${base}/backstage/govRdataElement/toStatus",{"sid":sid,"status":4},function(){
					layer.msg("注销成功");
					$(tableId).bootstrapTable('refresh');
				});
			});
	}
}


</script>
<%@include file="../common/baseSystemJS.jsp"%>
<script>
  function datailRow(id){
    layer.open({
        type: 2,
        title: '数据元详情',
        shadeClose: true,
        shade: 0.1,
        area: ['620px', '80%'],
        content: base+'/backstage/dataElement/detail?idForShow='+id
      }); 
  }
</script>