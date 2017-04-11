<%@ page import="com.govmade.common.utils.security.AccountShiroUtil" %>
<script>
var chosenInited=0;
var isDetailed=0;
var contentHtml;
var t_name="";
if(typeof(title_name)!="undefined"){
	t_name=title_name;
}

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


function disableChosen(){
	var cs=$(".chosen-select");
	if(cs.length){
		for(var i=0;i<cs.length;i++){
			if($(cs[i]).attr('data-bind')){
				var cid=$(cs[i]).attr('data-bind');
				if(!$(cs[i]).val()){
					$(cid).attr('disabled', true).trigger("chosen:updated");
				}else{
					$(cid).attr('disabled', false).trigger("chosen:updated");
				}
			}
			
		}
	}
	var cs=$(".chosen-select[data-level='2']");
	if(cs.length){
		for(var i=0;i<cs.length;i++){
			if($(cs[i]).attr('data-bind')){
				var cid=$(cs[i]).attr('data-bind');
				if(!$(cs[i]).val()){
					$(cid).attr('disabled', true).trigger("chosen:updated");
				}else{
					$(cid).attr('disabled', false).trigger("chosen:updated");
				}
			}
			
		}
	}
	var cs=$(".chosen-select[data-level='3']");
	if(cs.length){
		for(var i=0;i<cs.length;i++){
			if($(cs[i]).attr('data-bind')){
				var cid=$(cs[i]).attr('data-bind');
				if(!$(cs[i]).val()){
					$(cid).attr('disabled', true).trigger("chosen:updated");
				}else{
					$(cid).attr('disabled', false).trigger("chosen:updated");
				}
			}
			
		}
	}
	var cs=$(".chosen-select[data-level='4']");
	if(cs.length){
		for(var i=0;i<cs.length;i++){
			if($(cs[i]).attr('data-bind')){
				var cid=$(cs[i]).attr('data-bind');
				if(!$(cs[i]).val()){
					$(cid).attr('disabled', true).trigger("chosen:updated");
				}else{
					$(cid).attr('disabled', false).trigger("chosen:updated");
				}
			}
			
		}
	}
}
$('.form_datetime').datetimepicker({
    language:  'zh-CN',
    weekStart: 1,
    todayBtn:  1,
  	autoclose: 1,
  	todayHighlight: 1,
  	forceParse: 0,
    //showMeridian: 1,
    format: 'yyyy-mm-dd',
    pickerPosition: "bottom-left",
    startView: 2,
    minView: 2,
    zIndex: 100000000000
});
//初始化下拉框
function initChosen(fId){
	disableChosen();
	if(chosenInited==0){
		chosenInited=1;
	}else{
		$(".chosen-select").val("");
		$(".chosen-select").trigger("chosen:updated");
		return;
	}
	var chosen=$(".chosen-select").chosen({
		disable_search_threshold: 10,
		no_results_text: "没有匹配到这条记录",
		search_contains: true,
        width: "100%"
  });
	
	chosen.on('change', function(e, params) {
		if($(this).attr('data-bind')){
			var cid=$(this).attr('data-bind');
			if($(this).val()==''){
				$(cid).val('');
				$(cid).attr('disabled', true).trigger("chosen:updated");
			}else{
				$(cid).attr('disabled', false).trigger("chosen:updated")
				var  p = {};
				p[$(this).attr("data-param")] =$(this).val();
				initAjaxChosen(cid,$(cid).attr('data-url'),p);
			}
			
		}
		if(typeof(fId)=='undefined'){
			$(formId).valid();
		}else{
			$(fId).valid();
		}
			
	});
	
	$(".chosen-select").trigger("chosen:updated");
	
}

