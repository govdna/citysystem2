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
body {background: url(${base}/static/images/skin/skin-8-bg.jpg) no-repeat; -webkit-background-size: cover;
background-size: cover; color: #fff;}
a, a:focus, a:hover {text-decoration: none;}
.header {height: 80px;min-width: 997px;padding: 0 60px;background-image: radial-gradient(rgba(255, 255, 255, .3) 72%, transparent 0);background-position: 0px -100px;-webkit-background-size: 100% 225%;
background-size: 100% 225%;}
.header h1 {font-size: 24px;font-weight: 700;font-family: "SimHei";margin-top: 15px;}
.header .header-right {font-size: 16px;font-family: 'SimHei';margin-top: 15px;}
.header .header-right a {color: #d7d7d7;}
.header .header-right a:hover {color: #f6f6f6;}
.copyright {width: 100%;min-width: 997px;position: relative;top: 0px;text-align: center;color: #d7d7d7;line-height: 40px;height: 40px;}
.main-container {position: relative;min-width: 997px;height: calc(100vh - 120px);min-height: 500px;}
.main {position: absolute;top: 0; left: 0; bottom: 0; right: 0;}
.main-container .login-container {position: absolute;left: 50%; margin-left: -225px; margin-top: 62px;}
.main-container {padding: 35px 30px;height: 325px;}
.main-container input {text-indent: 1em;border-radius: 0;height: 40px;border-radius: 5px;background-color: rgba(255, 255, 255, .35); color: #fff;}
.main-container .form-group {position: relative;} 
.main-container .form-group i{position: absolute;top: 12px; left: 10px;font-size: 24px;color:#999;} 
.main-container .case-verify {width: 60%;margin-right: 3%;}
.main-container .verify {width: 37%;border-radius: 5px;overflow: hidden;}
.main-container .btn-submit {height: 40px;font-size: 20px;background-color: rgba(49, 156, 223, 0.8);color:#fff;border: none;}
.main-container .btn-submit:hover {background: #319cdf;}
.download-chrome {margin-top: 10px;font-size: 12px;color:#999;}
.download-chrome:hover {color:#666;text-decoration: underline;}
#loginForm {width: 450px;padding: 50px;background-color: rgba(255, 255, 255, .15);box-shadow: 0px 0px 0px 30px rgba(255, 255, 255, .05);}
.form-control:focus{border-color: #fff;outline: 0;-webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(255,255,255,.6);box-shadow: inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(255,255,255,.6);}
.form-control {background-color: rgba(255, 255, 255, 0);}
.logo-body {margin-bottom:30px;}
.logo-body h2{width: 450px;}
input::input-placeholder {color:#fff !important;}
input::-webkit-input-placeholder {color:#fff !important;}
input:-moz-placeholder {color:#fff !important;}
input::-moz-placeholder {color:#fff !important;}
input:-ms-input-placeholder {color:#fff !important;}
</style>
</head>
<body>
 <header class="header">
      <div class="container" style="padding: 0 50px;">
        <h1 class="pull-left">
          <img src="${base}<%=ServiceUtil.getLogoBig(10)%>" width="45">
          <span><%=ServiceUtil.getTitleBig(10)%></span>
        </h1>
        <div class="pull-right header-right">
          <a href="#">加入收藏</a>
          <a href="#">帮助中心</a>
        </div>
      </div>
    </header>
    <div class="main-container">
      <div class="container-fluid">
        <div class="login-container clearfix">
            <div class="text-center logo-body">
              <!-- <img src="images/logo-white.png" alt=""> -->
              <h2><%=ServiceUtil.getTitleBig(10)%></h2>
            </div>
            <form id="loginForm" method="post">
              <div class="form-group user-case">
                <input class="form-control" type="text" id="accountNameId" name="accountName" required="required" placeholder="请输入用户名">
              </div>
              <div class="form-group lock-case">
                <input class="form-control" type="password" id="passwordId" name="password" required="required" maxlength="16" placeholder="请输入密码">
              </div>
              <div class="form-group verify-case clearfix">
                <input class="form-control case-verify pull-left" id="verifyCodeId" name="verifyCode" required="required" maxlength="4" type="tel" placeholder="请输入验证码" onkeyup="this.value=this.value.replace(/\D/g,'')">
                <img class="verify pull-right" id="vimg" style="cursor:pointer;" title="验证码" width="60" height="40" src="verifyCode/slogin.do?random=0.7304289337922849">
              </div>
              <button type="button" id="loginBtn" class="btn btn-default btn-submit btn-block">登 录</button>
              <a href="/CitySystem/upload/excel/ChromeStandalone_56.0.2924.87_Setup.exe" class="download-chrome pull-right">适配浏览器下载</a>
            </form>
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
      autoVertaical();
      bodyHeight();
      $(window).resize(function(event) {
        autoVertaical();
        bodyHeight();
      });
    });
    function bodyHeight () {
      var bodyHeight = $('body').height();
      var divHeight = $('.body-height').height();
      console.log('bodyHeight=' + bodyHeight +';divHeight=' +divHeight);
      if (bodyHeight !== divHeight) {
        bodyHeight = divHeight;
      }
      $('body').height(bodyHeight)
    }
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