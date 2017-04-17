<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ page import="com.govmade.controller.system.model.HouseModelFieldsController" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
</head>
<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline">
            <div class="form-group" style="margin-left: 15px;">
              <div class="text-center">
               <c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/model/customModel/index?model=6\") %>">
                <a data-toggle="modal" id="addhm" class="btn btn-primary" onclick="addNew();" href="#">新增</a>
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
      <input type="hidden" name="dataElementId" />
      <input type="hidden" name="informationResId" id="inforResourceId" />
      <c:forEach var="obj" items="<%=ServiceUtil.fieldsType(request)  %>">
        <div class="form-group">
          <label class="col-sm-3 control-label info-label"  data-id="data${obj.id}">${obj.name}：</label>
          <div class="col-sm-8">
            <c:choose>
              <c:when test="${obj.inputType==1}">
                  <input type="text" name="value${obj.valueNo}"
                    class="form-control"
                  <c:if test="${obj.required==1}" >required</c:if>>
              </c:when>
              <c:when test="${obj.inputType==2}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="${MyFunction:dic(obj.inputValue)}">
                  <option value="${obj2.dicKey}">${obj2.dicValue}</option>
                  </c:forEach>
                </select>
              </c:when>
              <c:when test="${obj.inputType==3}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"ItemSortService\").find(ServiceUtil.buildBean(\"ItemSort@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.itemName}</option>
                  </c:forEach>
                </select>
              </c:when>
              <c:when test="${obj.inputType==4}">
                <input type="hidden" name="value${obj.valueNo}"
                    class="form-control edit-hide detail-show"
                    >
                <input type="text" name="value${obj.valueNo}ForShow"
                    class="form-control edit-hide detail-show"
                    >
              </c:when>
              <c:when test="${obj.inputType==5}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.companyName}</option>
                  </c:forEach>
                </select>
              </c:when>
              
              
              <c:when test="${obj.inputType==6}">
                <input type="text" name="value${obj.valueNo}"
                  class="form-control form_datetime" size="16" readonly
                <c:if test="${obj.required==1}" >required</c:if>>
              </c:when>
              <c:when test="${obj.inputType==7}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"GovServerService\").find(ServiceUtil.buildBean(\"GovServer@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.value1}</option>
                  </c:forEach>
                </select>
              </c:when>
              <c:when test="${obj.inputType==8}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"GovMemorizerService\").find(ServiceUtil.buildBean(\"GovMemorizer@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.value1}</option>
                  </c:forEach>
                </select>
              </c:when>
              <c:when test="${obj.inputType==9}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"GovComputerRoomService\").find(ServiceUtil.buildBean(\"GovComputerRoom@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.value1}</option>
                  </c:forEach>
                </select>
              </c:when>
              <c:when test="${obj.inputType==10}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"GovApplicationSystemService\").find(ServiceUtil.buildBean(\"GovApplicationSystem@isDeleted=0\"))%>">
                  <option value="${obj2.id}">${obj2.value1}</option>
                  </c:forEach>
                </select>
              </c:when>
              <c:when test="${obj.inputType==11}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"InformationBusinessService\").find(ServiceUtil.buildBean(\"InformationBusiness\"))%>">
                    <option value="${obj2.id}">${obj2.value1}</option>
                  </c:forEach>
                </select>
              </c:when>
              <c:when test="${obj.inputType==12}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"GovDatabaseService\").find(ServiceUtil.buildBean(\"GovDatabase@isDeleted=0\"))%>">
                    <option value="${obj2.id}">${obj2.value2}</option>
                  </c:forEach>
                </select>
              </c:when>   
              
               <c:when test="${obj.inputType==13}">
                 <div class="col-sm-4">
                  <select name="database13" data-placeholder=" "
           			 data-param="value3" data-bind="select[data-name='table13']"
            		 class="chosen-select" >
            		<option value=""></option>
            		<c:forEach var="db" items="<%=ServiceUtil.getService(\"GovDatabaseService\").find(ServiceUtil.buildBean(\"GovDatabase@isDeleted=0\"))%>">
            			<option value="${db.id}">${db.value2}-${db.value1}</option>
           			 </c:forEach>
         		  </select>
         		</div>
       			<div class="col-sm-4">
                <select data-name="table13" name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select" data-level="2" data-url="${base}/backstage/govTable/listAjax?all=y"
            data-keyField="id" data-valueField="value1"
                  <c:if test="${obj.required==1}" >required</c:if>>
                </select>
                </div>
              </c:when>     
              
               <c:when test="${obj.inputType==14}">
                <div class="col-sm-4">
                  <select name="database14" data-placeholder=" "
           			 data-param="value3" data-bind="select[name='table14']"
            		 class="chosen-select" >
            		<option value=""></option>
            		<c:forEach var="db" items="<%=ServiceUtil.getService(\"GovDatabaseService\").find(ServiceUtil.buildBean(\"GovDatabase@isDeleted=0\"))%>">
            			<option value="${db.id}">${db.value2}-${db.value1}</option>
           			 </c:forEach>
         		  </select>
         		</div>
       			<div class="col-sm-4">
                <select   data-placeholder=" " name="table14"
                  class="chosen-select" data-level="2" data-url="${base}/backstage/govTable/listAjax?all=y"
            data-keyField="id" data-valueField="value1" data-param="value3" data-bind="select[name='value${obj.valueNo}']" >
                </select>
                </div>
                <div class="form-group">
         		 <label class="col-sm-3 control-label info-label"  >&nbsp;</label>          
               <div class="col-sm-8">
                <select  name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select" data-level="3" data-url="${base}/backstage/govTableField/listAjax?all=y"
            data-keyField="id" data-valueField="value1"
                  <c:if test="${obj.required==1}" >required</c:if>>
                </select>
                </div>
                </div>                
              </c:when> 
              
              <c:when test="${obj.inputType==15}">
                <select name="value${obj.valueNo}" data-placeholder=" "
                  class="chosen-select"
                  <c:if test="${obj.required==1}" >required</c:if>>
                  <option value=""></option>
                  <c:forEach var="obj2" items="<%=ServiceUtil.getService(\"SortManagerService\").find(ServiceUtil.buildBean(\"SortManager@isDeleted=0&type=2\"))%>">
                  <option value="${obj2.sortName}">${obj2.sortCode}</option>
                  </c:forEach>
                </select>
              </c:when>
              
              <c:otherwise>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </c:forEach>
     
      <div class="ibox-content" id="dicTree" style="padding-left:0px;padding-right:0px;">
        <div class="btn-group" id="toolbar" role="group" style="margin-bottom:15px;">
          <div class="text-center detail-hide">
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
          <div class="form-group showinfor" >
        <label class="col-sm-2 control-label">信息资源：</label>
        <div class="col-sm-4">        
          <select name="informationResId" id="informationResId" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <option value="">&nbsp;</option>
            <c:forEach var="obj" items="<%=ServiceUtil.getService(\"InformationResourceService\").find(ServiceUtil.buildBean(\"InformationResource@isDeleted=0&status=0\"),\"id\",\"desc\") %>">
            <option value="${obj.id}">${obj.value1}</option>
            </c:forEach>
          </select> 
        </div>
        <label class="col-sm-2 control-label">数据元类型：</label>
        <div class="col-sm-4">        
          <select name="sys_type"  data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
            <option value=""></option>
            <option value="">&nbsp;</option>
            <option value="0">专用数据元</option>
            <option value="1">公共数据元</option>
          </select> 
        </div>
      </div>
      
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
                <input type="text" placeholder="输入名称" name="keyword" class="form-control"> 
                <span class="input-group-btn"> 
                <button type="button" onclick=" $('#dm3').bootstrapTable('refresh');" class="btn btn-primary">搜索
                </button> </span>
              </div>
            </div>
          </div>
          <table id="dm3"></table>
        </div>
      </div>
    </div>
  </div>

