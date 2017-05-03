<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="java.util.Random" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
int w=String.valueOf(ServiceUtil.getDicByDicNum("ZYTGF").size()).length();
int x=String.valueOf(ServiceUtil.getService("DataElementService").count(ServiceUtil.buildBean("DataElement@isDeleted=0&classType=0"))).length();
int y=String.valueOf(ServiceUtil.getService("InformationResService").count(ServiceUtil.buildBean("InformationRes@isDeleted=0"))).length();
pageContext.setAttribute("radm", (int)Math.pow(10,w));
pageContext.setAttribute("radm1", (int)Math.pow(10,x));
pageContext.setAttribute("radm2", (int)Math.pow(10,y));
%>
<!DOCTYPE html >
<html lang="en">

<head>
  <%@include file="../common/includeBaseLinkHead.jsp"%>
</head>
<style>
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
  <div class="tabsNav" id="tabsNav2">
    <div class="tabs-container">
      <div class="item col-sm-7">
        <div class="row">
          <div class="col-sm-12">
            <h3 class="title">模板数量</h3>
            <div class="ibox float-e-margins">
              <div class="ibox-content echarts-name">
                <div class="echarts" id="main1"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="item col-sm-5">
        <div class="row">
          <div class="col-sm-12">
            <h3 class="title">模板种类</h3>
            <div class="ibox float-e-margins">
              <div class="ibox-content">
                <div class="echarts" id="main4"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="item col-sm-5">
        <div class="row">
          <div class="col-sm-12">
            <h3 class="title">数据元情况</h3>
            <div class="ibox float-e-margins">
              <div class="ibox-content">
                <div class="echarts" id="main2"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="item col-sm-7">
        <div class="row">
          <div class="col-sm-12">
            <h3 class="title">模板排行</h3>
            <div class="ibox float-e-margins">
              <div class="ibox-content echarts-name">
                <div class="echarts" id="main5"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="item col-sm-12">
        <div class="row">
          <div class="col-sm-12">
            <h3 class="title">基础库目录情况</h3>
            <div class="ibox float-e-margins">
              <div class="ibox-content">
                <div class="echarts" id="main3"></div>
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
<script src="${base}/static/js/plugins/echarts/echarts-all.js"></script>

<script>
var color = <%=ServiceUtil.getEchartColor(10) %>;
var myChart1 = echarts.init(document.getElementById('main1'));
var myChart2 = echarts.init(document.getElementById('main2'));
var myChart3 = echarts.init(document.getElementById('main3'));
var myChart4 = echarts.init(document.getElementById('main4'));
var myChart5 = echarts.init(document.getElementById('main5'));

