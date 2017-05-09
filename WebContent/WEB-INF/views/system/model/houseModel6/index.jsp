<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../../common/includeBaseHead.jsp"%>
<style>

.node {
cursor: pointer;
}

.node circle {
fill: #fff;
stroke: steelblue;
stroke-width: 1.5px;
}

.node text {
padding: 3px 10px;
border: 1px solid #999;
border-radius: 2px;
font: 12px sans-serif;
}
.link {
fill: none;
stroke: #ccc;
stroke-width: 1.5px;
}

</style>
</head>
<body class="gray-bg skin-<%=ServiceUtil.getThemeType(10)%>">
</body>
</html>

<%-- <%@include file="../../common/includeJS.jsp"%> --%>
<script src="${base}/static/js/jquery.min.js?v=2.1.4"></script>
<script src="${base}/static/js/d3.v3.min.js"></script>
<script src="${base}/static/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<script>
var margin = { top: 20, right: 120, bottom: 20, left: 120 },
  width = 960 - margin.right - margin.left,
  height = 800 - margin.top - margin.bottom;

var i = 0,
  duration = 750,
  root;

var tree = d3.layout.tree()
  .size([height, width]);

var diagonal = d3.svg.diagonal()
  .projection(function(d) {
    return [d.y, d.x]; });

var svg = d3.select("body").append("svg")
  .attr("width", width + margin.right + margin.left)
  .attr("height", height + margin.top + margin.bottom)
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

d3.json("${base}${url}", function(error, flare) {
  if (error) throw error;

  root = flare;
  root.x0 = height / 2;
  root.y0 = 0;

  function collapse(d) {
    if (d.children) {
      d._children = d.children;
      d._children.forEach(collapse);
      d.children = null;
    }
  }

  root.children.forEach(collapse);
  update(root);
});

d3.select(self.frameElement).style("height", "800px");

function update(source) {

  // Compute the new tree layout.
  var nodes = tree.nodes(root).reverse(),
    links = tree.links(nodes);

  // Normalize for fixed-depth.
  nodes.forEach(function(d) { d.y = d.depth * 180; });

  // Update the nodes…
  var node = svg.selectAll("g.node")
    .data(nodes, function(d) {
      return d.id || (d.id = ++i); });

  // Enter any new nodes at the parent's previous position.
  var nodeEnter = node.enter().append("g")
    .attr("class", "node")
    .attr("transform", function(d) {
      return "translate(" + source.y0 + "," + source.x0 + ")"; })
    .on("click", click);

  nodeEnter.append("circle")
    .attr("r", 1e-6)
    .style("fill", function(d) {
      return d._children ? "lightsteelblue" : "#fff"; });

  nodeEnter.append("text")
    .attr("x", function(d) {
      return d.children || d._children ? -10 : 10; })
    .attr("dy", ".35em")
    .attr("text-anchor", function(d) {
      return d.children || d._children ? "end" : "start"; })
    .text(function(d) {
      return d.name; })
    .style({ "fill-opacity": 1e-6 });


  // Transition nodes to their new position.
  var nodeUpdate = node.transition()
    .duration(duration)
    .attr("transform", function(d) {
      return "translate(" + d.y + "," + d.x + ")"; });

  nodeUpdate.select("circle")
    .attr("r", 4.5)
    .style("fill", function(d) {
      return d._children ? "lightsteelblue" : "#fff"; });

  nodeUpdate.select("text")
    .style("fill-opacity", 1);

  // Transition exiting nodes to the parent's new position.
  var nodeExit = node.exit().transition()
    .duration(duration)
    .attr("transform", function(d) {
      return "translate(" + source.y + "," + source.x + ")"; })
    .remove();

  nodeExit.select("circle")
    .attr("r", 1e-6);

  nodeExit.select("text")
    .style("fill-opacity", 1e-6);

  // Update the links…
  var link = svg.selectAll("path.link")
    .data(links, function(d) {
      return d.target.id; });

  // Enter any new links at the parent's previous position.
  link.enter().insert("path", "g")
    .attr("class", "link")
    .attr("d", function(d) {
      var o = { x: source.x0, y: source.y0 };
      return diagonal({ source: o, target: o });
    });

  // Transition links to their new position.
  link.transition()
    .duration(duration)
    .attr("d", diagonal);

  // Transition exiting nodes to the parent's new position.
  link.exit().transition()
    .duration(duration)
    .attr("d", function(d) {
      var o = { x: source.x, y: source.y };
      return diagonal({ source: o, target: o });
    })
    .remove();

  // Stash the old positions for transition.
  nodes.forEach(function(d) {
    d.x0 = d.x;
    d.y0 = d.y;
  });
}

// Toggle children on click.
function click(d) {
  if (d.children) {
    d._children = d.children;
    d.children = null;
  } else {
    d.children = d._children;
    d._children = null;
  }
  update(d);
}
$(function() {
  $(".gray-bg").slimScroll({
    width: 'auto', //可滚动区域宽度
    height: '1000px', //可滚动区域高度
    size: '10px', //组件宽度
    color: '#000', //滚动条颜色
    position: 'right', //组件位置：left/right
    distance: '0px', //组件与侧边之间的距离
    start: 'top', //默认滚动位置：top/bottom
    opacity: .4, //滚动条透明度
    alwaysVisible: false, //是否 始终显示组件
    disableFadeOut: false, //是否 鼠标经过可滚动区域时显示组件，离开时隐藏组件
    railVisible: true, //是否 显示轨道
    railColor: '#333', //轨道颜色
    railOpacity: .2, //轨道透明度
    railDraggable: true, //是否 滚动条可拖动
    railClass: 'slimScrollRail', //轨道div类名 
    barClass: 'slimScrollBar', //滚动条div类名
    wrapperClass: 'slimScrollDiv', //外包div类名
    allowPageScroll: true, //是否 使用滚轮到达顶端/底端时，滚动窗口
    wheelStep: 20, //滚轮滚动量
    touchScrollStep: 200, //滚动量当用户使用手势
    borderRadius: '7px', //滚动条圆角
    railBorderRadius: '7px' //轨道圆角
  });
});

</script>

