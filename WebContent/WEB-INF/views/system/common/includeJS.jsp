<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="${base}/static/js/main.js"></script>
<!-- <script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
<script src="${base}/static/js/bootstrap.min.js?v=3.3.6"></script> -->
<!-- Bootstrap table -->
<!-- <script src="${base}/static/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
<script src="${base}/static/js/plugins/bootstrap-table/bootstrap-table-mobile.min.js"></script>
<script src="${base}/static/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script> -->
<!-- <script src="${base}/static/js/bootstrap-datetimepicker.min.js"></script>
<script src="${base}/static/js/bootstrap-datetimepicker.zh-CN.js"></script>   -->
<!-- layer javascript -->
<script src="${base}/static/js/plugins/layer/layer.js"></script>

<script type="text/javascript" src="${base}/static/js/easyui/plugin/jquery.easyui.min.js"></script>

<!-- jQuery Validation plugin javascript-->
<!-- <script src="${base}/static/js/plugins/validate/jquery.validate.min.js"></script>
<script src="${base}/static/js/plugins/validate/messages_zh.min.js"></script> -->
<!-- Chosen -->
<!-- <script src="${base}/static/js/plugins/chosen/chosen.jquery.js"></script> -->

<!-- iCheck -->
<!-- <script src="${base}/static/js/plugins/iCheck/icheck.min.js"></script> -->

<script>
$(function () {
  var header_html = '<header style=" padding: 20px 0px 0px 20px;font-size: 14px;color: #888;"><a onclick="parent.toIndex();" href="#">首页</a><c:forEach var="menu" items="<%=ServiceUtil.getURLPermisson(request)%>">>&nbsp;${menu.nodeName}&nbsp;</c:forEach></header>';



   layer.config({
     extend: '../extend/layer.ext.js'
   });

  $(document).ready(function() {
	 console.log("${theme}"); 
     <c:set  var="themeType"   value="${theme}"/>
          <c:if test="${themeType==1}">
          $('.i-checks').iCheck({
              checkboxClass: 'icheckbox_square-grey',
              radioClass: 'iradio_square-grey',
            }); 
          </c:if>
          <c:if test="${themeType==2}">
          $('.i-checks').iCheck({
              checkboxClass: 'icheckbox_square-grey',
              radioClass: 'iradio_square-grey',
            }); 
          </c:if>
          <c:if test="${themeType==3}">
		   $('.i-checks').iCheck({
		      checkboxClass: 'icheckbox_square-blue',
		      radioClass: 'iradio_square-blue',
		    }); 
	       </c:if>
          <c:if test="${themeType==4}">
		   $('.i-checks').iCheck({
		      checkboxClass: 'icheckbox_square-blue',
		      radioClass: 'iradio_square-blue',
		    }); 
	       </c:if>
	       <c:if test="${themeType==5}">
		   $('.i-checks').iCheck({
		      checkboxClass: 'icheckbox_square-red',
		      radioClass: 'iradio_square-red',
		    }); 
	       </c:if>
    <c:if test="<%=ServiceUtil.getURLPermisson(request)!=null&&ServiceUtil.getURLPermisson(request).size()>0%>">
    $("body.white-bg").prepend(header_html);
    </c:if>
  });
});
</script>