//notValid不进行验证
function initAjaxChosen(cid,url,p,value,notValid,isEdit){
	$.get(url,p,function(r){
		if(typeof(isEdit)!="undefined"){
			var th=cid;
			while ($(th).attr('data-bind'))
			{
				th=$(th).attr('data-bind');
				$(th).val('');
				$(th).attr('disabled', true).trigger("chosen:updated");
			}
		}
		
	
		
			var html='<option value=""></option>';
			var keyField=$(cid).attr('data-keyField');
			var valueField=$(cid).attr('data-valueField');
			for(var i=0;i<r.length;i++){
				var item=r[i];
				if(typeof($(cid).attr('formatter'))!='undefined'&&$(cid).attr('formatter')!=''){
					html+='<option value="'+item[keyField]+'">'+eval($(cid).attr('formatter')+'(item[valueField],item,i)')+'</option>';
				}else{
					html+='<option value="'+item[keyField]+'">'+item[valueField]+'</option>';
				}
				
			}
			$(cid).html(html);
			$(cid).val(value);
			if($(layerContent+' span[data-name="'+$(cid).attr('name')+'"]')){
				var vl=$(cid).find('option[value="'+value+'"]').html();
				$(layerContent+' span[data-name="'+$(cid).attr('name')+'"]').html(vl);
			}
			$(".chosen-select").trigger("chosen:updated");
			disableChosen();
			if(!notValid){
				$(formId).valid();
			}
		
	},'json');
}	


//notValid不进行验证
function jlChosen(cid,url,p,value){
	$.get(url,p,function(r){
			var html='<option value=""></option>';
			var keyField=$(cid).attr('data-keyField');
			var valueField=$(cid).attr('data-valueField');
			for(var i=0;i<r.length;i++){
				var item=r[i];
				html+='<option value="'+item[keyField]+'">'+item[valueField]+'</option>';
			}
			$(cid).html(html);
			$(cid).val(value[0]);
			if($(layerContent+' span[data-name="'+$(cid).attr('name')+'"]')){
				var vl=$(cid).find('option[value="'+value+'"]').html();
				$(layerContent+' span[data-name="'+$(cid).attr('name')+'"]').html(vl);
			}
			$(".chosen-select").trigger("chosen:updated");
			disableChosen();
			var arr=new Array();
			if(value.length>1){
				for(var i=1;i<value.length;i++){
					arr.push(value[i]);
				}
				var  p = {};
				p[$(cid).attr("data-param")] =$(cid).val();

				cid=$(cid).attr('data-bind');
				
				jlChosen(cid,$(cid).attr('data-url'),p,arr)
			}
			$(formId).valid();
	},'json');
}	


function openLayer(){
	$(formId).form('clear');
	initChosen();	
	$(".chosen-select").trigger("chosen:updated");
	
	$(formId).valid();
	layerIndex=layer.open({
	  type: 1,
	  area: ['70%', '70%'], //宽高
	  title: t_name+'新增',
	  scrollbar: false,
	  btn: ['保存','关闭'], 
	  yes: function(index, layero){
		  $(formId).submit();
	  },
	  cancel:function(index, layero){
		  $(layerContent+' .dt-span').remove();
		  $(layerContent+' .div_hidden').removeClass('div_hidden');
	  },
	  offset: '20px',
	  content: $(layerContent) //这里content是一个DOM
	});
}

function openDetailLayer(){
	$(formId).form('clear');
	initChosen();
	$(formId).valid();
	layerIndex=layer.open({
	  type: 1,
	  area: ['70%', '70%'], //宽高
	  title: t_name+'详情',
	  scrollbar: false,
	  cancel:function(index, layero){
		  $(layerContent+' .dt-span').remove();
		  $(layerContent+' .div_hidden').removeClass('div_hidden');
	  },
	  offset: '20px',
	  content: $(layerContent) //这里content是一个DOM
	});
}


$(function () {
	 
    //1.初始化Table
    oTable = new TableInit();
    oTable.Init();

    //2.初始化Button的点击事件
    /* var oButtonInit = new ButtonInit();
    oButtonInit.Init(); */
    $(formId).validate( {ignore: ""});
});


