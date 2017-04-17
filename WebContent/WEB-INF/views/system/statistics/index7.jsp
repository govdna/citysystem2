<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseLinkHead.jsp"%>
</head>
<style>
ul,li {
list-style: none;
}
</style>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
<div class="container">
    <div class="row"> 
    <div>
	    <div class="col-sm-6"  style="padding: 0 10px;">
	    	<div class="small-box box-1">
	    		<div class="icon-container text-center col-xs-4">
	    			<i class="fa fa-pie-chart"></i>
	    		</div>
	    		<div class="content text-center col-xs-8">数据元总数　<b><%=ServiceUtil.getService("DataElementService").count(ServiceUtil.buildBean("DataElement@classType=1&isDeleted=0"))%></b></div>
	    	</div>
	    </div>
	    <div class="col-sm-6"  style="padding: 0 10px;">
	    	<div class="small-box box-2">
	    		<div class="icon-container text-center col-xs-4">
	    			<i class="fa fa-area-chart"></i>
	    		</div>
	    		<div class="content text-center col-xs-8">信息资源总数　<b><%=ServiceUtil.getService("InformationResourceService").count(ServiceUtil.buildBean("InformationResource@status=0&isDeleted=0"))%></b></div>
	    	</div>
	    </div>
    </div>
    <div>
   
   <c:forEach items="<%=ServiceUtil.getUseCount()%>" var="company" varStatus="i">
	   	<c:if test="${i.count<=20}">
	   	<div class="panel-container col-xs-4">
	        <div class="panel panel-default  panel-item echart-show" data-bind="${company.id}" style="cursor:pointer">
	          <div class="panel-heading text-center text-hidden">${company.value1}</div>
	          <div class="panel-body content">
	            <ul>
	              <li  >
	                <p class="col-xs-8 text-right">涉及部门数量：</p> 
	                <p class="col-xs-4 text-left"><span>${company.companyId}</span></p>
	              </li>
	             <li  >
	                <p class="col-xs-8 text-right">信息资源使用 数量：</p> 
	                <p class="col-xs-4 text-left"><span>${company.counts}</span></p>
	              </li>
	              
	            </ul>
	          </div>
	        </div>
	      </div>
	      </c:if>
	</c:forEach>
	    
	    
    </div>
  </div>
  </div>
  <div id="hidden" style="display:none">
    <div class="echarts" id="main" style="height:500px"></div>
  </div>
</body>
</html>

<%@include file="../common/includeJS.jsp"%>
<script src="${base}/static/js/plugins/echarts/echarts-all.js"></script>
<script>
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
	    	            scaling: 1.0,
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
	    area: ['96%', '96%'], //宽高
	    scrollbar: false,
	    title: false, //不显示标题
	    content: $("#main"), //这里content是一个DOM，注意：最好该元素要存放在body最外层，否则可能被其它的相对元素所影响
	    cancel: function() {
	      $("#hidden").hide();
	    }
	  });
	}
	$('.echart-show').click(function(){
		var id = $(this).attr("data-bind");
		analyse(id);
	})
	</script>