<div id="dataElement-detail" class="form-horizontal"
    style="overflow: hidden;display:none;">
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
          <label class="col-sm-4 control-label">英文名称：</label>
          <span class="col-sm-8 dt-span" name="egName"></span>
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

  <div id="sql_div" style="display: none;" class="ibox-content">
    <div id="dicTree" style="padding-left:0px;padding-right:0px;">
        <div class="btn-group" id="toolbar" role="group" style="margin-bottom:15px;">
          <div class="text-center detail-hide">
            <div id="spansql">
              <div class="tab-container-c">
                <nav class="tab-nav clearfix">
                  <a href="javascript:void(0);" class="pull-left active">oracle</a>
<!--              	  <a href="javascript:void(0);" class="pull-left">mySql</a>  --> 
                </nav>
                <div class="tab-wrapper text-left">
                  <div class="item">oracle</div>
<!--                   <div class="item">mySql</div>  --> 
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>
  </div>

</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script>
var dicLayerContent = '#dic_form';
var title_name="";
var layerIndex;//layer 窗口对象
var layerContent='#layer_form';//layer窗口主体内容dom Id
var tableId='#dicList';//bootstrap-table id
var toolbar='#toolbar';//bootstrap-table 工具栏id
var formId='#eform';//form id
var url='${base}/backstage/model/customModel/';//controller 路径

