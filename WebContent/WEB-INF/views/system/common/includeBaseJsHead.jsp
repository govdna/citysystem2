<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
<script src="${base}/static/js/bootstrap.min.js?v=3.3.6"></script>
<script>
$(document).ready(function() {
  <c:if test="<%=ServiceUtil.getURLPermisson(request)!=null&&ServiceUtil.getURLPermisson(request).size()>0%>">
  $("body.white-bg").prepend(header_html);
  </c:if>
});

</script>