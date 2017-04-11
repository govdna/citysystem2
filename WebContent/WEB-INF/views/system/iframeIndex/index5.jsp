<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">

<head>
	<%@include file="../common/includeBaseHead.jsp"%>
	<link href="${base}/static/plugins/jqgrid/ui.jqgrid.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="${base}/static/css/plugins/webuploader/webuploader.css">
   	<link rel="stylesheet" type="text/css" href="${base}/static/css/demo/webuploader-demo.css">
    <link href="${base}/static/css/plugins/chosen/chosen.css" rel="stylesheet">
  	<link href="${base}/static/css/style.css?v=4.1.0" rel="stylesheet">
</head>
<body class="skin-<%=ServiceUtil.getThemeType(10)%>">
	<div class="wrapper wrapper-content animated fadeInRight">
	    <div class="row">
	        <div class="col-sm-12">
	            <div class="ibox float-e-margins">
	                <div class="ibox-title">
	                    <h5>分布地图展现</h5>
	                </div>
	                <div class="ibox-content">
	                    <div class="echarts" id="main1" style="height:500px"></div>
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
	<script src="${base}/static/js/plugins/echarts/echarts-all.js"></script>
	<script>
        var myChart1 = echarts.init(document.getElementById('main1'));
        var option1 = {
       	    tooltip : {
       	        trigger: 'item',
       	        formatter: '{b}'
       	    },
       	    series : [
       	        {
       	            name: '中国',
       	            type: 'map',
       	            mapType: 'china',
       	            selectedMode : 'multiple',
       	            itemStyle:{
       	                normal:{label:{show:true}},
       	                emphasis:{label:{show:true}}
       	            },
       	            data:[
                        {name:'北京',selected:true},
                        {name:'广西',selected:true},
                        {name:'上海',selected:true},
                        {name:'浙江',selected:true},
   	                	{name:'江苏',selected:true},
   	                	{name:'广东',selected:true}
       	            ]
       	        }
       	    ]
       	};
        
        myChart1.setOption(option1);
    </script>
</body>
</html>