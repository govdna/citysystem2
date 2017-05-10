<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseHead.jsp"%>
<link href="${base}/static/plugins/jqgrid/ui.jqgrid.css" rel="stylesheet">
</head>
<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline">
            <div class="form-group">
              <input type="text" placeholder="输入字典名称" name="dicN" class="form-control col-sm-8">
              <div class="input-group-btn col-sm-4">
                <button type="button" onclick=" $('#dicList').bootstrapTable('refresh');" class="btn btn-primary">搜索
                </button>
              </div>
            </div>
            <div class="form-group" style="margin-left: 5px;">
              <div class="text-center">
                <c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/govmadeDic/index\") %>">
                <a data-toggle="modal" class="btn btn-primary" onclick="addNew();" href="#">新增</a>
                </c:if>
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
      <input type="hidden" name="level"  class="form-control">
      <input type="hidden" name="fatherId"  class="form-control">
      <div class="form-group">
        <label class="col-sm-3 control-label">字典名称：</label>
        <div class="col-sm-9">
          <input type="text" name="dicName" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">字典号：</label>
        <div class="col-sm-9">
          <input type="text" name="dicNum" class="form-control" required>
        </div>
      </div>
    </form>
    <div class="ibox-content" id="dicTree" style="padding-left:0px;padding-right:0px;">
      <div class="btn-group" id="toolbar" role="group" style="margin-bottom:15px;">
        <div class="text-center">
          <a data-toggle="modal" class="btn btn-primary" onclick="addNewXM();" href="#">新增字典项</a>
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
      <input type="hidden" name="level"  class="form-control">
      <input type="hidden" name="fatherId"  class="form-control">
      <input type="hidden" name="rootId"  class="form-control">
      <div class="form-group">
        <label class="col-sm-3 control-label">字典键：</label>
        <div class="col-sm-9">
          <input type="text" name="dicKey" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">字典值：</label>
        <div class="col-sm-9">
          <input type="text" name="dicValue" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">排序优先值：</label>
        <div class="col-sm-9">
          <input type="number" name="listNo" class="form-control" >
        </div>
      </div>
    </form>
  </div>

</body>
</html>

<%@include file="../common/includeJS.jsp"%>
<script src="${base}/static/plugins/jqgrid/i18n/grid.locale-cn.js"></script>
<script src="${base}/static/plugins/jqgrid/jquery.jqGrid.min.js"></script>
<script>
  var layerIndex; //layer 窗口对象
var title_name = "数据字典";
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var dicLayerContent = '#dic_form'; //layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var dicFormId = '#dicForm'; //form id
var url = '${base}/backstage/govmadeDic/'; //controller 路径
var dicLayerIndex;
var fatherDic;
var treeData;
var treeInited = 0;
//bootstrap-table 列数
var columns = [{
  field: 'dicName',
  title: '字典名称',
  sortable:true
}, {
  field: 'dicNum',
  title: '字典号',
  sortable:true
}, {
  field: 'id',
  title: '操作',
  formatter: 'doFormatter', //对本列数据做格式化
}];

//得到查询的参数
var queryParams = function(params) {
	var sort=params.sort;
	var order=params.order;
	if($('input[name="dicN"]').val()!=null&&$('input[name="dicN"]').val()!=""){
		sort="length(trim(dicName))";
		order="asc";
	}
  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: 100,
    page: 1,
    sort:sort,
    order:order,
    level: 1,
    dicName: $('input[name="dicN"]').val()
  };
  return temp;
};


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


function openLayer() {
  $(formId).form('clear');
  $('input[type="number"]').val('');
  initChosen();
  $(formId).valid();
  layerIndex = layer.open({
    type: 1,
    area: ['70%', '60%'], //宽高
    title: '新增',
    scrollbar: false,
    btn: ['保存', '关闭'],
    yes: function(index, layero) {
      $(formId).submit();
    },
    content: $(layerContent) //这里content是一个DOM
  });
}

