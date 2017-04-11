<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseHead.jsp"%>
</head>
<style>
.form_datetime.input-group[class*=col-]{float: left;padding-right: 15px;padding-left: 15px;}
</style>
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
                </div>
            </div>
          </div>
        </div>
        <table id="dicList">
        </table>
      </div>
    </div>
  </div>
  <div id="main5">
      <div id="main4" class="form-horizontal" style="height:800px;"></div>
  </div>
</body>
</html>
<%@include file="../common/includeJS.jsp"%>
<script src="${base}/static/js/plugins/echarts/echarts-all.js"></script>
<script>
var cdata = {"companyId":"<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>"};
var layerIndex;//layer 窗口对象
var title_name="服务器资料";
var layerContent='#layer_form';//layer窗口主体内容dom Id
var tableId='#dicList';//bootstrap-table id
var toolbar='#toolbar';//bootstrap-table 工具栏id
var formId='#eform';//form id
var url='${base}/backstage/govServer/';//controller 路径

$("select[name='cId']").chosen({
  disable_search_threshold: 10,
  no_results_text: "没有匹配到这条记录",
    width: "100%"
});
var columns = [{field: 'value1',title: '服务器编号'},{field: 'value2ForShow',title: '责任部门'},{field: 'value3',title: '购买时间'}, {field: 'id',title: '操作',formatter: 'doFormatterL'}];

function dshow(id,name) {
	console.info(id+'----'+name);
    $.getJSON("${base}/backstage/echart/seranalyse?value3=" + id +"&name="+name, function(data) {
      $("#main5").show();
      var myChart4 = echarts.init(document.getElementById('main4'));
      var option4 = {
    	        title: {
    	          // text: '人物关系：乔布斯',
    	          //subtext: '数据来自人立方',
    	          x: 'right',
    	          y: 'bottom'
    	        },
    	        tooltip: {
    	          trigger: 'item',
    	          formatter: '{a} : {b}'
    	        },
    	        toolbox: {
    	          show: true,
    	          feature: {
    	            restore: { show: true },
    	            magicType: { show: true, type: ['force', 'chord'] },
    	            saveAsImage: { show: true }
    	          }
    	        },
    	        legend: {
    	          x: 'left',
    	          data: ['服务器','系统','表','字段']
    	        },
    	        series: [{
    	          type: 'force',
    	          name: "关系分析",
    	          ribbonType: false,
    	          categories: [{
    	            name: '服务器'
    	          }, {
    	            name: '系统'
    	          },{
    	            name: '表'
    	          },{
    	            name: '字段'
    	          }],
    	          itemStyle: {
    	            normal: {
    	              label: {
    	                show: true,
    	                textStyle: {
    	                  color: '#333'
    	                }
    	              },
    	              nodeStyle: {
    	                brushType: 'both',
    	                borderColor: 'rgba(255,215,0,0.4)',
    	                borderWidth: 1
    	              },
    	              linkStyle: {
    	                type: 'curve'
    	              }
    	            },
    	            emphasis: {
    	              label: {
    	                show: false
    	                  // textStyle: null      // 默认使用全局文本样式，详见TEXTSTYLE
    	              },
    	              nodeStyle: {
    	                //r: 30
    	              },
    	              linkStyle: {}
    	            }
    	          },
    	          useWorker: false,
    	          minRadius: 15,
    	          maxRadius: 25,
    	          gravity: 1.1,
    	          scaling: 1.8,
    	          roam: 'move',
    	          nodes: data.node,
    	          links: data.link
    	        }]
    	      };
      myChart4.setOption(option4);
      layer.open({
        type: 1,
        shade: false,
        area: ['98%', '96%'], //宽高
        scrollbar: false,
        title: false, //不显示标题
        content: $("#main4"), //这里content是一个DOM，注意：最好该元素要存放在body最外层，否则可能被其它的相对元素所影响
        cancel: function() {
          $("#main5").hide();
        }
      });

    });
}
function doFormatterL(value, row, index) {
    var html = '';
    html += '<div class="btn-group">';
    //html+='<button type="button" class="btn btn-default">按钮 1</button>';
    html += '<button type="button" class="btn btn-white" onclick="dshow(\''+row.id+'\',\''+row.value1+'\')"><i class="fa fa-pencil"></i>&nbsp;关系展现</button>';
    html += '</div>';
    return html;
  }
  //得到查询的参数
  var queryParams = function(params) {
    var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
      rows : params.limit,
      page : params.offset / params.limit + 1,
      value2:$('select[name="cId"]').val(),
      serverNum:1,
      <c:if test="${MyFunction:getMaxScope(\"/backstage/govServer/index\")==1}" >
       companyId:<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>,
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