<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
<style type="text/css">
.c-list{
cursor: auto !important;
}
.c-list li{
cursor: pointer !important;
}

.c-list li.search-choice{
padding: 3px 5px 3px 5px !important;

}
.dt-span{
padding-top: 7px;
margin-bottom: 0;
text-align: left;
}
</style>
</head>
<body class="white-bg">
<div class="wrapper wrapper-content animated fadeInRight">
  <div class="ibox float-e-margins">
    <div class="ibox-content">
      <table id="dicList">
      </table>
    </div>
  </div>
</div>
<!--信息资源模版详情开始-->
<div id="informationRes-detail" class="form-horizontal" style="overflow: hidden; display: none;">
  <div class="ibox float-e-margins">
    <div class="ibox-content">
      <div class="form-group">
        <label class="col-sm-6 control-label">信息资源</label>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">信息资源名称</label> <span class="col-sm-8 dt-span" name="value1"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">信息资源码</label> <span class="col-sm-8 dt-span" name="value2"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">信息资源摘要</label> <span class="col-sm-8 dt-span" name="value5"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-6 control-label">业务信息</label>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">事项名称</label> <span class="col-sm-8 dt-span" name="itemName"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">服务对象分类</label> <span class="col-sm-8 dt-span" name="serObjSort"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">服务内容</label> <span class="col-sm-8 dt-span" name="serContent"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">时限</label> <span class="col-sm-8 dt-span" name="deadline"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-6 control-label">应用系统</label>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">应用系统编号</label> <span class="col-sm-8 dt-span" name="appsystemNum"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">应用系统名称</label> <span class="col-sm-8 dt-span" name="appsystemName"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">单位名称</label> <span class="col-sm-8 dt-span" name="acompanyId"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">所在网络</label> <span class="col-sm-8 dt-span" name="network"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-6 control-label">存储器</label>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">存储器编号</label> <span class="col-sm-8 dt-span" name="memorizerNum"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">单位名称</label> <span class="col-sm-8 dt-span" name="mcompanyId"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">存储器品牌</label> <span class="col-sm-8 dt-span" name="memorizerBrand"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">存储器型号</label> <span class="col-sm-8 dt-span" name="memorizerModel"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-6 control-label">服务器</label>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">服务器编号</label> <span class="col-sm-8 dt-span" name="serverNum"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">单位名称</label> <span class="col-sm-8 dt-span" name="scompanyId"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">服务器品牌</label> <span class="col-sm-8 dt-span" name="serverBrand"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">服务器型号</label> <span class="col-sm-8 dt-span" name="serverModel"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-6 control-label">所属机房</label>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">机房编号</label> <span class="col-sm-8 dt-span" name="cproomNum"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">单位名称</label> <span class="col-sm-8 dt-span" name="ccompanyId"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">机房面积</label> <span class="col-sm-8 dt-span" name="cproomArea"></span>
      </div>
      <div class="form-group">
        <label class="col-sm-4 control-label">UPS型号</label> <span class="col-sm-8 dt-span" name="upsModel"></span>
      </div>
    </div>
  </div>
</div>
<div id="main5">
  <div id="main4" class="form-horizontal" style="height:600px;"></div>
</div>

  <!--信息资源模版详情结束-->  
