<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<meta name="renderer" content="webkit">

<title><%=ServiceUtil.getTitleSmall(10)%></title>

<c:set var="base" value="${pageContext.request.contextPath}"/>
<script>
  var base = '${base}';
  function toIndex(){
    location.href=base+'/backstage/index';
  }
</script>

 <link href="${base}/static/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
 <link href="${base}/static/fonts/Font-Awesome/css/font-awesome.min.css" rel="stylesheet">
<link href="${base}/static/css/style.css?v=4.1.0" rel="stylesheet">
<link rel="stylesheet" href="${base}/static/css/skin/skin-<%=ServiceUtil.getThemeType(10)%>.css">
<!--[if lte IE 8]><script>window.location.href='http://cdn.dmeng.net/upgrade-your-browser.html?referrer='+location.href;</script><![endif]-->