var option1 = {
    tooltip : {
        formatter: "{a} <br/>{c} {b}"
    },
    toolbox: {
        show : true,
        feature : {
            restore : {show: true},
            saveAsImage : {show: true}
        }
    },
    series : [
        {
            name:'数据元模板数量',
            type:'gauge',
            z: 3,
            min:0,
            max:<%=(Integer)pageContext.getAttribute("radm1")%>,
            radius : '100%',
            splitNumber:10,
            axisLine: {            // 坐标轴线
                lineStyle: {       // 属性lineStyle控制线条样式
                    width: 10,
                    color: [[1, color[0]],[1, color[1]],[1, color[2]]]
                }
            },
            axisTick: {            // 坐标轴小标记
                length :15,        // 属性length控制线长
                lineStyle: {       // 属性lineStyle控制线条样式
                    color: 'auto'
                }
            },
            splitLine: {           // 分隔线
                length :20,         // 属性length控制线长
                lineStyle: {       // 属性lineStyle（详见lineStyle）控制线条样式
                    color: 'auto'
                }
            },
            title : {
                textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                    fontWeight: 'bolder',
                    fontSize: 20,
                    fontStyle: 'italic'
                }
            },
            detail : {
                textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                    fontWeight: 'bolder'
                }
            },
            data:[{value: <%=ServiceUtil.getService("DataElementService").count(ServiceUtil.buildBean("DataElement@isDeleted=0&classType=0"))%>, name: '个'}]
        },
        {
            name:'部门模板数量',
            type:'gauge',
            center : ['25%', '50%'],    // 默认全局居中
            radius : '75%',
            min:0,
            max:<%=(Integer)pageContext.getAttribute("radm")%>,
            splitNumber:10,
            axisLine: {            // 坐标轴线
                lineStyle: {       // 属性lineStyle控制线条样式
                    width: 8,
                    color: [[0.2, color[0]],[0.8, color[2]],[1, color[1]]]
                }
            },
            axisTick: {            // 坐标轴小标记
                length :12,        // 属性length控制线长
                lineStyle: {       // 属性lineStyle控制线条样式
                    color: 'auto'
                }
            },
            splitLine: {           // 分隔线
                length :20,         // 属性length控制线长
                lineStyle: {       // 属性lineStyle（详见lineStyle）控制线条样式
                    color: 'auto'
                }
            },
            pointer: {
                width:5
            },
            title : {
                offsetCenter: [0, '-30%'],       // x, y，单位px
            },
            detail : {
                textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                    fontWeight: 'bolder'
                }
            },
            data:[{value: <%=ServiceUtil.getDicByDicNum("ZYTGF").size()%>, name: '个'}]
        },
        {
            name:'信息资源模板数量',
            type:'gauge',
            center : ['75%', '50%'],    // 默认全局居中
            radius : '75%',
            min:0,
            max:<%=(Integer)pageContext.getAttribute("radm2")%>,
            splitNumber:10,
            axisLine: {            // 坐标轴线
                lineStyle: {       // 属性lineStyle控制线条样式
                    width: 8,
                    color: [[0.2, color[0]],[0.8, color[2]],[1, color[1]]]
                }
            },
            axisTick: {            // 坐标轴小标记
                length :12,        // 属性length控制线长
                lineStyle: {       // 属性lineStyle控制线条样式
                    color: 'auto'
                }
            },
            splitLine: {           // 分隔线
                length :20,         // 属性length控制线长
                lineStyle: {       // 属性lineStyle（详见lineStyle）控制线条样式
                    color: 'auto'
                }
            },
            pointer: {
                width:5
            },
            title : {
                offsetCenter: [0, '-30%'],       // x, y，单位px
            },
            detail : {
                textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                    fontWeight: 'bolder'
                }
            },
            data:[{value: <%=ServiceUtil.getService("InformationResService").count(ServiceUtil.buildBean("InformationRes"))%>, name: '个'}]
        }
    ]
};

var labelTop = {
normal : {
    label : {
        show : true,
        position : 'center',
        formatter : '{b}',
        textStyle: {
        baseline : 'bottom'
        }
    },
    labelLine : {
        show : false
    }
  }
};
var labelFromatter = {
normal : {
    label : {
      formatter : function (params){
          return 100 - params.value + '%'
      },
      textStyle: {
          baseline : 'top'
          }
      }
  },
}
var labelBottom = {
  normal : {
      color: '#ccc',
      label : {
      show : true,
      position : 'center'
      },
      labelLine : {
      show : false
      }
  },
  emphasis: {
      color: 'rgba(0,0,0,0)'
  }
};
var radius = [40, 55]; 
myChart1.setOption(option1);

