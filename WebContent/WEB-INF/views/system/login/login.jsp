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
<link href="${base}/static/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
<!-- <link rel="stylesheet" href="${base}/static/css/system/system/login.css" /> -->
<link href="${base}/static/css/index.css" rel="stylesheet">
<link rel="stylesheet" href="${base}/static/css/skin/skin-<%=ServiceUtil.getThemeType(10)%>.css">

<!--[if lte IE 8]><script>window.location.href='http://cdn.dmeng.net/upgrade-your-browser.html?referrer='+location.href;</script><![endif]-->
<style>

.register-page { position: relative; width: 100%;height: 100%; background-size: cover; font-family: 'Microsoft YaHei';height: calc(100%);}

.register-page .last-copyright { position: relative; bottom: -35px; text-align: center; color: #666;clear: both; }

.register-page-case { position: relative; padding: 15px 40px 50px; width: 100%; height: auto; background-color:rgba(255,255,255,0.5); z-index: 1000; box-shadow: 0px 2px 10px 1px rgba(0, 0, 0, 0.4)}

.register-page-case .logo { margin: 100px 0 20px; width: 65px; height: auto; }

.register-page h2 { margin:0 0 25px 0; font-size: 26px; color: #000;font-weight: 700; font-family:"SimHei";}

.register-page-case .user-case, .register-page-case .verify-case, .register-page-case .lock-case { position: relative; margin-bottom: 20px; }

.register-page-case .user, .register-page-case .lock { position: absolute; top: 13px; left: 12px; width: 16px; height: auto; }

.register-page-case .verify { position: absolute; top: 0; right: 0; width: 40%; height: 46px; }

.register-page-case .case-verify { width: 60%; }

.register-page-case .register-btn:hover { background: #43bef8; }
.register-page .case input {text-indent: 5.5em;position: relative;} 
.register-page-case h3 {color: #666;margin-bottom: 20px;padding-bottom: 20px;border-bottom: 1px solid #d7d7d7;}
.register-page .user-case input {background-position:  0px -28px;}
.register-page .lock-case input {background-position:  0px -1px;}
.register-page .verify-case input {background-position:  0px -52px;}
.register-page .user-case:before {content:"账号";position: absolute;left:33px;top: 14px;z-index: 10000;}
.register-page .lock-case:before {content:"密码";position: absolute;left:33px;top: 14px;z-index: 10000;}
.register-page .verify-case:before {content:"验证码";position: absolute;left:33px;top: 14px;z-index: 10000;}
.register-page .btn {border-width: 0;color: #fff;}
.register-page .form-group i{display: block;position: absolute;top: 12px; left: 6px;height: 18px;width: 18px; background: url(${base}/static/images/login/icon_1.png)  no-repeat;z-index: 10000;}
.register-page .user-case i {background-position: -8px -34px;}
.register-page .lock-case i {background-position: -8px -8px;}
.register-page .verify-case i {background-position: -8px -59px;}
.register-page .form-control {height: 45px;}
.register-page .btn {
padding: 7px 0;
border-width: 0;
font-size: 18px;
}
.register-page .title img {
width: 45px;
margin-right: 10px;
}  
.header {
display: none;
} 
.download-chrome {
margin-top: 10px;
color: #999;
}
.download-chrome:hover {
color: #666;
text-decoration: underline;
}



</style>
</head>
<body class="hook-login skin-<%=ServiceUtil.getThemeType(10)%>">
<!-- <body class="hook-login skin-5"> -->
  <header class="header">
    <h1 class="pull-left">
      <img style="max-width: 45px;" src="${base}<%=ServiceUtil.getLogoBig(10)%>" alt=""></img>
      <span><%=ServiceUtil.getTitleBig(10)%></span>
    </h1>
    <div class="pull-right header-right">
      <a href="">加入收藏</a>
      <a href="">帮助中心</a>
    </div>
  </header>
  <div class="register-page">
    <div class="container-fluid">
      <div class="row skin-bg">
        <div class="col-md-4 col-sm-6 col-xs-10 col-md-offset-4 col-sm-offset-3 col-xs-offset-1 page-case">
          <h2 class="text-center title"><img src="${base}<%=ServiceUtil.getLogoBig(10)%>" alt="logo">
          <span><%=ServiceUtil.getTitleBig(10)%></span></h2>
          <div class="register-page-case">
            <h3>账号登录</h3>
            <form id="loginForm" method="post">
              <div class="form-group user-case case">
                <i></i>
                <input class="form-control" type="text" id="accountNameId" name="accountName" required="required"  placeholder="请输入用户名" >
              </div>
              <div class="form-group lock-case case">
                <i></i>
                <input class="form-control" type="password" id="passwordId" name="password"  required="required" maxlength="16" class="form-control" placeholder="请输入密码">
              </div>
              <div class="form-group verify-case case">
                <div class="">
                  <i></i>
                  <input class="form-control case-verify" id="verifyCodeId" name="verifyCode" required="required" maxlength="4" type="tel" class="form-control" placeholder="请输入验证码" onkeyup="this.value=this.value.replace(/\D/g,'')" >
                  <img  class="verify" id="vimg" style="cursor:pointer;" title="验证码" width="60" height="34" />
                </div>
              </div>
              <button type="button" id="loginBtn" class="btn btn-default btn-submit btn-block">登 录</button>
              <a href="${base}/upload/excel/ChromeStandalone_56.0.2924.87_Setup.exe" class="download-chrome pull-right">适配浏览器下载</a>
            </form>
          </div>
        </div>
      </div>
      <p class="last-copyright">Copyright © 2016 国脉海洋信息发展有限公司 </p>
    </div>
  </div>
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
  heightAuto()
  $(window).resize(function(event) {
    heightAuto()
  });
})
function heightAuto() {
  if (!$('body').hasClass('skin-4') && !$('body').hasClass('skin-5')) {
    console.log('skin');
    var box = $('.page-case'),
      boxH = box.height(),
      windowH = $(window).height();
    if (windowH > boxH) {
      box.css('marginTop', (windowH - boxH) / 2)
    } else {
      box.css('marginTop', 0)
    }
  }
}
</script>

<%@include file="../common/dialog.jsp" %>
</body>
</html>