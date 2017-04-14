<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.govmade.common.utils.ServiceUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.govmade.cn/MyFunction" prefix="MyFunction"%>
<!DOCTYPE html >
<html lang="en">
<head>
<%@include file="../common/includeBaseHead.jsp"%>
</head>
<body class="white-bg skin-<%=ServiceUtil.getThemeType(10)%>">

  <div id="holder"  style="background-color:#fff;padding:0px;"> </div>
   
</body>
</html>
<script src="${base}/static/js/raphael.js" ></script>
<%@include file="../common/includeJS.jsp"%>
<script type="text/javascript"> 




//官网

Raphael.fn.connection = function(obj1, obj2, line, bg) {
  if (obj1.line && obj1.from && obj1.to) {
      line = obj1;
      obj1 = line.from;
      obj2 = line.to;
  }
  //var bb1 = obj1.getBBox(), bb2 = obj2.getBBox(), p = [ {
  var bb1 = obj1.getBBox(), 
      bb2 = obj2.getBBox(),
      p = [ {
          x : bb1.x + bb1.width / 2,
          y : bb1.y - 1
      }, {
          x : bb1.x + bb1.width / 2,
          y : bb1.y + bb1.height + 1
      }, {
          x : bb1.x - 1,
          y : bb1.y + bb1.height / 2
      }, {
          x : bb1.x + bb1.width + 1,
          y : bb1.y + bb1.height / 2
      }, {
          x : bb2.x + bb2.width / 2,
          y : bb2.y - 1
      }, {
          x : bb2.x + bb2.width / 2,
          y : bb2.y + bb2.height + 1
      }, {
          x : bb2.x - 1,
          y : bb2.y + bb2.height / 2
      }, {
          x : bb2.x + bb2.width + 1,
          y : bb2.y + bb2.height / 2
      } ], 
      d = {}, 
      dis = [];
   
  for (var i = 0; i < 4; i++) {
      for (var j = 4; j < 8; j++) {
          var dx = Math.abs(p[i].x - p[j].x), dy = Math.abs(p[i].y
                  - p[j].y);
          if ((i == j - 4)
                  || (((i != 3 && j != 6) || p[i].x < p[j].x)
                  && ((i != 2 && j != 7) || p[i].x > p[j].x)
                  && ((i != 0 && j != 5) || p[i].y > p[j].y) 
                  && ((i != 1 && j != 4) || p[i].y < p[j].y))) {
              dis.push(dx + dy);
              d[dis[dis.length - 1]] = [ i, j ];
          }
      }
  }
  if (dis.length == 0) {
      var res = [ 0, 4 ];
  } else {
      res = d[Math.min.apply(Math, dis)];
  }
  var x1 = p[res[0]].x, y1 = p[res[0]].y, x4 = p[res[1]].x, y4 = p[res[1]].y;
  dx = Math.max(Math.abs(x1 - x4) / 2, 10);
  dy = Math.max(Math.abs(y1 - y4) / 2, 10);
  var x2 = [ x1, x1, x1 - dx, x1 + dx ][res[0]].toFixed(3), y2 = [
          y1 - dy, y1 + dy, y1, y1 ][res[0]].toFixed(3), x3 = [ 0, 0,
          0, 0, x4, x4, x4 - dx, x4 + dx ][res[1]].toFixed(3), y3 = [
          0, 0, 0, 0, y1 + dy, y1 - dy, y4, y4 ][res[1]].toFixed(3);
  var path = [ "M", x1.toFixed(3), y1.toFixed(3), "C", x2, y2, x3,
          y3, x4.toFixed(3), y4.toFixed(3) ].join(",");
  if (line && line.line) {
      line.bg && line.bg.attr({
          path : path
      });
      line.line.attr({
          path : path
      });
  } else {
      var color = typeof line == "string" ? line : "#000";
      return {
          bg : bg && bg.split && this.path(path).attr({
              stroke : bg.split("|")[0],
              fill : "none",
              //"stroke-width" : bg.split("|")[1] || 3
              "stroke-width" : 2
          }),
          line : this.path(path).attr({
              stroke : color,
              fill : "none"
          }),
          from : obj1,
          to : obj2
      };
  }
};





