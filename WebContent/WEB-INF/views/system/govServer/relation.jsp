<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseHead.jsp"%>
</head>
<style>
.form_datetime.input-group[class*=col-]{float: left;padding-right: 15px;padding-left: 15px;}
</style>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content animated fadeInRight">
      <div id="main4" class="form-horizontal" style="height:800px;"></div>
      <div id="hidden" style="display:none;">
      <div id="main3" class="form-horizontal" style="width:400px;height:400px;"></div>
      </div>
  </div>
</body>
</html>
<%@include file="../common/includeJS.jsp"%>
<script src="${base}/static/js/plugins/echarts/echarts-all.js"></script>
<script>
    $.getJSON("${base}/backstage/echart/seranalyse", function(data) {
      var myChart4 = echarts.init(document.getElementById('main4'));
      var option4 = {
    	        title: {
    	          // text: '人物关系：乔布斯',
    	          //subtext: '数据来自人立方',
    	          x: 'right',
    	          y: 'bottom'
    	        },
    	        tooltip: {
    	          trigger: 'item',
    	          formatter: '{a} : {b}'
    	        },
    	        toolbox: {
    	          show: true,
    	          feature: {
    	            restore: { show: true },
    	            magicType: { show: true, type: ['force', 'chord'] },
    	            saveAsImage: { show: true }
    	          }
    	        },
    	        legend: {
    	          x: 'left',
    	          data: ['部门','系统','库','表','字段']
    	        },
    	        series: [{
    	          type: 'force',
    	          name: "关系分析",
    	          ribbonType: false,
    	          categories: [{
    	            name: '部门'
    	          }, {
    	            name: '系统'
    	          },{
    	        	 name:'库' 
    	          },{
    	            name: '表'
    	          },{
    	            name: '字段'
    	          }],
    	          itemStyle: {
    	            normal: {
    	              label: {
    	                show: true,
    	                textStyle: {
    	                  color: '#333'
    	                }
    	              },
    	              nodeStyle: {
    	                brushType: 'both',
    	                borderColor: 'rgba(255,215,0,0.4)',
    	                borderWidth: 1
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
    	              nodeStyle: {
    	                //r: 30
    	              },
    	              linkStyle: {}
    	            }
    	          },
    	          useWorker: false,
    	          minRadius: 15,
    	          maxRadius: 25,
    	          gravity: 1.1,
    	          scaling: 1.5,
    	          roam: 'move',
    	          nodes: data.node,
    	          links: data.link
    	        }]
    	      };
      myChart4.setOption(option4);
      myChart4.on('click',  function eConsole(param) {
    	  console.info(param.data.category);
    	  if(param.data.category == 4){
    		  $.getJSON("${base}/backstage/echart/fieldrip?cid="+param.data.dataRange+"&mid="+param.data.name, function(data) {
        		  if(data.status!=0){
        			  var myChart3 = echarts.init(document.getElementById('main3'));
            	      var option3 = {
            	    	        title: {
            	    	          // text: '人物关系：乔布斯',
            	    	          //subtext: '数据来自人立方',
            	    	          x: 'right',
            	    	          y: 'bottom'
            	    	        },
            	    	        tooltip: {
            	    	          trigger: 'item',
            	    	          formatter: '{a} : {b}'
            	    	        },
            	    	        toolbox: {
            	    	          show: true,
            	    	          feature: {
            	    	            restore: { show: false },
            	    	            magicType: { show: false, type: ['force', 'chord'] },
            	    	            saveAsImage: { show: false }
            	    	          }
            	    	        },
            	    	        legend: {
            	    	          x: 'left',
            	    	          data: ['字段','关联字段']
            	    	        },
            	    	        series: [{
            	    	          type: 'force',
            	    	          name: "关系分析",
            	    	          ribbonType: false,
            	    	          categories: [{
            	    	            name: '字段'
            	    	          },{
            	    	            name: '关联字段'
            	    	          }],
            	    	          itemStyle: {
            	    	            normal: {
            	    	              label: {
            	    	                show: true,
            	    	                textStyle: {
            	    	                  color: '#333'
            	    	                }
            	    	              },
            	    	              nodeStyle: {
            	    	                brushType: 'both',
            	    	                borderColor: 'rgba(255,215,0,0.4)',
            	    	                borderWidth: 1
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
            	    	              nodeStyle: {
            	    	                //r: 30
            	    	              },
            	    	              linkStyle: {}
            	    	            }
            	    	          },
            	    	          useWorker: false,
            	    	          minRadius: 15,
            	    	          maxRadius: 25,
            	    	          gravity: 1.1,
            	    	          scaling: 1.5,
            	    	          roam: 'move',
            	    	          nodes: data.node,
            	    	          links: data.link
            	    	        }]
            	    	      };
            	      $('#hidden').show();
            	      myChart3.setOption(option3);
            	      layer.open({
        	    	      type: 1,
        	    	      shade: false,
        	    	      area: ['400px', '380px'], //宽高
        	    	      scrollbar: false,
        	    	      title: false, //不显示标题
        	    	      content: $('#main3'),
        	    	      cancel: function() {
        	    	          $("#hidden").hide();
        	    	        }
        	    	    });   
        		  }    	      
        	});  
    	  }    	  
      });
    });
  </script>