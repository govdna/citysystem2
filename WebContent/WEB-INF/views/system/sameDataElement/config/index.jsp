<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
<link href="${base}/static/plugins/jqgrid/ui.jqgrid.css" rel="stylesheet">
</head>
<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline">
            <div class="form-group">
              <input type="text" placeholder="输入配置名称" name="dicN" class="form-control col-sm-8">
              <div class="input-group-btn col-sm-4">
                <button type="button" onclick=" $('#dicList').bootstrapTable('refresh');" class="btn btn-primary">搜索
                </button>
              </div>
            </div>
            <div class="form-group" style="margin-left: 15px;">
              <div class="text-center">
                <a data-toggle="modal" class="btn btn-primary" onclick="addNew();" href="#">新增同义词配置</a>
              </div>
            </div>
          </div>
        </div>
        <table id="dicList">
        </table>
      </div>
    </div>
  </div>

  <div id="layer_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="eform">
      <input type="hidden" name="id" class="form-control"> 
      <input type="hidden" name="idForShow" class="form-control">
      <input type="hidden" name="levels"  class="form-control">
      <input type="hidden" name="fatherId"  class="form-control">
      <div class="form-group">
        <label class="col-sm-3 control-label">同义词配置名称：</label>
        <div class="col-sm-9">
          <input type="text" name="name" class="form-control" required>
        </div>
      </div>
      
    </form>
    <div class="ibox-content" id="dicTree" style="padding-left:0px;padding-right:0px;">
      <div class="btn-group" id="toolbar" role="group" style="margin-bottom:15px;">
        <div class="text-center">
          <a data-toggle="modal" class="btn btn-primary" onclick="addNewXM();" href="#">添加同义词</a>
        </div>
      </div>
      <table id="table_list_2">
      </table>
    </div>
  </div>

  <div id="dic_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="dicForm">
      <input type="hidden" name="id" class="form-control"> 
      <input type="hidden" name="idForShow" class="form-control">
      <input type="hidden" name="levels"  class="form-control">
      <input type="hidden" name="fatherId"  class="form-control">
      <div class="alert alert-info">
               *匹配多个字符，_匹配一个字符。
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">同义词：</label>
        <div class="col-sm-9">
          <input type="text" name="name" class="form-control" required>
        </div>
      </div>
    
    </form>
  </div>

</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script>
var layerIndex; //layer 窗口对象
var title_name = "同义词配置";
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var dicLayerContent = '#dic_form'; //layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var dicFormId = '#dicForm'; //form id
var url = '${base}/backstage/sameDataElementConfig/'; //controller 路径
var dicLayerIndex;
var treeData;
var treeInited = 0;
//bootstrap-table 列数
var columns = [{
  field: 'name',
  title: '同义词配置名称'
}, {
  field: 'id',
  title: '操作',
  formatter: 'doFormatter', //对本列数据做格式化
}];

//得到查询的参数
var queryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: 100,
    page: 1,
    levels: 1,
    name: $('input[name="dicN"]').val()
  };
  return temp;
};






function addNew() {
  openLayer();
  $("#dicTree").hide();
  $("input[name='levels']").val(1);
  $("input[name='fatherId']").val(0);
}


function addNewXM() {
  openDicLayer();
  $(dicFormId).find('input[name="levels"]').val(2);
  $(dicFormId).find('input[name="fatherId"]').val($('#eform input[name="id"]').val());
}




var ChildTableInit = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $('#table_list_2').bootstrapTable({
      url : '${base}/backstage/sameDataElementConfig/listAjax', //请求后台的URL（*）
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
        field : 'name',
        title : '同义词'
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


var childInit=0;
function initChild(){
	if(childInit==0){
		childInit=1;
		var cc=new ChildTableInit();
		cc.Init();
	}else{
		$('#table_list_2').bootstrapTable('refresh');
	}
}



function openDicLayer() {
  $(dicFormId).form('clear');
  initChosen();
  $(dicFormId).valid();
  dicLayerIndex = layer.open({
    type: 1,
    area: ['400px', '280px'], //宽高
    title: '新增',
    scrollbar: false,
    btn: ['保存', '关闭'],
    yes: function(index, layero) {
      $(dicFormId).submit();
    },
    content: $(dicLayerContent) //这里content是一个DOM
  });
}

$(dicFormId).form({
	  url: url + 'insertAjax',
	  onSubmit: function() {
	    return $(dicFormId).valid();
	  },
	  success: function(result) {
	    var result = eval('(' + result + ')');
	    if (result.code && result.code == 1) {
	      layer.close(dicLayerIndex);
	      $('#table_list_2').bootstrapTable('refresh');
	    }
	    layer.msg(result.msg);
	  }
	});

</script>
<%@include file="../../common/baseSystemJS.jsp"%>
<script>
function doWithEdit(id,data){
	$("#dicTree").show();
	initChild();
}
function doWithDetail(id,data){
	$("#dicTree").show();
	initChild();
}

function doFormatter4(value, row, index)
{
	var html='';
	html+='<div class="btn-group">';
	html+='<button type="button" class="btn btn-white" onclick="editChildRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
	html+='<button type="button" class="btn btn-white" onclick="deleteChildRow(\''+row.idForShow+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
	html+='</div>';
	return html;
}

function deleteChildRow(id){
	layer.confirm('您确定要删除么？', {
		  btn: ['确定','取消'] //按钮
		}, function(){
			$.post(url+'deleteAjax',{idForShow:id},function(result){  
				if(result.code && result.code==1){
		    		
		    		 $('#table_list_2').bootstrapTable('refresh');
		    	}
		    	layer.msg(result.msg);
	        },'json');
		}, function(){
		    
		});
}


function editChildRow(id){
	openDicLayer();
	layer.title('修改同义词', layerIndex);
	var data=$('#table_list_2').bootstrapTable('getRowByUniqueId', id);
	$(dicFormId).form('load',data);
	$(dicFormId).valid();
}

</script>