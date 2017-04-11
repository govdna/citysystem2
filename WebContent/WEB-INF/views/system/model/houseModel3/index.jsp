<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
</head>
<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div class="btn-group hidden-xs" id="toolbar" role="group">
          <div class="text-center">
            <a data-toggle="modal" id="addhm" class="btn btn-primary" onclick="openLayer();" href="#">新增</a>
          </div>
        </div>
        <table id="dicList">
        </table>
      </div>
    </div>
  </div>

  <div id="layer_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="eform">
      <input type="hidden" name="id"  class="form-control">
      <input type="hidden" name="idForShow"  class="form-control">  
      <input type="hidden" name="dataElementId" />
      <div class="form-group">
        <label class="col-sm-3 control-label">信息类：</label>
        <div class="col-sm-7">
          <select id="infoTypes" name="infoTypes" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value="1">基础信息</option>
            <option value="2">扩展信息</option>
            <option value="3">专项信息</option>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">专项信息名称：</label>
        <div class="col-sm-7">
          <input type="text" name="infoName" class="form-control" required>
        </div>
      </div>  
      <div class="form-group show3" id="dicTree2" style="display: none;" >
        <label class="col-sm-3 control-label">信息资源名称：</label>
        <div class="col-sm-7">        
          <select name="informationResId" id="informationResId" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"InformationResService\").find(ServiceUtil.buildBean(\"InformationRes@isDeleted=0&status=0\"),\"id\",\"desc\") %>">
            <option value="${obj.id}">${obj.inforName}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="ibox-content show3" id="dicTree" style="padding-left:0px;padding-right:0px;display: none;">
        <div class="btn-group" id="toolbar" role="group" style="margin-bottom:15px;">
          <div class="text-center">
            <a data-toggle="modal" class="btn btn-primary" id="addDM" onclick="openDicLayer();" href="#">选择信息项</a>
          </div>
        </div>
        <table id="dm2"></table>
      </div>
    </form>
  </div>

  <div id="dic_form" style="display: none;" class="ibox-content">
    <div class="row form-horizontal" style="overflow: hidden;">
      <div class="form-group">
        <label class="col-sm-3 control-label">已选择：</label>
        <div class="col-sm-9">
          <div class="chosen-container chosen-container-multi">
          <ul class="chosen-choices c-list">
          </ul>
          </div>
        </div>
      </div>
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

</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script>
$("#addhm").click(function() {
  $(".show3").hide();
});
var dicLayerContent = '#dic_form';
var layerIndex; //layer 窗口对象
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var url = '${base}/backstage/model/houseModel/'; //controller 路径
var dicLayerIndex;
var checkedIds = ",";
var checkedEles;
var dataEles; //存放选中的数据元
var inforResId = "";

//或许所有数据元
function initDataElements() {
  jQuery.get("${base}/backstage/dataElement/listAjax?all=y", function(r) {
    dataEles = r;
    initText();
  }, "json");
}

//加载选中框的内容
function initText() {
  var ids = checkedIds.split(",");
  checkedEles = new Array();
  if (ids.length) {
    for (var i = 0; i < ids.length; i++) {

      if (ids[i] != "") {
        for (var j = 0; j < dataEles.length; j++) {
          if (ids[i] == dataEles[j].id) {
            checkedEles.push(dataEles[j]);
          }
        }
      }
    }
  }
  if (checkedEles.length) {
    var html = '';
    for (var k = 0; k < checkedEles.length; k++) {
      html += '<li class="search-choice"><span>' + checkedEles[k].chName + '</span></li>';
    }
    $('.c-list').html(html);
  } else {
    $('.c-list').html('');
  }

}
//bootstrap-table 列数
var columns = [{
  //    field: 'houseTypes',
  //    title: '库类'
  //}, {
  field: 'infoTypes',
  title: '信息类',
  formatter: 'doFormatter1',
}, {
  field: 'infoName',
  title: '专项信息名称'
}, {
  field: 'informationResIdForShow',
  title: '信息资源名称'
}, {
  field: 'inforCodeForShow',
  title: '信息资源代码'
}, {
  field: 'id',
  title: '操作',
  formatter: 'doFormatter', //对本列数据做格式化
}];

