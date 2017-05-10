<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>

<!DOCTYPE html>
<html lang="en">
<head>
<title><%=ServiceUtil.getTitleSmall(10)%></title>
<c:set var="base" value="${pageContext.request.contextPath}"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0"/>

<link rel="shortcut icon" href="${base}/favicon.ico">
<link href="${base}/static/fonts/Font-Awesome/css/font-awesome.min.css" rel="stylesheet">
 <link href="${base}/static/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
<!-- <link rel="stylesheet" href="${base}/static/css/system/system/login.css" /> -->
<link href="${base}/static/css/index.css" rel="stylesheet">
<!--[if lte IE 8]><script>window.location.href='http://cdn.dmeng.net/upgrade-your-browser.html?referrer='+location.href;</script><![endif]-->
<style>
a, a:focus, a:hover {text-decoration: none;}
.header {height: 80px;min-width: 997px;line-height: 80px;padding: 0 60px;}
.header h1 {font-size: 24px;font-weight: 700;font-family: "SimHei";}
.header .header-right {font-size: 16px;font-family: 'SimHei';}
.header .header-right a{color: #666;}
.header .header-right a:hover {color: #999;}
.copyright {position: relative;top: 0px;text-align: center;color: #333;line-height: 40px;}
.main-container {min-width: 997px;height: calc(100vh - 120px);min-height: 500px;background:url(${base}/static/images/index/bg3.jpg);-webkit-background-size: 100%;background-size: 100%;}
.main-container .login-container {float:right;margin-top: 48px; margin-right: 45px;width: 450px;border: 10px solid #e9edf1;background-color: #fff;box-shadow: 0px 0px 30px -2px rgba(0, 0, 0, .15);padding: 8px 40px 10px;}
.main-container h3{margin-bottom: 20px;padding-bottom: 20px;border-bottom: 1px solid #d7d7d7;color: #333;font-weight: 700;}
.main-container .input-wrapper input{text-indent: 5em;height: 45px;border-radius: 0}
.main-container .form-group{position: relative;margin-bottom: 25px;}
.main-container .form-control:focus {border-color: rgba(13, 91, 172, 0.84);box-shadow: inset 0 1px 1px rgba(0,0,0,.075), 0 0 1px rgba(102,175,233,.6);}
.main-container .verify-case input{width: 60%;}
.main-container .verify-case img {width: 40%;}
.main-container .form-group:before {position: absolute;top: 8px;left: 15px;height: 30px;width: 50px;line-height: 30px;border-right: 1px solid #0d5bac;z-index: 10000;color: #0d5bac}
.main-container .input-wrapper .user-case:before{content: "账号";}
.main-container .input-wrapper .lock-case:before{content: "密码";}
.main-container .input-wrapper .verify-case:before{content: "验证码";}
.main-container .btn-submit {background: #0d5bac;padding: 7px 0;border-width: 0;font-size: 18px;color: #fff;}
.main-container .btn-submit:hover {background: rgba(13, 91, 172, 0.8);}
.download-chrome {color: #666; margin-top: 10px;font-size: 12px;}
.download-chrome:hover {color: #333;text-decoration: underline;}
</style>
</head>
<body id="body-bg" style="height: 99.5vh;">
  <header class="header">
    <div class="container-fluid">
      <h1 class="pull-left">
        <img src="${base}<%=ServiceUtil.getLogoBig(10) %>" width="45">
        <span> <%=ServiceUtil.getTitleBig(10)%></span>
      </h1>
      <div class="pull-right header-right">
        <a href="#">加入收藏</a>
        <a href="#">帮助中心</a>
      </div>
    </div>
  </header>
  <div class="main-container">
    <div class=" container-fluid">
      <div class="login-container clearfix input-wrapper">
        <h3>账号登录</h3>
        <form id="loginForm" method="post">
          <div class="form-group user-case">
            <input class="form-control" type="text" id="accountNameId" name="accountName" required="required" placeholder="请输入用户名">
          </div>
          <div class="form-group lock-case">
            <input class="form-control" type="password" id="passwordId" name="password" required="required" maxlength="16" placeholder="请输入密码">
          </div>
          <div class="form-group verify-case clearfix">
              <input class="form-control case-verify pull-left" id="verifyCodeId" name="verifyCode" required="required" maxlength="4" type="tel" placeholder="请输入验证码" onkeyup="this.value=this.value.replace(/\D/g,'')">
              <img class="verify pull-right" id="vimg" style="cursor:pointer;" title="验证码" width="60" height="34" src="verifyCode/slogin.do?random=0.7304289337922849">
          </div>
          <button type="button" id="loginBtn" class="btn btn-default btn-submit btn-block">登 录</button>
          <a href="${base}/upload/excel/ChromeStandalone_56.0.2924.87_Setup.exe" class="download-chrome pull-right">适配浏览器下载</a>
        </form>
      </div>
    </div>
  </div>
  <footer class="copyright hidden-xs">Copyright © 2016  北京国脉互联信息顾问有限公司</footer>
    <!-- /signup-box -->
<script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
<script src="${base}/static/js/jquery/jquery.md5.js"></script>
<script src="${base}/static/js/plugins/layer/layer.js"></script>
<script>
  var base = '${base}';
  function toIndex(){
    location.href=base+'/backstage/index';
  }
  layer.config({
	     extend: '../extend/layer.ext.js'
	   });
</script>
<script src="${base}/static/js/system/login/login.js"></script>
 <script>
    $(function() {
      autoVertaical();
    
      $(window).resize(function() {
        autoVertaical();
      });
    });
    
    function autoVertaical () {
      var login = $('.login-container'),
          loginHeight = login.outerHeight(),
          mainHeight = $('.main-container').height(),
          height = (mainHeight - loginHeight) / 2;
      // console.log('mainHeight='+mainHeight+";loginHeight="+loginHeight+ ';height='+height);
      login.css('marginTop', height)
    }
  </script>

<%@include file="../common/dialog.jsp" %>
</body>
</html>