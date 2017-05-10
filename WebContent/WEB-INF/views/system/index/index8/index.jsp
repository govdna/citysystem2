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
  border-color: rgba(255, 255, 255, .25);
  background-color: rgba(255, 255, 255, .4);
}
.header a {color: #fff;}
.header .logo h1 {color: #fff;}
.label-primary, .badge-primary{background-color: rgb(49, 156, 223);}
/* header  end*/
body {color: #fff;background: url(${base}/static/images/skin/skin-8-bg.jpg) no-repeat ;-webkit-background-size: cover;
background-size: cover;font-family: 'Microsoft Yahei';}
a, a:hover, a:focus {text-decoration: none;}
.header {background-color: rgba(255, 255, 255, .15);;height: 80px;min-width: 997px;padding: 0 60px;color: #fff;}
.main-container {height: calc(100vh - 128px);min-height: 450px;padding-bottom: 50px;min-width: 992px;margin: 0 auto;}
.menu-item {width: 20%; float: left;}
.menu-item .item {background-color: rgba(255, 255, 255, .5); width: 170px;height: 170px;display: block;border-radius: 50%;border: 15px solid rgba(255, 255, 255, .25);box-shadow: 0 0 0 15px rgba(255, 255, 255, .1);background-clip: padding-box;color: #fff;text-align: center;margin: 0 auto;}
.menu-item .item .img {background: url(${base}/static/images/skin/skin-8-icon.png) no-repeat;height: 80px;width: 100%;margin-top: 20px;}
.menu-item .item .name {display: inline-block;background-color: rgba(0, 0, 0, .5);color: #fff;padding: 2px 10px;border-radius: 22px;margin-top: 5px;}
.copyright {position: relative;top: 0px;text-align: center;}
.menu-item .menu-item-1 .img {background-position: 64% -330px;}
.menu-item .menu-item-2 .img {background-position: center -98px;}
.menu-item .menu-item-3 .img {background-position: center -256px;}
.menu-item .menu-item-4 .img {background-position: 64% -180px;}
.menu-item .menu-item-5 .img {background-position: center -10px;}
.menu-item:hover .item{animation: myfirst 2s infinite;}
@keyframes myfirst
{
  from {box-shadow: 0 0 0 0px rgba(255, 255, 255, .25);}
  to {box-shadow: 0 0 0 25px rgba(255, 255, 255, 0);}
}
</style>
<body>
  <div class="body-height">
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
            </c:if>
            <c:if test="<%=!ServiceUtil.haveCheck(\"/backstage/information/resource/index\") %>">
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
    <div class="container main-container">
      <div class="row">
        <div class="menu-list-container clearfix">
         <c:forEach var="obj"   items="${menuType1}">
    		<c:choose>
    		<c:when test="${obj==0}">
        <div class="menu-item">
          <a href="${base}/backstage/manage?menuType=0" class="item menu-item-1">
            <div class="img"></div>
            <p class="name text-center"><%=ServiceUtil.modRename(0)%></p>
          </a>
        </div>
          </c:when>
    		<c:when test="${obj==1}">
         <div class="menu-item">
            <a href="${base}/backstage/manage?menuType=1" class="item menu-item-2">
              <div class="img"></div>
              <p class="name text-center"><%=ServiceUtil.modRename(1)%></p>
            </a>
          </div>
          </c:when>
    		<c:when test="${obj==2}">
           <div class="menu-item">
            <a href="${base}/backstage/manage?menuType=2" class="item menu-item-3">
              <div class="img"></div>
              <p class="name text-center"><%=ServiceUtil.modRename(2)%></p>
            </a>
          </div>
          </c:when>
    		<c:when test="${obj==3}">
           <div class="menu-item">
            <a href="${base}/backstage/manage?menuType=3" class="item menu-item-4">
              <div class="img"></div>
              <p class="name text-center"><%=ServiceUtil.modRename(3)%></p>
            </a>
          </div>
          </c:when>
    		<c:when test="${obj==5}">
           <div class="menu-item">
            <a href="${base}/backstage/manage?menuType=5" class="item menu-item-5">
              <div class="img"></div>
              <p class="name text-center"><%=ServiceUtil.modRename(5)%></p>
            </a>
          </div>
          </c:when>
    		<c:otherwise>
    		</c:otherwise>
    		</c:choose>
         </c:forEach> 
        </div>
      </div>
    </div>
    <footer class="copyright hidden-xs">Copyright © 2016  国脉海洋信息发展有限公司</footer>
</body>
</html>
<script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
<script src="${base}/static/js/bootstrap.min.js?v=3.3.6"></script>
<script src="${base}/static/js/particles.min.js"></script>
<script>
  $(function () {
    (function ($, window) {
      var item = $('.menu-item'),
          size = item.length,
          width = 100 / size + '%';
      

      switchItem(size);
      autoItemMargin(size);
      $(window).resize(function () {
        autoItemMargin(size);
      });
      function autoItemMargin (size) {
        var mainContainerHeight = $('.main-container').height(),
            menu = $('.menu-list-container'),
            menuHeight = menu.height(),
            STATICSIZE = 30,
            height = (mainContainerHeight - menuHeight) / 2;

          menu.css('marginTop', height);
      }

      function switchItem (size) {
        switch (size) {
          case 3: 
            item.css('width', width);
            break;
          case 4:
            item.css('width', width);
            break;
          case 5:
            item.css('width', width);
            break;
        }
      }

    })(jQuery, window);
  });
</script>
