<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseSet.jsp" %>
</head>
<body>
<div class="easyui-layout" id="rbacscope" style="height:100%">
	<div title="数据规则管理" border="false" style="height:100%">
		<table id="dg-rbacscope" style="height:100%"></table>
	</div>
	<div id="toolbar-rbacscope">
	    <form action="" id="sb-rbacscope">
	      <a href="#" class="easyui-linkbutton dg-do-add" data-options="iconCls:'icon-add'" plain="true">新增</a>
	   
	        <div class="auto-clear"></div>
	    </form>
	</div>
	<div class="easyui-dialog" title="上传" style="width:700px" closed="true" buttons="#dlg-rbacscope-buttons" id="dlg-rbacscope" maximizable="true" data-options="shadow:false,modal:true">
	    <form id="form-rbacscope" method="post">
	    	<table cellpadding="5" style="padding:0 20px;width:100%;">
	    		<tr style="display: none;">
	    			<td><input class="easyui-textbox" type="hidden" name="id"></td>
	    		</tr>
	    		<tr>
	    			<td>名称:</td>
	    			<td><input class="easyui-textbox" type="text" name="name" data-options="required:true" /></td>
	    			<td>值:</td>
	    			<td><input class="easyui-textbox" type="text" name="value" /></td>
	    		</tr>
	    		
	    		<tr>
	    			<td>备注:</td>
	    			<td colspan="3"><input class="easyui-textbox" name="note" data-options="multiline:true" style="height:60px;width:100%"></td>
	    		</tr>
	    	</table>
	    	<table id="dg-rbacscope-scope" data-options="border:false" style="height:200px"></table>
	    </form>
	</div>
	<div id="dlg-rbacscope-buttons" style="text-align:center;">  
	    <a href="#" class="easyui-linkbutton dg-do-save" iconCls="icon-save">保存</a>
	</div>

</div>
</body>
</html>
<script src="${base}/static/js/easyui/requirejs/rbacscope.js"></script>
<script src="${base}/static/js/easyui/plugin/easyui-validType.js"></script>


