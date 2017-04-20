<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">

<head>
<%@include file="../../common/includeBaseHead.jsp"%>
<link href="${base}/static/plugins/jqgrid/ui.jqgrid.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${base}/static/css/plugins/webuploader/webuploader.css">
<link rel="stylesheet" type="text/css" href="${base}/static/css/demo/webuploader-demo.css">
<link href="${base}/static/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="${base}/static/css/style.css?v=4.1.0" rel="stylesheet">
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">
  <div class="wrapper wrapper-content  animated fadeInRight">
    <div class="ibox float-e-margins">
      <div class="ibox-content">
        <div id="toolbar">
          <div class="form-inline">
            <div class="form-group clearfix">
              <div class="pull-left" >
               <input type="text" placeholder="输入名称" name="sortN" class="form-control col-sm-8 input-hook">
               <button id="searchButton" type="searchButton" onclick="searchButton();" href="#" class="btn btn-primary">搜索</button>
               <c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/sortManager/index?type=3\") %>">
               <a data-toggle="modal" class="btn btn-primary" onclick="addNew();" href="#">新增</a>
               </c:if>
               <c:if test="<%=!ServiceUtil.haveImp(\"/backstage/sortManager/index?type=3\") %>">
               <a data-toggle="modal" class="btn btn-primary" onclick="importFromExcel();" href="#">Excel导入</a>
               </c:if>
              </div>
            </div>
            <div class="clearfix" style="margin-bottom: 20px;"></div>
            <div class="jqGrid_wrapper">
              <table id="table_list_2"></table>
              <div id="pager_list_2"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div id="layer_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="eform">
      <input type="hidden" name="id" class="form-control">
      <input type="hidden" name="idForShow">
      <input type="hidden" name="type">
      <input type="hidden" name="sortId">
      <input type="hidden" name="level">
      <div class="form-group">
        <label class="col-sm-3 control-label">代码：</label>
        <div class="col-sm-7">
          <input type="text" name="sortCode" class="form-control" required>
        </div>
      </div>
      <div class="form-group">
        <label class="col-sm-3 control-label">名称：</label>
        <div class="col-sm-7">
          <input type="text" name="sortName" class="form-control" required>
        </div>
      </div>
    </form>
  </div>
  <!-- excel导入开始 -->
  <div id="import_form" style="display: none;" class="ibox-content">
    <form method="post" class="form-horizontal" id="importForm">
      <div class="form-group" style="padding:10px;">
        <div class="alert alert-info">
          请先下载模版，根据模版填写数据。 <a class="alert-link" href="${base}/upload/excel/sortmanagerExcel.xls">Excel模版下载</a>.
          <br /> 如导入数据量大，上传请耐心等待！
        </div>
        <div id="uploader-demo">
          <label class="col-sm-3 control-label"></label>
          <div class="col-sm-7">
            <label class="col-sm-3" id="img_label"> </label>
            <div class="col-sm-9" id="filePicker">上传数据文件</div>
          </div>
        </div>
      </div>
      <div class="ibox float-e-margins">
        <div class="ibox-content" id="error-msg">
        </div>
      </div>
    </form>
  </div>

  <!-- excel导入结束 -->

</body>
</html>

<%@include file="../../common/includeJS.jsp"%>
<script src="${base}/static/plugins/jqgrid/i18n/grid.locale-cn.js"></script>
<script src="${base}/static/plugins/jqgrid/jquery.jqGrid.min.js"></script>
<script src="${base}/static/js/plugins/webuploader/webuploader.min.js"></script>
  <!-- Chosen -->
<script src="${base}/static/js/plugins/chosen/chosen.jquery.js"></script>
<script>
var layerIndex;//layer 窗口对象
var title_name="资源分类模板";
var layerContent='#layer_form';//layer窗口主体内容dom Id
var formId='#eform';//form id
var url='${base}/backstage/sortManager/';//controller 路径
var tableId='#table_list_2';
var treeData;
var BASE_URL = '${base}/static/js/plugins/webuploader';
var $list=$("#fileList");
var uploader;
var inited=0;

