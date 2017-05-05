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
  option = {
    color: [

    ],
    title: {
      text: '海南地图',
      x: 'left'
    },
    tooltip: {
      trigger: 'axis',
      padding: 10,
      formatter: function(params, ticket, callback) {
        alert(params);

        return params.data.info.name;
      }
    },
    dataRange: {
      min: 0,
      max: <%=ServiceUtil.getCompanyCountByAddr("")%>,
      calculable: true,
      color: ['rgb(255, 166, 0)', 'rgb(255, 255, 0)']
    },
    toolbox: {
      show: false,
      orient: 'vertical',
      x: 'right',
      y: 'center',
      feature: {
        mark: {
          show: true
        },
        dataView: {
          show: true,
          readOnly: false
        },
        restore: {
          show: true
        },
        saveAsImage: {
          show: true
        }
      }
    },
    series: [{
      name: '111',
      type: 'map',
      mapType: '海南',
      hoverable: true,
      roam: true,
      data: [ {name: '三亚市',value: <%=ServiceUtil.getCompanyCountByAddr("三亚市")%>, info: <%=ServiceUtil.getCompanyCountByAddrJS("三亚市")%>},
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
         ],
      markPoint: {
        symbolSize: 5,
        itemStyle: {
          normal: {
            borderColor: '#ff5722',
            borderWidth: 3, 
            label: {
              show: false
            }
          },
          emphasis: {
            borderColor: '#ff5722',
            borderWidth: 5,
            label: {
              show: false
            }
          }
        },
        data: [
		<c:forEach var="obj" items="<%=ServiceUtil.getCompanyCountList()%>">
		{
            name: '${obj.companyName}',
            value:${obj.companyId},
            info: {
              name: '${obj.companyName}',
              dataElement: ${obj.companyId},
              informationResource: ${obj.groupId}
            },
            tooltip: { // Series config.
              trigger: 'item',
              backgroundColor: 'black',
              formatter: function(params, ticket, callback) {
                return pars(params, ticket, callback);
              }
            },
          },

      	  </c:forEach>       
               
        ]
      },
      geoCoord: {
    	  <c:forEach var="obj" items="<%=ServiceUtil.getCompanyCountList()%>">
 	      "${obj.companyName}":[${obj.lng}, ${obj.lat}],
 	     </c:forEach>
      }
    }]
  };

  myChart.setOption(option);

  function pars(params, ticket, callback) {
    var content = params.name  + '<br>数据元数量: ' +
      params.data.info.dataElement + '<br>信息资源数量: ' + params.data.info.informationResource
    return content;
  }
    </script>
</body>
</html>