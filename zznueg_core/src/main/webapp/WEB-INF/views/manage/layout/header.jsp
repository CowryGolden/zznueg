<%@ page language="java" pageEncoding="utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<base href="<%=basePath%>"/>
<script type="text/javascript">
    $(function () {
        //顶部导航切换
        $(".nav li a").click(function () {
            $(".nav li a.selected").removeClass("selected")
            $(this).addClass("selected");
        });
    });
</script>
<div class="topleft">
    <a href="javascript:void(0);" target="_parent"><img
            src="resources/core/images/logo.png" title="系统首页"/></a>
</div>

<ul class="nav">
<!-- 
    <li><a href="javascript:void(0);" target="rightFrame"
           class="selected"><img
            src="resources/core/images/icon01.png" title="用户管理"/>
        <h2>用户管理</h2></a></li>
    <li><a href="javascript:void(0);" target="rightFrame"><img
            src="resources/core/images/icon02.png" title="用户中心"/>
        <h2>用户中心</h2></a></li>
    <li><a href="javascript:void(0);" target="rightFrame"><img
            src="resources/core/images/icon03.png" title="模块设计"/>
        <h2>模块设计</h2></a></li>
    <li><a href="javascript:void(0);" target="rightFrame"><img
            src="resources/core/images/icon04.png" title="常用工具"/>
        <h2>常用工具</h2></a></li>
    <li><a href="javascript:void(0);" target="rightFrame"><img
            src="resources/core/images/icon05.png" title="文件管理"/>
        <h2>文件管理</h2></a></li>
    <li><a href="javascript:void(0);" target="rightFrame"><img
            src="resources/core/images/icon06.png" title="系统设置"/>
        <h2>系统设置</h2></a></li>
 -->        
</ul>

<div class="topright">
    <ul>
        <li><a href="javascript:void(0)">关于</a></li>
        <li><a href="logout" target="_parent">退出</a></li>
    </ul>
    <div class="user">
        <span>${shiroUser.userName} 欢迎您登录</span>
    </div>
</div>