function doFormatter1(value, row, index) {
  var html = '';
  if (value == 1) {
    html = '基础信息';
  } else if (value == 2) {
    html = '扩展信息';
  } else if (value == 3) {
    html = '专项信息';
  }
  return html;
}

//得到查询的参数
var queryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
  };
  return temp;
};

var queryParams2 = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    id: $('input[name="id"]').val()
  };
  return temp;
};

var queryParams3 = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
    objectType: $('select[name="dxl-select"]').val(),
    chName: $('input[name="keyword"]').val(),
    id: $('input[name="informationResId"]').val(),
    inforResId: inforResId
  };
  return temp;
};

$(function() {
  oTable2 = new TableInit2();
  oTable2.Init();
  oTable3 = new TableInit3();
  oTable3.Init();
});

var TableInit2 = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $('#dm2').bootstrapTable({
      url: '${base}/backstage/model/houseModel/hmAjax', //请求后台的URL（*）
      method: 'post', //请求方式（*）
      contentType: "application/x-www-form-urlencoded",
      iconSize: 'outline',
      striped: true, //是否显示行间隔色
      cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
      pagination: false, //是否显示分页（*）
      sortable: false, //是否启用排序
      sortOrder: "asc", //排序方式
      queryParams: queryParams2, //传递参数（*）
      sidePagination: "server", //分页方式：client客户端分页，server服务端分页（*）
      pageNumber: 1, //初始化加载第一页，默认第一页
      pageSize: 10, //每页的记录行数（*）
      pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
      strictSearch: true,
      clickToSelect: false, //是否启用点击选中行
      uniqueId: "idForShow", //每一行的唯一标识，一般为主键列
      cardView: false, //是否显示详细视图
      detailView: false,
      queryParamsType: "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
      columns: [{
        field: 'identifier',
        title: '内部资源标识符'
      }, {

        field: 'chName',
        title: '中文名称'
      }, {
        field: 'id',
        title: '操作',
        formatter: 'doFormatter3', //对本列数据做格式化    
      }]
    });
  };
  return oTableInit;
};

function openDicLayer() {
  $('#dm3').bootstrapTable('refresh');
  dicLayerIndex = layer.open({
    type: 1,
    area: ['70%', '80%'], //宽高
    title: '选择信息项',
    scrollbar: false,
    btn: ['保存', '关闭'],
    yes: function(index, layero) {
      $('#dm2').bootstrapTable('load', { rows: checkedEles });
      //$(dicFormId).submit();
      //console.log(checkedEles);
      $('input[name="dataElementId"]').val(checkedIds);
      layer.close(dicLayerIndex);
    },
    offset: '20px',
    content: $(dicLayerContent)
      //这里content是一个DOM
  });
}

var TableInit3 = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $('#dm3').bootstrapTable({
      url: '${base}/backstage/dataElement/dmAjax', // 请求后台的URL（*）
      method: 'post', //请求方式（*）
      contentType: "application/x-www-form-urlencoded",
      iconSize: 'outline',
      striped: true, //是否显示行间隔色
      cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
      pagination: true, //是否显示分页（*）
      sortable: false, //是否启用排序
      sortOrder: "asc", //排序方式
      queryParams: queryParams3, //传递参数（*）
      sidePagination: "server", //分页方式：client客户端分页，server服务端分页（*）
      pageNumber: 1, //初始化加载第一页，默认第一页
      pageSize: 10, //每页的记录行数（*）
      pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
      showRefresh: true,
      strictSearch: true,
      clickToSelect: false, //是否启用点击选中行
      uniqueId: "idForShow", //每一行的唯一标识，一般为主键列
      cardView: false, //是否显示详细视图
      detailView: false,
      queryParamsType: "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
      columns: [{
        field: 'id',
        title: '添加',
        formatter: 'checkFormatter'
      }, {
        field: 'identifier',
        title: '内部资源标识符'
      }, {

        field: 'chName',
        title: '中文名称'
      }, {
        field: 'id',
        title: '操作',
        formatter: 'doFormatter3', //对本列数据做格式化    
      }]
    });
  };
  return oTableInit;
};

function checkFormatter(value, row, index) {
  var html = '';
  if (checkedIds.indexOf("," + value + ",") > -1) {
    html += '<input type="checkbox" value="' + value + '" data-name="' + row.chName + '" onclick="selectDE(this);" checked="checked"/>';
  } else {
    html += '<input type="checkbox" value="' + value + '" data-name="' + row.chName + '" onclick="selectDE(this);"/>';
  }
  return html;
}

