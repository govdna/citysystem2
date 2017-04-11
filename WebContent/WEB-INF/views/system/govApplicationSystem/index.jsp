<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
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
            <div class="form-group clearfix">
              <label class="control-label  pull-left">责任部门</label>
              <div class=" pull-left" style="margin-left:10px;width:250px;">
                <select name="cId" data-placeholder=" " class="chosen-select" style="width:350px; display:inline-block;" tabindex="4" required>
                  <option value=""></option>
                  <c:forEach var="obj" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"),\"id\",\"desc\") %>">
                  <option value="${obj.id}">${obj.companyName}</option>
                  </c:forEach>
                </select> 
              </div>
              <div class="pull-left"  style="margin-left:10px;">
              <button type="button" onclick=" $('#dicList').bootstrapTable('refresh');" class="btn btn-primary">搜索</button> 
              	<c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/govApplicationSystem/index\") %>">
                  <a data-toggle="modal" class="btn btn-primary" onclick="openLayer('新增');" href="#">新增</a>
                </c:if>
                <c:if test="<%=!ServiceUtil.haveExp(\"/backstage/govApplicationSystem/index\") %>">
                  <a data-toggle="modal" class="btn btn-primary" onclick="downloadData();" href="#">导出数据</a>
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
      <input type="hidden" name="id"  class="form-control">
      <input type="hidden" name="idForShow"  class="form-control">
       <c:set var="simpleFields" value="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=GovApplicationSystem\"),\"list_no\",\"asc\")%>"/>
      <%@include file="../common/simpleFields.jsp"%>
    </form>
  </div>
   <!-- 导出数据开始 -->
  <div id="download_div" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="downloadForm">
      <div class="alert alert-info">
            如导出数据量大，下载请耐心等待！
        </div>
       <c:forEach var="obj" items="${simpleFields}">
       	<div class="col-md-3"><input type="checkbox" name="xlsFields" value="value${obj.valueNo}"/> ${obj.name}</div>
       </c:forEach>
    </form>
  </div>
  <!-- 导出数据结束 -->
</body>
</html>
<%@include file="../common/includeJS.jsp"%>
<script>
//验证名称重复
$("input[name='value2']").blur(function() {
  jQuery.post("${base}/backstage/govApplicationSystem/validation", { "value2": $("input[name='value2']").val(), "id": $("input[name='id']").val() }, function(data) {
    data = JSON.parse(data);
    if (data.results == 1) {
      layer.msg("应用系统名称已存在，请重新填写");
      $("input[name='value2']").val("");
    }
  });
});
var title_name = "应用系统资料";
var cdata = { "companyId": "<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>" };
var layerIndex; //layer 窗口对象
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var url = '${base}/backstage/govApplicationSystem/'; //controller 路径

$("select[name='cId']").chosen({
  disable_search_threshold: 10,
  no_results_text: "没有匹配到这条记录",
  width: "100%"
});
//bootstrap-table 列数
<%@include file="../common/simpleFieldsColumns.jsp"%>
function longFormatter(value, row, index) {
  var html = '<span title="' + value + '">';
  if (value.length > 10) {
    html += value.substring(0, 10) + "...";
  } else {
    html += value;
  }
  html += '</span>';
  return html;
}
//得到查询的参数
var queryParams = function(params) {
  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
    value3: $('select[name="cId"]').val(),
    <c:if test = "${MyFunction:getMaxScope(\"/backstage/govApplicationSystem/index\")==1}" >
    companyId: <%=AccountShiroUtil.getCurrentUser().getCompanyId()%>,
    </c:if>
  };
  return temp;
};

</script>
<%@include file="../common/baseSystemJS.jsp"%>
<script>
function openLayer() {
  $(formId).form('clear');
  initChosen();
  $(formId).form('load', cdata);
  $(".chosen-select").trigger("chosen:updated");
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
$('#downloadForm').form({  
    url: url+'downloadData',  
    success: function(result){ 
    	 
    }  
});


function downloadData(){
	  $('#downloadForm').form('clear');
	  layerIndex=layer.open({
	    type: 1,
	    area: ['60%', '300px'], //宽高
	    title: '选择导出字段',
	    offset: '100px',
	    btn: ['导出', '关闭'],
	    yes: function(index, layero) {
	    	 $('#downloadForm').submit();
	    	 layer.close(layerIndex);
	    },
	    content: $('#download_div') //这里content是一个DOM
	  });
}
function doFormatter(value, row, index)
{
	var html='';
	html+='<div class="btn-group">';
	html+='<button type="button" class="btn btn-white" onclick="datailRow(\''+row.idForShow+'\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
	<c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/govApplicationSystem/index\") %>">
	html+='<button type="button" class="btn btn-white" id="edit"  onclick="editRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
	</c:if>
	<c:if test="<%=!ServiceUtil.haveDel(\"/backstage/govApplicationSystem/index\") %>">
	html+='<button type="button" class="btn btn-white" onclick="deleteRow(\''+row.idForShow+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
	</c:if>
	html+='</div>';
	return html;
}

</script>