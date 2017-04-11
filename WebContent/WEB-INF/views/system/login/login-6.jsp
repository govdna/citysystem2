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
body {background-color: #f6f6f6;}
a, a:focus, a:hover {text-decoration: none;}
.header {height: 80px;min-width: 997px;line-height: 80px;padding: 0 60px; background-color: rgba(255, 255, 255, .7);box-shadow: 0px 0px 20px 4px rgba(0, 0, 0, .2);}
.header h1 {font-size: 24px;font-weight: 700;font-family: "SimHei";}
.header .header-right {font-size: 16px;font-family: 'SimHei';}
.header .header-right a{color: #666;}
.header .header-right a:hover {color: #999;}
.copyright {width: 100%;min-width: 997px;position: relative;top: 0px;text-align: center;color: #333;line-height: 40px;height: 40px;background-color: rgba(255, 255, 255, .7);box-shadow: 0px 0px 20px 4px rgba(0, 0, 0, .2);}
.main-container {position: relative;min-width: 997px;height: calc(100vh - 120px);min-height: 500px;}
.main {position: absolute;top: 0; left: 0; bottom: 0; right: 0;}
.main-container .login-container {position: relative;left: 50%; margin-left: -350px; margin-top: 62px;width: 700px;height: 325px;box-shadow: rgba(0, 0, 0, 0.2) 0px 0px 13px 1px;}
.main-container .login-left {padding-top: 80px;width: 260px;height: 325px;color: #fff;text-align: center;background-color: rgba(49, 156, 223, 0.8);}
.main-container .login-left h3{padding: 10px;font-weight: 700;font-size: 32px;}
.main-container .login-right {padding: 35px 30px;width: 440px;height: 325px;background-color: rgba(255, 255, 255, 0.8);}
.main-container .login-right input {text-indent: 2em;border-radius: 0;height: 50px;}
.main-container .login-right .form-group {position: relative;} 
.main-container .login-right .form-group i{position: absolute;top: 12px; left: 10px;font-size: 24px;color:#999;} 
.main-container .login-right .case-verify {width: 60%;}
.main-container .login-right .verify {width: 40%;}
.main-container .login-right .btn-submit {height: 50px;font-size: 20px;background-color: rgba(49, 156, 223, 0.8);color:#fff;border: none;}
.main-container .login-right .btn-submit:hover {background: #319cdf;}
.download-chrome {margin-top: 10px;font-size: 12px;color:#999;}
.download-chrome:hover {color:#666;text-decoration: underline;}
.form-control {background-color: rgba(255, 255, 255, 0);}
</style>
</head>
<body id="body-bg" style="height: 99.5vh;">
  <div class="body-height" style="position: absolute;top:0;left:0;width: 100%;">
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
    <div class="main-container">
      <div class="container-fluid">
        <div class="login-container clearfix">
          <div class="pull-left login-left"><img src="${base}/static/images/header/logo-white.png" alt="logo" width="68"><h3><%=ServiceUtil.getTitleBig(10)%></h3></div>
          <div class="pull-left login-right">
            <form id="loginForm" method="post">
              <div class="form-group user-case">
                <i class="fa fa-user"></i>
                <input class="form-control" type="text" id="accountNameId" name="accountName" required="required" placeholder="请输入用户名">
              </div>
              <div class="form-group lock-case">
                <i class="fa fa-lock"></i>
                <input class="form-control" type="password" id="passwordId" name="password" required="required" maxlength="16" placeholder="请输入密码">
              </div>
              <div class="form-group verify-case clearfix">
                <i class="fa fa-keyboard-o"></i>
                <input class="form-control case-verify pull-left" id="verifyCodeId" name="verifyCode" required="required" maxlength="4" type="tel" placeholder="请输入验证码" onkeyup="this.value=this.value.replace(/\D/g,'')">
                <img class="verify pull-right" id="vimg" style="cursor:pointer;" title="验证码" width="60" height="50" src="verifyCode/slogin.do?random=0.7304289337922849">
              </div>
              <button type="button" id="loginBtn" class="btn btn-default btn-submit btn-block">登 录</button>
              <a href="/CitySystem/upload/excel/ChromeStandalone_56.0.2924.87_Setup.exe" class="download-chrome pull-right">适配浏览器下载</a>
            </form>
          </div>
        </div>
      </div>
    </div>
    <footer class="copyright hidden-xs">Copyright © 2016  国脉海洋信息发展有限公司</footer>
  </div>
    <!-- /signup-box -->
<script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
<script src="${base}/static/js/jquery/jquery.md5.js"></script>
<script src="${base}/static/js/plugins/layer/layer.js"></script>
<script src="${base}/static/js/particles.min.js"></script>
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
      $('body').height(bodyHeight - 5)
    }
    function autoVertaical () {
      var login = $('.login-container'),
          loginHeight = login.outerHeight(),
          mainHeight = $('.main-container').height(),
          height = (mainHeight - loginHeight) / 2;
      // console.log('mainHeight='+mainHeight+";loginHeight="+loginHeight+ ';height='+height);
      login.css('marginTop', height)
    }
    particlesJS('body-bg',   
      {
        "particles": {
          "number": {
            "value": 80,
            "density": {
              "enable": true,
              "value_area": 800
            }
          },
          "color": {
            "value": "#319cdf"
          },
          "shape": {
            "type": "circle",
            "stroke": {
              "width": 0,
              "color": "#000000"
            },
            "polygon": {
              "nb_sides": 5
            },
            "image": {
              "src": "img/github.svg",
              "width": 100,
              "height": 100
            }
          },
          "opacity": {
            "value": 0.5,
            "random": false,
            "anim": {
              "enable": false,
              "speed": 1,
              "opacity_min": 0.1,
              "sync": false
            }
          },
          "size": {
            "value": 12,
            "random": true,
            "anim": {
              "enable": false,
              "speed": 40,
              "size_min": 0.1,
              "sync": false
            }
          },
          "line_linked": {
            "enable": true,
            "distance": 150,
            "color": "#319cdf",
            "opacity": 0.4,
            "width": 1
          },
          "move": {
            "enable": true,
            "speed": 6,
            "direction": "none",
            "random": false,
            "straight": false,
            "out_mode": "out",
            "attract": {
              "enable": false,
              "rotateX": 600,
              "rotateY": 1200
            }
          }
        },
        "interactivity": {
          "detect_on": "canvas",
          "events": {
            "onhover": {
              "enable": true,
              "mode": "repulse"
            },
            "onclick": {
              "enable": true,
              "mode": "push"
            },
            "resize": true
          },
          "modes": {
            "grab": {
              "distance": 400,
              "line_linked": {
                "opacity": 1
              }
            },
            "bubble": {
              "distance": 400,
              "size": 40,
              "duration": 2,
              "opacity": 8,
              "speed": 3
            },
            "repulse": {
              "distance": 200
            },
            "push": {
              "particles_nb": 4
            },
            "remove": {
              "particles_nb": 2
            }
          }
        },
        "retina_detect": true,
        "config_demo": {
          "hide_card": false,
          "background_color": "#b61924",
          "background_image": "",
          "background_position": "50% 50%",
          "background_repeat": "no-repeat",
          "background_size": "cover"
        }
      }
    );
  </script>

<%@include file="../common/dialog.jsp" %>
</body>
</html>