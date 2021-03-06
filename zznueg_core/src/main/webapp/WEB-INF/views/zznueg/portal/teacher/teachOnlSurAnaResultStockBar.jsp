<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<!DOCTYPE html>
<html>
	<head>
		<base href="<%=basePath%>"/>
		<meta charset="UTF-8">
		<title>教师平台-（在线测评）分析结果-条形图</title>
		<tags:include_zznueg/>
		<style type="text/css">
			#main3, #main4, #main5, #main6 {
				width: 100%;
				height: 400px;
				text-align: center;
				margin: 20px auto;
			}
		</style>
		
	</head>
	<body>
		<div id="main6"></div>
	</body>
	
	<script type="text/javascript">
		setIframeH();

		function setIframeH() {
			var body = $(document.body);
			var iframe = $(parent.document.getElementById('parentIframe'));
			iframe.height(body.height()+50);
		}
		var color3 = ['#4596e5', '#2ec7c9', '#b6a2de', '#5c9ded', '#36bd9b', '#22b7e5', '#7266bb', '#fe9331'];
		var myChart6 = echarts.init(document.getElementById("main6"));
		var option6 = {
			color: color3,
			tooltip: {
				trigger: 'axis',
				axisPointer: { // 坐标轴指示器，坐标轴触发有效
					type: 'shadow' // 默认为直线，可选为：'line' | 'shadow'
				}
			},
			legend: {
				data: ['得分', '满分']
			},
			grid: {
				left: '3%',
				right: '4%',
				bottom: '3%',
				containLabel: true
			},
			xAxis: {
				type: 'value'
			},
			yAxis: {
				type: 'category',
				data: ["沟通能力", "学习能力", "亲和力", "抗压力", "责任心", "随机反应能力", "心理承受能力", "数学运算能力"]
			},
			series: [{
				name: '得分',
				type: 'bar',
				stack: '总量',
				label: {
					normal: {
						show: true,
						position: 'insideRight'
					}
				},
				data: [20, 25, 15, 18, 19, 16, 20, 22]
			}, {
				name: '满分',
				type: 'bar',
				stack: '总量',
				label: {
					normal: {
						show: true,
						position: 'insideRight'
					}
				},
				data: [25, 50, 50, 20, 20, 25, 20, 25]
			}]
		};
		myChart6.setOption(option6);
	</script>
	
</html>
