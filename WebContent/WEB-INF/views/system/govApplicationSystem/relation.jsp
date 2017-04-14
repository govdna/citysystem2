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
              <div class="pull-left"  style="margin-left:10px;">
               	<c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/govApplicationSystem/relation\") %>">
                  <a data-toggle="modal" class="btn btn-primary" onclick="openLayer('新增');" href="#">新增</a>
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
      <input type="hidden" name="idForShow"  class="form-control"> 
       <div class="form-group">
        <label class="col-sm-3 control-label">应用系统：</label>
        <div class="col-sm-7">
          <select name="id" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"GovApplicationSystemService\").find(ServiceUtil.buildBean(\"GovApplicationSystem@isDeleted=0\"),\"id\",\"desc\") %>">
            <option value="${obj.id}">${obj.value2}</option>
            </c:forEach>
          </select>
        </div>
      </div>      
       <div class="form-group">
        <label class="col-sm-3 control-label">部署服务器：</label>
        <div class="col-sm-7">
          <select name="value5" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" >
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"GovServerService\").find(ServiceUtil.buildBean(\"GovServer@isDeleted=0\"),\"id\",\"desc\") %>">
            <option value="${obj.id}">${obj.value1}</option>
            </c:forEach>
          </select>
        </div>
      </div>
       <div class="form-group">
        <label class="col-sm-3 control-label">部署存储器：</label>
        <div class="col-sm-7">
          <select name="value6" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" >
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"GovMemorizerService\").find(ServiceUtil.buildBean(\"GovMemorizer@isDeleted=0\"),\"id\",\"desc\") %>">
            <option value="${obj.id}">${obj.value1}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">数据库：</label>
        <div class="col-sm-7">
          <select name="value7" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"GovDatabaseService\").find(ServiceUtil.buildBean(\"GovDatabase@isDeleted=0\"),\"id\",\"desc\") %>">
            <option value="${obj.id}">${obj.value1}</option>
            </c:forEach>
          </select>
        </div>
      </div>
    </form>
  </div>
</body>
</html>
<%@include file="../common/includeJS.jsp"%>
<script>
//验证名称重复
$("input[name='appsystemName']").blur(function() {
  jQuery.post("${base}/backstage/govApplicationSystem/validation", { "appsystemName": $("input[name='appsystemName']").val(), "id": $("input[name='id']").val() }, function(data) {
    data = JSON.parse(data);
    if (data.results == 1) {
      layer.msg("应用系统名称已存在，请重新填写");
      $("input[name='appsystemName']").val("");
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
  no_results_text: "没有匹配找这条记 录",
  width: "100%"
});
//bootstrap-table 列数
var columns = [{
  field: 'value1',
  title: '应用系统编号',
  sortable:true
}, {
  field: 'value2',
  title: '应用系统名称',
  formatter: 'longFormatter',
  sortable:true
}, {
  field: 'id',
  title: '操作',
  formatter: 'doFormatterl', //对本列数据做格式化
}];

function doFormatterl(value, row, index)
{
	var html='';
	html+='<div class="btn-group">';
	html+='<button type="button" class="btn btn-white" onclick="datailRow(\''+row.idForShow+'\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
	<c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/govApplicationSystem/relation\") %>">
	html+='<button type="button" class="btn btn-white" id="edit"  onclick="editRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
	</c:if>
	<c:if test="<%=!ServiceUtil.haveDel(\"/backstage/govApplicationSystem/relation\") %>">
	html+='<button type="button" class="btn btn-white" onclick="deleteRelationRow(\''+row.id+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
	</c:if>
	html+='</div>';
	return html;
}

function deleteRelationRow(id){
	layer.confirm('您确定要删除么？', {
		  btn: ['确定','取消'] //按钮
		}, function(){
			$.post(url+'deleteRelationAjax',{id:id},function(result){  
				if(result.code && result.code==1){
		    		layer.close(layerIndex);
		    		 $(tableId).bootstrapTable('refresh');
		    	}
		    	layer.msg(result.msg);
	        },'json');
		}, function(){
		    
		});
}
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
    sort:params.sort,
    order:params.order,
    companyId: $('select[name="cId"]').val(),
    value8:'233',
    value2:$('input[name="appN"]').val(),
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

</script>