//mychart2
$.getJSON('${base}/backstage/dataElement/echarts?classType=0', function (data) {
  var option2 = {
    color: color,
    tooltip: {
      trigger: 'item',
      formatter: "{a} <br/>{b} : {c} ({d}%)"
    },
    legend: {
        orient : 'vertical',
        x : 'left',
        data:data.legend
    }, 
    toolbox: {
      show: true,
      feature: {
        mark: { show: false },
        dataView: { show: true, readOnly: false },
        magicType: {
          show: true,
          type: ['pie', 'funnel'],
          option: {
            funnel: {
              x: '25%',
              width: '50%',
              funnelAlign: 'left',
              max: 1548
            }
          }
        },
        restore: { show: true },
        saveAsImage: { show: true }
      }
    },
    calculable: true,
    series: [{
      name: '访问来源',
      type: 'pie',
      radius: '55%',
      center: ['60%', '60%'],
      data: data.data
    }]
  };
  myChart2.setOption(option2);
});

//mychart3
$.getJSON('${base}/backstage/information/res/basicEcharts', function (data) {
	var sers =  [];
	var legend = [];
	 for(var i=0,l=data.length;i<l;i++){
		 var obj = {
		            type : 'pie',
		            center : ['10%', '50%'],
		            radius : radius,
		            itemStyle : labelFromatter,
		            data : [
		                {itemStyle : labelBottom},
		                {itemStyle : labelTop}
		            ]
		          };
		obj.center[0]=(10+i*(90/l))+'%';
		obj.data[0].name="other";
		obj.data[0].value=parseInt((1000-data[i].value*10)/10);
		obj.data[1].name=data[i].name;
		obj.data[1].value=parseInt(data[i].value);
		obj.x=i*(90/l)+'%';
		sers[i]=obj;
		legend.push(data[i].name);
	} 
    var option3 = {
      color: color,
      legend: {
        x : 'center',
        y : '10',
        data:legend
      },
    toolbox: {
      show : true,
      feature : {
        dataView : {show: true, readOnly: false},
        magicType : {
          show: true, 
          type: ['pie', 'funnel'],
          option: {
            funnel: {
              width: '20%',
              height: '30%',
              itemStyle : {
                normal : {
                  label : {
                    formatter : function (params){
                      return 'other\n' + params.value + '%\n'
                    },
                    textStyle: {
                      baseline : 'middle'
                    }
                  }
                },
              } 
            }
          }
        },
        restore : {show: true},
        saveAsImage : {show: true}
      }
    },
      series : sers
    };
    myChart3.setOption(option3);
});

//myChart4
$.getJSON('${base}/backstage/echart/muban', function (data) {
	function createRandomItemStyle(i) {
	    return {
	        normal: {
	            color: color[i]
	        }
	    };
	}
	var colorLength = color.length;
	
	var datar = [];
	for(var i=0,l=data.length;i<l;i++){
		var j = i === 0 ? 0 : i % colorLength;
		var obj = {itemStyle: createRandomItemStyle(j)};
		obj.name=data[i].name;
		obj.value=data[i].count;
		datar.push(obj);
	}
	var option = {	   
	    tooltip: {
	        show: true
	    },
	    series: [{
	        name: '模板分类',
	        type: 'wordCloud',
	        size: ['80%', '80%'],
	        textRotation : [0, 45, 90, -45],
	        textPadding: 5,
	        autoSize: {
	            enable: true,
	            minSize: 14
	        },
	        data: datar
	    }]
	};
	 myChart4.setOption(option);                  
});

//myChart5
$.getJSON('${base}/backstage/echart/mrank', function (data) {
	var yAxisarr = [];
	var idata = [];
	var ddata = [];
	for(var i=0,l=data.length;i<l;i++){
		yAxisarr.push(data[i].cname);
		idata.push(parseInt(data[i].icount));
		ddata.push(parseInt(data[i].dcount));
	}
	option = {
    color: color,
	  		tooltip : {
	        trigger: 'axis'
	    },
	    legend: {
	        data:['信息资源', '数据元']
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
	            data : yAxisarr
	        }
	    ],
	    series : [
	        {
	            name:'信息资源',
	            type:'bar',
	            data:idata
	        },
	        {
	            name:'数据元',
	            type:'bar',
	            data:ddata
	        }
	    ]
	};
	                    
	 myChart5.setOption(option);                  
});



</script>