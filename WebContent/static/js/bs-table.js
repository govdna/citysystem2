/*
 * @Author: kk
 * @Date:   2017-03-03 09:26:07
 * @Last Modified by:   kk
 * @Last Modified time: 2017-03-03 13:39:14
 */

function bstable (me, params) {
  // alert(1)
  tableParams = {
    url: '',
    method: 'post', //请求方式（*）
    contentType: "application/x-www-form-urlencoded",
    iconSize: 'outline',
    striped: true, //是否显示行间隔色
    cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
    pagination: false, //是否显示分页（*）
    sortable: true, //是否启用排序
    sortOrder: "asc", //排序方式
    queryParams: {}, //传递参数（*）
    sidePagination: "server", //分页方式：client客户端分页，server服务端分页（*）
    pageNumber: 1, //初始化加载第一页，默认第一页
    pageSize: 10, //每页的记录行数（*）
    pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
    strictSearch: true,
    clickToSelect: false, //是否启用点击选中行
    uniqueId: "idForShow", //每一行的唯一标识，一般为主键列
    cardView: false, //是否显示详细视图
    detailView: false,
    queryParamsType: "limit",
    columns: [],
    onLoadSuccess: function () {}
  };
  var settings = $.extend({}, tableParams, params||{});
  
  me.bootstrapTable({
    url: settings.url,
    method: settings.method, 
    contentType: settings.contentType,
    iconSize: settings.iconSize,
    striped: settings.striped,
    cache: settings.cache,
    pagination: settings.pagination,
    sortable: settings.sortable,
    sortOrder: settings.sortOrder,
    queryParams: settings.queryParams,
    sidePagination: settings.sidePagination,
    pageNumber: settings.pageNumber,
    pageSize: settings.pageSize,
    pageList: settings.pageList,
    strictSearch: settings.strictSearch,
    clickToSelect: settings.clickToSelect,
    uniqueId: settings.uniqueId,
    cardView: settings.cardView,
    detailView: settings.detailView,
    queryParamsType: settings.queryParamsType,
    columns: settings.columns,
    onLoadSuccess: settings.onLoadSuccess
  });
}