function selectDE(t) {
  if ($(t).is(':checked')) {
    checkedIds += $(t).val() + ",";
  } else {
    checkedIds = checkedIds.replace("," + $(t).val() + ",", ",");
  }
  initText();
}

function doFormatter3(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="editRow(\'' + row.idForShow + '\')">查看</button>';
  html += '</div>';
  return html;
}

</script>
<%@include file="../../common/baseSystemJS.jsp"%>
<script type="text/javascript">

function editRow(id) {
  openLayer();

  layer.title('修改', layerIndex);
  var data = $(tableId).bootstrapTable('getRowByUniqueId', id);
  $(formId).form('load', data);
  checkedIds = "," + data.dataElementId + ",";
  console.log(checkedIds);
  initDataElements();
  $('#dm2').bootstrapTable('refresh');
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
  $(formId).valid();
  inforResId = $("#informationResId").val();
  var it = $("#infoTypes").val();
  if (it == "3") {
    $("#dicTree2").show();
    if ($("#informationResId").val() > 0) {
      $("#dicTree").show();
    }
  } else {
    $(".show3").hide();
  }

}

</script>

<script>
var TableInit = function() {
  var oTableInit = new Object();
  //初始化Table
  oTableInit.Init = function() {
    $(tableId).bootstrapTable({
      url: '${base}/backstage/model/houseModel/listAjax?houseTypes=3', //请求后台的URL（*）
      method: 'post', //请求方式（*）
      contentType: "application/x-www-form-urlencoded",
      toolbar: toolbar, //工具按钮用哪个容器
      iconSize: 'outline',
      striped: true, //是否显示行间隔色
      cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
      pagination: true, //是否显示分页（*）
      sortable: false, //是否启用排序
      sortOrder: "asc", //排序方式
      queryParams: queryParams, //传递参数（*）
      sidePagination: "server", //分页方式：client客户端分页，server服务端分页（*）
      pageNumber: 1, //初始化加载第一页，默认第一页
      pageSize: 10, //每页的记录行数（*）
      pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
      strictSearch: true,
      clickToSelect: false, //是否启用点击选中行
      uniqueId: "idForShow", //每一行的唯一标识，一般为主键列
      cardView: false, //是否显示详细视图
      detailView: false,
      showRefresh: true,
      showToggle: true,
      showColumns: true,
      queryParamsType: "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
      columns: columns
    });
  };
  return oTableInit;
};
$(formId).form({
  url: url + 'insertAjax?houseTypes=3',
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
$("#addde").click(function() {
  var adIds = "";
  $("input:checkbox[name='dename']:checked").each(function(i) {
    if (0 == i) {
      adIds = $(this).val();
    } else {
      adIds += ("," + $(this).val());
    }
  });
  alert(adIds);
});

function initChosen() {
  disableChosen();
  if (chosenInited == 0) {
    chosenInited = 1;
  } else {
    $(".chosen-select").val("");
    $(".chosen-select").trigger("chosen:updated");
    return;
  }
  var chosen = $(".chosen-select").chosen({
    disable_search_threshold: 10,
    no_results_text: "没有匹配到这条记录",
    max_selected_options: 3,
    width: "100%"
  });

  chosen.on('change', function(e, params) {
    var it = $("#infoTypes").val();
    if (it == "3") {
      $("#dicTree2").show();
      if ($("#informationResId").val() > 0) {
        $("#dicTree").show();
      }
    } else {
      $(".show3").hide();
    }

    inforResId = $("#informationResId").val();

    if ($(this).attr('data-bind')) {
      var cid = $(this).attr('data-bind');
      if ($(this).val() == '') {
        $(cid).val('');
        $(cid).attr('disabled', true).trigger("chosen:updated");
      } else {
        $(cid).attr('disabled', false).trigger("chosen:updated")
        var p = {};
        p[$(this).attr("data-param")] = $(this).val();
        initAjaxChosen(cid, $(cid).attr('data-url'), p);
      }
    }
    $(formId).valid();
  });
  $(".chosen-select").trigger("chosen:updated");
}

</script>
