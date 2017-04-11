<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en"> 
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
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
                <a data-toggle="modal" class="btn btn-primary" onclick="openLayer();" href="#">自定义</a>
                <a data-toggle="modal" class="btn btn-primary" onclick="openDicLayer();" href="#">选择模板</a>
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
      <input type="hidden" name="status" class="form-control">
      <div class="form-group">
        <label class="col-sm-3 control-label">中文名称：</label>
        <div class="col-sm-7">
          <input type="text" name="chName" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">定义：</label>
        <div class="col-sm-7">
          <input type="text" name="define" class="form-control">
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">数据类型：</label>
        <div class="col-sm-7">
          <select name="dataType" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required >
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"DATATYPE\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">数据长度：</label>
        <div class="col-sm-7">
          <input type="text" name="dataFormat" class="form-control" required >
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">对象类型：</label>
        <div class="col-sm-7">
          <select name="objectType" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required >
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"OBJECTTYPE\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">备注：</label>
        <div class="col-sm-7">
          <input type="text" name="notes" class="form-control"  >
        </div>
      </div>
    </form>
  </div>
  
  <div id="detailForm" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="dform">
      <input type="hidden" name="id"  class="form-control">
      <input type="hidden" name="idForShow"  class="form-control">
      <input type="hidden" name="status"  class="form-control">
      <div class="form-group">
        <label class="col-sm-3 control-label">内部标识符：</label>
        <div class="col-sm-7">
          <input type="text" name="identifier"  class="form-control" required disabled="true"　readOnly="true" >
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">中文名称：</label>
        <div class="col-sm-7">
          <input type="text" name="chName"  class="form-control" required disabled="true"　readOnly="true" >
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">定义：</label>
        <div class="col-sm-7">
          <input type="text" name="define" class="form-control" required disabled="true"　readOnly="true" >
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">数据类型：</label>
        <div class="col-sm-7">
          <select name="dataType" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required disabled="true"　readOnly="true" >
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"DATATYPE\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">数据长度：</label>
        <div class="col-sm-7">
          <input type="text" name="dataFormat" class="form-control" required disabled="true"　readOnly="true" >
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">对象类型：</label>
        <div class="col-sm-7">
          <select name="objectType" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4"required disabled="true"　readOnly="true" >
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"OBJECTTYPE\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">备注：</label>
        <div class="col-sm-7">
          <input type="text" name="notes" class="form-control" required disabled="true"　readOnly="true" >
        </div>
      </div>
    </form>
  </div>

  <div id="dic_form" style="display: none;" class="ibox-content">
    <div class="row form-horizontal" style="overflow: hidden;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div class="form-group">
          <label class="col-sm-2 control-label">对象类</label>
          <div class="col-sm-4">
            <select name="dxl-select" data-placeholder=" " class="chosen-select">
              <option value=""></option>
              <option value="">全部</option>
              <c:forEach var="obj"
                items="<%=ServiceUtil.getDicByDicNum(\"OBJECTTYPE\")%>">
                <option value="${obj.dicKey}">${obj.dicValue}</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-sm-6">
            <div class="input-group">
              <input type="text" placeholder="输入名称" name="keyword" class="form-control"> <span class="input-group-btn"> <button type="button" onclick=" $('#dm3').bootstrapTable('refresh');" class="btn btn-primary">搜索
              </button> </span>
            </div>
          </div>
        </div>
        <table id="dm3"></table>
        </div>
      </div>
    </div>
  </div>

  <div id="dataElement-detail" class="form-horizontal" style="overflow: hidden;display:none;">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div class="form-group">
          <label class="col-sm-4 control-label">内部标识符：</label>
          <span class="col-sm-8 dt-span" name="identifier"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">中文名称：</label>
          <span class="col-sm-8 dt-span" name="chName"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">定义：</label>
          <span class="col-sm-8 dt-span" name="define"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">数据类型：</label>
          <span class="col-sm-8 dt-span" name="dataTypeForShow"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">数据长度：</label>
          <span class="col-sm-8 dt-span" name="dataFormat"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-4 control-label">对象类型：</label>
          <span class="col-sm-8 dt-span" name="objectTypeForShow"></span>
        </div>
      </div>
    </div>
  </div>

</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script>
//验证名称重复
$("input[name='chName']").blur(function() {
  jQuery.post("${base}/backstage/dataElement/validation", { "chName": $("input[name='chName']").val() }, function(data) {
    data = JSON.parse(data);
    if (data.results == 1) {
      layer.msg("此中文名称已存在，请重新填写");
      $("input[name='chName']").val("");
    }
  });
});



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

var detailContent = '#detailForm';
var dformId = '#dform';

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
var queryParams3 = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
    objectType: $('select[name="dxl-select"]').val(),
    chName: $('input[name="keyword"]').val()
  };
  return temp;
};

$(function() {
  //1.初始化Table
  oTable3 = new TableInit3();
  oTable3.Init();
});

//bootstrap-table 列数
var columns = [{
  field: 'identifier',
  title: '内部标识符'
}, {
  field: 'chName',
  title: '中文名称'
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
  formatter: 'doFormatter0', //对本列数据做格式化
}];

function doFormatter0(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="readonly(\'' + row.idForShow + '\')">查看</button>';
  html += '</div>';
  return html;
}

