<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseHead.jsp"%>
<link href="${base}/static/plugins/jqgrid/ui.jqgrid.css" rel="stylesheet">
</head>
<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  
<div class="wrapper wrapper-content  animated fadeInRight">
  <div class="row">
    <div class="col-sm-12">
      <div class="ibox ">
        <div class="ibox-title">
          <h5>前台菜单</h5>
          <div class="ibox-tools">
            <a href="projects.html" class="btn btn-primary btn-xs"><i class="fa fa-plus"></i> 新建</a>
          </div>
        </div>
        <div class="ibox-content">
          <div class="jqGrid_wrapper">
            <table id="table_list_2"></table>
            <div id="pager_list_2"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<!-- 添加菜单模态框开始 -->
<div id="modal-form-add" class="modal fade" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
          &times;
        </button>
        <h4 class="modal-title" id="myModalLabel">
          添加菜单
        </h4>
      </div>
      <div class="modal-body">
        <div class="row">
          <div class="col-sm-12 b-r">
            <form role="form" action="{:U('Admin/Menu/add')}" method="post">
              <div class="form-group">
                <label>菜单名：</label>
                <input type="text" name="name" placeholder="菜单名" class="form-control">
              </div>
              <div class="form-group">
                <label>链接：</label>
                <input type="text" name="url" placeholder="链接" class="form-control">
                <span class="help-block m-b-none">输入模块/控制器/方法即可 例如 Admin/Nav/index</span>
              </div>
              <div class="form-group">
                <label>SEO：</label>
                <input type="text" name="seo" placeholder="" class="form-control">
                <span class="help-block m-b-none"> 用于SEO优化</span>
              </div>
              <div>
                <input type="hidden" name="pid" placeholder="" class="form-control">
                <button class="btn btn-sm btn-primary pull-right m-t-n-xs" type="submit"><strong>保存</strong>
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<!-- 添加菜单模态框结束 -->
<!-- 修改菜单模态框开始 -->
<div id="modal-form-edit" class="modal fade" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
          &times;
        </button>
        <h4 class="modal-title" id="myModalLabel">
            修改菜单
          </h4>
      </div>
      <div class="modal-body">
        <div class="row">
          <div class="col-sm-12 b-r">
            <form role="form" action="{:U('Admin/Menu/edit')}" method="post">
              <div class="form-group">
                <label>菜单名：</label>
                <input type="text" name="name" placeholder="菜单名" class="form-control">
              </div>
              <div class="form-group">
                <label>链接：</label>
                <input type="text" name="url" placeholder="链接" class="form-control">
                <span class="help-block m-b-none">输入模块/控制器/方法即可 例如 Admin/Nav/index</span>
              </div>
              <div class="form-group">
                <label>SEO：</label>
                <input type="text" name="seo" placeholder="" class="form-control">
                <span class="help-block m-b-none"> 用于SEO优化</span>
              </div>
              <div>
                <input type="hidden" name="id" placeholder="" class="form-control">
                <button class="btn btn-sm btn-primary pull-right m-t-n-xs" type="submit"><strong>保存</strong>
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<!-- 修改菜单模态框结束 -->
</body>
</html>

<%@include file="../common/includeJS.jsp"%>
<script src="${base}/static/plugins/jqgrid/i18n/grid.locale-cn.js"></script>
<script src="${base}/static/plugins/jqgrid/jquery.jqGrid.min.js"></script>

<script>
var title_name = "编目";
$(document).ready(function() {
  $.jgrid.defaults.styleUI = 'Bootstrap';

  $("#table_list_2").jqGrid({
    treeGrid: true,
    treeGridModel: 'adjacency', //treeGrid模式，跟json元数据有关 ,adjacency/nested
    ExpandColumn: 'name',
    scroll: true,
    autowidth: true,
    shrinkToFit: false, //是否默认宽度
    forceFit: true,
    url: "${base}/static/json/a.json",
    datatype: 'json',
    colNames: ['编号', '菜单名', '链接', '操作'],
    colModel: [
      { name: 'id', index: 'id', width: 100, sorttype: "int" },
      { name: 'name', index: 'name', width: 300 },
      { name: 'url', index: 'url', width: 500 },
      { name: 'id', index: 'id', width: 300, align: 'center', formatter: button }
    ], //name 列显示的名称；index 传到服务器端用来排序用的列名称；width 列宽度；align 对齐方式；sortable 是否可以排序
    pager: "false",
    treeReader: {
      level_field: "_level", //层次结构中的级别
      parent_id_field: "pid", //记录父类id
      leaf_field: "_isleaf", //是否叶节点
      expanded_field: "_end" //是否该元素在加载过程中应展开
    },
    // caption: "前台菜单",
    hidegrid: false,
    mtype: "get",
    height: 450, // 设为具体数值则会根据实际记录数出现垂直滚动条
    rowNum: "-1", // 显示全部记录
    shrinkToFit: true // 控制水平滚动条
  });

  function button(cellvalue, options, rowObject) {
    return '<a class="btn btn-white btn-sm" navId="' + rowObject["id"] + '" onclick="add_child(this)"><i class="fa fa-plus"></i>添加子菜单</a>' +
      '<a class="btn btn-white btn-sm" navId="' + rowObject["id"] + '" navName="' + rowObject["name"] + '" navUrl="' + rowObject["url"] + '" navSeo="' + rowObject["seo"] + '" onclick="edit(this)"><i class="fa fa-pencil"></i> 修改 </a>' +
      '<a class="btn btn-white btn-sm" href="javascript:if(confirm(\'确定删除？\'))location=\'/index.php/Admin/Menu/delete/id/' + rowObject["id"] + '\'"><i class="fa fa-trash"></i> 删除 </a>'
  }
});

// 添加菜单
function add() {
  $("input[name='name'],input[name='url']").val('');
  $("input[name='pid']").val(0);
  $('modal-form-add').modal('show');
}

// 添加子菜单
function add_child(obj) {
  var navId = $(obj).attr('navId');
  $("input[name='pid']").val(navId);
  $("input[name='name']").val('');
  $("input[name='url']").val('');
  $("input[name='seo']").val('');
  $('#modal-form-add').modal('show');
}

// 修改菜单
function edit(obj) {
  var navId = $(obj).attr('navId');
  var navName = $(obj).attr('navName');
  var navUrl = $(obj).attr('navUrl');
  var navSeo = $(obj).attr('navSeo');
  $("input[name='id']").val(navId);
  $("input[name='name']").val(navName);
  $("input[name='url']").val(navUrl);
  $("input[name='seo']").val(navSeo);
  $('#modal-form-edit').modal('show');
}

</script>

