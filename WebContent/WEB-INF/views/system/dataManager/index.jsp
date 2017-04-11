<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
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
              <input type="text" placeholder="输入元素名称" name="dataN" class="form-control col-sm-8">
              <div class="input-group-btn col-sm-4">
                <button type="button" onclick=" $('#dataList').bootstrapTable('refresh');" class="btn btn-primary">搜索
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
        <table id="dataList" class="ft14">
        </table>
      </div>
    </div>
  </div>

  <div id="layer_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="eform">
      <input type="hidden" name="id"  class="form-control">
      <input type="hidden" name="idForShow"  class="form-control">
      <input type="hidden" name="valueNo"  class="form-control">
      <div class="form-group">
        <label class="col-sm-3 control-label">元数据类型：</label>
        <div class="col-sm-4">
          <select name="sortManagerIdForShow" data-placeholder=" " data-param="fatherId" class="chosen-select" data-bind="select[name='sortManagerId']"required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"ORIGNDATATYPE\") %>">
            <option value="${obj.id}">${obj.dicValue}</option>
            </c:forEach>
          </select> 
        </div>
        <div class="col-sm-4">
          <select name="sortManagerId" data-placeholder=" " class="chosen-select" data-url="${base}/backstage/govmadeDic/listAjax?all=y"
            data-keyField="dicKey" data-valueField="dicValue" required>
          </select> 
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">元素名称：</label>
        <div class="col-sm-7">
          <input type="text" name="dataName" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">定义：</label>
        <div class="col-sm-7">
          <input type="text" name="define" class="form-control" >
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">数据类型：</label>
        <div class="col-sm-7">
          <select name="dataType" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"DATATYPE\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>  
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">值域：</label>
        <div class="col-sm-7">
          <input type="text" name="ranges" class="form-control" >
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">短名：</label>
        <div class="col-sm-7">
          <input type="text" name="shortName" class="form-control" >
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">注解：</label>
        <div class="col-sm-7">
          <input type="text" name="note" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">取值实例：</label>
        <div class="col-sm-7">
          <input type="text" name="valueCase" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">是否必填：</label>
        <div class="col-sm-7">
          <select name="required" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"REQUIRED\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>  
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">是否为显示列：</label>
        <div class="col-sm-7">
          <select name="isShow" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"YESORNO\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>  
        </div>
      </div>      
      <div class="form-group">
        <label class="col-sm-3 control-label">输入框类型：</label>
        <div class="col-sm-7">
          <select name="inputType" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"INPUTTYPE\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>  
        </div>
      </div>
      <div class="form-group" id="inputValue_Div" style="display:none;">
        <label class="col-sm-3 control-label">输入框取值：</label>
        <div class="col-sm-7">
          <select name="inputValue" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" >
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"GovmadeDicService\").find(ServiceUtil.buildBean(\"GovmadeDic@isDeleted=0&level=1\"))%>">
            <option value="${obj.dicNum}">${obj.dicName}</option>
            </c:forEach>
          </select>  
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">排序：</label>
        <div class="col-sm-7">
          <input type="number" name="listNo" class="form-control" required>
        </div>
      </div>
    </form>
  </div>
</body>
</html>

<%@include file="../common/includeJS.jsp"%>
<script>
//验证名称重复
$("input[name='dataName']").blur(function() {
  jQuery.post("${base}/backstage/dataManager/validation", { "dataName": $("input[name='dataName']").val(), "id": $("input[name='id']").val() }, function(data) {
    data = JSON.parse(data);
    if (data.results == 1) {
      layer.msg("元素名称已存在，请重新填写");
      $("input[name='dataName']").val("");
    }
  });
});

var layerIndex; //layer 窗口对象
var title_name = "元数据";
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var tableId = '#dataList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var datailContent = '#datail_form'; //layer窗口主体内容dom Id
var datailId = '#datailform'; //form id

var dicLayerIndex;
var checkedIds = ",";
var checkedEles;
var dataEles; //存放选中的数据元
var url = '${base}/backstage/dataManager/'; //controller 路径

//bootstrap-table 列数
var columns = [{
  field: 'sortManagerIdValue',
  title: '元数据类型'
}, {
  field: 'dataName',
  title: '元素名称'
}, {
  //    field: 'egName',
  //    title: '英文名称'
  //}, {
  //    field: 'define',
  //    title: '定义'
  //}, {
  field: 'dataTypeForShow',
  title: '数据类型'
}, {
  field: 'id',
  title: '操作',
  formatter: 'doFormatter', //对本列数据做格式化
}];
$("select[name='sortManagerId']").change(function() {
  var selected_value = $(this).val();
  var csta_number = $("select[name='cataNumber']");
  csta_number.empty();
  $.ajax({
    type: "GET",
    url: "${base}/backstage/govmadeDic/sonJson",
    data: { fatherId: selected_value },
    dataType: "json",
    success: function(data) {
      $.each(data, function(index) {
        var html = '<option value="' + data[index].id + '">' + data[index].dicValue + '</option>';
        console.info(html);
        csta_number.append(html);
      });
    }
  });
});



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
    dataName: $('input[name="dataN"]').val()
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
$('select[name="inputType"]').on('change', function(e, params) {
  var val = $(this).val();
  if (val == 2) {
    $('#inputValue_Div').show();
  } else {
    $('#inputValue_Div').hide();
  }
});

</script>