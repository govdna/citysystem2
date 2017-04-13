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
<style>
  .myclass{max-width: 400px;}
  .myclass .layui-layer-content {padding: 10px;}
</style>
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
  <script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
	<script src="${base}/static/js/plugins/echarts/echarts-all.js"></script>
  <script src="${base}/static/js/plugins/layer/layer.js"></script>
	<script>
  $(function() {
    layer.config({
      extend: '../extend/layer.ext.js'
    });
  })
        var myChart = echarts.init(document.getElementById('main1'));
       // var myChart = echarts.init(document.getElementById('main'));
  
var curIndx = 0;

option = {
    title: {
        text : '海南',
        subtext : '海南'
    },
    tooltip : {
        trigger: 'item',
        formatter: '{b}'
    },
    
    dataRange: {
        min: 0,
        max: 1000,
        color:['orange','yellow'],
        text:['高','低'],// 文本，默认为数值文本
        calculable : false
    },
    series : [
        {
            name: '随机数据',
            type: 'map',
            mapType: '海南',
            selectedMode : 'single',
            itemStyle:{
                normal:{label:{show:true}},
                emphasis:{label:{show:true}}
            },
            data:[
                {name: '三亚市',value: Math.round(Math.random()*1000)},
                {name: '乐东黎族自治县',value: Math.round(Math.random()*1000)},
                {name: '儋州市',value: Math.round(Math.random()*1000)},
                {name: '琼中黎族苗族自治县',value: Math.round(Math.random()*1000)},
                {name: '东方市',value: Math.round(Math.random()*1000)},
                {name: '海口市',value: Math.round(Math.random()*1000)},
                {name: '万宁市',value: Math.round(Math.random()*1000)},
                {name: '澄迈县',value: Math.round(Math.random()*1000)},
                {name: '白沙黎族自治县',value: Math.round(Math.random()*1000)},
                {name: '琼海市',value: Math.round(Math.random()*1000)},
                {name: '昌江黎族自治县',value: Math.round(Math.random()*1000)},
                {name: '临高县',value: Math.round(Math.random()*1000)},
                {name: '陵水黎族自治县',value: Math.round(Math.random()*1000)},
                {name: '屯昌县',value: Math.round(Math.random()*1000)},
                {name: '定安县',value: Math.round(Math.random()*1000)},
                {name: '保亭黎族苗族自治县',value: Math.round(Math.random()*1000)},
                {name: '文昌市',value: Math.round(Math.random()*1000)},
                {name: '五指山市',value: Math.round(Math.random()*1000)}
            ]
        }
    ]
};
                    
myChart.on('click', eConsole);
  myChart.setOption(option);
    function eConsole(param) { 
      var content = param.name;
        layer.open({
          type: 1,
          title: false,
          closeBtn: 0,
          shadeClose: true,
          skin: 'myclass',
          content: content
        });
    }
    </script>
</body>
</html>