<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0"/>
<title><%=ServiceUtil.getTitleSmall(10) %></title>
<c:set var="base" value="${pageContext.request.contextPath}"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="shortcut icon" href="../favicon.ico">
<link href="${base}/static/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
<link href="${base}/static/fonts/Font-Awesome/css/font-awesome.min.css" rel="stylesheet">
<link href="${base}/static/css/index.css" rel="stylesheet">
<link href="${base}/static/css/style.css?v=4.1.0" rel="stylesheet">
<!--[if lte IE 8]><script>window.location.href='http://cdn.dmeng.net/upgrade-your-browser.html?referrer='+location.href;</script><![endif]-->
</head>
<style>
/* header  start*/
.header .name img ,
.header .name span,
.message-group .count-info,
.header .btn-signout{
  border-color: #d7d7d7;
}
/* header  end*/

body {background-color: #f6f6f6;}
.header {height: 80px;min-width: 997px;padding: 0 60px; background-color: rgba(255, 255, 255, .7);box-shadow: 0px 0px 20px 4px rgba(0, 0, 0, .2);}
body { overflow: auto; }
.main-container {height: calc(100vh - 120px);min-height: 450px;padding-bottom: 50px;min-width: 992px;margin: 0 auto;}
.copyright {width: 100%;min-width: 997px;position: relative;top: 0px;text-align: center;color: #333;line-height: 40px;height: 40px;background-color: rgba(255, 255, 255, .7);box-shadow: 0px 0px 20px 4px rgba(0, 0, 0, .2);}
a, a:hover, a:focus {text-decoration: none;}
.main-container .item {display: block;width: 18%;margin: 0 1%;float: left;margin-top: 107px;border:10px solid rgba(255, 255, 255, 0);}
.main-container .item:hover{border-color: rgba(49, 156, 223, 0.4);}
.main-container .item:hover .item-body {background-color: #319cdf;}
.main-container .item h3 {font-size: 28px;margin: 0;line-height: 65px;color: #7b7b7b;}
.main-container .item:hover h3 {color: #fff;}
.main-container .item .item-bg {height: 150px;background: url(${base}/static/images/icon/icon-6-5.png);}
.main-container .item.item-1 .item-bg {background-position: center -177px;}
.main-container .item.item-1:hover .item-bg {background-position: center -25px;}
.main-container .item.item-2 .item-bg {background-position: center -503px;}
.main-container .item.item-2:hover .item-bg {background-position: center -338px;}
.main-container .item.item-3 .item-bg {background-position: center -818px;}
.main-container .item.item-3:hover .item-bg {background-position: center -664px;}
.main-container .item.item-4 .item-bg {background-position: center -1434px;}
.main-container .item.item-4:hover .item-bg {background-position: center -1284px;}
.main-container .item.item-5 .item-bg {background-position: center -1124px;}
.main-container .item.item-5:hover .item-bg {background-position: center -970px;}
.label-primary, .badge-primary {background-color: #319cdf !important;}
@media (min-width: 768px) {
  .container {width: 100%}
}
@media (min-width: 992px) {
  .container {width: 100%}
}
@media (min-width: 1200px) {
  .container {width: 1170px}
}
</style>
</style>
<body  id="body-bg" style="height: 99.5vh;">
  <div class="body-height" style="position: absolute;top:0;left:0;width: 100%;">
    <header class="header">
      <div class="container-fluid">
        <div class="row" style="margin-top: 7px;">
          <a href="#" class="pull-left logo">
            <img src="${base}<%=ServiceUtil.getLogoBig(10) %>" alt="logo">
              <h1>
                <%=ServiceUtil.getTitleBig(10)%>
              </h1>
          </a>
          <div class="pull-right">
            <a href="#" class="name">
              <img src="${base}/static/images/icon/11.jpg" alt="头像">
              <span><%=AccountShiroUtil.getCurrentUser().getName()%></span>
            </a>
            <c:set var="roleid" value="<%=AccountShiroUtil.getCurrentUser().getRoleId() %>"/>
            <c:if test="${roleid==1}">
            <a href="${base}/backstage/manage?menuType=4" class="btn-signout" style="margin-right:10px;">参数设置</a>
            <div class="dropdown message-group">
              <c:set  var="noticeNum"   value="<%=ServiceUtil.noticeNum() %>"/>
              <c:set  var="deSatausNum"   value="<%=ServiceUtil.deSatausNum() %>"/>
              <c:set  var="inforSatausNum"   value="<%=ServiceUtil.inforSatausNum() %>"/>
              <c:set  var="num"   value="${noticeNum+inforSatausNum}"/>
              <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">消息
              <c:if test="${num > 0}">
                <span class="label label-primary">${num}</span>
              </c:if>
              </a>
              <ul class="dropdown-menu dropdown-alerts" style="left: -70px;">    
              <c:choose>
              <c:when test="${num>0}"> 
                <c:if test="${noticeNum>0}">
                  <li>
                    <a href="${base}/backstage/manage?menuType=1&rurl=${base}/backstage/subscribe/index">
                      <div>
                        <i class="fa fa-envelope fa-fw"></i> 您订阅的信息资源有${noticeNum}条更新
                      </div>
                    </a>
                  </li>
                  <li class="divider"></li>
                </c:if>
                  <c:if test="${inforSatausNum>0}">
                    <li>
                      <a href="${base}/backstage/manage?menuType=1&rurl=${base}/backstage/information/resource/index?status=14">
                        <div>
                          <i class="fa fa-envelope fa-fw"></i> 信息资源有${inforSatausNum}条待审核
                        </div>
                      </a>
                    </li>
                  </c:if> 
                  </c:when> 
                  <c:otherwise>
                  <div>
                    <i class="fa fa-envelope fa-fw"></i>没有新消息
                  </div>
                </c:otherwise>
              </c:choose>
              </ul>
            </div>
            </c:if>
            <a href="${base}/system_logout" class="btn-signout"><i class="fa fa-times mr5"></i>退出</a>
          </div>
        </div>
      </div>
    </header>
    <div class="main-container">
      <div class="container">
        <div class="row">
          <div class="item-container clearfix">
           <c:forEach var="obj"   items="${menuType1}">
      		<c:choose>
      		<c:when test="${obj==0}">
            <a href="${base}/backstage/manage?menuType=0" class="item item-1">
              <div class="item-body">
                <div class="item-bg"></div>
                <h3 class="text-center"><%=ServiceUtil.modRename(0)%></h3>
              </div>
            </a>
            </c:when>
      		<c:when test="${obj==1}">
            <a href="${base}/backstage/manage?menuType=1" class="item item-2">
              <div class="item-body">
                <div class="item-bg"></div>
                <h3 class="text-center"><%=ServiceUtil.modRename(1) %></h3>
              </div>
            </a>
            </c:when>
      		<c:when test="${obj==2}">
            <a href="${base}/backstage/manage?menuType=2" class="item item-3">
              <div class="item-body">
                <div class="item-bg"></div>
                <h3 class="text-center"><%=ServiceUtil.modRename(2) %></h3>
              </div>
            </a>
            </c:when>
      		<c:when test="${obj==3}">
            <a href="${base}/backstage/manage?menuType=3" class="item item-4">
              <div class="item-body">
                <div class="item-bg"></div>
                <h3 class="text-center"><%=ServiceUtil.modRename(3) %></h3>
              </div>
            </a>
            </c:when>
      		<c:when test="${obj==5}">
            <a href="${base}/backstage/manage?menuType=5" class="item item-5">
              <div class="item-body">
                <div class="item-bg"></div>
                <h3 class="text-center"><%=ServiceUtil.modRename(5) %></h3>
              </div>
            </a>
            </c:when>
      		<c:otherwise>
      		</c:otherwise>
      		</c:choose>
           </c:forEach> 
          </div>
        </div>
      </div>
    </div>
    <footer class="copyright hidden-xs">Copyright © 2016  国脉海洋信息发展有限公司</footer>
  </div>
</body>
</html>
<script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
<script src="${base}/static/js/bootstrap.min.js?v=3.3.6"></script>
<script src="${base}/static/js/particles.min.js"></script>
<script>
 $(function() {
      bodyHeight();
      $(window).resize(function () {
        bodyHeight();
      });
      var item = $('.item-container .item');
      var itemBg = $('.item-container .item-bg');
      var itemName = $('.item-container .item h3');
      var itemLength = item.length;
      itemHander(item, itemBg, itemLength);
    });
 function itemHander (item, itemBg, length) {
   
   switch(length) {
     case 3:
       item.css({
         width: '19%',
         marginLeft: '7%',
         marginRight: '7%'
       });
       itemBg.css({
         height: 180,
         paddingTop: 10,
         paddingBottom: 10
       });
       // itemName.css({
       //   paddingTop: 10,
       //   paddingBottom: 10
       // });
       break;
     case 4:
       item.css({
         width: '17%',
         marginLeft: '4%',
         marginRight: '4%'
       });
       itemBg.css({
         height: 170,
         paddingTop: 10,
         paddingBottom: 10
       });
       break;
   }
 }
    function bodyHeight () {
      var bodyHeight = $('.body-height').height();
      $('body').height(bodyHeight -5)
    }
    function autoVertaical () {
      var item = $('.item-container'),
          itemHeight = item.outerHeight(),
          mainHeight = $('.main-container').height(),
          height = (mainHeight - itemHeight) / 2;
      console.log('mainHeight='+mainHeight+";itemHeight="+itemHeight+ ';height='+height);
      item.css('marginTop', height)
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
