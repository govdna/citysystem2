<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en"> 
<head>
<%@include file="../common/includeBaseHead.jsp"%>
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
<div class="wrapper wrapper-content animated fadeInRight">
  <div class="ibox float-e-margins">
    <div class="ibox-content">
      <div id="toolbar">
        <div class="form-inline">
          <div class="form-group">
            <input type="text" placeholder="输入细目编目类型" name="sortM" class="form-control col-sm-8">
            <div class="input-group-btn col-sm-4">
              <button type="button" onclick=" $('#dicList').bootstrapTable('refresh');" class="btn btn-primary">搜索
              </button>
            </div>
          </div>
          <div class="form-group" style="margin-left: 15px;">
            <div class="text-center">
              <a data-toggle="modal" class="btn btn-primary" onclick="openLayer();" href="#">新增</a>
            </div>
          </div>
        </div>
      </div>
      <table id="dicList"></table>
    </div>
  </div>
</div>
<div id="layer_form" style="display: none;" class="ibox-content">
  <form method="post" class="form-horizontal" id="eform">
    <input type="hidden" name="id" class="form-control">
    <input type="hidden" name="idForShow" class="form-control">
    <div class="form-group">
      <label class="col-sm-3 control-label">细目编目类型：</label>
      <div class="col-sm-7">
        <input type="text" name="sortManagerId" class="form-control" required>
      </div>
    </div>
    <div class="form-group">
      <label class="col-sm-3 control-label">流水号：</label>
      <div class="col-sm-7">
        <select name="cataNumber" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
          <option value=""></option>
          <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"CATANUMBER\") %>">
          <option value="${obj.dicKey}">${obj.dicValue}</option>
          </c:forEach>
        </select> 
      </div>
    </div>
    <div class="form-group">
      <label class="col-sm-3 control-label">分类值：</label>
      <div class="col-sm-7">
        <input type="text" name="classValue" class="form-control" required>
      </div>
    </div>
    <div class="form-group">
      <label class="col-sm-3 control-label">分类代码：</label>
      <div class="col-sm-7">
        <input type="text" name="classCode" class="form-control" required>
      </div>
    </div>
  </form>
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
var url = '${base}/backstage/catalogManager/'; //controller 路径

//bootstrap-table 列数
var columns = [{
  field: 'sortManagerId',
  title: '细目编目类型'
}, {
  field: 'cataNumberForShow',
  title: '流水号'
}, {
  field: 'classValue',
  title: '分类值'
}, {
  field: 'classCode',
  title: '分类代码'
}, {
  field: 'id',
  title: '操作',
  formatter: 'doFormatter', //对本列数据做格式化
}];



var chosenInited = 0;
var isDetailed = 0;
var contentHtml;

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


function disableChosen() {
  var cs = $(".chosen-select");
  if (cs.length) {
    for (var i = 0; i < cs.length; i++) {
      if ($(cs[i]).attr('data-bind')) {
        var cid = $(cs[i]).attr('data-bind');
        if (!$(cs[i]).val()) {
          $(cid).attr('disabled', true).trigger("chosen:updated");
        } else {
          $(cid).attr('disabled', false).trigger("chosen:updated");
        }
      }

    }
  }
}
$('.form_datetime').datetimepicker({
  language: 'zh-CN',
  weekStart: 1,
  todayBtn: 1,
  autoclose: 1,
  todayHighlight: 1,
  startView: 2,
  forceParse: 0,
  //showMeridian: 1,
  format: 'yyyy-mm-dd hh:ii',
  pickerPosition: "bottom-left",
  zIndex: 100000000000
});
//初始化下拉框
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
    width: "100%"
  });

  chosen.on('change', function(e, params) {
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

//notValid不进行验证
function initAjaxChosen(cid, url, p, value, notValid) {
  $.get(url, p, function(r) {
    if (r.length) {
      var html = '<option value=""></option>';
      var keyField = $(cid).attr('data-keyField');
      var valueField = $(cid).attr('data-valueField');
      for (var i = 0; i < r.length; i++) {
        var item = r[i];
        html += '<option value="' + item[keyField] + '">' + item[valueField] + '</option>';
      }
      $(cid).html(html);
      $(cid).val(value);
      if ($(layerContent + ' span[data-name="' + $(cid).attr('name') + '"]')) {
        var vl = $(cid).find('option[value="' + value + '"]').html();
        $(layerContent + ' span[data-name="' + $(cid).attr('name') + '"]').html(vl);
      }
      $(".chosen-select").trigger("chosen:updated");
      disableChosen();
      if (!notValid) {
        $(formId).valid();
      }

    }
  }, 'json');
}

function openLayer() {
  $(formId).form('clear');
  initChosen();
  $(formId).valid();
  layerIndex = layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '新增',
    scrollbar: false,
    btn: ['保存', '关闭'],
    yes: function(index, layero) {
      $(formId).submit();
    },
    cancel: function(index, layero) {
      $(layerContent + ' .dt-span').remove();
      $(layerContent + ' .div_hidden').removeClass('div_hidden');
    },
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
  });
}

