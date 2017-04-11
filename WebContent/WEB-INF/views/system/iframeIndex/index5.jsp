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
        var myChart = echarts.init(document.getElementById('main1'));
       // var myChart = echarts.init(document.getElementById('main'));
  
var curIndx = 0;
var mapType = [
     'china',
    // 23个省
    '广东', '青海', '四川', '海南', '陕西', 
    '甘肃', '云南', '湖南', '湖北', '黑龙江',
    '贵州', '山东', '江西', '河南', '河北',
    '山西', '安徽', '福建', '浙江', '江苏', 
    '吉林', '辽宁', '台湾',
    // 5个自治区
    '新疆', '广西', '宁夏', '内蒙古', '西藏', 
    // 4个直辖市
    '北京', '天津', '上海', '重庆',
    // 2个特别行政区
    '香港', '澳门'
];

myChart.on('mapSelected', function (param){
    var len = mapType.length;
    var mt = mapType[curIndx % len];
    var selected = param.selected;
   
    if (mt == 'china') {
        // 全国选择时指定到选中的省份
        var selected = param.selected;
        console.log(selected);
        for (var i in selected) {
            if (selected[i]) {
                mt = i;
                while (len--) {
                    if (mapType[len] == mt) {
                        curIndx = len;
                    }
                }
                break;
            }
        }
        option.tooltip.formatter = '{b}';
    }
    else {
        curIndx = 0;
        mt = 'china';
        option.tooltip.formatter = '{b}';
    }
    option.series[0].mapType = mt;
    // option.title.subtext = mt + ' （滚轮或点击切换）';
    myChart.setOption(option, true);
});
option = {
    title: {
        text : '中国',
        subtext : 'china （海南）'
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
        calculable : true
    },
    series : [
        {
            name: '随机数据',
            type: 'map',
            mapType: 'china',
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
                    

  myChart.setOption(option);
    </script>
</body>
</html>