</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script src="${base}/static/js/plugins/echarts/echarts-all.js"></script>
<script>    
    function dshow(id) {
      $.getJSON("relation?id=" + id, function(data) {
    	  var cats = data.cate;
    	  var catries = [];
    	  for(i=0;i<cats.length;i++){
        	  var unit = {};
    		  unit.name=cats[i];
    		  catries.push(unit);
    	  }
    	  console.info(data);
    	  console.info(catries);
        $("#main5").show();
        var myChart4 = echarts.init(document.getElementById('main4'));
    	   var option = {
   		        title: {
   		          // text: '人物关系：乔布斯',
   		          //subtext: '数据来自人立方',
   		          x: 'right',
   		          y: 'bottom'
   		        },
   		        tooltip: {
   		          trigger: 'item',
   		          formatter: '{a} : {b}'
   		        },
   		        toolbox: {
   		          show: true,
   		          feature: {
   		            restore: { show: true },
   		            magicType: { show: true, type: ['force', 'chord'] },
   		            saveAsImage: { show: true }
   		          }
   		        },
   		        legend: {
   		          x: 'left',
   		          data: data.cate
   		        },
   		        series: [{
   		          type: 'force',
   		          name: "关系分析",
   		          ribbonType: false,
   		          categories: catries,
   		          itemStyle: {
   		            normal: {
   		              label: {
   		                show: true,
   		                textStyle: {
   		                  color: '#333'
   		                }
   		              },
   		              nodeStyle: {
   		                brushType: 'both',
   		                borderColor: 'rgba(255,215,0,0.4)',
   		                borderWidth: 1
   		              },
   		              linkStyle: {
   		                type: 'curve'
   		              }
   		            },
   		            emphasis: {
   		              label: {
   		                show: false
   		                  // textStyle: null      // 默认使用全局文本样式，详见TEXTSTYLE
   		              },
   		              nodeStyle: {
   		                //r: 30
   		              },
   		              linkStyle: {}
   		            }
   		          },
   		          useWorker: false,
   		          minRadius: 15,
   		          maxRadius: 25,
   		          gravity: 1.1,
   		          scaling: 1.1,
   		          roam: 'move',
   		          nodes: data.node,
   		          links:data.link
   		        }]
   		      };
       
       
		      myChart4.setOption(option);
        layer.open({
          type: 1,
          shade: false,
          area: ['98%', '96%'], //宽高
          scrollbar: false,
          title: false, //不显示标题
          content: $("#main4"), //这里content是一个DOM，注意：最好该元素要存放在body最外层，否则可能被其它的相对元素所影响
          cancel: function() {
            $("#main5").hide();
          }
        });

      });
    }
    var tableId = '#dicList'; //bootstrap-table id
    var toolbar = '#toolbar'; //bootstrap-table 工具栏id
    var url = '${base}/backstage/information/resource/'; //controller 路径
    //bootstrap-table 列数
    var columns = [{
      field: 'value2',
      title: '信息资源代码'
    }, {
      field: 'value1',
      title: '信息资源名称',
      formatter: 'longFormatter',
    }, {
      field: 'id',
      title: '操作',
      formatter: 'doFormatter', //对本列数据做格式化
    }];

    function longFormatter(value, row, index) {
      var html = '<span title="' + value + '">';
      if (value.length > 10) {
        html += value.substring(0, 10) + "...";
      } else {
        html += value;
      }
      html += '</span>';
      return html;
    }
    //得到查询的参数
    var queryParams = function(params) {

      var temp = { //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
        rows: params.limit,
        page: params.offset / params.limit + 1,
        status: 0,
        value6: 0,
      };
      return temp;
    };
    $(function() {
      oTable = new TableInit();
      oTable.Init();
    });

    //查看方法 参数（当前行的id,TableId,div,弹窗类型，默认小窗口）
    function detail(id) {
      var sp = $('#informationRes-detail span');
      jQuery.ajax({
        type: "GET",
        url: url + "relation",
        data: { id: id },
        dataType: "json",
        success: function(data) {
          if (sp.length) {
            for (var i = 0; i < sp.length; i++) {
              $(sp[i]).html("无");
            }
            for (var i = 0; i < sp.length; i++) {
              if ($(sp[i]).attr('name') && $(sp[i]).attr('name') != null) {
                var nm = $(sp[i]).attr('name');
                if (data[nm]) {
                  $(sp[i]).html(data[nm]);
                }
              }
            }
          }
          layer.open({
            type: 1,
            shade: false,
            area: ['500px', '500px'], //宽高
            scrollbar: false,
            title: false, //不显示标题
            content: $("#informationRes-detail")
          });
        }
      });
    }
    var TableInit = function() {
      var oTableInit = new Object();
      //初始化Table
      oTableInit.Init = function() {
        $(tableId).bootstrapTable({
          url: url + 'listAjax', //请求后台的URL（*）
          method: 'post', //请求方式（*）
          contentType: "application/x-www-form-urlencoded",
          toolbar: toolbar, //工具按钮用哪个容器
          iconSize: 'outline',
          striped: true, //是否显示行间隔色
          cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
          pagination: true, //是否显示分页（*）
          sortable: false, //是否启用排序
          sortOrder: "asc", //排序方式
          queryParams: queryParams, //传递参数（*）
          sidePagination: "server", //分页方式：client客户端分页，server服务端分页（*）
          pageNumber: 1, //初始化加载第一页，默认第一页
          pageSize: 10, //每页的记录行数（*）
          pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
          strictSearch: true,
          clickToSelect: false, //是否启用点击选中行
          uniqueId: "idForShow", //每一行的唯一标识，一般为主键列
          cardView: false, //是否显示详细视图
          detailView: false,
          showRefresh: true,
          showToggle: true,
          showColumns: true,
          queryParamsType: "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
          columns: columns
        });
      };
      return oTableInit;
    };

    function doFormatter(value, row, index) {
      var html = '';
      html += '<div class="btn-group">';
      //html+='<button type="button" class="btn btn-default">按钮 1</button>';
      html += '<button type="button" class="btn btn-white" onclick="dshow(\'' + row.id + '\')"><i class="fa fa-pencil"></i>&nbsp;关系展现</button>';
      //html += '<button type="button" class="btn btn-white" onclick="detail(\'' + row.id + '\')"><i class="fa fa-pencil"></i>&nbsp;查看关系</button>';
      html += '</div>';
      return html;
    }

  
</script>