<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="renderer" content="webkit">
  <c:set var="base" value="${pageContext.request.contextPath}"/>
  <title>
   <%=ServiceUtil.getTitleSmall(10)%>
  </title>
  <link rel="shortcut icon" href="${base}/favicon.ico"> 
  <link href="${base}/static/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
  <link href="${base}/static/fonts/Font-Awesome/css/font-awesome.min.css" rel="stylesheet">
  <link href="${base}/static/css/style.css?v=4.1.0" rel="stylesheet">
  <link href="${base}/static/css/index.css" rel="stylesheet">
  <link rel="stylesheet" href="${base}/static/css/skin/skin-<%=ServiceUtil.getThemeType(10)%>.css">
  <!--[if lte IE 8]><script>window.location.href='http://cdn.dmeng.net/upgrade-your-browser.html?referrer='+location.href;</script><![endif]-->
</head>
<style>
body.skin-8 {background: url(${base}/static/images/skin/skin-8-bg.jpg) no-repeat !important;}
.rel {
    position: relative;
}
.theme-skin {
    display: none;
    position: fixed;
    top: 77px;
    right: 0;
    border-left: 1px solid #d7d7d7;
    border-bottom: 1px solid #d7d7d7;
    background: #fff;
}
.theme-skin div{
    padding: 15px 20px;
    width: 300px;
    text-align: center;
}
.theme-skin .title {
    background: #efefef;
    text-align: center;
    text-transform: uppercase;
    font-weight: 600;
    display: block;
    padding: 10px 15px;
    font-size: 12px;
}
.default-skin {
    background-color: #d2d2d3;
}
.default-skin:hover {
    background-color: #b8b8b9;
}
.black-skin {
    background-color: rgb(111, 111, 111);
}
.black-skin:hover {
    background-color: rgb(60, 60, 60);
}
.blue-skin {
    background: rgb(121, 136, 160);
}
.blue-skin:hover {
    background: rgb(72, 96, 134);
}  
</style>
<body class="fixed-sidebar full-height-layout hook-manage-skin index-skin" style="overflow:hidden">
  <header class="header">
    <div class="container-fluid">
      <div class="row">
        <a href="#" class="pull-left logo">
          <img src="${base}<%=ServiceUtil.getLogoBig(10)%>" alt="logo">
          <h1>
            <%=ServiceUtil.getTitleBig(10)%>
          </h1>
        </a>
        <div class="pull-right rel">
          <a href="#" class="name">
            <img src="${base}/static/images/icon/11.jpg" alt="头像"><span><%=AccountShiroUtil.getCurrentUser().getName()%></span>
          </a>
          <c:set  var="roleid"   value="<%=AccountShiroUtil.getCurrentUser().getRoleId() %>"/>
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
              <ul class="dropdown-menu dropdown-alerts"  style="left: -70px;">
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
          <a href="${base}/system_logout" class="btn-signout btn-sign-out"><i class="fa fa-times mr5"></i>退出</a>
          <div class="theme-skin">
            <a href="#" class="btn-signout theme" style="margin-right: 15px;"  data-skin=" skin-<%=ServiceUtil.getThemeType(10)%>">主题</a>
          </div>
        </div>
      </div>
    </div>
  </header>
  <div id="wrapper">
      <!--左侧导航开始-->
    <nav class="navbar-default navbar-static-side" role="navigation">
      <div class="sidebar-collapse">
        <ul class="nav" id="side-menu">
          <li class="home-icon">
            <a class="J_menuItem index-page" href="#" onclick="location.href='${base}/backstage/index';" >
              <i class="fa fa-home skin-home"></i>
              <span class="nav-label">首页</span>
              <i class="fa fa-home pull-right"></i>
            </a>
          </li>
            ${menuHtml}
        </ul>
      </div>
    </nav>
      <!--左侧导航结束-->
      <!--右侧部分开始-->
    <div id="page-wrapper" class="gray-bg dashbard-1">        
      <div class="row J_mainContent" id="content-main">
      <c:choose>
        <c:when test="${rurl!=null}">
          <iframe class="J_iframe" name="iframe0" width="100%" height="100%" src="${rurl}" frameborder="0" data-id="index_v1.html" seamless></iframe>
        </c:when>
        <c:otherwise>
          <iframe class="J_iframe" name="iframe0" width="100%" height="100%" src="${base}/backstage/iframeIndex?index=${menuType}" frameborder="0" data-id="index_v1.html" seamless></iframe>
        </c:otherwise>
      </c:choose>
      </div>
    </div>
      <!--右侧部分结束-->
  </div>

    <!-- 全局js -->
<script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
<script src="${base}/static/js/bootstrap.min.js?v=3.3.6"></script>
<script src="${base}/static/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="${base}/static/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- 自定义js -->
<script src="${base}/static/js/hplus.js?v=4.1.0"></script>
<script>
$('.sidebar-collapse .nav li').on('click', function() {
  var url = $(this).find('a').attr('href');
  if (url.indexOf('/') != -1) {
    $('#page-wrapper iframe').attr('src', url);
    return false;
  }
});
  themeInit()
$('#side-menu').slimScroll({
  height: '100%',
  railOpacity: 0.9,
  alwaysVisible: false,
  size: '10px'
});

function themeInit() {
  $('body').addClass($('.theme').attr('data-skin'));
}

</script>
</body>

</html>
