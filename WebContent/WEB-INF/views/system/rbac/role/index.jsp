<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
<link rel="stylesheet" type="text/css" href="${base}/static/js/easyui/css/themes/material/easyui.css">
<link rel="stylesheet" type="text/css" href="${base}/static/js/easyui/css/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${base}/static/js/easyui/css/themes/IconExtension.css">
<link rel="stylesheet" type="text/css" href="${base}/static/js/easyui/css/themes/color.css">
<script type="text/javascript" src="${base}/static/js/easyui/libs/jquery.min.js"></script>
<script type="text/javascript" src="${base}/static/js/easyui/plugin/jquery.easyui.min.js"></script>
</head>
<style>
#layer_form .datagrid-cell{
  padding: 10px 4px;
}
body .layui-layer-title {
  background-color: #fff;
  border-radius: 5px;
}
body .layui-layer {
  border-radius: 5px;
}

body .layui-layer-content .ibox-content{
  border: 0;
}
.layui-layer .panel-heading {
  background-color: #bfbfbf;
  border: 0;
  font-weight: 700;
}
body .layui-layer-btn0 {
  background-color: #bfbfbf;
  border-color: #bfbfbf;
}
.tree-file {
  background: url(${base}/static/images/icon/icon_3.png) no-repeat;
}
.tree-folder {
  background: url(${base}/static/images/icon/icon_2.png) no-repeat;
}
</style>
<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline">
            <div class="form-group">
              <input type="text" placeholder="输入角色名" name="Name1" class="form-control col-sm-8">
              <div class="input-group-btn col-sm-4">
                <button type="button" onclick=" $('#dicList').bootstrapTable('refresh');" class="btn btn-primary">搜索
                </button>
              </div>
            </div>
            <div class="form-group" style="margin-left: 15px;">
              <div class="text-center">
                <a data-toggle="modal" class="btn btn-primary" onclick="addNew();" href="#">新增</a>
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
      <div class="form-group">
        <label class="col-sm-2 control-label">角色名：</label>
        <div class="col-sm-10">
          <input type="text" name="name" class="form-control">
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-2 control-label">描述：</label>
        <div class="col-sm-10">
          <input type="text" name="note" class="form-control">
        </div>
      </div>
      <div class="hr-line-dashed"></div>
      <div>
        <div class="panel panel-primary">
          <div class="panel-heading">
            选择权限
          </div>
          <div class="panel-body">
            <table id="dg-rbacrole-perm" data-options="border:false" style="max-height: 200px"></table>
          </div>
        </div>
      </div>
      <div class="hr-line-dashed"></div>
      <div>
        <div class="panel panel-primary">
          <div class="panel-heading">
            选择菜单
          </div>
          <div class="panel-body">
            <table id="dg-rbacrole-menu" data-options="border:false" style="max-height: 200px"></table>
          </div>
        </div>
      </div>
    </form>
  </div>
