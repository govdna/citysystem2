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
  <link href="${base}/static/css/bootstrap-datetimepicker.min.css" rel="stylesheet">
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
.gjpz div .pull-left input{width: calc(100% - 45px);float:left;}
.gjpz div .pull-left label{line-height: 34px;text-align: center;width: 40px;}
.gjpz div .pull-left{width: 50%;}
/* .panel-container #tables label input {display: none;}
.panel-container #tables label i {font-size: 16px;margin-right: 5px;} */
</style>
<body>
  <div class="container">
    <div class="row">
      <div class="panel-container">
        <div class="panel panel-default animated">
          <div class="panel-heading"></div>
          <div class="panel-body">
            <form class="form-horizontal form-database">
              <div class="form-group sql-choose">
                <label class="col-sm-3 control-label" style="margin-top: 40px;">数据库选择:</label>
                <div class="col-sm-9">
                  <label class="col-sm-6 text-center active">
                    <input type="radio" name="value1" value="mysql" checked><img src="${base}/static/images/sql/mysql.jpg" width="100" height="75">
                    <p class="text-center">mysql数据库</p>
                  </label>
                  <label class="col-sm-6 text-center">
                    <input type="radio" name="value1" value="oracle"><img src="${base}/static/images/sql/oracle.jpg" width="100" height="75">
                    <p class="text-center">oracle数据库</p>
                  </label>
                </div>
              </div>
              <div class="form-group">
                <label class="control-label col-sm-3">用户名:</label>
                <div class="col-sm-9">
                  <input type="text" class="form-control" name="value2">
                </div>
              </div>
              <div class="form-group">
                <label class="control-label col-sm-3">密码:</label>
                <div class="col-sm-9">
                  <input type="text" class="form-control" name="value3">
                </div>
              </div>
              <div class="form-group">
                <label class="control-label col-sm-3">数据库连接地址:</label>
                <div class="col-sm-9">
                  <input type="text" class="form-control" name="value4">
                </div>
              </div>
              <div class="form-group">
                <label class="control-label col-sm-3">端口:</label>
                <div class="col-sm-9">
                  <input type="text" class="form-control" name="value5">
                </div>
              </div>
              
              <div class="form-group">
                <label class="control-label col-sm-3">数据库名:</label>
                <div class="col-sm-9">
                  <input type="text" class="form-control" name="value6">
                </div>
              </div>
              <div class="form-group sid" style="display:none;">
                <label class="control-label col-sm-3">SID:</label>
                <div class="col-sm-9">
                  <input type="text" class="form-control" name="value7">
                </div>
              </div>
               <div class="form-group peizhi">
                <label class="control-label col-sm-3">数据库名:</label>
                <div class="col-sm-9">
                  <label><input type="radio" name="iCheck" value="1">是</label>　　
                  <label><input type="radio" name="iCheck" value="0">否</label>
                </div>
              </div>
              <div class="form-group gjpz" style="display:none;">
                <label class="control-label col-sm-3">高级配置:</label>
                <div class="col-sm-9 clearfix">
                  <div class="pull-left">
                      <label class='pull-left'>周期</label>
                      <input type="text" class="form-control pull-left" name="value6">
                  </div>
                  <div class="pull-left">
                    <div>
                      <label class='pull-left'>时间</label>
                      <input type="text" class="form-control pull-left form_datetime1" name="value6" style="">
                    </div>
                  </div>
                </div>
              </div>
              <!-- <div class="form-group icheck">
                <label class="control-label col-sm-3">数据源状态:</label>
                <div class="col-sm-9">
                  <label>
                    <input type="radio" name="iCheck">　启用</label>
                  <label>
                    <input type="radio" name="iCheck">　禁用</label>
                </div>
              </div> -->
            </form>
          </div>
          <div class="panel-footer clearfix">
            <div class="pull-right">
              <button class="btn btn-default btn-test" type="button">连接数据库测试</button>
              <button class="btn btn-default btn-submit" type="submit">提交</button>
            </div>
          </div>
        </div>
        <div class="panel panel-default animated">
          <div class="panel-heading"></div>
          <div class="panel-body">
            <form class="form form-table" action="${base}/backstage/sql/listFields">
              <div class="form-group icheck">
                <label class="control-label col-sm-12" style="margin-left: 30px;">数据表:</label>
                <div id="tables" class="col-sm-12"></div>x
              </div>
            </form>
            </div>
            <div class="panel-footer clearfix">
              <button class="btn btn-default pull-right btn-table" type="submit">提交</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
