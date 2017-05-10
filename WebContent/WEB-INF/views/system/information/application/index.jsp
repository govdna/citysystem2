<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
<style type="text/css">
.c-list{
cursor: auto !important;
}
.c-list li{
cursor: pointer !important;
}

.edit-span{
  margin-bottom: 0;
  text-align: left;
  padding: 7px;
  border: 1px dashed #eee;
}
</style>
</head>
<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">

 <div class="wrapper wrapper-content animated fadeInRight">
  <div class="ibox float-e-margins">
    <div class="ibox-content">
      <table id="dicList"></table>
    </div>
  </div>
</div>
<!--资源申请开始 -->
<div id="application-layer" class="form-horizontal" style="overflow: hidden;display:none;">
  <form method="post" class="form-horizontal eform1" id="applicationForm">
    <input type="hidden" name="informationId" />
    <input type="hidden" name="informationCompany" />
    <input type="hidden" name="id" />
    <input type="hidden" name="idForShow" />
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="status_div"></div>
        <div class="form-group">
          <label class="col-sm-3 control-label">申请资源：</label>
          <span class="col-sm-8 edit-span" name="informationIdForShow"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">申请单位：</label>
          <span class="col-sm-8 edit-span" name="applyCompanyForShow"></span>
        </div>
         <div class="form-group">
          <label class="col-sm-3 control-label">申请时间：</label>
          <span class="col-sm-8 edit-span" name="timeModified"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">经办人：</label>
          <span class="col-sm-8 edit-span" name="informationCompanyForShow"></span>
        </div>
        <div class="form-group">
          <label class="col-sm-3 control-label">申请用途：</label>
          <div class="col-sm-8" style="padding: 0px;">
            <textarea class="form-control" rows="3" name="applyReason" required></textarea>
          </div>
        </div>
      </div>
    </div>
  </form>
</div>
<!-- 资源申请结束 -->

</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script>
var layerIndex; //layer 窗口对象
var layerContent = '#application-layer'; // layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#applicationForm'; //form id
var url = '${base}/backstage/application/'; //controller 路径
var chosenInited = 0;
var isDetailed = 0;
var contentHtml;

var queryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
    <c:if test = "${MyFunction:getMaxScope(\"/backstage/application/index\")==100}" >
    companyId: <%=AccountShiroUtil.getCurrentUser().getCompanyId()%>,
    </c:if>
  };
  return temp;
};



function statusFormatter(value, row, index) {
  if (value == 0) {
    return '已同意共享';
  } else if (value == 1) {
    return '待审核';
  } else if (value == 2) {
    return '拒绝共享';
  }
}

//bootstrap-table 列数
var columns = [{
  field: 'informationIdForShow',
  title: '申请资源'
}, {
  field: 'applyCompanyForShow',
  title: '申请单位'
}, {
  field: 'informationCompanyForShow',
  title: '经办人'
}, {
  field: 'status',
  title: '状态',
  formatter: 'statusFormatter', //对本列数据做格式化
}, {
  field: 'id',
  title: '操作',
  formatter: 'doFormatter', //对本列数据做格式化
}];


</script>
<%@include file="../../common/baseSystemJS.jsp"%>
<script>
function doWithEdit(id, data) {
  $('span[name="informationIdForShow"]').html(data.informationIdForShow);
  $('span[name="applyCompanyForShow"]').html(data.applyCompanyForShow);
  $('span[name="informationCompanyForShow"]').html(data.informationCompanyForShow);
  $('span[name="timeModified"]').html(data.timeModified);

  if (data.status == 2) {
    $('#status_div').html('<div class="alert alert-danger" >审核不通过：' + data.refuseReason + '</div>');
  } else {
    $('#status_div').html('');
  }
}

function doFormatter(value, row, index)
{
  var html='';
  html+='<div class="btn-group">';
  if(row.status==1&&row.informationCompany==<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>){
    html+='<button type="button" class="btn btn-white" onclick="updateStatusRow(\''+row.idForShow+'\')"><i class="fa fa-eye"></i>&nbsp;审核</button>';
  }
  html+='<button type="button" class="btn btn-white" onclick="datailRow(\''+row.idForShow+'\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
  if(row.status!=0&&row.applyCompany==<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>){
    html+='<button type="button" class="btn btn-white" onclick="editRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
  }
  html+='</div>';
  return html;
}

function doBeforDetail(id, data) {
  doWithEdit(id, data);
}


function updateStatusRow(id, iszx) {
  openStatusLayer(iszx);
  datailRow(id, 1);
}


function openStatusLayer(iszx) {
  $(formId).form('clear');
  initChosen();
  $(formId).valid();
  layerIndex = layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '详情',
    scrollbar: false,
    btn: ['审核通过', '审核不通过'],
    yes: function(index, layero) {
      if (iszx) {
        updateStatus(5, '');
      } else {
        updateStatus(0, '');
      }

    },
    btn2: function(index, layero) {
      var ii = layer.prompt({ title: '审核不通过理由', formType: 2 }, function(text, index) {
        layer.close(index);
        if (iszx) {
          updateStatus(0, '');
        } else {
          updateStatus(2, text);
        }

      });
    },
    cancel: function(index, layero) {
      $('#status_div').html('');
      $(layerContent + ' .dt-span').remove();
      $(layerContent + ' .div_hidden').removeClass('div_hidden');
    },
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
  });
}

function updateStatus(st, text) {
  $.post(url + 'updateStatus', { idForShow: $('input[name="idForShow"]').val(), status: st, refuseReason: text }, function(r) {
    var result = eval('(' + r + ')');
    if (result.code && result.code == 1) {
      layer.close(layerIndex);
      $(tableId).bootstrapTable('refresh');
    }
    layer.msg(result.msg);
  });
}

</script>