function openLayer1() {
  $(dformId).form('clear');
  initChosen();
  $(dformId).valid();
  layerIndex = layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '新增',
    scrollbar: false,
    btn: ['关闭'],
    yes: function(index, layero) {
      layer.close(index);
    },
    offset: '20px',
    content: $(detailContent) //这里content是一个DOM
  });
}

function readonly(id) {
  openLayer1();
  layer.title('查看', layerIndex);
  var data = $(tableId).bootstrapTable('getRowByUniqueId', id);
  $(dformId).form('load', data);
  //通知chosen下拉框更新
  var cs = $(".chosen-select");
  if (cs.length) {
    for (var i = 0; i < cs.length; i++) {
      if ($(cs[i]).attr('data-bind')) {
        var cid = $(cs[i]).attr('data-bind');
        var p = {};
        p[$(cs[i]).attr("data-param")] = $(cs[i]).val();
        initAjaxChosen(cid, $(cid).attr('data-url'), p, data[$(cid).attr('name')]);
      }

    }
  }
  $(".chosen-select").trigger("chosen:updated");
  $(dformId).valid();
}

  //得到查询的参数
  var queryParams = function(params) {

    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1,
      groupId : <%= AccountShiroUtil.getCurrentUser().getGroupId() %>,
    chName:$('input[name="chN"]').val()
    };
    return temp;
  };
  function openDicLayer() {
     $('#dm3').bootstrapTable('refresh');
     initChosen();
    dicLayerIndex = layer.open({
      type : 1,
      area : [ '70%', '80%' ], //宽高
      title : '选择模板',
      scrollbar : false,
      btn : [ '保存', '关闭' ],
      yes : function(index, layero) {
        var adIds = "";
            $("input:checkbox[name='dmname']:checked").each(function(i){  
                if(0==i){
                    adIds = $(this).val();  
                }else{
                    adIds += (","+$(this).val());  
                }
            });
            $.ajax({
                 type: "POST",
                 url: "${base}/backstage/govRdataElement/insertList",
                 data: {ids:adIds},
                 dataType: "json",
                 success: function(result){
                             if(result.stips && result.ftips){
                               layer.msg(result.stips+result.ftips);
                             }else if(result.stips && typeof(result.ftips) == "undefined"){
                               layer.msg(result.stips);
                               $('#dicList').bootstrapTable('refresh');
                               layer.close(index);
                             }else{
                               layer.msg(result.ftips);
                               $('#dicList').bootstrapTable('refresh');
                               layer.close(index);
                             }
                          }
             });
            },
      offset : '20px',
      content : $(dicLayerContent)
    //这里content是一个DOM
    });
  }
  var TableInit3 = function() {
    var oTableInit = new Object();
    //初始化Table
    oTableInit.Init = function() {
      $('#dm3').bootstrapTable({
        url : '${base}/backstage/dataElement/listAjax?status=6&classType=1', //请求后台的URL（*）
        method : 'post', //请求方式（*）
        contentType : "application/x-www-form-urlencoded",
        iconSize : 'outline',
        striped : true, //是否显示行间隔色
        cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        pagination : true, //是否显示分页（*）
        sortable : false, //是否启用排序
        sortOrder : "asc", //排序方式
        queryParams : queryParams3,//传递参数（*）
        sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
        pageNumber : 1, //初始化加载第一页，默认第一页
        pageSize : 10, //每页的记录行数（*）
        pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
        strictSearch : true,
        clickToSelect : false, //是否启用点击选中行
        uniqueId : "idForShow", //每一行的唯一标识，一般为主键列
        cardView : false, //是否显示详细视图
        detailView : false,
        queryParamsType : "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
        columns : [{
          field : 'id',
          title : '添加',
          formatter : 'doFormatter3'
                },{
          field : 'identifier',
          title : '内部资源标识符'
        }, {

          field : 'chName',
          title : '中文名称'
        }, {
          field : 'id',
          title : '操作',
          formatter : 'doFormatter4'
        }]
      });
    };
    return oTableInit;
  };

  function doFormatter3(value, row, index)
  {
    var html='';
    html+='<div class="btn-group">';
    html+='<input type="checkbox" name="dmname" value="'+row.id+'"/> ';
    html+='</div>';
    return html;
  }
  function doFormatter4(value, row, index) {
    var html = '';
    html += '<div class="btn-group">';
    html+='<button type="button" class="btn btn-white" onclick="detail(\''+row.idForShow+'\')">查看</button>';
    html += '</div>';
    return html;
  }
  function detail(id,tableId){console.log(dataEles);
    var data;
    if(!tableId){
      for(var j=0;j<dataEles.length;j++){
        if(dataEles[j].idForShow==id){
          data=dataEles[j];
        }
      }
    }else{
      data=$(tableId).bootstrapTable('getRowByUniqueId', id);
    }
    
    var sp=$('#dataElement-detail span');
    if(sp.length){
      for(var i=0;i<sp.length;i++){
        if($(sp[i]).attr('name')&&$(sp[i]).attr('name')!=null){
          var nm=$(sp[i]).attr('name');
          var value=data[nm];
          $(sp[i]).html(value);
        }
      }
    }
    layer.open({
        type: 1,
        shade: false,
        area : [ '400px', '380px' ], //宽高
        scrollbar : false,
        title: false, //不显示标题
        content: $('#dataElement-detail')
      });    
  }

</script>
<%@include file="../../common/baseSystemJS.jsp"%>
