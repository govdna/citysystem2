<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en"> 
<head>
<%@include file="../common/includeBaseHead.jsp"%>
<link rel="stylesheet" type="text/css" href="${base}/static/css/plugins/webuploader/webuploader.css">
<link rel="stylesheet" type="text/css" href="${base}/static/css/demo/webuploader-demo.css">

</head>
<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div class="btn-group hidden-xs" id="toolbar" role="group">
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
      <input type="hidden" name="belongType"  class="form-control">
      <div class="form-group">
        <label class="col-sm-3 control-label">主题类型：</label>
        <div class="col-sm-7">
          <select name="themeType" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"STYLE\") %>">
            <option value="${obj.dicKey}">${obj.dicValue}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">大logo：</label>
        <div class="col-sm-7">
          <input type="text" name="logoBig"  class="form-control" required>
        </div>
      </div>
      <div class="form-group" >
        <div id="uploader-demo">
          <label class="col-sm-3 control-label"></label>
          <div class="col-sm-7">
          <label class="col-sm-3" id="img_label">
          </label>
          <div class="col-sm-9 detail-hide" id="filePicker">选择图片</div>
          </div>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">单机登录权限：</label>
        <div class="col-sm-7">
           <select id="logoSmall" name="logoSmall" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <option value="1">是</option>
            <option value="2">否</option>
          </select> 
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">大标题：</label>
        <div class="col-sm-7">
          <input type="text" name="titleBig" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">小标题：</label>
        <div class="col-sm-7">
          <input type="text" name="titleSmall" class="form-control" required>
        </div>
      </div>
    </form>
  </div>
</body>
</html>

<%@include file="../common/includeJS.jsp"%>
 <script src="${base}/static/js/plugins/webuploader/webuploader.min.js"></script>

<script>
var layerIndex; //layer 窗口对象
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var url = '${base}/backstage/theme/'; //controller 路径
var BASE_URL = '${base}/static/js/plugins/webuploader';
var $list = $("#fileList");
var thumbnailWidth = 48;
var thumbnailHeight = 48;
var uploader;
var inited = 0;
//bootstrap-table 列数
var columns = [{
  field: 'themeTypeForShow',
  title: '主题类型'
}, {
  field: 'titleBig',
  title: '大标题'
}, {
  field: 'titleSmall',
  title: '小标题'
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
  };
  return temp;
};

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
var chosenInited = 0;

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


function initAjaxChosen(cid, url, p, value) {
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
      $(".chosen-select").trigger("chosen:updated");
      disableChosen();
      $(formId).valid();
    }
  }, 'json');
}

function openLayer() {
  $('#img_label').html('');
  $(formId).form('clear');
  initUploader();
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
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
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
      url: url + 'listAjax'+'?belongType=1', //请求后台的URL（*）
      method: 'post', //请求方式（*）
      contentType: "application/x-www-form-urlencoded",
      toolbar: toolbar, //工具按钮用哪个容器
      logoBigSize: 'outline',
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
  html += '<button type="button" class="btn btn-white" onclick="datailRow(\'' + row.idForShow + '\')"><i class="fa fa-pencil"></i>&nbsp;详情</button>';
  html += '<button type="button" class="btn btn-white" onclick="editRow(\'' + row.idForShow + '\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';

  html += '</div>';
  return html;
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
    $('input[name="logoBig"]').val(response.obj);
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

function doWithDetail(id, data) {}

function doBeforDetail(id, data) {}

function datailRow(id, la) {
  if (!la) {
    openDetailLayer();
    layer.title('详情', layerIndex);
  }
  $(layerContent + " div").removeClass("has-error");
  $(layerContent + " div").removeClass("has-success");
  $(layerContent + " .detail-hide").addClass('div_hidden');
  var data = $(tableId).bootstrapTable('getRowByUniqueId', id);
  doBeforDetail(id, data);
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

  //替换input显示
  var txt = $(layerContent + ' textarea');
  if (txt.length) {
    for (var i = 0; i < txt.length; i++) {
      if ($(txt[i]).attr('type') != 'hidden' && $(txt[i]).hasClass('form-control')) {
        var cl = $(txt[i]).parent('div').attr('class');
        $(txt[i]).parent('div').addClass('div_hidden');
        var rootDiv = $(txt[i]).parents('.form-group');
        if ($(rootDiv).find('span .dt-span').length) {
          $(rootDiv).find('span .dt-span').html(data[$(txt[i]).attr('name')])
        } else {
          $(rootDiv).append('<span class="' + cl + ' dt-span">' + data[$(txt[i]).attr('name')] + '</span>');
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

  $(".col-sm-7.dt-span").each(function() {
    if ($(this).html() == "undefined") {
      //$(this).next("span").remove();
      //$(this).remove();  
      $(this).html("");
    }
  });

}

</script>