$("select[name='infoT']").chosen({
  disable_search_threshold: 10,
  no_results_text: "没有匹配到这条记录",
    width: "100%"
});
var dicLayerIndex;
var checkedIds=",";
var checkedEles;
var dataEles;//存放选中的数据元
var inforResId="";
function addNew(){
  dataEles=new Array();
  inforResId : $('input[name="informationResId"]').val();
  checkedIds=",";
  $('#dm2').bootstrapTable('load',{rows:[]});
  openLayer();
  initDataElements();
}
//或许所有数据元
function initDataElements(){

    initText();

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
      html += '<li class="search-choice" onclick="detail(\''
          + checkedEles[k].idForShow + '\');"><span>'
          + checkedEles[k].chName + '</span><a class="search-choice-close" onclick="unCheck(\''
          + checkedEles[k].idForShow + '\');"></a></li>';
    }
    $('.c-list').html(html);
  } else {
    $('.c-list').html('');
  }

}
var  columns=${columns};
  //得到查询的参数
  var queryParams = function(params) {
    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1
    };
    return temp;
  };

  var queryParams2 = function(params) {

    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      id : $('input[name="id"]').val()
    };
    return temp;
  };

  var queryParams3 = function(params) {
    var temp = { 
        rows : params.limit,
        page : params.offset / params.limit + 1,
        objectType:$('select[name="dxl-select"]').val(),
        chName:$('input[name="keyword"]').val(),
        systemType:$('select[name="sys_type"]').val(),
        
        id : $("#informationResId").val()
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
        url : '${base}/backstage/dataElement/hmAjax', //请求后台的URL（*）
        method : 'post', //请求方式（*）
        contentType : "application/x-www-form-urlencoded",
        iconSize : 'outline',
        striped : true, //是否显示行间隔色
        cache : false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        pagination : false, //是否显示分页（*）
        sortable : false, //是否启用排序
        sortOrder : "asc", //排序方式
        queryParams : queryParams2,//传递参数（*）
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
        columns : [ {
          field : 'identifier',
          title : '内部资源标识符'
        }, {
          field : 'chName',
          title : '中文名称'
        },{
          field : 'egName',
          title : '英文名称'
        },{
            field: 'dataTypeForShow',
            title: '数据类型'
        }, {
          field : 'id',
          title : '操作',
          formatter : 'doFormatter3',//对本列数据做格式化    
        } ],
        onLoadSuccess:function(data){
          
          if(typeof(data.rows)!="undefined"){
            dataEles=data.rows;
            initText();
          }
        }
      });
    };
    return oTableInit;
  };

  function openDicLayer() {
     $('#dm3').bootstrapTable('refresh');
    dicLayerIndex = layer.open({
      type : 1,
      area : [ '70%', '80%' ], //宽高
      title : '选择信息项',
      scrollbar : false,
      btn : [ '保存', '关闭' ],
      yes : function(index, layero) {
        $('#dm2').bootstrapTable('load',{rows:checkedEles});
        //$(dicFormId).submit();
        console.log(checkedEles);
        $('input[name="dataElementId"]').val(checkedIds);
        layer.close(dicLayerIndex);
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
        url : '${base}/backstage/cleanDataElement/findDataElementByResId', // 请求后台的URL（*）
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
        showRefresh: false,
        strictSearch : true,
        clickToSelect : false, //是否启用点击选中行
        uniqueId : "idForShow", //每一行的唯一标识，一般为主键列
        cardView : false, //是否显示详细视图
        detailView : false,
        queryParamsType : "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
        columns : [{
          field : 'id',
          title : '添加',
          formatter : 'checkFormatter'
                 },{
          field : 'identifier',
          title : '内部资源标识符'
        }, {
          field : 'chName',
          title : '中文名称'
        },{
          field : 'egName',
          title : '英文名称'
        },{
            field: 'dataTypeForShow',
            title: '数据类型'
        }, {
          field : 'id',
          title : '操作',
          formatter : 'doFormatter4',//对本列数据做格式化    
        } ]
      });
    };
    return oTableInit;
  };  
  
  function checkFormatter(value, row, index) {
    var html = '';
    if (checkedIds.indexOf("," + value + ",") > -1) {
      html += '<input type="checkbox" data-id="'+value+'" value="' + row.idForShow + '" data-name="'
          + row.chName
          + '" onclick="selectDE(this);" checked="checked"/>';
    } else {
      html += '<input type="checkbox" data-id="'+value+'" value="' + row.idForShow + '" data-name="'
          + row.chName + '" onclick="selectDE(this);"/>';
    }
    return html;
  }
  
  function selectDE(t) {
    if ($(t).is(':checked')) {
      checkedIds += $(t).attr('data-id') + ",";
      var data = $('#dm3').bootstrapTable('getRowByUniqueId', $(t).val());
      //console.log(data,checkedIds);
      dataEles.push(data);
    } else {
      checkedIds = checkedIds.replace("," + $(t).val() + ",", ",");
      unCheck($(t).val());
    }
    initText();
  }
    
  function unCheck(id){
    var arr=new Array();
    var ck=",";
    for(var j=0;j<dataEles.length;j++){
      if(dataEles[j].idForShow!=id){
        arr.push(dataEles[j]);
        ck+=dataEles[j].id+",";
      }
    }
    $('#dm3 input[value="'+id+'"]').removeAttr("checked");
    checkedIds =ck;
    dataEles=arr;
    initText();

  }
  
  function doFormatter3(value, row, index) {
    var html = '';
    html += '<div class="btn-group">';
    html+='<button type="button" class="btn btn-white" onclick="deDetail(\''+row.idForShow+'\')">查看</button>';
    html += '</div>';
    return html;
  }
  function doFormatter4(value, row, index) {
    var html = '';
    html += '<div class="btn-group">';
    html+='<button type="button" class="btn btn-white" onclick="deDetail(\''+row.idForShow+'\',\'#dm3\')">查看</button>';
    html += '</div>';
    return html;
  }
  
  function deDetail(id,la){
		layer.open({
		    type: 2,
		    title: '数据元详情',
		    shadeClose: true,
		    shade: 0.1,
		    area: ['620px', '80%'],
		    content: base + '/backstage/cleanDataElement/detail?idForShow=' + id
		  });
	}
