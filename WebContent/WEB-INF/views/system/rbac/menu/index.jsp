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
     <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline">
            <div class="form-group clearfix">

              <label class="control-label  pull-left">菜单模块</label>
		       <div class=" pull-left" style="margin-left:10px;width:250px;">
		          <select id="menuT" name="menuT" data-placeholder=" " class="chosen-select select-hook" style="width:350px;" tabindex="4" required>
		            <option value=""></option>
		            <option value="">&nbsp;</option>
		              <c:forEach var="obj" items="<%=ServiceUtil.getService(\"ThemeService\").find(ServiceUtil.buildBean(\"Theme@isDeleted=0&belongType=2\"))%>">
                <option value="${obj.id}">${obj.titleBig}</option>
                </c:forEach>
		          </select>
		        </div>	        
              <div class="pull-left"  style="margin-left:10px;">
              <input type="text" placeholder="输入菜单名称" name="nodeN" class="form-control col-sm-8 input-hook">
              <button id="searchButton" type="searchButton" onclick="searchButton();" href="#" class="btn btn-primary">搜索</button>
                  <button id="clearButton" type="clearButton" onclick="clearButton();" href="#" class="btn btn-primary">清空搜索条件</button>
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
        <label class="col-sm-3 control-label">菜单模块：</label>
        <div class="col-sm-7" >
          <select name="menuType" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj"
                  items="<%=ServiceUtil.getService(\"ThemeService\").find(ServiceUtil.buildBean(\"Theme@isDeleted=0&belongType=2\"))%>">
                <option value="${obj.id}">${obj.titleBig}</option>
                </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">打开方式：</label>
        <div class="col-sm-7">
          <select name="openMethod" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"OPENMETHOD\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">URL链接：</label>
        <div class="col-sm-7">
          <input type="text" name="url" class="form-control" >
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">图标：</label>
        <div class="col-sm-7">
          <input type="text" name="icon" class="form-control" >
        </div>
      </div>
      <div class="form-group" >
        <div id="uploader-demo">
          <label class="col-sm-3 control-label"></label>
          <div class="col-sm-7">
          <label class="col-sm-3" id="img_label">
          </label>
          <div  class="col-sm-9" id="filePicker">选择图片</div>
        </div>
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

<script>
$("select[name='menuT']").chosen({
	  disable_search_threshold: 10,
	  no_results_text: "没有匹配到这条记录",
	  width: "100%"
	});
var layerIndex; //layer 窗口对象
var title_name = "菜单";
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var formId = '#eform'; //form id
var url = '${base}/backstage/rbac/menu/'; //controller 路径
var tableId = '#table_list_2';
var BASE_URL = '${base}/static/js/plugins/webuploader';
var $list = $("#fileList");
var treeData;
var thumbnailWidth = 48;
var thumbnailHeight = 48;
var uploader;
var inited = 0;

//初始化下拉框
function initChosen() {

  var chosen = $(".chosen-select").chosen({
    disable_search_threshold: 10,
    no_results_text: "没有匹配到这条记录",
    max_selected_options: 3,
    width: "100%"
  });

  chosen.on('change', function(e, params) {
    $(formId).valid();
  });

  $(".chosen-select").trigger("chosen:updated");

}

function initUploader() {
  if (inited == 0) {
    inited = 1;
  } else {
    uploader.destroy();
  }
  uploader = WebUploader.create({

    // 选完文件后，是否自动上传。
    auto: true,

    // swf文件路径
    swf: BASE_URL + '/Uploader.swf',

    // 文件接收服务端。 
    server: base + '/backstage/io/upload',

    // 选择文件的按钮。可选。
    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
    pick: '#filePicker',

    // 只允许选择图片文件。
    accept: {
      title: 'Images',
      extensions: 'gif,jpg,jpeg,bmp,png',
      mimeTypes: 'image/*'
    }
  });

  //当有文件添加进来的时候
  uploader.on('fileQueued', function(file) {
    $('#img_label').html('<img src="" id="img_view" style="width:48px;height:48px;background:#ccc;"/>');
    $img = $('#img_view');

    // 创建缩略图
    // 如果为非图片文件，可以不用调用此方法。
    // thumbnailWidth x thumbnailHeight 为 100 x 100
    uploader.makeThumb(file, function(error, src) {
      if (error) {
        $img.replaceWith('<span>不能预览</span>');
        return;
      }

      $img.attr('src', src);
    }, thumbnailWidth, thumbnailHeight);
  });



  // 文件上传成功，给item添加成功class, 用样式标记上传成功。
  uploader.on('uploadSuccess', function(file, response) {
    //$( '#'+file.id ).addClass('upload-state-done');
    $('input[name="icon"]').val(response.obj);
  });

  // 文件上传失败，显示上传出错。
  uploader.on('uploadError', function(file) {
    var $li = $('#' + file.id),
      $error = $li.find('div.error');

    // 避免重复创建
    if (!$error.length) {
      $error = $('<div class="error"></div>').appendTo($li);
    }

    $error.text('上传失败');
  });

  // 完成上传完了，成功或者失败，先删除进度条。
  uploader.on('uploadComplete', function(file) {
    $('#' + file.id).find('.progress').remove();
  });

}
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
    url: "${base}/backstage/rbac/menu/jqGridTreeJson",
    datatype: 'json',
    colNames: ['ID', '菜单名', '链接', '操作'],
    colModel: [
      { name: 'id', index: 'id', width: 200, sortable: false },
      { name: 'nodeName', index: 'nodeName', width: 150, sortable: false },
      { name: 'url', index: 'url', width: 300, sortable: false },
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
  $('#img_label').html('');
  $(formId).form('clear');
  initUploader();
  initChosen();
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
      $('.chosen-select[name="menuType"]').find("option[value='" + treeData[i].menuType + "']").prop("selected", true);
      $(".chosen-select").trigger("chosen:updated");
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
      //通知chosen下拉框更新
      $(".chosen-select").trigger("chosen:updated");
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
	 var menuT=$('select[name="menuT"]').val();
	 var nodeN=$('input[name="nodeN"]').val();
    //传入查询条件参数  
    $(tableId).jqGrid("setGridParam",{postData:{"menuT":menuT,"nodeN":nodeN}});   
    //每次提出新的查询都转到第一页  
    $(tableId).jqGrid("setGridParam",{page:1});  
    //提交post并刷新表格  
    $(tableId).jqGrid("setGridParam",{url:"${base}/backstage/rbac/menu/search"}).trigger("reloadGrid");  
};  

//清空搜索条件  
	function clearButton() {
    //传入查询条件参数     
    $("input[name='nodeN']").val(""); // 清空并获得焦点
	$("#menuT").val("");
	$(".chosen-select").trigger("chosen:updated");
    $(tableId).jqGrid("setGridParam",{postData:{"menuT":null,"nodeN":null}});   
    //每次提出新的查询都转到第一页  
    $(tableId).jqGrid("setGridParam",{page:1});  
    //提交post并刷新表格  
    $(tableId).jqGrid("setGridParam",{url:"${base}/backstage/rbac/menu/search"}).trigger("reloadGrid");  
};  
</script>