var TableInit = function () {
    var oTableInit = new Object();
    //初始化Table
    oTableInit.Init = function () {
        $(tableId).bootstrapTable({
            url: url+'listAjax'+'?'+'<%=request.getQueryString()%>',         //请求后台的URL（*）
            method: 'post',                      //请求方式（*）
            contentType: "application/x-www-form-urlencoded",
            toolbar:toolbar,//工具按钮用哪个容器
            iconSize: 'outline',
            striped: true,                      //是否显示行间隔色
            cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
            pagination: true,                   //是否显示分页（*）
            sortable: true,                     //是否启用排序
            sortOrder:"desc",
            queryParams: queryParams,//传递参数（*）
            sidePagination: "server",           //分页方式：client客户端分页，server服务端分页（*）
            pageNumber:1,                       //初始化加载第一页，默认第一页
            pageSize: 10,                       //每页的记录行数（*）
            pageList: [10, 25, 50, 100],        //可供选择的每页的行数（*）
            strictSearch: true,
            clickToSelect: false,                //是否启用点击选中行
            uniqueId: "idForShow",                     //每一行的唯一标识，一般为主键列
            cardView: false,                    //是否显示详细视图
            detailView: false,   
            showRefresh: true,  
            showToggle: true,      
            showColumns:true,
            customSort: $.noop,
            queryParamsType: "limit", //参数格式,发送标准的RESTFul类型的参数请求  //是否显示父子表
            columns:columns
        });
    };
    return oTableInit;
};

function doFormatter(value, row, index)
{
	var html='';
	html+='<div class="btn-group">';
	html+='<button type="button" class="btn btn-white" onclick="datailRow(\''+row.idForShow+'\')"><i class="fa fa-info-circle"></i>&nbsp;详情</button>';
	html+='<button type="button" class="btn btn-white" id="edit"  onclick="editRow(\''+row.idForShow+'\')"><i class="fa fa-pencil"></i>&nbsp;修改</button>';
	html+='<button type="button" class="btn btn-white" onclick="deleteRow(\''+row.idForShow+'\')"><i class="fa fa-trash"></i>&nbsp;删除</button>';
	html+='</div>';
	return html;
}


var submiting=0;
$(formId).form({  
    url: url+'insertAjax',  
    onSubmit: function(){
    	var v=$(formId).valid()&&submiting==0;
    	if(v){
    		submiting=1;
    		$('#layui-layer'+layerIndex).find('.layui-layer-btn0').html('保存中...');
    	}
    	return v;
    },  
    success: function(result){ 
    	var result = eval('('+result+')');
    	if(result.code && result.code==1){
    		layer.close(layerIndex);
    		 $(tableId).bootstrapTable('refresh');
    	}
    	submiting=0;
    	$('#layui-layer'+layerIndex).find('.layui-layer-btn0').html('保存');
    	layer.msg(result.msg);
    }  
});
function deleteRow(id){
	layer.confirm('您确定要删除么？', {
		  btn: ['确定','取消'] //按钮
		}, function(){
			$.post(url+'deleteAjax',{idForShow:id},function(result){  
				if(result.code && result.code==1){
		    		layer.close(layerIndex);
		    		 $(tableId).bootstrapTable('refresh');
		    	}
		    	layer.msg(result.msg);
	        },'json');
		}, function(){
		    
		});
}

//修改的额外处理覆盖此方法
function doWithEdit(id,data){
	
}


function editRow(id){
	openLayer();
	layer.title(t_name+'修改', layerIndex);
	var data=$(tableId).bootstrapTable('getRowByUniqueId', id);
	console.info(data);
	$(formId).form('load',data);
	doWithEdit(id,data);
	//通知chosen下拉框更新
	var cs=$(".chosen-select");
	if(cs.length){
		for(var i=0;i<cs.length;i++){
			if($(cs[i]).attr('data-bind')){
				var cid=$(cs[i]).attr('data-bind');
				var  p = {};
				p[$(cs[i]).attr("data-param")] =$(cs[i]).val();
				initAjaxChosen(cid,$(cid).attr('data-url'),p,data[$(cid).attr('name')],1);
				console.info(cid);
			}
			
		}
	}
	$(".chosen-select").trigger("chosen:updated");
	$(formId).valid();
}

//查看的额外处理覆盖此方法
function doWithDetail(id,data){
	
}

