<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>
		<!-- 01 导入js -->
		<script src="js/echarts.min.js"></script>
		<!-- 03 设置容器的样式 -->
		<style>
			#container{
				width: 800px;
				height: 600px;
			}
		</style>
	</head>
	<body>
		<!-- 02 创建个容器 -->
		<div id="container"></div>
	</body>
	<script>
		//04 实例化echarts
		// 4.1 创建一个实例
		var echart = echarts.init(document.getElementById("container"))
		// 4.2 定义配置项
		var option = {
			// 图表的标题
			title:{
				text:"我的第一个图表"
			},
			// 图表的提示
			tooltip:{},
			// 图例
			legend:{data:["睡眠时长"]},
			// x轴线
			xAxis:{data:["周一","周二","周三","周四","周五","周六","周日"]},
			// y轴线
			yAxis:{},
			// 设置数据
			series:[
				{
					// 数据名称
					name:"睡眠时长",
					// 类型为柱状图
					type:"bar",
					// 数据data
					data:[8,10,4,5,9,4,8]
					}
			]
		}
		// 4.3 更新配置
		echart.setOption(option);
		// chart图表，set设置 Option选项  data数据 type类型 bar条（柱状条），series系列（数据） Axis轴线 xAxis水平轴线 
		// legend传奇（图例） tooltip 提示 init初始化 document文档 
	</script>
</html>
