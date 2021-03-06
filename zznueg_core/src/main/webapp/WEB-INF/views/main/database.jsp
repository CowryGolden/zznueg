<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<!DOCTYPE HTML>
<html lang="zh-CN">
<head>
    <base href="<%=basePath%>"/>
    <meta charset="UTF-8">
    <title>4Tiro-数据库</title>
    <meta name="keywords" content="Java,git,spring,mvc,mybatis,oracle,mysql,shiro"/>
    <meta name="description" content=""/>
    <link rel="stylesheet" href="resources/show/css/index.css"/>
    <link rel="stylesheet" href="resources/show/css/style.css"/>
    <script type="text/javascript"
            src="resources/public/js/jquery.js"></script>
    <script type="text/javascript"
            src="resources/show/js/jquery.SuperSlide.2.1.1.js"></script>
    <!--[if lt IE 9]>
    <script src="resources/show/js/html5.js"></script>
    <![endif]-->
</head>

<body>
<c:import url="head.jsp"></c:import>
<!--content start-->
<div id="content">
    <!--left-->
    <div class="left" id="news">
        <div class="weizi">
            <div class="wz_text">
                当前位置：<a href="#">首页</a>><a href="#">学无止境</a>><span>文章内容</span>
            </div>
        </div>
        <div class="news_content">
            <div class="news_top">
                <h1>浅谈：html5和html的区别</h1>
                <p>
                    <span class="left sj">时间:2014-8-9</span><span class="left fl">分类:学无止境</span>
                    <span class="left author">Zhoujincheng</span>
                </p>
                <div class="clear"></div>
            </div>
            <div class="news_text">
                这几天真的太忙了，白天要上课，晚上还要策划客户的网站方案，经常弄到一两点才睡，也没什么时间去学习了。
                不过最近看群里聊天聊得最火热的莫过于手机网站和html5这两个词。可能有人会问，这两者有什么关系呢？随着这移动互联网快速发展的时代，
                尤其是4G时代已经来临的时刻，加上微软对"XP系统"不提供更新补丁、维护的情况下。"html5+css3"也逐渐的成为新一代web前端技术，
                手机网站也渐渐的成为一种趋势。什么是html5呢？<br/> html5最先由WHATWG(Web
                超文本应用技术工作组)命名的一种超文本标记语言，随后和W3C的xhtml2.0(标准)相结合，
                产生现在最新一代的超文本标记语言。可以简单点理解成：HTML 5 ≈ HTML+CSS 3+JS+API。hmtl5于html的区别<br/>
                我们现在web前端开发的静态网页，一般都是html4.0。同时是符合W3C的xhtml1.0规范来的。那么他们两者又有什么实质性的区别呢？<br/>
                1.在文档类型声明上<br/> html:!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0
                Transitional//EN"
                "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
                html5:!doctype html <br/>
                由这两者对比可见：在文档声明上，html有很长的一段代码，并且很难记住这段代码，想必很多人都是靠工具直接生成的吧？而html5却是不同，
                只有简简单单的声明，这也方便人们的记忆。 <br/> 2.在结构语义上 <br/>
                html:没有体现结构语义化的标签，我们通常都是这样来命名的div id="header".这样表示网站的头部。 <br/>
                html5:在语义上却有很大的优势。提供了一些新的标签，比如:header、article、footer <br/>
                提供这样的标签有什么样的好处呢？我觉得最主要还是在SEO的优化上，不管是我们自己来对网页模块命名，还是有这样的标签。因为做网站最终的目的只有一个，那就是盈利。
                想盈利的话，就只有通过SEO优化的技术，把你网站排名做上来，这样你的网站才有价值，且正是这一点，html5符合了这一点。
                为什么这么说呢？因为他定义的这些标签，更加有利于优化，蜘蛛能识别你。 <br/>
                总结：虽然在前几年html5已经出来了，但是那时候因为不够成熟，时机不对，才没被兴起。在这互联网高速发展的时候，也是来临4G的时代。我们还不学习hml5+css3我们就out了！

            </div>
        </div>

    </div>
    <!--end left -->
    <c:import url="right.jsp"></c:import>
    <div class="clear"></div>
</div>
<!--content end-->
<c:import url="foot.jsp"></c:import>
<script type="text/javascript">
    jQuery(".lanmubox").slide({
        easing: "easeOutBounce",
        delayTime: 400
    });
</script>
</body>
</html>


