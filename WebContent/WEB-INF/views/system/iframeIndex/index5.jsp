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
      max: 1000,
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
      data: [{
        name: '海口市',
        value: 1000,

      }, {
        name: '万宁市',
        value: 950,

      }, {
        name: '澄迈县',
        value: 900,

      }, {
        name: '白沙黎族自治县',
        value: 850,

      }, {
        name: '琼海市',
        value: 800,

      }, {
        name: '昌江黎族自治县',
        value: 750,

      }, {
        name: '临高县',
        value: 700,

      }, {
        name: '陵水黎族自治县',
        value: 650,

      }, {
        name: '屯昌县',
        value: 600,

      }, {
        name: '定安县',
        value: 550,

      }, {
        name: '保亭黎族苗族自治县',
        value: 500,

      }, {
        name: '五指山市',
        value: 450,

      }, {
        name: '儋州市',
        value: 400,

      }, {
        name: '东方市',
        value: 550,

      }, {
        name: '乐东黎族自治县',
        value: 300,

      }, {
        name: '三亚市',
        value: 950,

      }, {
        name: '文昌市',
        value: 200,

      }, {
        name: '琼中黎族苗族自治县',
        value: 150,

      }],
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

          {
            name: "海口",
            value: 44,
            info: {
              name: '1414',
              dataElement: '222',
              informationResource: '555'
            },
            tooltip: { // Series config.
              trigger: 'item',
              backgroundColor: 'black',
              formatter: function(params, ticket, callback) {
                return pars(params, ticket, callback);
              }
            },
          },

          {
            name: "三亚",
            value: 54,
            info: {
              name: '1515',
              dataElement: '111',
              informationResource: '333'
            },
            tooltip: { // Series config.
              trigger: 'item',
              backgroundColor: 'black',
              formatter: function(params, ticket, callback) {
                return pars(params, ticket, callback);
              }
            },
          },

        ]
      },
      geoCoord: {

        "海口": [110.35, 20.02],

        "三亚": [109.511909, 18.252847],

      }
    }]
  };

  myChart.setOption(option);

  function pars(params, ticket, callback) {
    var content = params.name + '<br>部门名称: ' + params.data.info.name + '<br>数据元数量: ' +
      params.data.info.dataElement + '<br>信息资源数量: ' + params.data.info.informationResource
    return content;
  }
    </script>
</body>
</html>