function openDicLayer() {
  $(dicFormId).form('clear');
  $('input[type="number"]').val('');
  initChosen();
  $(dicFormId).valid();
  dicLayerIndex = layer.open({
    type: 1,
    area: ['70%', '60%'], //宽高
    title: '新增',
    scrollbar: false,
    btn: ['保存', '关闭'],
    yes: function(index, layero) {
      $(dicFormId).submit();
    },
    content: $(dicLayerContent) //这里content是一个DOM
  });
}




$(function() {

  //1.初始化Table
  oTable = new TableInit();
  oTable.Init();

  //2.初始化Button的点击事件
  /* var oButtonInit = new ButtonInit();
  oButtonInit.Init(); */
  $(formId).validate({ ignore: "" });
});


var TableInit = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $(tableId).bootstrapTable({
      url: url + 'listAjax', //请求后台的URL（*）
      method: 'post', //请求方式（*）
      contentType: "application/x-www-form-urlencoded",
      toolbar: toolbar, //工具按钮用哪个容器
      iconSize: 'outline',
      striped: true, //是否显示行间隔色
      cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
      pagination: false, //是否显示分页（*）
      sortable: true, //是否启用排序
      sortOrder: "asc", //排序方式
      queryParams: queryParams, //传递参数（*）
      sidePagination: "server", //分页方式：client客户端分页，server服务端分页（*）
      strictSearch: true,
      clickToSelect: false, //是否启用点击选中行
      uniqueId: "idForShow", //每一行的唯一标识，一般为主键列
      cardView: false, //是否显示详细视图
      detailView: false,
      queryParamsType: "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
      columns: columns
    });
  };
  return oTableInit;
};

function doFormatter(value, row, index) {
  var html = '';
  //html+='<div class="btn-group"><button data-toggle="dropdown" class="btn btn-primary btn-sm dropdown-toggle" aria-expanded="false">操作 <span class="caret"></span></button><ul class="dropdown-menu"> ';
  //html+='<li><a href="#" onclick="editRow(\''+row.idForShow+'\')">修改</a></li>';
  //html+='<li><a href="#" onclick="deleteRow(\''+row.idForShow+'\')">删除</a></li></ul> </div>';
  html += '<div class="btn-group">';
  //html+='<button type="button" class="btn btn-white"><i class="fa fa-plus"></i>&nbsp;添加字典项</button>';
  <c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/govmadeDic/index\") %>">
  html += '<button type="button" class="btn btn-white" onclick="editRow(\'' + row.idForShow + '\')"><i class="fa fa-pencil"></i>&nbsp;编辑</button>';
  </c:if>
  <c:if test="<%=!ServiceUtil.haveDel(\"/backstage/govmadeDic/index\") %>">
  html += '<button type="button" class="btn btn-white" onclick="deleteRow(\'' + row.idForShow + '\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
  </c:if>
  html += '</div>';
  return html;
}

$(formId).form({
  url: url + 'insertAjax',
  onSubmit: function() {
    return $(formId).valid();
  },
  success: function(result) {
    var result = eval('(' + result + ')');
    if (result.code && result.code == 1) {
      layer.close(layerIndex);
      $(tableId).bootstrapTable('refresh');
    }
    layer.msg(result.msg);
  }
});

$(dicFormId).form({
  url: url + 'insertAjax',
  onSubmit: function() {
    return $(dicFormId).valid();
  },
  success: function(result) {
    var result = eval('(' + result + ')');
    if (result.code && result.code == 1) {
      layer.close(dicLayerIndex);
      $('#table_list_2').trigger('reloadGrid');
    }
    layer.msg(result.msg);
  }
});


function addNew() {
  openLayer();
  $("#dicTree").hide();
  $("input[name='level']").val(1);
  $("input[name='fatherId']").val(0);
}


function addNewXM() {
  openDicLayer();
  $(dicFormId).find('input[name="rootId"]').val(fatherDic.id);
  $(dicFormId).find('input[name="level"]').val(2);
  $(dicFormId).find('input[name="fatherId"]').val(fatherDic.id);
}


function deleteRow(id) {
  layer.confirm('您确定要删除么？', {
    btn: ['确定', '取消'] //按钮
  }, function() {
    $.post(url + 'deleteAjax', { idForShow: id }, function(result) {
      if (result.code && result.code == 1) {
        layer.close(layerIndex);
        $(tableId).bootstrapTable('refresh');
      }
      layer.msg(result.msg);
    }, 'json');
  }, function() {

  });
}

