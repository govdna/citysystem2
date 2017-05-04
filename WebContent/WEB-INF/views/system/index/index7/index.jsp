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
.header a,.header .logo h1 {color: #fff;}
.header {height: 80px;min-width: 997px;padding: 0 60px;background-color: transparent;color: #fff;border-bottom: 1px solid #fff;color: #fff;}

/* header  end*/
body {color: #fff;background: #2c455c url(${base}/static/images/skin/skin-7-bg.png) no-repeat bottom center;font-family: 'Microsoft Yahei';}
a, a:hover, a:focus {text-decoration: none;}
.label-primary, .badge-primary {background-color: #00a3ab;}
 
.main-container {height: calc(100vh - 128px);min-height: 450px;padding-bottom: 50px;min-width: 992px;margin: 0 auto;}
.copyright {position: relative;top: 0px;text-align: center;}
.menu-list-container .menu-item {width: 20%;float: left; color: #fff;}
.menu-list-container .menu-item {height: 250px;}
.menu-list-container .menu-item .img{height: 180px;background: url(${base}/static/images/skin/skin-7-icon.png) no-repeat;}
.menu-list-container .menu-item .name {line-height: 50px;font-size: 26px;}
.menu-list-container .menu-item:hover {color: #00a3ab;}
.menu-list-container .menu-item-1 .img {background-position: center -240px;}
.menu-list-container .menu-item-1:hover .img {background-position: center -42px;}
.menu-list-container .menu-item-2 .img {background-position: center -673px;}
.menu-list-container .menu-item-2:hover .img {background-position: center -462px;}
.menu-list-container .menu-item-3 .img {background-position: center -1076px;}
.menu-list-container .menu-item-3:hover .img {background-position: center -879px;}
.menu-list-container .menu-item-4 .img {background-position: center  -1460px;}
.menu-list-container .menu-item-4:hover .img {background-position: center  -1254px;}
.menu-list-container .menu-item-5 .img {background-position: center -1873px;}
.menu-list-container .menu-item-5:hover .img {background-position: center -1663px;}
</style>
<body>

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
              <a href="${base}/backstage/manage?menuType=0" class="menu-item menu-item-1">
                <div class="img"></div>
                <p class="name text-center"><%=ServiceUtil.modRename(0)%></p>
              </a>
              </c:when>
            <c:when test="${obj==1}">
              <a href="${base}/backstage/manage?menuType=1" class="menu-item menu-item-2">
                <div class="img"></div>
                <p class="name text-center"><%=ServiceUtil.modRename(1)%></p>
              </a>
              </c:when>
            <c:when test="${obj==2}">
              <a href="${base}/backstage/manage?menuType=2" class="menu-item menu-item-3">
                <div class="img"></div>
                <p class="name text-center"><%=ServiceUtil.modRename(2)%></p>
              </a>
              </c:when>
            <c:when test="${obj==3}">
              <a href="${base}/backstage/manage?menuType=3" class="menu-item menu-item-4">
               <div class="img"></div>
               <p class="name text-center"><%=ServiceUtil.modRename(3)%></p>
             </a>
              </c:when>
            <c:when test="${obj==5}">
               <a href="${base}/backstage/manage?menuType=5" class="menu-item menu-item-5">
                 <div class="img"></div>
                 <p class="name text-center"><%=ServiceUtil.modRename(5)%></p>
                </a>
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

        if (size === 3 || size === 4) {
          menu.css('marginTop', height);
        } else if (size === 5) {
          
          item.each(function (index) {
            if (index % 2 === 0) {
              $(this).css('marginTop', height - STATICSIZE);
            } else {
              $(this).css('marginTop', height + STATICSIZE);
            }
          });
          var menuH = menu.height(),
              h = (mainContainerHeight - menuH) / 2016;
          menu.css('marginTop', h);
        }
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