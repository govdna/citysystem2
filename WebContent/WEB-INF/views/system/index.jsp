<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<title><%=ServiceUtil.getTitleSmall(10) %></title>
<c:set var="base" value="${pageContext.request.contextPath}"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="shortcut icon" href="../favicon.ico">
  <link href="${base}/static/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
<link href="${base}/static/css/index.css" rel="stylesheet">
<link href="${base}/static/css/style.css?v=4.1.0" rel="stylesheet">
<link rel="stylesheet" href="${base}/static/css/skin/skin-<%=ServiceUtil.getThemeType(10) %>.css">
<!--[if lte IE 8]><script>window.location.href='http://cdn.dmeng.net/upgrade-your-browser.html?referrer='+location.href;</script><![endif]-->
</head>
<style>

/* dock2 - bottom */
a:hover {text-decoration: none;}
.header {padding: 7px 15px 18px;}
.header .name {position: relative;}
.header .logo {margin-left: 30px; color: #333;font-size: 20px; font-weight: 700;}
.header .logo img {width: 45px;}
.header .logo h1 {font-size: 20px; font-weight: 700; display: inline-block;}
.header .name img {position: absolute; top: -11px; left: -4px; height: 40px; width: 40px; border-radius: 50%; border: 2px solid #9f9f9f;}
.header .name span {display: inline-block; padding: 3px 20px 3px 50px; margin: 17px 10px 0 0; min-width: 140px; border-radius: 26px; border: 2px solid #888888;  }
.header .btn-signout { display: inline-block; padding: 3px 20px; margin-right: 30px; border-radius: 26px; border: 2px solid #888888;}
.nav {
margin-top: 100px;
}

.nav a {
display: block;
padding-top: 200px;
}

.last-copyright {
display: inline-block;
position: relative;
left: 50%;
bottom: 0px;
margin-left: -135px;
color: #666;
}
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
  z-index: 10;
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
.nav-item-skin div {
  float: left;
  width: 25%;
}
</style>
</style>
<body class="hook-index-item index-skin">
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
            <c:set  var="num"   value="${noticeNum+deSatausNum+inforSatausNum}"/>
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
                <c:if test="${deSatausNum>0}">
                  <li>
                    <a href="${base}/backstage/manage?menuType=1&rurl=${base}/backstage/govRdataElement/status?st=1">
                      <div>
                        <i class="fa fa-envelope fa-fw"></i> 数据元有${deSatausNum}条待审核
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
          <div class="theme-skin">
            <a href="#" class="btn-signout theme" style="margin-right: 15px;" data-skin=" skin-<%=ServiceUtil.getThemeType(10)%>">主题</a>      
          </div>
        </div>
      </div>
    </div>
  </header>
  <div class="container rel clearfix" style="padding-bottom: 20px;height: calc(100vh - 108px);box-sizing: border-box;">
    <div class="row">
      <div class="nav hook-nav-list nav-item-skin clearfix">
        <c:forEach var="obj"   items="${menuType1}">
	      <c:choose>
	        <c:when test="${obj==1}">
	         <div class="nav-list-skin-1">
	          <a href="${base}/backstage/manage?menuType=1" class=" nav1">
	            <h3 class="text-center"><%=ServiceUtil.modRename(1) %></h3>
	          </a>
	         </div>
	        </c:when>
	        <c:when test="${obj==2}">
	         <div class="nav-list-skin-2">
	          <a href="${base}/backstage/manage?menuType=2" class="nav2">
	            <h3 class="text-center"><%=ServiceUtil.modRename(2) %></h3>
	          </a>
	         </div>
	        </c:when>
	      	<c:when test="${obj==3}">
	         <div class="nav-list-skin-3">
	          <a href="${base}/backstage/manage?menuType=3" class="nav3">
	            <h3 class="text-center"><%=ServiceUtil.modRename(3) %></h3>
	          </a>
	         </div>
	        </c:when>
	      	<c:when test="${obj==5}">
	         <div class="nav-list-skin-4">
	          <a href="${base}/backstage/manage?menuType=5" class="nav4">
	            <h3 class="text-center"><%=ServiceUtil.modRename(5) %></h3>
	          </a>
	         </div>
	        </c:when>
	      	<c:when test="${obj==6}">
	      	 <div class="nav-list-skin-5">
	          <a href="${base}/backstage/manage?menuType=6" class="nav5">
	            <h3 class="text-center"><%=ServiceUtil.modRename(6) %></h3>
	          </a>
	         </div>
	        </c:when> 
	        <c:when test="${obj==7}">
	      	 <div class="nav-list-skin-6">
	          <a href="${base}/backstage/manage?menuType=7" class="nav6">
	            <h3 class="text-center"><%=ServiceUtil.modRename(7) %></h3>
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
  </div>
  <p class="last-copyright hidden-xs">Copyright © 2016  国脉海洋信息发展有限公司 </p>
</body>
</html>
<script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
<script src="${base}/static/js/bootstrap.min.js?v=3.3.6"></script>
<script>
$(function() {
  themeInit();
  var item = $('.nav-item-skin div');
  var itemLength = item.length;
  itemHander(item, itemLength);
})

function itemHander (item, length) {
  console.log(length);
  switch(length) {
    case 3:
      item.css({
        width: '33.333%'
      });
      break;
    case 4:
      item.css({
        width: '25%'
      });
      break;
    case 5:
      item.css({
        width: '20%'
      });
      break;
  }
}
function themeInit() {
  $('body').addClass($('.theme').attr('data-skin'));
}

</script>
