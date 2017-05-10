<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">

<head>
<%@include file="../../common/includeBaseHead.jsp"%>
<link href="${base}/static/plugins/jqgrid/ui.jqgrid.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${base}/static/css/plugins/webuploader/webuploader.css">
<link rel="stylesheet" type="text/css" href="${base}/static/css/demo/webuploader-demo.css">
<link href="${base}/static/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="${base}/static/css/style.css?v=4.1.0" rel="stylesheet">
</head>
<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content  animated fadeInRight">
    <div class="row">
      <div class="col-sm-12">
        <div class="ibox ">
          <div class="ibox-content">
           <div class="form-inline">
            <div class="form-group">
              <input type="text" placeholder="输入权限名" name="nodeN" class="form-control col-sm-8">
              <div class="input-group-btn col-sm-4">
               <button id="searchButton" type="searchButton" onclick="searchButton();" href="#" class="btn btn-primary">搜索</button>
              </div>
            </div>
            <div class="form-group" style="margin-left: 15px;">
            <div class="btn-group" id="toolbar" role="group">            
              <div class="text-center">            
                <a data-toggle="modal" class="btn btn-primary" onclick="openLayer();" href="#">新增</a>
              </div>
            </div>
            </div>
          </div>
            <div class="clearfix" style="margin-bottom: 20px;"></div>
            <div class="jqGrid_wrapper">
              <table id="table_list_2"></table>
              <div id="pager_list_2"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div id="layer_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="eform">
      <input type="hidden" name="id" class="form-control">
      <input type="hidden" name="idForShow" class="form-control">
      <div class="form-group">
        <label class="col-sm-3 control-label">父ID：</label>
        <div class="col-sm-7">
          <input type="text" name="parent" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">层级：</label>
        <div class="col-sm-7">
          <input type="text" name="level" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">优先级：</label>
        <div class="col-sm-7">
          <input type="text" name="listNo" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">名称：</label>
        <div class="col-sm-7">
          <input type="text" name="nodeNameForShow" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">URL链接：</label>
        <div class="col-sm-7">
          <input type="text" name="url" class="form-control">
        </div>
      </div>
    </form>
  </div>

</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script src="${base}/static/plugins/jqgrid/i18n/grid.locale-cn.js"></script>
<script src="${base}/static/plugins/jqgrid/jquery.jqGrid.min.js"></script>
 <script src="${base}/static/js/plugins/webuploader/webuploader.min.js"></script>
  <!-- Chosen -->
<script src="${base}/static/js/plugins/chosen/chosen.jquery.js"></script>
<script>
var layerIndex; //layer 窗口对象
var title_name = "权限";
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var formId = '#eform'; //form id
var url = '${base}/backstage/rbac/permission/'; //controller 路径
var tableId = '#table_list_2';
var treeData;

$(document).ready(function() {
  $.jgrid.defaults.styleUI = 'Bootstrap';

  $(tableId).jqGrid({
    treeGrid: true,
    treeGridModel: 'adjacency', //treeGrid模式，跟json元数据有关 ,adjacency/nested
    ExpandColumn: 'name',
    scroll: true,
    autowidth: true,
    shrinkToFit: false, //是否默认宽度
    forceFit: true,
    url: "${base}/backstage/rbac/permission/jqGridTreeJson",
    datatype: 'json',
    colNames: ['ID', '权限名', '链接', '优先级', '操作'],
    colModel: [
      { name: 'id', index: 'id', width: 200, sortable: false },
      { name: 'nodeName', index: 'nodeName', width: 170, sortable: false },
      { name: 'url', index: 'url', width: 300, sortable: false },
      { name: 'listNo', index: 'listNo', width: 100, sortable: false },
      { name: 'id', index: 'id', width: 400, align: 'center', sortable: false, formatter: button }
    ], //name 列显示的名称；index 传到服务器端用来排序用的列名称；width 列宽度；align 对齐方式；sortable 是否可以排序
    pager: "false",
    treeReader: {
      level_field: "level", //层次结构中的级别
      parent_id_field: "parent", //记录父类id
      leaf_field: "isLeaf", //是否叶节点
      icon_field: "_icon",
      expanded_field: "expanded" //是否该元素在加载过程中应展开
    },
    // caption: "前台菜单",
    hidegrid: false,
    mtype: "get",
    height: 550, // 设为具体数值则会根据实际记录数出现垂直滚动条
    rowNum: "-1", // 显示全部记录
    shrinkToFit: true, // 控制水平滚动条
    loadComplete: function(data) {
      treeData = data;
    }
  });

  function button(cellvalue, options, rowObject) {
    var html = '';
    html += '<div class="btn-group">';
    //html+='<button type="button" class="btn btn-default">按钮 1</button>';
    html += '<button type="button" class="btn btn-white" onclick="addSon(\'' + rowObject.idForShow + '\')"><i class="fa fa-plus"></i>&nbsp;添加子菜单</button>';
    html += '<button type="button" class="btn btn-white" onclick="editRow(\'' + rowObject.idForShow + '\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
    html += '<button type="button" class="btn btn-white" onclick="deleteRow(\'' + rowObject.idForShow + '\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
    html += '</div>';
    return html;
  }


  $(window).resize(function() {
    $(tableId).setGridWidth($('.ibox-content').width());
  });

});



