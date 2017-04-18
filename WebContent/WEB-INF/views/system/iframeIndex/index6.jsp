<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">

<head>
	<%@include file="../common/includeBaseHead.jsp"%>
	<link href="${base}/static/css/style.css?v=4.1.0" rel="stylesheet">
	<link href="${base}/static/css/index.css" rel="stylesheet">
	<link rel="stylesheet" href="${base}/static/css/skin/skin-<%=ServiceUtil.getThemeType(10)%>.css">
</head>
<style>
.label-primary, .badge-primary {
    background-color: #319cdf !important;
}
.header .name img ,
.header .name span,
.message-group .count-info,
.header .btn-signout{
  border-color: #d7d7d7;
}
.header {
    height: 80px;
    min-width: 997px;
    padding: 0 60px;
    background-color: rgba(255, 255, 255, .7);
    box-shadow: 0px 0px 20px 4px rgba(0, 0, 0, .2);
    margin-bottom: 10px;
}
</style>
<body id="body-bg">
	<div class="body-height" style="position: absolute;top:0;left:0;width: 100%;">
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
	      </div>
	    </div>
	  </div>
	</header>
	<div style="margin-top: 10px;height:calc(100vh - 90px)">
	   <iframe class="" name="iframe0" width="100%" height="100%" src="https://www.baidu.com" style="height:calc(100vh);background: #fff;border:none;"></iframe>
	</div> 
	</div>
	<script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
	<script src="${base}/static/js/bootstrap.min.js?v=3.3.6"></script>
	<script src="${base}/static/js/particles.min.js"></script>
	<script>
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
</body>
</html>