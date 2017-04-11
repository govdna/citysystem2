<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseHead.jsp"%>
</head>
<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">

  <c:if test="${type==null}" >
    <div class="wrapper wrapper-content animated fadeInRight">
      <div class="ibox float-e-margins">
        <div class="ibox-content gray-bg">
          <div class="btn-group hidden-xs" id="toolbar" role="group">
          </div>
          <table id="dicList">
          </table>
        </div>
      </div>
    </div>
  </c:if>

  <div id="layer_form"  <c:if test="${type==null}" > style="display: none;"</c:if>  <c:if test="${type!=null}" ></c:if>  style="width: 90%;margin: 20px;background-color: #fff;margin: 0 auto;" >
    <div class="panel panel-default">
      <div class="panel-heading" style="background-color: #fff;">新增需求</div>
        <div class="panel-body">
          <form method="post" class="form-horizontal" id="eform" autocomplete="off">
            <input type="hidden" name="id"  class="form-control">
            <input type="hidden" name="idForShow"  class="form-control">        
            <div class="form-group">
              <label class="col-sm-3 control-label">序号：</label>
              <div class="col-sm-7">
                <input type="text" name="number"  class="form-control" required >
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">所需资源名称：</label>
              <div class="col-sm-7">
                <input type="text" name="resName"  class="form-control" required>
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">具体数据项名称：</label>
              <div class="col-sm-7">
                <input type="text" name="resDataName" class="form-control" required>
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">资源所在部门：</label>
              <div class="col-sm-7">
                <select name="resCompanyId" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" data-param="companyId" data-bind="select[name='resGroupId']" required>
                  <option value=""></option>
                  <c:forEach var="obj" items="<%=ServiceUtil.getService(\"CompanyService\").find(ServiceUtil.buildBean(\"Company@isDeleted=0\"),\"id\",\"desc\") %>">
                  <option value="${obj.id}">${obj.companyName}</option>
                  </c:forEach>
                </select>
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">资源所在处室：</label>
              <div class="col-sm-7">
                <select name="resGroupId" data-placeholder=" " data-url="${base}/backstage/groups/listAjax?all=y"
            data-keyField="id" data-valueField="name" class="chosen-select" style="width:350px;" tabindex="4" >
                </select>
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">信息资源格式：</label>
              <div class="col-sm-7">
                <select name="resFormat" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
                  <option value=""></option>
                  <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"INFORMATIONFORMAT\") %>">
                  <option value="${obj.dicKey}">${obj.dicValue}</option>
                  </c:forEach>
                </select>
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">主要用途：</label>
              <div class="col-sm-7">
                <input type="text" name="resPurpose" class="form-control" >
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">更新周期：</label>
              <div class="col-sm-7">
                <select name="updateCycle" data-placeholder=" " class="chosen-select" style="width:350px;" tabindex="4" required>
                  <option value=""></option>
                  <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"UPDATECYCLE\") %>">
                  <option value="${obj.dicKey}">${obj.dicValue}</option>
                  </c:forEach>
                </select>
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">备注：</label>
              <div class="col-sm-7">
                <input type="text" name="remarks" class="form-control" >
              </div>
            </div>
            <c:if test="${type!=null}" >
              <div class="form-group">
                  <div class="col-sm-4 col-sm-offset-5">
                  <input type="submit"  class="btn btn-primary" value="提交"/>
                 </div>
              </div>
            </c:if>
          </form>
        </div>
      </div>
    </div>

</body>
</html>

<%@include file="../common/includeJS.jsp"%>
<script>
var layerIndex;//layer 窗口对象
var layerContent='#layer_form';// layer窗口主体内容dom Id
var tableId='#dicList';//bootstrap-table id
var toolbar='#toolbar';//bootstrap-table 工具栏id
var formId='#eform';//form id
var url='${base}/backstage/resourcesDemand/';//controller 路径

//bootstrap-table 列数
var  columns=[{
    field: 'number',
    title: '序号'
}, {
    field: 'resName',
    title: '所需资源名称'
},{
    field: 'resDataName',
    title: '具体数据项名称'
},{
    field: 'resCompanyIdForShow',
    title: '资源所在部门'
},{
    field: 'resGroupIdForShow',
    title: '资源所在处室'
},{
    field: 'resFormatForShow',
    title: '信息资源格式'
}, {
    field: 'resPurpose',
    title: '主要用途'
},{
    field: 'updateCycleForShow',
    title: '更新周期'
},{
    field: 'remarks',
    title: '备注'
},{
    field: 'status',
    title: '状态'
},{
    field: 'id',
    title: '操作',
    formatter: 'doFormatter',//对本列数据做格式化
}];


  //得到查询的参数
  var queryParams = function(params) {

    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1,
    };
    return temp;
  };
</script>
<%@include file="../common/baseSystemJS.jsp"%>
<script>
<c:if test="${type!=null}" >
initChosen();
</c:if>
</script>