$.validator.setDefaults({
  highlight: function(element) {
    $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
  },
  success: function(element) {
    element.closest('.form-group').removeClass('has-error').addClass('has-success');
  },
  errorElement: "span",
  errorPlacement: function(error, element) {
    if (element.is(":radio") || element.is(":checkbox")) {
      error.appendTo(element.parent().parent().parent());
    } else {
      error.appendTo(element.parent());
    }
  },
  errorClass: "help-block m-b-none",
  validClass: "help-block m-b-none"
});


function openLayer() {
  $(formId).form('clear');
  $(formId).valid();
  layerIndex = layer.open({
    type: 1,
    area: ['60%', '80%'], //宽高
    title: '新增',
    btn: ['保存', '关闭'],
    yes: function(index, layero) {
      $(formId).submit();
    },
    offset: '0',
    content: $(layerContent) //这里content是一个DOM
  });
}

$(function() {
  $(formId).validate({ ignore: "" });
});



$(formId).form({
  url: url + 'insertAjax',
  onSubmit: function() {
    return $(formId).valid();
  },
  success: function(result) {
    var result = eval('(' + result + ')');
    if (result.code && result.code == 1) {
      layer.close(layerIndex);
      $(tableId).trigger('reloadGrid');
    }
    layer.msg(result.msg);
  }
});


function deleteRow(id) {
  layer.confirm('您确定要删除么？', {
    btn: ['确定', '取消'] //按钮
  }, function() {
    $.post(url + 'deleteAjax', { idForShow: id }, function(result) {
      if (result.code && result.code == 1) {
        layer.close(layerIndex);
        $(tableId).trigger('reloadGrid');
      }
      layer.msg(result.msg);
    }, 'json');
  }, function() {

  });
}

function addSon(id) {
  openLayer();
  for (var i = 0; i < treeData.length; i++) {
    if (treeData[i].idForShow == id) {
      $('input[name="parent"]').val(treeData[i].id);
      $('input[name="level"]').val(++treeData[i].level);
      $(formId).valid();
    }
  }

}

function editRow(id) {
  openLayer();
  layer.title('修改', layerIndex);
  for (var i = 0; i < treeData.length; i++) {
    if (treeData[i].idForShow == id) {
      $(formId).form('load', treeData[i]);
      if (treeData[i].icon && treeData[i].icon.indexOf('/') == 0) {
        $('#img_label').html('<img src="" id="img_view" style="width:48px;height:48px;background:#ccc;"/>');
        $img = $('#img_view');
        $img.attr('src', base + treeData[i].icon);
      }
      $(formId).valid();
    }
  }
}
//查询  
function searchButton() {
 var nodeN=$('input[name="nodeN"]').val();
//传入查询条件参数  
$(tableId).jqGrid("setGridParam",{postData:{"nodeN":nodeN}});   
//每次提出新的查询都转到第一页  
$(tableId).jqGrid("setGridParam",{page:1});  
//提交post并刷新表格  
$(tableId).jqGrid("setGridParam",{url:"${base}/backstage/rbac/permission/search"}).trigger("reloadGrid");  
};  
</script>