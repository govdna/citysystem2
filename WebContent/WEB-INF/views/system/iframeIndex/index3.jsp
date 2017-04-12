<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
pageContext.setAttribute("jsa", ServiceUtil.getService("CompanyService").find(ServiceUtil.buildBean("Company@isDeleted=0")));
%>
<!DOCTYPE html >
<html lang="en">

<head>
<%@include file="../common/includeBaseLinkHead.jsp"%>
<link rel="stylesheet" href="${base}/static/js/bootstrap-select/css/bootstrap-select.min.css">
</head>
<style>
.bootstrap-select.btn-group .dropdown-menu.inner {max-width: 300px;}
  .tabsNav .item .title {
    margin: 0;
    padding: 15px 0 15px 10px;
    background-color: #fff;
}
.wrapper {
    padding: 0 20px;
}
.ibox {
    clear: both;
    margin-bottom: 25px;
    margin-top: 0;
    padding: 0;
}
.ibox-content {
    background-color: #ffffff;
    color: inherit;
    padding: 15px 20px 20px 20px;
    border-color: #e7eaec;
    -webkit-border-image: none;
    -o-border-image: none;
    border-image: none;
    border-style: solid solid none;
    border-width: 1px 0px;
        clear: both;
}
.echarts {
    height: 240px;
}
h3 {font-size: 16px; font-weight: 600;}
</style>
<body class="skin-<%=ServiceUtil.getThemeType(10)%>">
<div class="wrapper animated fadeInRight">
  <!-- <h2 class="canvas-title">资源排行榜</h2> -->
		<div class="tabsNav">
      <div class="tabs-container">
        <div class="item col-sm-12">
    	    <div class="row">
    	        <div class="col-sm-12">
                <h3 class="title">排行榜</h3>
                <div class="pull-right multiselect">
                    <select id="testSelect" class="selectpicker"  multiple data-hide-disabled="true" data-size="5">
                      <c:forEach items="${jsa}" var="company" >
                      <option value="${company.id}">${company.companyName}</option>
                      </c:forEach>
                    </select>
                    <button class="btn btn-default firstSubmit" type="button">提交</button>
                </div>
    	            <div class="ibox float-e-margins">
    	                <div class="ibox-content">
    	                    <div class="echarts" id="main1"></div>
    	                </div>
    	            </div>
    	        </div>
    	    </div>
        </div>
        <div class="item col-sm-6">
    	    <div class="row">
    	        <div class="col-sm-12">
                <h3 class="title">热门信息资源</h3>
    	            <div class="ibox float-e-margins">
    	                <div class="ibox-content">
    	                    <div class="echarts" id="main2"></div>
    	                </div>
    	            </div>
    	        </div>
    	    </div>
        </div>
        <div class="item col-sm-6">
    	    <div class="row">
    	        <div class="col-sm-12">
                <h3 class="title">常用数据元</h3>
    	            <div class="ibox float-e-margins">
    	                <div class="ibox-content">
    	                    <div class="echarts" id="main3"></div>
    	                </div>
    	            </div>
    	        </div>
    	    </div>
        </div>
        <div class="item col-sm-12">
    	    <div class="row">
    	        <div class="col-sm-12">
                <div class="clearfix">
                	<h3 class="title pull-left">部门对比</h3>
                  <div class="pull-right multiselect">
                    <select class="selectpicker"  multiple data-hide-disabled="true" data-size="5">
                      <option>Mustard</option>
                      <option>Ketchup</option>
                      <option>Relish</option>
                      <option>Mustard1</option>
                      <option>Ketchup1</option>
                      <option>Relish1</option>
                    </select>
                    <button class="btn btn-default" type="button">提交</button>
                </div>
    	            <div class="ibox float-e-margins">
    	                <div class="ibox-content">
    	                    <div class="echarts" id="main4"></div>
    	                </div>
    	            </div>
    	        </div>
    	    </div>
        </div>
      </div>
    </div>
</div>

</body>
</html>
<script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
<script src="${base}/static/js/bootstrap.min.js?v=3.3.6"></script>
<script src="${base}/static/js/plugins/echarts/echarts-all.js"></script>
<script src="${base}/static/js/bootstrap-select/js/bootstrap-select.min.js"></script>
<script src="${base}/static/js/bootstrap-select/js/i18n/defaults-zh_CN.min.js"></script>
<script>
 $('.selectpicker').selectpicker({
    maxOptions: 5
  });
 $('.firstSubmit').click(function(){
  var arr = [];
	 $(this).prev().find('option').each(function(index, value) {
    if ($(this).prop('selected')) {
      arr.push($(this).val());
    }
	 });
   console.log(arr);
 });
