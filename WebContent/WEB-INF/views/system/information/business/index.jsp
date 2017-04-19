<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline clearfix">
            <div class="form-group pull-left">
              <input type="text" placeholder="输入业务名称" name="busN" class="form-control col-sm-8">
             <div class="btn-group">
               <button type="button" class="btn btn-primary" onclick=" $('#dicList').bootstrapTable('refresh');" style="border-right: rgba(255,255,255,.3);">搜索</button>
               <button type="button" class="btn btn-primary dropdown-toggle dropdown-btn">
                 <span class="caret"></span>
               </button>
             </div>
            </div>
            <div class="form-group clearfix" style="margin-left: 5px;">
              <div class="text-center">
               <c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/information/business/index\") %>">
                <a data-toggle="modal" class="btn btn-primary" onclick="openLayer();" href="#">新增</a>
               </c:if>
               <c:if test="<%=!ServiceUtil.haveDel(\"/backstage/information/business/index\") %>">
                <a data-toggle="modal" class="btn btn-primary" onclick="deleteAll();" href="#">批量删除</a>
               </c:if>
              </div>
            </div>
          </div>
          <ul class="dropdown-menu1 dn form-inline clearfix" style="padding-left: 0; margin: 5px 0 0;">
			    <li class="form-group clearfix">	
				  <label class="pull-left">服务对象：</label>
				  <div class="pull-left" style="width: 200px;">
				  	<select name="val2" data-placeholder=" " class="chosen-select name1 form-control" style="width:350px; display:inline-block;" tabindex="4" required>
	                  <option value=""></option>
	                  <option value="">&nbsp;</option>
	                  <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"FWDX\") %>">
		              <option value="${obj.dicKey}">${obj.dicValue}</option>
		              </c:forEach>
	                </select>		
				  </div>	                
				</li>
			    <li class="form-group" style="margin-left: 10px;">			    	    
				<label class="pull-left">服务内容：</label>		
				 <div class="pull-left" style="width: 200px;">  
		          <select name="val3" data-placeholder=" " class="chosen-select name1" style="width:350px;" tabindex="4" required>		            
		            <option value=""></option>
		            <option value="">&nbsp;</option>
		            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"FWNR\") %>">
			        <option value="${obj.dicKey}">${obj.dicValue}</option>
			        </c:forEach>
		          </select>
		        </div>				
			    </li>
			 <!--    <li class="form-group">
				    <div class="form-group">
						<label class="control-label">高级3：</label>
						<input type="text" class="form-control">
					</div>
			    </li> -->
			  </ul>
        </div>
        <table id="dicList">
        </table>
      </div>
    </div>
  </div>

  <div id="layer_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="eform">
      <input type="hidden" name="id"  class="form-control">
      <input type="hidden" name="busNumber"  class="form-control">
      <input type="hidden" name="idForShow"  class="form-control">      

   
	  <c:set var="simpleFields" value="<%=ServiceUtil.getService(\"SimpleFieldsService\").find(ServiceUtil.buildBean(\"SimpleFields@isDeleted=0&className=InformationBusiness\"),\"list_no\",\"asc\")%>"/>
      <%@include file="../../common/simpleFields.jsp"%>


    </form>
  </div>

  
</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script>
var title_name = "业务梳理模板";
//验证名称重复
$("input[name='value1']").blur(function() {
  jQuery.post("${base}/backstage/information/business/validation", { "value1": $("input[name='value1']").val(), "id": $("input[name='id']").val() }, function(data) {
    data = JSON.parse(data);
    if (data.results == 1) {
      layer.msg("业务名称已存在，请重新填写");
      $("input[name='value1']").val("");
    }
  });
});
$('.dropdown-btn').on('click', function() {
	$('.dropdown-menu1').toggleClass('dn');
});
$(".name1").chosen({
	  disable_search_threshold: 10,
	  no_results_text: "没有匹配到这条记录",
	  width: "100%"
	});
var layerIndex; //layer 窗口对象
var layerContent = '#layer_form'; //layer窗口主体内容dom Id
var tableId = '#dicList'; //bootstrap-table id
var toolbar = '#toolbar'; //bootstrap-table 工具栏id
var formId = '#eform'; //form id
var url = '${base}/backstage/information/business/'; //controller 路径

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

//---------批量删除开始---------
$("#dicList").on("click", '#allC', function() {
  var isChecked = $(this).prop("checked");
  $("input[data-type='plsp']").prop("checked", isChecked);
});

//选择
function checkFormatter2(value, row, index) {
  var html = '';
  html += '<input type="checkbox" data-type="plsp" data-id="' + value + '" value="' + row.idForShow + '"  />';
  return html;
}

function deleteAll() {
  var ids = "";
  var c = $("input[data-type='plsp']:checked");
  for (var i = 0; i < c.length; i++) {
    ids += "," + $(c[i]).attr('data-id');
  }
  if (ids != "") {
    layer.confirm('您确定要删除么？', {
      btn: ['确定', '取消'] //按钮
    }, function() {
      $.post(url + 'deleteAjax', { ids: ids }, function(r) {
        var result = eval('(' + r + ')');
        if (result.code && result.code == 1) {
          $(tableId).bootstrapTable('refresh');

        }
        layer.msg(result.msg);
      });
    }, function() {});
  }
}

//-------批量删除结束---------


var columns = [{
	  field: 'id',
	  title: '<input id="allC" type="checkbox">',
	  formatter: 'checkFormatter2',
	}, 
<c:forEach var="obj" items="${simpleFields}">
	<c:if test="${obj.isShow==1}">
		<c:choose>
			<c:when test="${obj.inputType==1}">
			 	{field: 'value${obj.valueNo}',title: '${obj.name}',sortable:true,formatter:'longFormatter'}, 
			</c:when>
			<c:otherwise>
				{field: 'value${obj.valueNo}ForShow',title: '${obj.name}'},
        	</c:otherwise>
		</c:choose>
	</c:if>       
</c:forEach>
{
  field: 'id',
  title: '操作',
  formatter: 'doFormatter', 
}];
function longFormatter(value, row, index)
{
  var html='<span title="'+value+'">';
  if(value.length>10){
    html+=value.substring(0,10)+"...";
  }else{
    html+=value;
  }
  html+='</span>';
  return html;
}
//得到查询的参数
var queryParams = function(params) {
	var sort=params.sort;
	var order=params.order;
	if($('input[name="busN"]').val()!=null&&$('input[name="busN"]').val()!=""){
		sort="length(trim(value1))";
		order="asc";
	}
  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
    sort:sort,
    order:order,
    value1: $('input[name="busN"]').val(),
    value2: $('select[name="val2"]').val(),
    value3: $('select[name="val3"]').val()
  };
  return temp;
};

</script>
<%@include file="../../common/baseSystemJS.jsp"%>
<script>
function doFormatter(value, row, index)
{
	var html='';
	html+='<div class="btn-group">';
	html+='<button type="button" class="btn btn-white" onclick="datailRow(\''+row.idForShow+'\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
	<c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/information/business/index\") %>">
	html+='<button type="button" class="btn btn-white" id="edit"  onclick="editRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
    </c:if>
	<c:if test="<%=!ServiceUtil.haveDel(\"/backstage/information/business/index\") %>">
	html+='<button type="button" class="btn btn-white" onclick="deleteRow(\''+row.idForShow+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
	</c:if>
	html+='</div>';
	return html;
}
</script>