function deleteDicRow(id) {
  layer.confirm('您确定要删除么？', {
    btn: ['确定', '取消'] //按钮
  }, function() {
    $.post(url + 'deleteAjax', { idForShow: id }, function(result) {
      if (result.code && result.code == 1) {
        layer.close(dicLayerIndex);
        $('#table_list_2').jqGrid('setGridParam', { url: url + "jqGridTreeJson?rootId=" + fatherDic.id }).trigger('reloadGrid');

      }
      layer.msg(result.msg);
    }, 'json');
  }, function() {

  });
}

function addSon(id) {
  openDicLayer();
  layer.title('新增子字典项', dicLayerIndex);
  for (var i = 0; i < treeData.length; i++) {
    if (treeData[i].idForShow == id) {
      $(dicFormId).find('input[name="rootId"]').val(fatherDic.id);
      $(dicFormId).find('input[name="level"]').val(++treeData[i].level);
      $(dicFormId).find('input[name="fatherId"]').val(treeData[i].id);
      $(formId).valid();
    }
  }

}

function editRow(id) {
  openLayer();
  layer.title('编辑', layerIndex);
  $("#dicTree").show();
  $(formId).form('load', $(tableId).bootstrapTable('getRowByUniqueId', id));
  fatherDic = $(tableId).bootstrapTable('getRowByUniqueId', id);
  //通知chosen下拉框更新
  initTree();
  $(".chosen-select").trigger("chosen:updated");
  $(formId).valid();
}

function editDicRow(id) {
  openDicLayer();
  for (var i = 0; i < treeData.length; i++) {
    if (treeData[i].idForShow == id) {
      $(dicFormId).form('load', treeData[i]);
      $(dicFormId).valid();
    }
  }

}

function button(cellvalue, options, rowObject) {
  var html = '';
  html += '<div class="btn-group">';
  //html+='<button type="button" class="btn btn-default">按钮 1</button>';
  <c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/govmadeDic/index\") %>">
  html += '<button type="button" class="btn btn-white" onclick="addSon(\'' + rowObject.idForShow + '\')"><i class="fa fa-plus"></i>&nbsp;添加子字典</button>';
  </c:if>
  <c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/govmadeDic/index\") %>">
  html += '<button type="button" class="btn btn-white" onclick="editDicRow(\'' + rowObject.idForShow + '\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
  </c:if>
  <c:if test="<%=!ServiceUtil.haveDel(\"/backstage/govmadeDic/index\") %>">
  html += '<button type="button" class="btn btn-white" onclick="deleteDicRow(\'' + rowObject.idForShow + '\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
  </c:if>
  html += '</div>';
  return html;
}

function initTree() {
  if (treeInited == 1) {
    $('#table_list_2').jqGrid('setGridParam', { url: url + "jqGridTreeJson?rootId=" + fatherDic.id }).trigger('reloadGrid');
    return;
  }
  treeInited = 1;
  $.jgrid.defaults.styleUI = 'Bootstrap';

  $('#table_list_2').jqGrid({
    treeGrid: true,
    treeGridModel: 'adjacency', //treeGrid模式，跟json元数据有关 ,adjacency/nested
    ExpandColumn: 'name',
    scroll: true,
    autowidth: true,
    shrinkToFit: false, //是否默认宽度
    forceFit: true,
    url: url + "jqGridTreeJson?rootId=" + fatherDic.id,
    datatype: 'json',
    colNames: ['字典键', '字典值', '操作'],
    colModel: [
      { name: 'dicKey', index: 'dicKey', width: 200, sortable: false },
      { name: 'dicValue', index: 'dicValue', width: 100, sortable: false },
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
    height: 350, // 设为具体数值则会根据实际记录数出现垂直滚动条
    rowNum: "-1", // 显示全部记录
    shrinkToFit: true, // 控制水平滚动条
    loadComplete: function(data) {
      treeData = data;
    }
  });

}

</script>