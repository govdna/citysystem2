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
            <div class="btn-group" id="toolbar" role="group">
              <div class="text-center">
                <c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/city/index\") %>">
                <a data-toggle="modal" class="btn btn-primary" onclick="addNew();" href="#">新增</a>
                </c:if>
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
      <input type="hidden" name="id"  class="form-control">
      <input type="hidden" name="idForShow" >
      <input type="hidden" name="fatherId" >
      <input type="hidden" name="level" >
      <div class="form-group">
        <label class="col-sm-3 control-label">城市编号：</label>
        <div class="col-sm-7">
          <input type="text" name="number"  class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">城市名称：</label>
        <div class="col-sm-7">
          <input type="text" name="cityName"  class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">城市级别：</label>
        <div class="col-sm-7">
           <select name="level" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"CITYLEVEL\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>
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
var title_name = "城市";
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var formId = '#eform'; //form id
var url = '${base}/backstage/city/'; //controller 路径
var tableId = '#table_list_2';
var treeData;


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
    url: url + "jqGridTreeJson",
    datatype: 'json',
    colNames: ['城市编号', '城市名称', '操作'],
    colModel: [
      { name: 'number', index: 'number', width: 200, sortable: false },
      { name: 'cityName', index: 'cityName', width: 170, sortable: false },
      { name: 'id', index: 'id', width: 400, align: 'center', sortable: false, formatter: button }
    ], //name 列显示的名称；index 传到服务器端用来排序用的列名称；width 列宽度；align 对齐方式；sortable 是否可以排序
    pager: "false",
    treeReader: {
      level_field: "level", //层次结构中的级别
      parent_id_field: "fatherId", //记录父类id
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
    <c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/city/index\") %>">
    html += '<button type="button" class="btn btn-white" onclick="addSon(\'' + rowObject.idForShow + '\')"><i class="fa fa-plus"></i>&nbsp;添加子城市</button>';
    </c:if>
    <c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/city/index\") %>">
    html += '<button type="button" class="btn btn-white" onclick="editRow(\'' + rowObject.idForShow + '\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
    </c:if>
    <c:if test="<%=!ServiceUtil.haveDel(\"/backstage/city/index\") %>">
    html += '<button type="button" class="btn btn-white" onclick="deleteRow(\'' + rowObject.idForShow + '\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
    </c:if>
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
  $(formId + ' input[type="number"]').val('');
  initChosen();
  $(formId).valid();
  layerIndex = layer.open({
    type: 1,
    area: ['60%', '80%'], //宽高
    title: '新增',
    scrollbar: false,
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

function addNew() {
  openLayer();
  $('input[name="fatherId"]').val(0);
  $('input[name="level"]').val(1);
}

function addSon(id) {
  openLayer();
  for (var i = 0; i < treeData.length; i++) {
    if (treeData[i].idForShow == id) {
      $('input[name="fatherId"]').val(treeData[i].id);
      $('input[name="level"]').val(++treeData[i].level);
      $(formId).valid();
    }
  }
}

function editRow(id) {
  openLayer();
  for (var i = 0; i < treeData.length; i++) {
    if (treeData[i].idForShow == id) {
      $(formId).form('load', treeData[i]);
      $(".chosen-select").trigger("chosen:updated");
      $(formId).valid();
    }
  }

}

</script>