function initUploader(){
  if(inited==0){
    inited=1;
  }else{
    uploader.destroy();
  }
  uploader = WebUploader.create({

    // 选完文件后，是否自动上传。
    auto: true,

    // swf文件路径
    swf: BASE_URL + '/Uploader.swf',
    timeout: 0,
    // 文件接收服务端。/backstage/sortManager/importData
    server: base+'/backstage/sortManager/importData?belong=1',
    threads :1,
    fileNumLimit:1,
    // 选择文件的按钮。可选。
    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
    pick: '#filePicker',

    // 只允许选择Excel文件。
    accept: {
        title: 'Excel',
        extensions: 'xls,xlsx',
        mimeTypes: 'Excel/*'
    }
  });
  
  uploader.on( 'fileQueued', function( file ) {
	  var html = '<div class="zz"><p><i class="fa fa-refresh fa-spin" ></i><br><span style="font-size: 14px;font-weight: 700;">拼命上传中</span></p></div>';

	    $('.layui-layer').append(html);
    $('#filePicker .webuploader-pick').addClass('grey').html('上传中<i class="fa fa-refresh fa-spin" style="margin-left:10px;"></i>');
    $('input[type="file"]').attr('disabled',true);
  });

  // 文件上传成功，给item添加成功class, 用样式标记上传成功。
  uploader.on( 'uploadSuccess', function( file,response) {
      console.log(response);
      if(response.res==1){
        layer.close(layerIndex);
        layer.msg('导入成功');
        $(tableId).trigger('reloadGrid');
      }else{
        $('#error-msg').html('<div class="alert alert-danger">'+response.resMsg+'</div>');
      }
      $('#filePicker .webuploader-pick').removeClass('grey').html('上传数据文件');
      $('input[type="file"]').attr('disabled',false);
      $('.zz').remove();
  });

  // 文件上传失败，显示上传出错。
  uploader.on( 'uploadError', function( file ) {
    layer.msg('上传失败');
      $('#filePicker .webuploader-pick').removeClass('grey').html('上传数据文件');
      $('input[type="file"]').attr('disabled',false);
      $('.zz').remove();
  });

    // 完成上传完了，成功或者失败，先删除进度条。
    uploader.on( 'uploadComplete', function( file ) {
        $( '#'+file.id ).find('.progress').remove();
    });

  }
  
function importFromExcel(){
  $('#importForm').form('clear');
  initUploader();
  $('#importForm').valid();
  layerIndex=layer.open({
    type: 1,
    area: ['60%', '80%'], //宽高
    title: '从Excel导入',
    offset: '0',
    cancel:function(){
      $('#error-msg').html('');
    },
    content: $('#import_form') //这里content是一个DOM
  });
}

//验证名称重复
$("input[name='sortName']").blur(function (){
  jQuery.post("${base}/backstage/sortManager/validation",{"sortName":$("input[name='sortName']").val(),"id":$("input[name='id']").val(),"level":$("input[name='level']").val(),type:3},function(data){
    data=JSON.parse(data); 
    if(data.results==1){
     // layer.msg("名称已存在，请重新填写");
      //$("input[name='sortName']").val("");
    }
  });
});

