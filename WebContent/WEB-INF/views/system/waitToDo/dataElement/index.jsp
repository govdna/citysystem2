<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
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

.c-list li.search-choice{
padding: 3px 5px 3px 5px !important;

}

</style>
</head>
<body class="white-bg">
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
          </div>
        </div>
        <table id="dicList">
        </table>
      </div>
    </div>
  </div>
  <div id="detailForm" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="dform">
      <input type="hidden" name="id" class="form-control">
      <input type="hidden" name="idForShow" class="form-control">
      <input type="hidden" name="status" class="form-control">
      <div class="form-group">
        <label class="col-sm-3 control-label">内部标识符：</label>
        <div class="col-sm-7">
          <input type="text" name="identifier" class="form-control" required disabled="true" 　readOnly="true">
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">中文名称：</label>
        <div class="col-sm-7">
          <input type="text" name="chName" class="form-control" required disabled="true" 　readOnly="true">
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">英文名称：</label>
        <div class="col-sm-7">
          <input type="text" name="cegName" class="form-control" required disabled="true" 　readOnly="true">
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">定义：</label>
        <div class="col-sm-7">
          <input type="text" name="define" class="form-control" required disabled="true" 　readOnly="true">
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

</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script>
var layerIndex;//layer 窗口对象
var layerContent='#layer_form';//layer窗口主体内容dom Id
var tableId='#dicList';//bootstrap-table id
var toolbar='#toolbar';//bootstrap-table 工具栏id
var formId='#eform';//form id
var url='${base}/backstage/govRdataElement/listAjax?statuses=123';//controller 路径
var dicLayerContent = '#dic_form';
var dicFormId = '#dicForm';
var statusContent = '#statusform';
var dicLayerIndex;
var checkedIds=",";
var checkedEles;
var dataEles;//存放选中的数据元

var detailContent='#detailForm';
var dformId='#dform';




//bootstrap-table 列数
var  columns=[{
    field: 'identifier',
    title: '内部标识符'
}, {
    field: 'chName',
    title: '中文名称'
},{
    field: 'egName',
    title: '英文名称'
},  {
    field: 'dataTypeForShow',
    title: '数据类型'
}, {
    field: 'dataFormat',
    title: '数据长度'
}, {
    field: 'objectTypeForShow',
    title: '对象类型'
},{

    field: 'statusForShow',
    title: '状态'
},{
    field: 'id',
    title: '操作',
    formatter: 'doFormatter0',//对本列数据做格式化
}];
function doFormatter0(value, row, index){
  var html='';
  html+='<div class="btn-group">';
  html+='<button type="button" class="btn btn-white" onclick="readonly(\''+row.idForShow+'\')">查看</button>';
  html+='</div>';
  return html;
}
function openLayer1(){
  $(dformId).form('clear');
  initChosen();
  $(dformId).valid();
  layerIndex=layer.open({
    type: 1,
    area: ['70%', '70%'], //宽高
    title: '新增',
    scrollbar: false,
    btn: ['关闭'], 
    yes: function(index, layero){
      layer.close(index);
    },
    offset: '20px',
    content: $(detailContent) //这里content是一个DOM
  });
}
function readonly(id){
  layer.open({
      type: 2,
      title: '数据元详情',
      shadeClose: true,
      shade: 0.1,
      area: ['60%', '80%'],
      content: base+'/backstage/dataElement/detail?idForShow='+id
    }); 
}

  //得到查询的参数
  var queryParams = function(params) {

    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1,
      groupId : <%= AccountShiroUtil.getCurrentUser().getGroupId() %>,
      chName:$('input[name="chN"]').val(),
      <c:if test="${MyFunction:getMaxScope(\"/backstage/dataElement/waitToDo/index\")==100}" >
      companyId:<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>,
    </c:if>
    };
    return temp;
  };

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