</script>
<%@include file="../../common/baseSystemJS.jsp"%>
<script type="text/javascript">

function editRow(id){
  openLayer();
  
  layer.title('修改', layerIndex);
  var data=$(tableId).bootstrapTable('getRowByUniqueId', id);
  $(formId).form('load',data);
  checkedIds=","+data.dataElementIds+",";
  console.log(checkedIds);
  //initDataElements();
   $('#dm2').bootstrapTable('refresh');
   $('#informationResId').val(data.informationResId);
  //通知chosen下拉框更新
  var cs=$(".chosen-select");
  if(cs.length){
    for(var i=0;i<cs.length;i++){
      if($(cs[i]).attr('data-bind')){
        var cid=$(cs[i]).attr('data-bind');
        var  p = {};
        p[$(cs[i]).attr("data-param")] =$(cs[i]).val();
        initAjaxChosen(cid,$(cid).attr('data-url'),p,data[$(cid).attr('name')]);
      }
    }
  }
  $(".chosen-select").trigger("chosen:updated");
  $(formId).valid();
  //inforResId=$("#informationResId").val();
//  $("#inforCode").val($("#informationResId").val());
  $(".chosen-select").trigger("chosen:updated");
//  $("#inforCodeShow").val($("#inforCode").find("option:selected").text());
}
</script>

