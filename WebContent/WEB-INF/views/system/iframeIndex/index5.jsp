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
  .myclass{width: 400px;max-width: 500px; height: 300px;max-height: 400px;overflow-y: auto;}
  .myclass .layui-layer-content {padding: 20px;}
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
        subtext : ''
    },
    tooltip : {
        trigger: 'item',
        formatter: '{b}'
    },
    
    dataRange: {
        min: 0,
        max: <%=ServiceUtil.getCompanyCountByAddr("")%>,
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
                {name: '三亚市',value: <%=ServiceUtil.getCompanyCountByAddr("三亚市")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("三亚市")%>},
                {name: '乐东黎族自治县',value: <%=ServiceUtil.getCompanyCountByAddr("乐东黎族自治县")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("乐东黎族自治县")%>},
                {name: '儋州市',value: <%=ServiceUtil.getCompanyCountByAddr("儋州市")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("儋州市")%>},
                {name: '琼中黎族苗族自治县',value: <%=ServiceUtil.getCompanyCountByAddr("琼中黎族苗族自治县")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("琼中黎族苗族自治县")%>},
                {name: '东方市',value: <%=ServiceUtil.getCompanyCountByAddr("东方市")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("东方市")%>},
                {name: '海口市',value: <%=ServiceUtil.getCompanyCountByAddr("海口市")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("海口市")%>},
                {name: '万宁市',value: <%=ServiceUtil.getCompanyCountByAddr("万宁市")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("万宁市")%>},
                {name: '澄迈县',value: <%=ServiceUtil.getCompanyCountByAddr("澄迈县")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("澄迈县")%>},
                {name: '白沙黎族自治县',value: <%=ServiceUtil.getCompanyCountByAddr("白沙黎族自治县")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("白沙黎族自治县")%>},
                {name: '琼海市',value: <%=ServiceUtil.getCompanyCountByAddr("琼海市")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("琼海市")%>},
                {name: '昌江黎族自治县',value: <%=ServiceUtil.getCompanyCountByAddr("昌江黎族自治县")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("昌江黎族自治县")%>},
                {name: '临高县',value: <%=ServiceUtil.getCompanyCountByAddr("临高县")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("临高县")%>},
                {name: '陵水黎族自治县',value: <%=ServiceUtil.getCompanyCountByAddr("陵水黎族自治县")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("陵水黎族自治县")%>},
                {name: '屯昌县',value: <%=ServiceUtil.getCompanyCountByAddr("屯昌县")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("屯昌县")%>},
                {name: '定安县',value: <%=ServiceUtil.getCompanyCountByAddr("定安县")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("定安县")%>},
                {name: '保亭黎族苗族自治县',value: <%=ServiceUtil.getCompanyCountByAddr("保亭黎族苗族自治县")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("保亭黎族苗族自治县")%>},
                {name: '文昌市',value: <%=ServiceUtil.getCompanyCountByAddr("文昌市")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("文昌市")%>},
                {name: '五指山市',value: <%=ServiceUtil.getCompanyCountByAddr("五指山市")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("五指山市")%>}
            ]
        }
    ]
};
                    
myChart.setOption(option);
myChart.on('click', eConsole);
    function eConsole(param) { 
      var name = param.name;
      var content = param.data.info;
      var html = '';

      if (!content.length) {
        html += '<h2 class="text-center" style="color: #aaa">'+name+'数据为空</h2>';

      } else {
        html += '<h3>'+name+'数据信息:</h3>';
        html += '<table class="table table-bordered"><tr><th>部门名称</th><th>数据元</th><th>部门数据元</th></tr>'
        $.each(content, function (index, value) {

          
          html += '<tr><td>'+ value.name + '</td><td>'+value.dataElement+'</td><td>'+value.informationResource+'</td>';
        });
        html += '</table>';
      }
      
      // var html = name + '<br>' + content
        layer.open({
          type: 1,
          title: false,
          closeBtn: 0,
          shadeClose: true,
          skin: 'myclass',
          content: html,
          area: ['70%', '350px']
        });
    }
    </script>
</body>
</html>