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
   <link href="${base}/static/css/plugins/iCheck/_all.css" rel="stylesheet">
   <link href="${base}/static/css/animate.min.css" rel="stylesheet">
</head>
<style>
.panel-container {position: relative;width: 70%;max-width: 700px;min-width: 300px;margin: 20px 100px 20px 100px;}
.panel {border: none;}
.panel:nth-child(2) {position: absolute;top: 0; left:0;display: none;}
.panel .panel-heading {font-size: 18px;color: #666;font-weight: 700;}
.sql-choose img {width: 80px;}
.sql-choose label {cursor: pointer;}
.sql-choose input {display: none;}
.sql-choose div label {position: relative;border: 2px solid rgba(0, 0, 0, 0);border-radius: 4px;}
.sql-choose div label:hover,.sql-choose div label.active {border-color: #ddd;background: -o-linear-gradient(135deg, transparent 90%, #ddd 90%, #ddd 100%);background: -webkit-linear-gradient(135deg, transparent 90%, #ddd 90%, #ddd 100%);background: -moz-linear-gradient(135deg, transparent 90%, #ddd 90%, #ddd 100%);background: linear-gradient(135deg, transparent 90%, #ddd 90%, #ddd 100%);}
.sql-choose div label:hover::after,.sql-choose div label.active::after {content: '\2714';width: 10px;height: 10px;position: absolute;bottom: 8px;right: 5px;color: #fff;}
.sql-choose div label p {margin-top: 5px;color: #666;}
.panel-body {padding: 20px;}
.icheck div {padding-top: 5px;}
.icheck div label {cursor: pointer;margin-right: 0px;padding: 0;overflow: hidden;text-overflow:ellipsis;white-space: nowrap;}
.form-control:focus {border-color: #ddd;outline: 0;-webkit-box-shadow: 0 0 8px #ddd;box-shadow: 0 0 8px #ddd;}
.form-horizontal .control-label {text-align: left;}
.panel-footer {background-color: #fff; border-top: none;}
.panel-default>.panel-heading {background-color: #fff;border: none;}
.panel-container #tables label {position: relative;    padding-left: 26px;}
.error {color: #f00;}
/* .panel-container #tables label input {display: none;}
.panel-container #tables label i {font-size: 16px;margin-right: 5px;} */
</style>
<body>
  <div class="container">
    <div class="row">
      <div class="panel-container">
        <div class="panel panel-default animated">
        <form class="form-horizontal form-database" id="formid">
          <div class="panel-heading"></div>
          <div class="panel-body">
              <div class="form-group">
                <label class="control-label col-sm-3" >原密码:</label>
                <div class="col-sm-9">
                  <input type="text" class="form-control" name="oldpsd" required id="oldPsw">
                </div>
              </div>
              <div class="form-group">
                <label class="control-label col-sm-3" >新密码:</label>
                <div class="col-sm-9">
                  <input type="password" class="form-control" name="newpsd"  required id="newPsd">
                </div>
              </div>
              <div class="form-group">
                <label class="control-label col-sm-3">确认新密码:</label>
                <div class="col-sm-9">
                  <input type="password" class="form-control" name="newpsd2"  required equalTo="#newPsd">
                </div>
              </div>  
          </div>
          <div class="panel-footer clearfix">
            <div class="pull-right">
              <button class="btn btn-default btn-submit" type="submit" onclick="save();">提交</button>
            </div>
          </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</body>
</html>
<%@include file="../../common/includeJS.jsp"%>
<script src="${base}/static/js/plugins/webuploader/webuploader.min.js"></script>
<script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
<script src="${base}/static/js/plugins/validate/jquery.validate.min.js"></script>
<script src="${base}/static/js/plugins/validate/messages_zh.min.js"></script>
<script>
jQuery.validator.addMethod("isWord", function(value, element, param) {
    var reg = /^([0-9a-zA-Z]|_)*$/;
    console.log('val='+value)
    console.log(reg.test(value))
  return this.optional(element) || reg.test(value);   
}, $.validator.format("只能输入字母和数字和下划线"));
$("#formid").validate({
	 messages: {
		 oldpsd: {
			 remote:'原密码错误，请重新输入',
			
		 }
	 },
	rules: {

		 newpsd: {
			 'isWord': true
		 },
		 newpsd2: {
			 'isWord': true
		 },
		oldpsd: {
			 'isWord': true,
			remote: {
				url: "${base}/backstage/account/samepsd",     //后台处理程序
			    type: "post",               //数据发送方式
			    dataType: "json",           //接受数据格式   
			    data: {                     //要传递的数据
			        username: function() {
			            return $("#oldPsw").val();
			        }
			    },
			    dataFilter: function (data) {
			    	console.log('data:'+data);
			    	console.log(!parseInt(data));
                    if (!parseInt(data) ) {
                        return true;
                    }
                    else {
                        return false;
                    }
                }
			}
		}
	},
	 submitHandler: function(form) { 

		 $.ajax({  
		        type: "POST",  
		        url:"${base}/backstage/account/updatepsd",  
		        data:$('#formid').serialize(),// 序列化表单值  
		        async: false,  
		        error: function(request) {  
		            alert("Connection error");  
		        },  
		        success: function(data) {  
		        	layer.msg('修改成功，即将跳转...');
		        	setTimeout(function() { window.parent.location.href='${base}/backstage/index'}, 2000);
		           
		        }  
		    });

} 
});

</script>