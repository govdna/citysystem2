<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseHead.jsp"%>
</head>
<style>
  ul,li {
    list-style: none;
  }
  .chosen-container{
  	width: 174px !important;
  }
</style>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
<div class="container">
    <div class="row">
    <div class="clearfix" style="margin:10px 0 0 10px;border-bottom: 1px solid #f6f6f6;">
    	    <label class="control-label  pull-left" style="line-height: 35px;margin-right:10px;">责任部门</label>
    	    <div class=" pull-left">
            <select name="cId" data-placeholder=" " class="chosen-select" style="width:350px; display:inline-block;" tabindex="4" required>
            <option value=""></option>
            <c:forEach var="obj" items="<%=ServiceUtil.getDicByDicNum(\"ZYTGF\") %>">
                  <option value="${obj.dicKey}">${obj.dicValue}</option>
                  </c:forEach>                  
          </select>
          </div>
		 <div class="btn-group pull-left" style="margin-left: 10px;">
         	<button type="button" class="btn btn-primary" onclick="compare();" style="border-right: rgba(255,255,255,.3);">搜索</button>
         </div>
         </div>
	    <div>
		   	<div class="panel-container col-xs-4">
		        <div class="panel panel-default  panel-item">
		          <div class="panel-heading text-center text-hidden"><%= new String(request.getParameter("cname").getBytes("iso8859-1"),"utf-8")%></div>
		          <div class="panel-body content">
		            <ul>
			            <li>
			                <p class="col-xs-8 text-right">数据元数量：</p> 
			                <p class="col-xs-4 text-left"><span><%=request.getParameter("dcount") %></span></p>
			            </li>
			            <li>
			                <p class="col-xs-8 text-right">信息资源数量：</p> 
			                <p class="col-xs-4 text-left"><span><%=request.getParameter("icount") %></span></p>
			            </li>  
		            </ul>
		          </div>
		        </div>
		      </div>
		      <div class="compare-group">
		      
		      </div>	    
	    </div>

  </div>
</div>  
</body>
</html>
<%@include file="../common/includeJS.jsp"%>
<script>
var mid = '';
var obj = $('.panel-container').clone(true);
var obj2 = $('.panel-container').clone(true);	
$("select[name='cId']").chosen({
	  disable_search_threshold: 10,
	  no_results_text: "没有匹配到这条记录",
	  search_contains: true,
	  width: "100%"
	});
$("select[name='cId']").on('change', function(e, params) {
	  mid = params.selected;
	});
	function compare(){	
		$.ajax({
            type: "GET",
            url: "${base}/backstage/echart/mCompare",
            data: {mid:mid,cid:<%=request.getParameter("cid") %>},
            dataType: "json",
            success: function(data){
            	console.log(mid);
	            obj = objformat(obj,data[0]);	
	    		$('.compare-group').html(obj);
	    		obj2 = objformat(obj2,data[1]);
	    		$('.compare-group').append(obj2);
	         }
        });
	}
	
	function objformat(obj,arr){
		obj.find('.panel-heading').html(arr.title);
		obj.find('span').eq(0).html(arr.sp1);
		obj.find('span').eq(1).html(arr.sp2);
		obj.find('.text-right').eq(0).html(arr.p1);
		obj.find('.text-right').eq(1).html(arr.p2);
		return obj;
	}
</script>
