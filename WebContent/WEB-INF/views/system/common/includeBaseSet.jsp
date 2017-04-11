<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<title>智慧城市数据中心DNA系统23232323</title>
<c:set var="base" value="${pageContext.request.contextPath}"/>
<script>
    var base = '${base}';

 //数据规则管理权限
 var p_rbacscope = { see: 74, add: 75, del: 76, edit: 77 };
 //菜单管理权限
 var p_rbacmenu = { see: 32, add: 33, del: 34, edit: 53 };
 //权限管理权限
 var p_rbacperm = { see: 40, add: 41, del: 42, edit: 54 };
 //角色管理权限
 var p_rbacrole = { see: 44, add: 45, del: 46, edit: 55 };


 function hasPermission(p) {
   return true;
 }


 //记住调整的列宽
 function getFieldWidth(id, field) {

   var strStoreDate = window.localStorage ? localStorage.getItem(id + "." + field) : Cookie.read(id + "." + field);
   if (strStoreDate && strStoreDate > 0) {
     return strStoreDate;
   } else {
     return 0;
   }
 }
 //记住调整的列宽
 function loadFieldWidth(columns, id) {
   var cols = columns[0];
   for (var i = 0; i < cols.length; i++) {
     var col = cols[i];
     if (getFieldWidth(id, col.field) > 0) {
       col.width = getFieldWidth(id, col.field);
     }
   }
   return columns;
 }
 //记住调整的列宽
 function setFieldWidth(id, col) {
   if (window.localStorage) {
     localStorage.setItem(id + "." + col.field, col.width);
   } else {
     Cookie.write(id + "." + col.field, col.width);
   }
 }

</script>
<script type="text/javascript">
  if("ontouchend" in document) {
    //手机适应;
    document.write("<script src='"+base+"/static/js/jquery/jquery.mobile.custom.min.js'><"+"/script>");
  }
</script>
<link rel="icon" href="${base}/favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="${base}/favicon.ico" type="image/x-icon" />
<link rel="bookmark" href="${base}/favicon.ico" type="image/x-icon" />

<link rel="stylesheet" type="text/css" href="${base}/static/js/easyui/css/themes/material/easyui.css">
  <link rel="stylesheet" type="text/css" href="${base}/static/js/easyui/css/themes/icon.css">
  <link rel="stylesheet" type="text/css" href="${base}/static/js/easyui/css/themes/IconExtension.css">
  <link rel="stylesheet" type="text/css" href="${base}/static/js/easyui/css/themes/color.css">
  <script type="text/javascript" src="${base}/static/js/easyui/libs/jquery.min.js"></script>
  <script type="text/javascript" src="${base}/static/js/easyui/plugin/jquery.easyui.min.js"></script>
  <script data-main="${base}/static/js/easyui/apps/main.js?v=1031.1" src="${base}/static/js/easyui/libs/require.js"></script>
