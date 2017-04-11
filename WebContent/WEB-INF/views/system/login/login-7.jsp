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
<!--[if lte IE 8]><script>window.location.href='http://cdn.dmeng.net/upgrade-your-browser.html?referrer='+location.href;</script><![endif]-->

<style>
body {color: #fff;background: #2c455c url(${base}/static/images/skin/skin-7-bg.png) no-repeat bottom center;font-family: 'Microsoft Yahei';}
a, a:focus, a:hover {text-decoration: none;}
.header {height: 80px;min-width: 997px;line-height: 80px;padding: 0 60px;border-bottom: 1px solid #fff;}
.header h1 {font-size: 24px;font-weight: 700;font-family: "SimHei";}
.header .header-right {font-size: 16px;font-family: 'SimHei';}
.header .header-right a{color: #d7d7d7;}
.header .header-right a:hover {color: #fff;}
.copyright {width: 100%;min-width: 997px;position: relative;top: 0px;text-align: center;line-height: 40px;height: 40px;}
.main-container {position: relative;min-width: 997px;height: calc(100vh - 120px);min-height: 500px;}
.main-container .login-left {text-align: center; margin-top: 180px;}
.main-container .login-left h2{font-size: 38px; font-weight: 700;}
.main-container .login-right input {background-color: transparent;border: none;border-bottom: 1px solid #fff;color: #fff;}
.main-container .login-right {padding: 0 50px;margin-top: 80px;}
.main-container .login-right .login-name {font-style: normal;}
.main-container .login-right .case-verify {width: 60%;}
.main-container .login-right .verify {width: 40%;position: relative;top: -6px;}
.main-container .login-right .form-group {position: relative;margin: 40px 0;}
.main-container .login-right .login-name {position: absolute;top: 7px;left: 12px;}
.main-container .login-right .btn-submit {border-radius: 34px;background-color: #00a3ab;border: none;color: #fff;}
.main-container .login-right .btn-submit:hover {background-color: #039198;}
.main-container .login-right .btn-submit:focus {outline: none;}
.main-container .login-right .download-chrome {margin-top: 10px;color: #d7d7d7;}
.main-container .login-right .download-chrome:hover {text-decoration: underline;}
.form-control:focus {box-shadow: none;}
@media (max-width: 997px) {
  .main-container .login-right {padding: 0;}
}
</style>
</head>
<body>
  <header class="header">
    <div class="container-fluid">
      <h1 class="pull-left">
        <img style="max-width: 45px;" src="${base}/static/images/header/logo-white.png">
        <span><%=ServiceUtil.getTitleBig(10)%></span>
      </h1>
      <div class="pull-right header-right">
        <a href="#">加入收藏</a>
        <a href="#">帮助中心</a>
      </div>
    </div>
  </header>
  <div class="main-container">
    <div class="container">
      <div class="login-container clearfix">
        <div class="login-left col-sm-6">
          <img src="${base}/static/images/header/logo-white.png" alt="logo" width="68">
          <h2><%=ServiceUtil.getTitleBig(10)%></h2>
        </div>
        <div class="login-right col-sm-6">
          <form id="loginForm" method="post">
            <div class="form-group user-case">
              <i class="login-name">用户名</i>
              <input class="form-control" type="text" id="accountNameId" name="accountName" required="required">
            </div>
            <div class="form-group lock-case">
              <i class="login-name">密码</i>
              <input class="form-control" type="password" id="passwordId" name="password" required="required" maxlength="16">
            </div>
            <div class="form-group verify-case clearfix">
              <i class="login-name">验证码</i>
              <input class="form-control case-verify pull-left" id="verifyCodeId" name="verifyCode" required="required" maxlength="4" type="tel" onkeyup="this.value=this.value.replace(/\D/g,'')">
              <img class="verify pull-right" id="vimg" style="cursor:pointer;" title="验证码" width="60" height="40" src="verifyCode/slogin.do?random=0.7304289337922849">
            </div>
            <button type="button" id="loginBtn" class="btn btn-default btn-submit btn-block">登 录</button>
            <a href="/CitySystem/upload/excel/ChromeStandalone_56.0.2924.87_Setup.exe" class="download-chrome pull-right">适配浏览器下载</a>
          </form>
        </div>
      </div>
    </div>
  </div>
  <footer class="copyright hidden-xs">Copyright © 2016  国脉海洋信息发展有限公司</footer>
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
     var input = $('.form-group input');
     setTimeout(function () {
      input.each(function () {
        liginNameInit($(this));
      });
     }, 500);
     $(window).resize(function (event) {
       autoLoginMarginTop($('.login-left'));
       autoLoginMarginTop($('.login-right'));
     });
     input.on('focus', function () {
       var $this = $(this),
           name = $(this).prev();

       loginNameFocus($this)
     }).on('blur', function () {
       var $this = $(this),
           name = $(this).prev();

       loginNameBlur($this);
     });

   });
   function liginNameInit (input) {
     var name = input.prev(),
         inputVal = $.trim(input.val());
      console.log(inputVal);
     if (inputVal !== '') {
       name.css({
         top: '-21px'
       });
     }
   }
   //登录注册文字效果
   function loginNameFocus (input) {
     var name = input.prev(),
         inputVal = $.trim(input.val());

       name.animate({
         top: '-21px'}
       , 200);
   }
   function loginNameBlur (input) {
     var name = input.prev(),
         inputVal = $.trim(input.val());
     if (inputVal === '') {
       name.animate({
         top: '7px'}
       , 200);
     }
   }

   function autoLoginMarginTop (container) {
     var containerHeight = container.height(),
         mainContainerHeight = $('.main-container').height()
         height = (mainContainerHeight - containerHeight) / 2;

     container.css('marginTop', height)
   }
 </script>

<%@include file="../common/dialog.jsp" %>
</body>
</html>