<script>
function openLayer(){
  $(formId).form('clear');
  initChosen();
  $(formId).valid();
  layerIndex=layer.open({
    type: 1,
    area: ['70%', '80%'], //宽高
    title: '新增',
    scrollbar: false,
    btn: ['保存','关闭'], 
    yes: function(index, layero){
      $(formId).submit();
    },
    offset: '20px',
    content: $(layerContent) //这里content是一个DOM
  });
}
$(formId).form({  
    url: url+'insertAjax'+'?'+'<%=request.getQueryString()%>',
    onSubmit: function(){
      return $(formId).valid();
    },
    success: function(result){ 
      console.log(result);
      var result = eval('('+result+')');
      if(result.code && result.code==1){
        layer.close(layerIndex);
         $(tableId).bootstrapTable('refresh');
      }
      layer.msg(result.msg);
    }
});
function detail(id,tableId){
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
var TableInit = function () {
    var oTableInit = new Object();
    //初始化Table
    oTableInit.Init = function () {
        $(tableId).bootstrapTable({
            url: url+'listAjax'+'?'+'<%=request.getQueryString()%>',         //请求后台的URL（*）
            method: 'post',                      //请求方式（*）
            contentType: "application/x-www-form-urlencoded",
            toolbar:toolbar,//工具按钮用哪个容器
            iconSize: 'outline',
            striped: true,                      //是否显示行间隔色
            cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
            pagination: true,                   //是否显示分页（*）
            sortable: false,                     //是否启用排序
            sortOrder: "asc",                   //排序方式
            queryParams: queryParams,//传递参数（*）
            sidePagination: "server",           //分页方式：client客户端分页，server服务端分页（*）
            pageNumber:1,                       //初始化加载第一页，默认第一页
            pageSize: 10,                       //每页的记录行数（*）
            pageList: [10, 25, 50, 100],        //可供选择的每页的行数（*）
            strictSearch: true,
            clickToSelect: false,                //是否启用点击选中行
            uniqueId: "idForShow",                     //每一行的唯一标识，一般为主键列
            cardView: false,                    //是否显示详细视图
            detailView: false,   
            showRefresh: true,  
            showToggle: true,      
            showColumns:true,
            queryParamsType: "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
            columns:columns
        });
    };
    return oTableInit;
};

$("#addde").click(function(){
  var adIds = "";  
    $("input:checkbox[name='dename']:checked").each(function(i){
        if(0==i){
            adIds = $(this).val();
        }else{
            adIds += (","+$(this).val());
        }
    });
    //alert(adIds); 
});

function initChosen(){
  disableChosen();
  if(chosenInited==0){
    chosenInited=1;
  }else{
    $(".chosen-select").val("");
    $(".chosen-select").trigger("chosen:updated");
    return;
  }
  var chosen=$(".chosen-select").chosen({
    disable_search_threshold: 10,
    no_results_text: "没有匹配到这条记录",
        max_selected_options: 3,
        width: "100%"
  });
  chosen.on('change', function(e, params) {
	  $("#inforResourceId").val($("#informationResId").val());
	  $('#dm3').bootstrapTable('refresh');
//    $("#inforCode").val($("#informationResId").val());
    $(".chosen-select").trigger("chosen:updated");
//    $("#inforCodeShow").val($("#inforCode").find("option:selected").text());
    if($(this).attr('data-bind')){
      var cid=$(this).attr('data-bind');
      if($(this).val()==''){
        $(cid).val('');
        $(cid).attr('disabled', true).trigger("chosen:updated");
      }else{
        $(cid).attr('disabled', false).trigger("chosen:updated")
        var  p = {};
        p[$(this).attr("data-param")] =$(this).val();
        initAjaxChosen(cid,$(cid).attr('data-url'),p);
      }
    }
    $(formId).valid();
    });
  $(".chosen-select").trigger("chosen:updated");  
}

function doFormatter(value, row, index){
  var html='';
  html+='<div class="btn-group">';
  html+='<button type="button" class="btn btn-white" onclick="datailBefor(\''+row.idForShow+'\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
  <c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/model/customModel/index?model=6\") %>">
  html+='<button type="button" class="btn btn-white" onclick="editRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
  </c:if>
  <c:if test="<%=!ServiceUtil.haveDel(\"/backstage/model/customModel/index?model=6\") %>">
  html+='<button type="button" class="btn btn-white" onclick="deleteRow(\''+row.idForShow+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
  </c:if>
  html+='<button type="button" class="btn btn-white" onclick="createSql('+row.id+')"><i class="fa fa-paper-plane-o"></i>&nbsp;生成sql</button>';
  html+='</div>';
  return html;
}
function createSql(id){

	var data=$(tableId).bootstrapTable('getRowByUniqueId', id);
	  jQuery.post(url+"createSql",{"id":id},function(data){
		     console.log(data.oracle);

			layerIndex=layer.open({
			  type: 1,
			  area: ['70%', '70%'], //宽高
			  title: 'sql',
			  offset: '20px',
			  btn: ['下载'], 
			  yes: function(index, layero){
				  var types=$('.pull-left.active').html();
				  
				    var elemIF = document.createElement("iframe");     
				    elemIF.src = "${base}/upload/excel/"+types+"-"+data.tables+".sql";    
				    elemIF.style.display = "none";     
				    document.body.appendChild(elemIF);  
			  },
			  cancel:function(index, layero){				 
			  },
			  content: $('#sql_div') //这里content是一个DOM
			});
      var reg = /(,|;)/gi
      // var reg = /(\\n)*/gi
      data.oracle = data.oracle.replace(reg, '$1<br>');
      data.oracle = data.oracle.replace('"ID" NUMBER(12) NOT NULL', '<br>"ID" NUMBER(12) NOT NULL');
      data.oracle = data.oracle.replace('PRIMARY KEY ("ID")', 'PRIMARY KEY ("ID")<br> ');
      data.mySql = data.mySql.replace(reg, '$1<br>');
      data.mySql = data.mySql.replace('`id` int(12) NOT NULL', '<br>`id` int(12) NOT NULL');
      data.mySql = data.mySql.replace('PRIMARY KEY (`id`)', 'PRIMARY KEY (`id`)<br> ');
      $("#spansql .tab-wrapper .item").eq(0).html(data.oracle);
//			$("#spansql .tab-wrapper .item").eq(1).html(data.mySql);
	  },'json');
}	


function datailBefor(id){
  var data=$(tableId).bootstrapTable('getRowByUniqueId', id);
  $(formId).form('load',data);
  checkedIds=","+data.dataElementIds+",";
  $('#dm2').bootstrapTable('refresh');
  $(formId).valid();

  datailRow(id);
  $(".col-sm-8.dt-span").each(function(){
    if($(this).html()=="undefined"){
      $(this).remove();  
    }
  });
}

$('.tab-container-c .tab-nav a').on('click', function () {
	  var index = $(this).index();
	  $(this).addClass('active').siblings().removeClass('active');
	  $('.tab-container-c .tab-wrapper .item').eq(index).show().siblings().hide();
	});
</script>