</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script>
  var layerIndex; //layer 窗口对象
 var title_name = "角色";
 var layerContent = '#layer_form'; //layer窗口主体内容dom Id
 var tableId = '#dicList'; //bootstrap-table id
 var toolbar = '#toolbar'; //bootstrap-table 工具栏id
 var formId = '#eform'; //form id
 var url = '${base}/backstage/rbac/role/'; //controller 路径



 var rbacroleperm = {
   columns: [
     [{
       field: 'nodeNameForShow',
       title: '权限名称:',
       width: 200,
       formatter: function(value, rowData) {
         return "<input type='checkbox' name='sel_permissions' value='" + rowData.id + "' class='dg-rbacrole-perm dg-rbacrole-perm-" + rowData.id + "' " + (rowData.isChecked ? 'checked' : '') + "/>" + value;
       }
     }, {
       field: 'scopes',
       title: '数据权限',
       width: 500,
       formatter: function(value, rowData) {
         var inputbox = "";
         $.each(value, function(i, v) {
           inputbox += "<input type='checkbox' name='sel_scopes' value='" + v.value + "' " + (v.isChecked ? 'checked' : '') + ">" + v.name;
         });
         return inputbox;
       }
     }]
   ]
 };

 var rbacrolemenu = {
   columns: [
     [{
       field: 'nodeNameForShow',
       title: '菜单名称:',
       width: 200,
       formatter: function(value, rowData) {
         return "<input type='checkbox' name='sel_permissions' value='" + rowData.id + "' class='dg-rbacrole-menu dg-rbacrole-menu-" + rowData.id + "' " + (rowData.isChecked ? 'checked' : '') + "/>" + value;
       }
     }]
   ]
 };


 //bootstrap-table 列数
 var columns = [{
   field: 'name',
   title: '角色名称'
 }, {
   field: 'note',
   title: '描述'
 }, {
   field: 'id',
   title: '操作',
   formatter: 'doFormatter', //对本列数据做格式化
 }];

 //得到查询的参数
 var queryParams = function(params) {

   var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
     rows: params.limit,
     page: params.offset / params.limit + 1,
     name: $('input[name="Name1"]').val()
   };
   return temp;
 };

 function doTreeCheck(treegrid) {
   $(document).delegate("." + treegrid, "click", function(event) {
     var checkid = $(this).val();
     var nodes = $("#" + treegrid).treegrid("getChildren", checkid);
     //console.log(nodes);        
     for (i = 0; i < nodes.length; i++) {
       $("." + treegrid + "-" + nodes[i].id)[0].checked = $(this)[0].checked;
     }

     //选上级节点
     if ($(this)[0].checked) {
       var parent = $("#" + treegrid).treegrid("getParent", checkid);
       $("." + treegrid + "-" + parent.id)[0].checked = true;
       while (parent) {
         parent = $("#" + treegrid).treegrid("getParent", parent.id);
         $("." + treegrid + "-" + parent.id)[0].checked = true;
       }
     } else {
       var parent = $("#" + treegrid).treegrid("getParent", checkid);
       //console.log(parent);
       var flag = true;
       var sons = parent.children;
       for (j = 0; j < sons.length; j++) {
         if ($("." + treegrid + "-" + sons[j].id)[0].checked) {
           flag = false;
           break;
         }
       }
       if (flag) {
         $("." + treegrid + "-" + parent.id)[0].checked = false;
       }
       while (flag) {
         parent = $("#" + treegrid).treegrid("getParent", parent.id);
         if (parent) {
           sons = parent.children;
           for (j = 0; j < sons.length; j++) {
             if ($("." + treegrid + "-" + sons[j].id)[0].checked) {
               flag = false;
               break;
             }
           }
         }
         if (flag) {
           $("." + treegrid + "-" + parent.id)[0].checked = false;
         }
       }
     }

   });
 }

 function getTreegrid(me, tgurl, tgtitle, tgpage, tgtoolbar, tgcolumns, tgfit, tgIf, tgTf) {
   me.treegrid({
     url: tgurl,
     title: tgtitle,
     pagination: tgpage,
     pageSize: 10,
     fitColumns: tgfit,
     columns: tgcolumns,
     toolbar: tgtoolbar,
     idField: tgIf,
     singleSelect: false,
     checkOnSelect: false,
     treeField: tgTf,
     onLoadSuccess: function() {
       me.treegrid('collapseAll'); //折叠所有节点
     }
   });

 }

</script>
<%@include file="../../common/baseSystemJS.jsp"%>
<script>
var treeInited=0;
function addNew(){
  openLayer();
  if(treeInited==0){
    var rbacrolepermcolumns = rbacroleperm.columns;
    var rbacrolemenucolumns = rbacrolemenu.columns;
    getTreegrid($("#dg-rbacrole-perm"),base+'/backstage/rbac/role/detailAjax',null,false,'',rbacrolepermcolumns,true,'id','nodeNameForShow');
    getTreegrid($("#dg-rbacrole-menu"),base+'/backstage/rbac/role/detailAjax?menu=y',null,false,'',rbacrolemenucolumns,true,'id','nodeNameForShow');
    treeInited=1;
  }
}

function editRow(id){
  openLayer();
  layer.title('修改', layerIndex);
  //dg-rbacrole-perm
  var rbacrolepermcolumns = rbacroleperm.columns;
  var rbacrolemenucolumns = rbacrolemenu.columns;
  $(formId).form('load',$(tableId).bootstrapTable('getRowByUniqueId', id));
  getTreegrid($("#dg-rbacrole-perm"),base+'/backstage/rbac/role/detailAjax?idForShow='+id,null,false,'',rbacrolepermcolumns,true,'id','nodeNameForShow');
  getTreegrid($("#dg-rbacrole-menu"),base+'/backstage/rbac/role/detailAjax?menu=y&idForShow='+id,null,false,'',rbacrolemenucolumns,true,'id','nodeNameForShow');
  $(formId).valid();
}
</script>