function openDetailLayer() {
  $(formId).form('clear');
  initChosen();
  $(formId).valid();
  layerIndex = layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '详情',
    scrollbar: false,
    cancel: function(index, layero) {
      $(layerContent + ' .dt-span').remove();
      $(layerContent + ' .div_hidden').removeClass('div_hidden');
    },
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
  });
}

//得到查询的参数
var queryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
    sortManagerId: $('input[name="sortM"]').val()
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
    chName: $('input[name="keyword"]').val()
  };
  return temp;
};

$(function() {

  //1.初始化Table
  oTable = new TableInit();
  oTable.Init();
  oTable2 = new TableInit2();
  oTable2.Init();
  oTable3 = new TableInit3();
  oTable3.Init();
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

function doFormatter(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';

  html += '<button type="button" class="btn btn-white" onclick="datailRow(\'' + row.idForShow + '\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
  html += '<button type="button" class="btn btn-white" onclick="editRow(\'' + row.idForShow + '\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
  html += '<button type="button" class="btn btn-white" onclick="deleteRow(\'' + row.idForShow + '\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
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

function editRow(id) {
  openLayer();
  layer.title('修改', layerIndex);
  var data = $(tableId).bootstrapTable('getRowByUniqueId', id);
  $(formId).form('load', data);
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
}

//查看的额外处理覆盖此方法
function doWithDetail(id, data) {

}

function datailRow(id) {
  openDetailLayer();
  layer.title('详情', layerIndex);
  $(layerContent + " div").removeClass("has-error");
  $(layerContent + " div").removeClass("has-success");
  $(layerContent + " .detail-hide").addClass('div_hidden');
  var data = $(tableId).bootstrapTable('getRowByUniqueId', id);
  $(formId).form('load', data);
  doWithDetail(id, data);
  //下拉级联显示
  var cs = $(layerContent + " .chosen-select");
  if (cs.length) {
    for (var i = 0; i < cs.length; i++) {
      if ($(cs[i]).attr('data-bind')) {
        var cid = $(cs[i]).attr('data-bind');
        var p = {};
        p[$(cs[i]).attr("data-param")] = $(cs[i]).val();
        initAjaxChosen(cid, $(cid).attr('data-url'), p, data[$(cid).attr('name')], true);
      }

    }
  }
  $(".chosen-select").trigger("chosen:updated");
  //替换input显示
  var inp = $(layerContent + ' input');
  if (inp.length) {
    for (var i = 0; i < inp.length; i++) {
      if ($(inp[i]).attr('type') != 'hidden' && $(inp[i]).hasClass('form-control')) {
        var cl = $(inp[i]).parent('div').attr('class');
        $(inp[i]).parent('div').addClass('div_hidden');
        var rootDiv = $(inp[i]).parents('.form-group');
        if ($(rootDiv).find('span .dt-span').length) {
          $(rootDiv).find('span .dt-span').html(data[$(inp[i]).attr('name')])
        } else {
          $(rootDiv).append('<span class="' + cl + ' dt-span">' + data[$(inp[i]).attr('name')] + '</span>');
        }
      }

    }
  }
  //替换select显示
  var sel = $(layerContent + ' select');
  if (sel.length) {
    for (var i = 0; i < sel.length; i++) {
      var vl = $(sel[i]).find('option[value="' + data[$(sel[i]).attr('name')] + '"]').html();
      var cl = $(sel[i]).parent('div').attr('class');
      $(sel[i]).parent('div').addClass('div_hidden');
      var rootDiv = $(sel[i]).parents('.form-group');
      if ($(rootDiv).find('span .dt-span').length) {
        $(rootDiv).find('span .dt-span').html(vl)
      } else {
        if (vl) {
          $(rootDiv).append('<span class="' + cl + ' dt-span" data-name="' + $(sel[i]).attr('name') + '" data-value="' + data[$(sel[i]).attr('name')] + '">' + vl + '</span>');
        } else {
          $(rootDiv).append('<span class="' + cl + ' dt-span" data-name="' + $(sel[i]).attr('name') + '" data-value="' + data[$(sel[i]).attr('name')] + '"></span>');
        }

      }
    }
  }

}

</script>