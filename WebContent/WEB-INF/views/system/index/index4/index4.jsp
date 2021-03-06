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
<link rel="stylesheet" href="${base}/static/css/skin/skin-4-4.css">
<link rel="stylesheet" href="${base}/static/css/skin/skin-<%=ServiceUtil.getThemeType(10)%>.css">
<!--[if lte IE 8]><script>window.location.href='http://cdn.dmeng.net/upgrade-your-browser.html?referrer='+location.href;</script><![endif]-->
</head>
<style>
body {
    overflow: auto;
  }
.header {
  width: 100%;
  min-width: 992px;
}
.main-container {
    height: calc(100vh - 128px);
    min-height: 520px;
    padding-bottom: 50px;
    min-width: 992px;
    margin: 0 auto;
  }
  .copyright {
    position: relative;
    top: 0px;
    text-align: center;
    color: #333;
    min-width: 992px;
  }
  a, a:hover, a:focus {
    text-decoration: none;
  }
  .menu-list-container {
    width: 950px;
    border: 10px solid #fff;
    margin: 120px auto 0;
    background-color: #fff;
  }
  .menu-list-container .menu-item {
    height: 205px;
    margin: 5px;
  }
  .menu-list-container .menu-item-1 {
    width: 570px;
  }
  .menu-list-container .menu-item-2 {
    width: 340px;
  }
  .menu-list-container .menu-item-3 {
    width: 340px;
  }
  .menu-list-container .menu-item-4 {
    width: 570px;
  }
  .menu-list-container .menu-item .img {
    margin-top: 10px;
    height: 145px;
  }
  .menu-list-container .menu-item .name{
    height: 40px;
    line-height: 40px;
    font-size: 16px;
    font-weight: 700;
    color: #fff;
  }
  @media (min-width: 992px) {
    .main-container {
      width: 100%;
    }
  }
  @media (min-width: 1200px) {
    .main-container {
      width: 1200px;
    }
  }
</style>
</style>
<body class="hook-index-item index-skin skin-4-4 skin-4">
  <header class="header">
    <div class="container-fluid">
      <div class="row">
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
          <c:set var="roleid"   value="<%=AccountShiroUtil.getCurrentUser().getRoleId() %>"/>
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
		<c:forEach items="${menuType}" var="obj" varStatus="status">	
			<c:if test="${status.index==0}">
				<a href="${base}/backstage/manage?menuType=${obj.key}" class="menu-item menu-item-1 pull-left">
		          <div class="img"></div>
		          <p class="name text-center">${obj.value}</p>
		        </a>
			</c:if>
			<c:if test="${status.index==1}">
			    <a href="${base}/backstage/manage?menuType=${obj.key}" class="menu-item menu-item-2 pull-left">
		          <div class="img"></div>
		          <p class="name text-center">${obj.value}</p>
		        </a>
			</c:if>
			<c:if test="${status.index==2}">
			    <a href="${base}/backstage/manage?menuType=${obj.key}" class="menu-item menu-item-3 pull-left">
		          <div class="img"></div>
		          <p class="name text-center">${obj.value}</p>
		        </a>
			</c:if>
			<c:if test="${status.index==3}">
			    <a href="${base}/backstage/manage?menuType=${obj.key}" class="menu-item menu-item-4 pull-left">
		          <div class="img"></div>
		          <p class="name text-center">${obj.value}</p>
		        </a>
			</c:if>
		</c:forEach>
      </div>
    </div>
  </div>
  <p class="copyright hidden-xs">Copyright © 2016  国脉海洋信息发展有限公司</p>
</body>
</html>
<script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
<script src="${base}/static/js/bootstrap.min.js?v=3.3.6"></script>
<script>
$(function() {
  themeInit();
  windowHeight = $(window).height();
  vertical(windowHeight);
  $(window).resize(function(event) {
    windowHeight = $(window).height();
    vertical(windowHeight);
  });
})
function vertical (windowHeight) {
  var headerHeight = $('.header').outerHeight(),
      container = $('.menu-list-container'),
      containerHeight = container.height();
  console.log('headerHeight = ' + headerHeight +';containerHeight = ' + containerHeight, 'windowHeight=' + windowHeight);
  var height = windowHeight - headerHeight - containerHeight;
  console.log(height)
  if (height > 0) {
    container.css('marginTop', height/2 );
  } else {
     container.css('marginTop', 0 );
  }
}
function themeInit() {
  $('body').addClass($('.theme').attr('data-skin'));
}

</script>
