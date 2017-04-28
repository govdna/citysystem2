<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="java.util.Random" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>

<c:choose>
<c:when test="${MyFunction:getMaxScope(\"/backstage/information/resource/index\")==1}">
<c:set var="cpid" value="<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>" />
</c:when>
<c:otherwise>
<c:set var="cpid" value="" />
</c:otherwise>
</c:choose> 
<c:set var="cpid" value="<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>" />
<%
int c = ServiceUtil.getService("GovTableService").count(ServiceUtil.buildBean("GovTable@isDeleted=0&companyId="+pageContext.getAttribute("cpid")));
int c1 = ServiceUtil.getService("GovApplicationSystemService").count(ServiceUtil.buildBean("GovApplicationSystem@isDeleted=0&value3="+pageContext.getAttribute("cpid")));
int c2 = ServiceUtil.getService("GovTableFieldService").count(ServiceUtil.buildBean("GovTableField@isDeleted=0&companyId="+pageContext.getAttribute("cpid")));
int c3 =ServiceUtil.getService("InformationResourceService").count(ServiceUtil.buildBean("InformationResource@status=0&isDeleted=0&companyId="+pageContext.getAttribute("cpid")));
int c4 =ServiceUtil.getService("DataElementService").count(ServiceUtil.buildBean("DataElement@classType=1&isDeleted=0&value8="+pageContext.getAttribute("cpid")));
int s =String.valueOf(c).length();
int s1 = String.valueOf(c1).length(); 
int s2 = String.valueOf(c2).length();  
pageContext.setAttribute("radm",  (int)Math.pow(10,s));
pageContext.setAttribute("radm1",  (int)Math.pow(10,s1));
pageContext.setAttribute("radm2", (int)Math.pow(10,s2));
pageContext.setAttribute("s",  c);
pageContext.setAttribute("s1",  c1);
pageContext.setAttribute("s2", c2);
pageContext.setAttribute("s3",  c3);
pageContext.setAttribute("s4", c4);
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
      <div class="item col-sm-12">
        <div class="row">
          <div class="box-wrapper-c clearfix" style="margin-top:10px;">
            <div class="small-box">
             <a href="${base}/backstage/govApplicationSystem/index?value3=<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>">
              <div class="icon pull-left text-center"><i class="fa fa-window-restore"></i></div>
              <div class="content pull-left">
                <p class="name ">系统</p>
                <p class="number">${s1}</p>
              </div>
              </a>
            </div>
            <div class="small-box">
             <a href="${base}/backstage/govTable/index?companyId=<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>">
              <div class="icon pull-left text-center"><i class="fa fa-table"></i></div>
              <div class="content pull-left">
                <p class="name ">数据表</p>
                <p class="number">${s}</p>
              </div>
              </a>
            </div>
            <div class="small-box">
            <a href="${base}/backstage/govTableField/index?companyId=<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>">
              <div class="icon pull-left text-center"><i class="fa fa-file-text"></i></div>           
              <div class="content pull-left">
                <p class="name ">数据字段</p>
                <p class="number">${s2}</p>
              </div>
              </a>
            </div>
            <div class="small-box">
            <a href="${base}/backstage/information/resource/index?companyId=<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>">
              <div class="icon pull-left text-center"><i class="fa fa-list-alt"></i></div>
              <div class="content pull-left">
                <p class="name ">信息资源</p>
                <p class="number">${s3}</p>
              </div>
              </a>
            </div>
            <div class="small-box">
             <a href="${base}/backstage/govRdataElement/index?value8=<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>">
              <div class="icon pull-left text-center"><i class="fa fa-database"></i></div>
              <div class="content pull-left">
                <p class="name ">数据元</p>
                <p class="number">${s4}</p>
              </div>
              </a>
            </div>
          </div>
        </div>
      </div>
      <div class="item col-sm-12">
        <div class="row">
          <div class="col-sm-12">
            <h3 class="title">资源关系图</h3>
            <div class="ibox float-e-margins">
              <div class="ibox-content">
                <div class="echarts" id="main2" style="height: 450px;"></div>
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
<script src="${base}/static/js/echartsSkin.js"></script>
<script>
$(function() {
var color = <%=ServiceUtil.getEchartColor(10) %>
var myChart2 = echarts.init(document.getElementById('main2'));
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
              return (1000 - 10*params.value)/10 + '%'
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
  var placeHoledStyle = {
    normal:{
      barBorderColor:'rgba(0,0,0,0)',
      color:'rgba(0,0,0,0)'
    },
    emphasis:{
      barBorderColor:'rgba(0,0,0,0)',
      color:'rgba(0,0,0,0)'
    }
  };
  var dataStyle = { 
    normal: {
      label : {
        show: true,
        position: 'insideLeft',
        formatter: '{c}%'
      }
    }
  };
$.getJSON('${base}/backstage/echart/systree?companyId=<%=AccountShiroUtil.getCurrentUser().getCompanyId()%>', function(data){
	  var option = {
			    toolbox: {
			        show : true,
			        feature : {
			            restore : {show: false},
			            saveAsImage : {show: false}
			        }
			    },
			    series : [
			        {
			            name:'树图',
			            type:'tree',
			            orient: 'horizontal',  // vertical horizontal
			            rootLocation: {x: 30,y: 'center'}, // 根节点位置  {x: 100, y: 'center'}
			            nodePadding: 8,
			            layerPadding: 200,
			            hoverable: false,
			            roam: true,
			            symbolSize: 10,
			            itemStyle: {
			                normal: {
			                    color: color[0],
			                    label: {
			                        show: true,
			                        position: 'right',
			                        formatter: "{b}",
			                        textStyle: {
			                            color: '#000',
			                            fontSize: 10
			                        }
			                    },
			                    lineStyle: {
			                        color: '#ccc',
			                        type: 'curve' // 'curve'|'broken'|'solid'|'dotted'|'dashed'

			                    }
			                },
			                emphasis: {
			                    color: '#4883b4',
			                    label: {
			                        show: false
			                    },
			                    borderWidth: 0
			                }
			            },
			            
			            data: [data]
			        }
			    ]
			};
			                    
	          myChart2.setOption(option);
  });

 
});

</script>
