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
  #allmap {
    width: 100%;
    height: calc(100vh - 70px);
    overflow: hidden;
    margin: 0;
    font-family: "微软雅黑";
  }
</style>
<body class="skin-<%=ServiceUtil.getThemeType(10)%>">
	<div class="wrapper wrapper-content animated fadeInRight">
	    <div class="row">
	        <div class="col-sm-12">
	            <div class="ibox float-e-margins">
	                <div class="ibox-title">
	                    <h5>分布地图展现</h5>
	                </div>
	                <div class="ibox-content" style="padding: 5px;">
	                    <div id="allmap"></div>
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
  <script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
	<script src="${base}/static/js/plugins/echarts/echarts-all.js"></script>
  <script src="${base}/static/js/plugins/layer/layer.js"></script>
  <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=oZcrHfndGQ44Bj0ERaAlnnuGkKl8pg2B"></script>
	<script>
	// 百度地图API功能
	var map = new BMap.Map("allmap");
	map.centerAndZoom(new BMap.Point(109.900923, 19.175807), 9);
	//map.disableDragging();
	setTimeout(function() {
	  map.setZoom(9);
	}, 2000); 
	map.enableScrollWheelZoom(true);

	// 信息窗口部分
	var opts = opts = {
	      width : 250,     // 信息窗口宽度
	      height: 80,     // 信息窗口高度
	      title : "" , // 信息窗口标题
	      enableMessage:true//设置允许信息窗发送短息
	       };
	function addClickHandler(content,marker){
	    marker.addEventListener("click",function(e){
	      openInfo(content,e)}
	    );
	  }
	  function openInfo(content,e){
	    var p = e.target;
	    var point = new BMap.Point(p.getPosition().lng, p.getPosition().lat);
	    var infoWindow = new BMap.InfoWindow(content,opts);  // 创建信息窗口对象 
	    map.openInfoWindow(infoWindow,point); //开启信息窗口
	  } 
	  var infos = [

	     <c:forEach var="obj" items="<%=ServiceUtil.getCompanyCountList()%>">
	     [${obj.lng}, ${obj.lat}, {name: '${obj.companyName}', dataElement: ${obj.companyId}, informationResource: ${obj.groupId}}],
	   	    
	     </c:forEach>
     	  ];

	  var data_info = [];
	  
	  $.each(infos, function(index, value) {
  	  var info = [];

      var data =  value[2].name + '<br>' + '数据元数量:' + value[2].dataElement + '<br>' + '信息资源数量:' + value[2].informationResource

  		info.push(value[0],value[1], data);
		  data_info.push(info);
	  });
	  
	    for(var i=0;i<data_info.length;i++){
	      var marker = new BMap.Marker(new BMap.Point(data_info[i][0],data_info[i][1]));  // 创建标注
	      var content = data_info[i][2];
	      map.addOverlay(marker);               // 将标注添加到地图中
	      addClickHandler(content,marker);
	    }
	 


	  
    </script>
</body>
</html>