var jifangpic="${base}/static/images/system/jifang.png";
var databasepic="${base}/static/images/system/dataBase.png";
var bumenpic="${base}/static/images/system/bumen.png";

var selectBumen;//选中的部门
var selectSystem;//选中的系统
var selectDatabase;//选中的数据库

function DataBase(r, l, t,db){ 
var title=db.value1;
var tt=title;
if(tt.length>8){
	tt=tt.substring(0,8)+"...";
}
this.Label = r.text(l + 55/2, t + 90, tt); 
this.Label.attr({"fill":"#333", "font-size":"14px"});
this.Rectangle = r.image(databasepic,l, t, 55, 80).attr({title:title}).drag(move, Dragger, up).data("cooperative", this.Label).toBack(); 

function Dragger(){ 
this.xx = this.attr("x"); 
this.yy = this.attr("y"); 
this.animate({"fill-opacity": .2}, 100); 
} 
function move(dx, dy){ 
var attr = {x: this.xx + dx, y: this.yy + dy}; 
this.attr(attr); 
var lb = this.data("cooperative"); 
var attr1 = {x: this.xx + dx + 55 / 2, y: this.yy + dy + 90}; 
lb.attr(attr1); 
} 
function up(){ 
this.animate({"fill-opacity": 1}, 300); 
} 
} 

//st 系统
function System(r, l, t,st){ 
	var title;
	if(typeof(st.value2)!='undefined'){
		title=st.value2;
	}else{
		title=st;
	}
var tt=title;
if(tt.length>8){
	tt=tt.substring(0,8)+"...";
}
this.Label = r.text(l + 55/2, t + 90, tt); 
this.Label.attr({"fill":"#333", "font-size":"14px"});
this.Rectangle = r.image(jifangpic,l, t, 55, 80).attr({title:title}).drag(move, Dragger, up).data("cooperative", this.Label).toBack(); 
this.Rectangle.click(function(){
	if(typeof(st.value2)!='undefined'){
		buildDataBase(st);
	}else{
		buildSystem(selectBumen);
	}
});
function Dragger(){ 
this.xx = this.attr("x"); 
this.yy = this.attr("y"); 
this.animate({"fill-opacity": .2}, 100); 
} 
function move(dx, dy){ 
var attr = {x: this.xx + dx, y: this.yy + dy}; 
this.attr(attr); 
var lb = this.data("cooperative"); 
var attr1 = {x: this.xx + dx + 55 / 2, y: this.yy + dy + 90}; 
lb.attr(attr1); 
} 
function up(){ 
this.animate({"fill-opacity": 1}, 300); 
} 
} 




function BuMen(r, l, t,bm){
	var title;
	if(typeof(bm.value3ForShow)!='undefined'){
		title=bm.value3ForShow;
	}else{
		title=bm;
	}
var tt=title;
if(tt.length>8){
	tt=tt.substring(0,8)+"...";
}
this.Label = r.text(l + 55/2, t + 90, tt); 
this.Label.attr({"fill":"#333", "font-size":"14px"});
this.Rectangle = r.image(bumenpic,l, t, 55, 80).attr({title:title}).drag(move, Dragger, up).data("cooperative", this.Label).toBack(); 

this.Rectangle.click(function(){
	if(typeof(bm.value3ForShow)!='undefined'){
		buildSystem(bm);
	}else{
		buildBuMen();
	}

});
function Dragger(){ 
this.xx = this.attr("x"); 
this.yy = this.attr("y"); 
this.animate({"fill-opacity": .2}, 100); 
} 
function move(dx, dy){ 
var attr = {x: this.xx + dx, y: this.yy + dy}; 
this.attr(attr); 
var lb = this.data("cooperative"); 
var attr1 = {x: this.xx + dx + 55 / 2, y: this.yy + dy + 90}; 
lb.attr(attr1); 
} 
function up(){ 
this.animate({"fill-opacity": 1}, 300); 
} 
} 