//查看的额外处理覆盖此方法
function doBeforDetail(id,data){
	
}
function datailRow(id,la){
	if(!la){
		openDetailLayer();
		layer.title(t_name+'详情', layerIndex);
	}
	$(layerContent+" div").removeClass("has-error");
	$(layerContent+" div").removeClass("has-success");
	$(layerContent+" .detail-hide").addClass('div_hidden');
	var data=$(tableId).bootstrapTable('getRowByUniqueId', id);
	doBeforDetail(id,data);
	$(formId).form('load',data);
	doWithDetail(id,data);
	//下拉级联显示
	var cs=$(layerContent+" .chosen-select");
	if(cs.length){
		for(var i=0;i<cs.length;i++){
			if($(cs[i]).attr('data-bind')){
				var cid=$(cs[i]).attr('data-bind');
				var  p = {};
				p[$(cs[i]).attr("data-param")] =$(cs[i]).val();
				initAjaxChosen(cid,$(cid).attr('data-url'),p,data[$(cid).attr('name')],true);
			}
			
		}
	}
	$(".chosen-select").trigger("chosen:updated");
	//替换input显示
	var inp=$(layerContent+' input');
	if(inp.length){
		for(var i=0;i<inp.length;i++){
			if($(inp[i]).attr('type')!='hidden'&&$(inp[i]).hasClass('form-control')){
				var cl=$(inp[i]).parent('div').attr('class');
				$(inp[i]).parent('div').addClass('div_hidden');
				var rootDiv=$(inp[i]).parents('.form-group');
				if($(rootDiv).find('span .dt-span').length){
					$(rootDiv).find('span .dt-span').html(data[$(inp[i]).attr('name')])
				}else{
					$(rootDiv).append('<span class="'+cl+' dt-span">'+data[$(inp[i]).attr('name')]+'</span>');
				}
			}
			
		}
	}
	
	//替换input显示
	var txt=$(layerContent+' textarea');
	if(txt.length){
		for(var i=0;i<txt.length;i++){
			if($(txt[i]).attr('type')!='hidden'&&$(txt[i]).hasClass('form-control')){
				var cl=$(txt[i]).parent('div').attr('class');
				$(txt[i]).parent('div').addClass('div_hidden');
				var rootDiv=$(txt[i]).parents('.form-group');
				if($(rootDiv).find('span .dt-span').length){
					$(rootDiv).find('span .dt-span').html(data[$(txt[i]).attr('name')])
				}else{
					$(rootDiv).append('<span class="'+cl+' dt-span">'+data[$(txt[i]).attr('name')]+'</span>');
				}
			}
			
		}
	}
	
	//替换select显示
	var sel=$(layerContent+' select');
	if(sel.length){
		for(var i=0;i<sel.length;i++){
			var vl="";
			var dv=data[$(sel[i]).attr('name')]+"";
			if(dv.indexOf(',')>=0){
				var vls=dv.split(",");
				for(var k=0;k<vls.length;k++){
					vl+=$(sel[i]).find('option[value="'+vls[k]+'"]').html()+","
				}
				vl=vl.substring(0,vl.length-1);
			}else{
				vl=$(sel[i]).find('option[value="'+data[$(sel[i]).attr('name')]+'"]').html();
				var cl=$(sel[i]).parent('div').attr('class');
				
			}
			$(sel[i]).parent('div').addClass('div_hidden');
			var rootDiv=$(sel[i]).parents('.form-group');
			if(typeof($(rootDiv).find('span .dt-span').length)!="undefined"&&$(rootDiv).find('span .dt-span').length>0){
				$(rootDiv).find('span .dt-span').html(vl)
			}else{
				if(typeof(vl)!="undefined"){
					$(rootDiv).append('<span class="'+cl+' dt-span" data-name="'+$(sel[i]).attr('name')+'" data-value="'+data[$(sel[i]).attr('name')]+'">'+vl+'</span>');
				}else{
					$(rootDiv).append('<span class="'+cl+' dt-span" data-name="'+$(sel[i]).attr('name')+'" data-value="'+data[$(sel[i]).attr('name')]+'"></span>');
				}
				
			}
			
		}
	}
	
}

function dataElementDetail(id) {
	  layer.open({
	    type: 2,
	    title: '数据元详情',
	    shadeClose: true,
	    shade: 0.1,
	    area: ['620px', '80%'],
	    content: base + '/backstage/dataElement/detail?id=' + id
	  });

	}
	
	
function informationResourceDetail(id) {
	  layer.open({
	    type: 2,
	    title: '信息资源详情',
	    shadeClose: true,
	    shade: 0.1,
	    area: ['70%', '70%'],
	    content: base + '/backstage/information/resource/detail?id=' + id
	  });

	}
//excel只能点击一次

</script>