</script>
<script>
  var myChart1 = echarts.init(document.getElementById('main1'));
  var myChart2 = echarts.init(document.getElementById('main2'));  
  var myChart3 = echarts.init(document.getElementById('main3'));
	var option1,option2,option3;
	$.getJSON('${base}/backstage/echart/dataInfor', function(data){
		var option = {
			    
			    tooltip : {
			        trigger: 'axis'
			    },
			    legend: {
			        data:['数据元数量', '信息资源数量','共享信息资源','开放信息资源']
			    },
			    toolbox: {
			        show : true,
			        feature : {
			            dataView : {show: true, readOnly: false},
			            magicType: {show: true, type: ['line', 'bar']},
			            restore : {show: true},
			            saveAsImage : {show: true}
			        }
			    },
			    calculable : true,
			    xAxis : [
			        {
			            type : 'value',
			            boundaryGap : [0, 0.01]
			        }
			    ],
			    yAxis : [
			        {
			            type : 'category',
			            data : data.legend
			        }
			    ],
			    series : [
			        {
			            name:'数据元数量',
			            type:'bar',
			            data:data.data
			        },
			        {
			            name:'信息资源数量',
			            type:'bar',
			            data:data.infor
			        },
			        {
			            name:'共享信息资源',
			            type:'bar',
			            data:data.open
			        },
			        {
			            name:'开放信息资源',
			            type:'bar',
			            data:data.share
			        }
			    ]
			};
   		myChart1.setOption(option);
    });
	$.getJSON('${base}/backstage/echart/hotData', function(data){
		function createRandomItemStyle() {
		    return {
		        normal: {
		            color: 'rgb(' + [
		                Math.round(Math.random() * 160),
		                Math.round(Math.random() * 160),
		                Math.round(Math.random() * 160)
		            ].join(',') + ')'
		        }
		    };
		}
		for(var i=0,l=data.length;i<l;i++){
			data[i].itemStyle=createRandomItemStyle();
		}
		option3 = {
		    
		    tooltip: {
		        show: true
		    },
		    series: [{
		        name: '常用数据元',
		        type: 'wordCloud',
		        size: ['80%', '80%'],
		        textRotation : [0, 45, 90, -45],
		        textPadding: 10,
		        autoSize: {
		            enable: true,
		            minSize: 14
		        },
		        data: data
		    }]
		};
          myChart3.setOption(option3);        
    });
	$.getJSON('${base}/backstage/echart/hotres', function(data){
		function createRandomItemStyle() {
		    return {
		        normal: {
		            color: 'rgb(' + [
		                Math.round(Math.random() * 160),
		                Math.round(Math.random() * 160),
		                Math.round(Math.random() * 160)
		            ].join(',') + ')'
		        }
		    };
		}
		var datar = [];		
		for(var i=0,l=data.legend.length;i<l;i++){
			var obj = {itemStyle: createRandomItemStyle()};
			obj.name=data.legend[i];
			obj.value=data.data[i];
			datar.push(obj);
		}
		option2 = {
		   
		    tooltip: {
		        show: true
		    },
		    series: [{
		        name: '热门信息资源',
		        type: 'wordCloud',
		        size: ['80%', '80%'],
		        textRotation : [0, 45, 90, -45],
		        textPadding: 10,
		        autoSize: {
		            enable: true,
		            minSize: 14
		        },
		        data: datar
		    }]
		};
        myChart2.setOption(option2);          
	});
	$.getJSON("${base}/backstage/echart/unions",function(data){
	    var keyCity = data.keyCity;
	    var xpoint = data.xpoint;
	    var sdata = data.sdata;
	  var option = {
	   
	    tooltip: {
	      trigger: 'axis',
	      formatter: function (v) {
	        var res = v[0][1] + '<br/>';
	        if (v.length < 5) {
	          for (var i = 0, l = v.length; i < l; i++) {
	            res += v[i][0] + ' : ' + v[i][2] + '<br/>';
	          }
	        } else {
	          for (var i = 0, l = v.length; i < l; i++) {
	            res += v[i][0] + ' : ' + v[i][2] + ((i + 1) % 3 == 0 ? '<br/>' : ' ');
	          }
	        }
	        return res;
	      }
	    },
	    legend: {
	      data: keyCity
	    },
	    toolbox: {
	      show: true,
	      orient: 'vertical',
	      x: 'right',
	      y: 'center',
	      feature: {
	        mark: { show: true },
	        dataView: { show: true, readOnly: false },
	        magicType: { show: true, type: ['line', 'bar'] },
	        restore: { show: true },
	        saveAsImage: { show: true }
	      }
	    },
	    grid: {
	      x: 50,
	      y: 80,
	      x2: '32%',
	      borderWidth: 0
	    },
	    xAxis: [{
	      type: 'category',
	      splitLine: { show: false },
	      data: xpoint
	    }],
	    yAxis: [{
	      type: 'value',
	      splitArea: { show: true },
	      splitLine: { show: true }
	    }],
	    polar: [{
		  indicator: [],
	      center: ['84%', 120],
	      radius: 120
	    }]
	  };
	  for (var i=0,l=xpoint.length;i<l;i++){
		var unit = {};
		unit.text=xpoint[i];
		option.polar[0].indicator.push(unit);
		}	
		
		

	  var selected = {};
	  var series = [{
	    name: '对比',
	    type: 'radar',
	    tooltip: {
	      trigger: 'axis',
	      formatter: function (v) {
	        var res = v[0][3] + '<br/>';
	        if (v.length < 5) {
	          for (var i = 0, l = v.length; i < l; i++) {
	            res += v[i][1] + ' : ' + v[i][2] + '<br/>';
	          }
	        } else {
	          for (var i = 0, l = v.length; i < l; i++) {
	            res += v[i][1] + ' : ' + v[i][2] + ((i + 1) % 3 == 0 ? '<br/>' : ' ');
	          }
	        }
	        return res;
	      }
	    },
	    itemStyle: {
	      normal: {
	        lineStyle: {
	          width: 1
	        }
	      }
	    },
	    data: sdata

	  }];
	   for (var i=0,l=sdata.length;i<l;i++){
		var unit = {
	    barCategoryGap: "10%",
	    barGap: "5%",
	    type: "bar"
	  };
	  unit.data = sdata[i].value;
	  unit.name = sdata[i].name;
		series.push(unit);
		}
	  option.series = series;
	  var myChart4 = echarts.init(document.getElementById('main4'));
		myChart4.setOption(option);
		});
	


</script>