<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en"> 
<head>
<%@include file="../common/includeBaseHead.jsp"%>
<style type="text/css">
.c-list{
cursor: auto !important;
}

.c-list li.search-choice{
padding: 3px 5px 3px 5px !important;

}

</style>
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
        </div>
        <table id="dicList">
        </table>
      </div>
    </div>
  </div>
  <div id="hidden" style="display:none">
    <div class="echarts" id="main" style="height:800px"></div>
  </div>

</body>
</html>

<%@include file="../common/includeJS.jsp"%>
<script src="${base}/static/js/plugins/echarts/echarts-all.js"></script>
<script>
var queryParams = function(params) {

  var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
    rows: params.limit,
    page: params.offset / params.limit + 1,
  };
  return temp;
};
$("#dicList").bootstrapTable({
  url: '${base}/backstage/govRdataElement/listAjax?classType=1&status=113', //请求后台的URL（*）
  method: 'post', //请求方式（*）
  contentType: "application/x-www-form-urlencoded",
  toolbar: '#toolbar', //工具按钮用哪个容器
  iconSize: 'outline',
  striped: true, //是否显示行间隔色
  cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
  pagination: true, //是否显示分页（*）
  sortable: false, //是否启用排序
  sortOrder: "asc",
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
  columns: [{
    field: 'identifier',
    title: '内部标识符'
  }, {
    field: 'chName',
    title: '中文名称'
  }, {
    field: 'dataTypeForShow',
    title: '数据类型'
  }, {
    field: 'dataFormat',
    title: '数据长度'
  }, {
    field: 'objectTypeForShow',
    title: '对象类型'
  }, {
    field: 'id',
    title: '操作',
    formatter: 'doFormatter', //对本列数据做格式化
  }]
});


var labelFromatter = {
  normal: {
    label: {
      show: true,
      position: 'top',
      textStyle: {
        color: '#676a6c',
        fontSize: 13,
        fontWeight: 'bolder'
      }
    },
    lineStyle: {
      color: '#d2d2d3',
      width: 2,
      type: 'broken' // 'curve'|'broken'|'solid'|'dotted'|'dashed'
    }
  },
  emphasis: {
    label: {
      show: false,
    }
  }
}

function doFormatter(value, row, index) {
  var html = '';
  html += '<div class="btn-group">';
  html += '<button type="button" class="btn btn-white" onclick="analyse(\'' + row.id + '\')"><i class="fa fa-share-alt"></i>&nbsp;关联分析</button>';
  html += '</div>';
  return html;
}

function analyse(id) {
  $("#hidden").show();
  var myChart = echarts.init(document.getElementById('main'));
  $.getJSON('${base}/backstage/dataElement/analyse?id=' + id, function(data) {
    var option = {
    	    
    	    tooltip : {
    	        trigger: 'item',
    	        formatter: '{a} : {b}'
    	    },
    	    toolbox: {
    	        show : true,
    	        feature : {
    	            restore : {show: true},
    	            magicType: {show: true, type: ['force', 'chord']},
    	            saveAsImage : {show: true}
    	        }
    	    },
    	    legend: {
    	        x: 'left',
    	        data:['数据元','信息资源','部门']
    	    },
    	    series : [
    	        {
    	            type:'force',
    	            name : "关联分析",
    	            ribbonType: false,
    	            categories : [
    	                {
    	                    name: '数据元'
    	                },
    	                {
    	                    name: '信息资源'
    	                },
    	                {
    	                    name:'部门'
    	                }
    	            ],
    	            itemStyle: {
    	                normal: {
    	                    label: {
    	                        show: true,
    	                        textStyle: {
    	                            color: '#333'
    	                        }
    	                    },
    	                    nodeStyle : {
    	                        brushType : 'both',
    	                        borderColor : 'rgba(255,215,0,0.4)',
    	                        borderWidth : 1
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
    	                    nodeStyle : {
    	                        //r: 30
    	                    },
    	                    linkStyle : {}
    	                }
    	            },
    	            useWorker: false,
    	            minRadius : 15,
    	            maxRadius : 25,
    	            gravity: 1.1,
    	            scaling: 1.1,
    	            roam: 'move',
    	            nodes:data.node,
    	            links : data.link
    	        }
    	    ]
    	};
    myChart.setOption(option);
  });
  layer.open({
    type: 1,
    shade: false,
    area: ['98%', '96%'], //宽高
    scrollbar: false,
    title: false, //不显示标题
    content: $("#main"), //这里content是一个DOM，注意：最好该元素要存放在body最外层，否则可能被其它的相对元素所影响
    cancel: function() {
      $("#hidden").hide();
    }
  });
}

</script>
