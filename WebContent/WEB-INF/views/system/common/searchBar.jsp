<%@ page contentType="text/html;charset=UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />  

<style>
#search_bar {
  width: 100%;
  position: relative;
  z-index: 200;
}

.search_bar {
  width: 100%;
  height: 50px;
  position: absolute;
  top: 0;
  overflow: hidden;
  z-index: 100;
  box-sizing: border-box;
  /*不会把盒子撑开*/
}

.search_bar::before {
  content: "";
  position: absolute;
  top: 0px;
  left: 0px;
  right: 0px;
  bottom: 0px;
  z-index: -1;
  /*-1 可以当背景*/
  -webkit-filter: blur(10px);
  filter: blur(10px);
  margin: -30px; /*消除边缘透明*/
  background: url(${base}/static/images/index/bg.jpg) center top;
  background-size: cover;
  /*平铺*/
  background-attachment: fixed;
  /*位置固定*/
}
</style>
<div class="search_bar"></div>
<div id="search_bar">
  <div class="row" style="height: 50px;">
    <div class="search-form col-md-10 col-sm-10 col-xs-10 col-md-offset-1 col-sm-offset-1 col-xs-offset-1">
      <form action="index.html" method="get">
        <div class="input-group">
          <input type="text" placeholder="输入关键字" name="search" class="form-control input-sm">
          <div class="input-group-btn">
            <button class="btn btn-sm btn-primary" type="submit">
              <i class="fa fa-search"></i>
            </button>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>