//验证代码重复
$("input[name='sortCode']").blur(function (){
  jQuery.post("${base}/backstage/sortManager/validation",{"sortCode":$("input[name='sortCode']").val(),"id":$("input[name='id']").val(),type:3},function(data){
    data=JSON.parse(data); 
    if(data.results==1){
     // layer.msg("代码已存在，请重新填写");
      //$("input[name='sortCode']").val("");
    }
  });
});

  $(document).ready(function () {
        $.jgrid.defaults.styleUI = 'Bootstrap';

        $(tableId).jqGrid({
          treeGrid: true,
            treeGridModel: 'adjacency', //treeGrid模式，跟json元数据有关 ,adjacency/nested
            ExpandColumn : 'name',
            scroll: true,
            autowidth: true,
            shrinkToFit: false,//是否默认宽度
            forceFit: true,
            url: url+"/jqGridTreeJson?type=3",
            datatype: 'json',
            colNames:['代码','名称','操作'],
            colModel:[
                {name:'sortCode',index:'sortCode', width:200,sortable: false},
                {name:'sortName',index:'sortName', width:170,sortable: false,formatter:longFormatter},
                {name:'id',index:'id', width:400, align:'center',sortable: false, formatter:button}
            ],//name 列显示的名称；index 传到服务器端用来排序用的列名称；width 列宽度；align 对齐方式；sortable 是否可以排序
            pager: "false",
            treeReader : {
                level_field: "level",//层次结构中的级别
                parent_id_field: "sortId",//记录父类id
                leaf_field: "isLeaf",//是否叶节点
                icon_field:"_icon",
                expanded_field: "expanded"//是否该元素在加载过程中应展开
            },
            // caption: "前台菜单",
            hidegrid: false,
            mtype: "get",
            height: 550,    // 设为具体数值则会根据实际记录数出现垂直滚动条
            rowNum : "-1",     // 显示全部记录
            shrinkToFit:true,  // 控制水平滚动条
            loadComplete:function(data){
              treeData=data;
            }
        });

      function longFormatter(value, row, index)
      {
        var html='<span title="'+value+'">';
        if(value.length>8){
          html+=value.substring(0,8)+"...";
        }else{
          html+=value;
        }
        html+='</span>';
        return html;
      }
      
        function button(cellvalue, options, rowObject){
          var html='';
          html+='<div class="btn-group">';
          //html+='<button type="button" class="btn btn-default">按钮 1</button>';
          <c:if test="<%=!ServiceUtil.haveAdd(\"/backstage/sortManager/index?type=3\") %>">
          html+='<button type="button" class="btn btn-white" onclick="addSon(\''+rowObject.idForShow+'\')"><i class="fa fa-plus"></i>&nbsp;添加子级</button>';
          </c:if>
          <c:if test="<%=!ServiceUtil.haveEdit(\"/backstage/sortManager/index?type=3\") %>">
          html+='<button type="button" class="btn btn-white" onclick="editRow(\''+rowObject.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
          </c:if>
          <c:if test="<%=!ServiceUtil.haveDel(\"/backstage/sortManager/index?type=3\") %>">
          if(rowObject.id!=1&&rowObject.id!=2){
          html+='<button type="button" class="btn btn-white" onclick="deleteRow(\''+rowObject.idForShow+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
          }
          </c:if>
          html+='</div>';
          return html;
        }

         $(window).resize(function(){   
         $(tableId).setGridWidth($('.ibox-content').width());
        });    
    });
  
  $.validator.setDefaults({
      highlight: function (element) {
          $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
      },
      success: function (element) {
          element.closest('.form-group').removeClass('has-error').addClass('has-success');
      },
      errorElement: "span",
      errorPlacement: function (error, element) {
          if (element.is(":radio") || element.is(":checkbox")) {
              error.appendTo(element.parent().parent().parent());
          } else {
              error.appendTo(element.parent());
          }
      },
      errorClass: "help-block m-b-none",
      validClass: "help-block m-b-none"
  });

  function openLayer(){
    $(formId).form('clear');
    $(formId).valid();
    layerIndex=layer.open({
      type: 1,
      area: ['60%', '80%'], //宽高
      title: '资源分类新增',
      scrollbar: false,
      btn: ['保存','关闭'],
      yes: function(index, layero){
        $(formId).submit();
      },
      offset: '0',
      content: $(layerContent) //这里content是一个DOM
    });
  }

  $(function () {
    $(formId).validate( {ignore: ""});
  });

  $(formId).form({  
      url: url+'insertAjax?type=3&belong=1',  
      onSubmit: function(){
        return $(formId).valid();
      },  
      success: function(result){ 
        var result = eval('('+result+')');
        if(result.code && result.code==1){
          layer.close(layerIndex);
           $(tableId).trigger('reloadGrid');
        }
        layer.msg(result.msg);
      }
  });
  
  function deleteRow(id){
    layer.confirm('删除的同时将删除它的所有子集，您确定要删除么？', {
        btn: ['确定','取消'] //按钮
      }, function(){
        $.post(url+'deleteAjax',{idForShow:id},function(result){  
          if(result.code && result.code==1){
              layer.close(layerIndex);
               $(tableId).trigger('reloadGrid');
            }
            layer.msg(result.msg);
            },'json');
      }, function(){
        
      });
  }

  function addNew(){
    openLayer();
    $('input[name="sortId"]').val(0);
    $('input[name="level"]').val(1);
    $('input[name="type"]').val(1);
  }
  
  function addSon(id){
    $(formId).form('clear');
    $(formId).valid();
    layerIndex=layer.open({
      type: 1,
      area: ['60%', '80%'], //宽高
      title: '资源分类子级新增',
      scrollbar: false,
      btn: ['保存','关闭'], 
      yes: function(index, layero){
        $(formId).submit();
      },
      offset: '0',
      content: $(layerContent) //这里content是一个DOM
    });
    for(var i=0;i<treeData.length;i++){
      if(treeData[i].idForShow==id){
        $('input[name="sortId"]').val(treeData[i].id);
        $('input[name="level"]').val(++treeData[i].level);
        $(formId).valid();
      }
    }
  }
  
  function editRow(id){
    $(formId).form('clear');
    $(formId).valid();
    layerIndex=layer.open({
      type: 1,
      area: ['60%', '80%'], //宽高
      title: '资源分类修改',
      scrollbar: false,
      btn: ['保存','关闭'], 
      yes: function(index, layero){
        $(formId).submit();
      },
      offset: '0',
      content: $(layerContent) //这里content是一个DOM
    });
    for(var i=0;i<treeData.length;i++){
      if(treeData[i].idForShow==id){
        $(formId).form('load',treeData[i]);
        $(formId).valid();
      }
    }
  }
//查询  
	function searchButton() {
	 var sortN=$('input[name="sortN"]').val();
  //传入查询条件参数  
  $(tableId).jqGrid("setGridParam",{postData:{"sortN":sortN}});   
  //每次提出新的查询都转到第一页  
  $(tableId).jqGrid("setGridParam",{page:1});  
  //提交post并刷新表格  
  $(tableId).jqGrid("setGridParam",{url:"${base}/backstage/sortManager/search1"}).trigger("reloadGrid");  
};  
</script>