<script src="${base}/static/js/bootstrap-datetimepicker.min.js"></script>
<script src="${base}/static/js/bootstrap-datetimepicker.zh-CN.js"></script>
<script src="${base}/static/js/plugins/iCheck/icheck.min.js"></script>
<script src="${base}/static/js/plugins/layer/layer.js"></script>
<script>
  $(function() {
      $('.peizhi input').click(function() {

        //console.log($(this).val());
        if (+$(this).val()) {
          console.log(1);
          $('.gjpz').show();
        }else {
          $('.gjpz').hide();

        }
    });
     $('.icheck input').iCheck({
      checkboxClass: 'icheckbox_square-grey',
         radioClass: 'iradio_square-grey'
     });
    //  $('.icheck input').on('ifClicked', function(event){
    //   alert(111);
    // });
	  $('.form_datetime1').datetimepicker({
		  language: 'zh-CN',
		  // weekStart: 1,
		  // todayBtn: 1,
		  autoclose: 1,
		  //todayHighlight: 1,
		  startView: 1,
		  forceParse: 0,
		  //showMeridian: 1,
		  format: 'hh:ii',
		  pickerPosition: "top-left",
      	// minView: 0,
      minuteStep:5,
		  zIndex: 100000000000
		});
    /*$('.peizhi input').click(funciton() {
      console.log($(this).val());
    });*/

        $('.icheck input').iCheck({
        	checkboxClass: 'icheckbox_square-grey',
            radioClass: 'iradio_square-grey'
        });
        $('.sql-choose div label').on('click', function() {
          $(this).addClass('active').siblings().removeClass('active');
          if($(this).find("input").val()=='oracle'){
        	  $('.sid').show();
          }else{
        	  $('.sid').hide();
          }
        });
        $('.btn-submit').on('click', function () {
        	$.ajax({
                type: "GET",
                url: "${base}/backstage/sql/listAllTales",
                data: $('.form-database').serialize(),
                dataType: "json",
                success: function(data){
                		   console.log(data)
                           if(data.length>0){
                        	   var html = '';
                        	   for(var i=0,l=data.length;i<l;i++){
                        		  html+='<label class="col-sm-4"><input type="checkbox" name="iCheck" value="'+data[i]+'"> '+data[i]+'</label>';
                        	   }
                        	   $('#tables').html(html);
                             $('.icheck input').iCheck({
                                checkboxClass: 'icheckbox_square-grey',
                                   radioClass: 'iradio_square-grey'
                               });
                        	   $('.panel:eq(0)').addClass('fadeOutLeft');
                             $('.panel:eq(1)').show().addClass('fadeInRight');
                           }else{
                        	   layer.msg("连接失败，请仔细检查配置项！");
                           }
                         }
            });
          
        });
        $('.btn-test').on('click', function () {
        	$.ajax({
                type: "GET",
                url: "${base}/backstage/sql/listAllTales",
                data: $('.form-database').serialize(),
                dataType: "json",
                success: function(data){
                		   console.log(data);
                           if(data.length>0){
                        	   layer.msg("success")
                           }else{
                        	   layer.msg("连接失败，请仔细检查配置项！");
                           }
                         }
            });
          });
        $('.btn-table').on('click', function () {
        	$('.form-table').submit();
          });
        });        
</script>
</body>

</html>