var systemList;
var bumenList;
window.onload = function(){ 
	
	jQuery.post('${base}/backstage/govApplicationSystem/listAjax?all=y',function(r){
		systemList=r;
		initBumenList();
		buildBuMen();
	},'json');

}; 

function initBumenList(){
	bumenList=new Array();
	var s=",";
	for(var i=0;i<systemList.length;i++){
		if(s.indexOf(systemList[i].value3ForShow)==-1){
			bumenList.push(systemList[i]);
			s+=systemList[i].value3ForShow+",";
		}
	}
}





function buildDataBase(st){
	selectSystem=st;
	
	jQuery.post('${base}/backstage/govDatabase/listAjax?all=y',function(r){
		var list=r;
		var num=r.length;
		var c_width=document.body.clientWidth;
		var clumns= Math.ceil((c_width-200)/120);//能放几列
		var rows=Math.ceil(num/clumns);//行数
		var height=rows*120+100;
		if(height<document.body.clientHeight){
		height=document.body.clientHeight;
		}
		initPaper( c_width, height);
		var x=100;
		var y=190;
		var bumen = new BuMen(paper, x,50,selectBumen.value3ForShow); 
		var stm = new System(paper, x+120,50,st.value2); 
		var p = paper.path("M 120,90 L220,90 Z").toBack();//路径  
		var p = paper.path("M 250,90 L250,170 Z").toBack();//路径  
		
		var p = paper.path("M 120,170 L"+clumns*120+",170 Z").toBack();//路径  
		var p = paper.path("M 120,170 L120,180 Z").toBack();//路径  
		var p = paper.path("M "+clumns*120+",170 L"+clumns*120+",180 Z").toBack();//路径  
		
		for(var i=0;i<num;i++){
			var entity1 = new DataBase(paper, x+ (i%clumns)*120,y+ Math.floor(i/clumns)*120,list[i]); 
		}
	},'json');
	
	


}

function buildSystem(bm){
	selectBumen=bm;
var list=new Array();
for(var i=0;i<systemList.length;i++){
	if(systemList[i].value3===bm.value3){
		list.push(systemList[i]);
	}
}
var num=list.length;
var c_width=document.body.clientWidth;
var clumns= Math.ceil((c_width-200)/120);//能放几列
var rows=Math.ceil(num/clumns);//行数
var height=rows*120+100;
if(height<document.body.clientHeight){
height=document.body.clientHeight;
}
initPaper( c_width, height);
var x=100;
var y=190;
var bumen = new BuMen(paper, x,50,bm.value3ForShow); 

for(var i=0;i<num;i++){
	var entity1 = new System(paper, x+ (i%clumns)*120,y+ Math.floor(i/clumns)*120,list[i]); 
}
}


function buildBuMen(){
var num=bumenList.length;
var c_width=document.body.clientWidth;
var clumns= Math.ceil((c_width-200)/120);//能放几列
var rows=Math.ceil(num/clumns);//行数
var height=rows*120+100;
if(height<document.body.clientHeight){
height=document.body.clientHeight;
}
initPaper( c_width, height);
var x=100;
var y=50;
for(var i=0;i<num;i++){
	var entity1 = new BuMen(paper, x+ (i%clumns)*120,y+ Math.floor(i/clumns)*120,bumenList[i]); 
}
}



var paper;
function initPaper(width,height){
	if(typeof(paper)=="undefined"){
		paper=Raphael("holder", width, height),discattr={fill:"red", stroke:"none"};
	}else{
		paper.clear();
		paper.setSize( width, height);
	}

}










</script> 









