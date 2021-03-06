<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
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
    <title>教师管理</title>
    <tags:include/>
    <!-- 样式有冲突，单独引入 -->
	<link rel="stylesheet" type="text/css" href="resources/zznueg/css/style.css"/>
	
    <script type="text/javascript">
        var $dg;
        var $classinfo;
        var $grid;
        $(function () {
        	$("#panel").panel({
                width: 'auto',
                height: $(this).height()
            });

            $dg = $("#dg");
            $classinfo = $("#classinfo");
            
            $grid = $dg.datagrid({
                width: 'auto',
                height: $(this).height() - 2,
                url: "zznueg/manage/teastuinfo/getAllTeacherByPage",
                queryParams:{},
                pagination: true,
                rownumbers: true,
                animate: true,
                fitColumns: true,
                striped: true,
                border: true,
                idField: 'id',
                singleSelect: true,
                columns: [[
					{
					    field: 'tsno',
					    title: '教师工号',
					    width: parseInt($(this).width() * 0.1),
					    align: 'center',
					    editor: "text"
					},       
                    {
                        field: 'name',
                        title: '教师姓名',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        editor: "text"
                    },
                    {
                        field: 'sex',
                        title: '性别',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        formatter: function (value, row) {
                            if ("1" == row.sex) return "<font color=green>男<font>";
                            else return "<font color=red>女<font>";
                        },
                        editor: "text"
                    },
                    {
                        field: 'deptId',
                        title: '所属系部ID',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        editor: "text",
                        hidden: true
                    },
                    {
                        field: 'deptName',
                        title: '所属系部',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        editor: "text"
                    },
                    {
                        field: 'classId',
                        title: '负责班级ID',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        editor: "text",
                        hidden: true
                    },
                    {
                        field: 'className',
                        title: '负责班级',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        editor: "text"
                    },
                    {
                        field: 'userType',
                        title: '用户类型',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        formatter: function (value, row) {
                            if ("T" == row.userType) return "<font color=red>教师<font>";
                            else return "<font color=green>学生<font>";
                        },
                        editor: "text"
                    },
                    {
                        field: 'isOpenAct',
                        title: '是否开户',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        formatter: function (value, row) {
                            if ("1" == row.isOpenAct) return "<font color=green>已开户<font>";
                            else return "<font color=red>未开户<font>";
                        },
                        editor: "text"
                    }
                ]], 
                toolbar: '#tbTeach',
                onDblClickRow: editTeacher,	    //双击行记录时调用编辑方法
                onClickRow: showAssigned,       //单击行时显示该教师已经分配的班级
                onLoadSuccess: function (data) {
	            	//alert("data=" + JSON.stringify(data));
	                if (data == null || data.rows.length == 0) {
	                    $.messager.show({
	                        title: "提示",
	                        msg: "没有找到符合条件的数据",
	                        timeout: 1000 * 2
	                    });
	                }
	            },
	            onLoadError: function () {
	                $.messager.show({
	                    title: "错误",
	                    msg: "加载数据失败",
	                    timeout: 1000 * 2
	                });
	            }
            });
            
            //院系班级树结构显示
            $classinfo.treegrid({
            	width: 'auto',
                height: $(this).height() - 2,
                url: "zznueg/manage/teastuinfo/getADCMultiMenu",
                rownumbers: true,
                animate: true,
                //fitColumns: true,
                //striped: true,
                idField: 'id',
                treeField: 'name',
                singleSelect: false,
                deepCascadeCheck: true,
                columns: [[ 
                    {field: 'ck', checkbox: true},
                    {field: 'id', title: '菜单ID', width: parseInt($(this).width() * 0.07), align: 'center', hidden: true},
                    {field: 'pid', title: '父菜单ID', width: parseInt($(this).width() * 0.07), align: 'center', hidden: true},
                    {field: 'name', title: '菜单名称', width: parseInt($(this).width() * 0.15), align: 'left'},                    
                    {field: 'pName', title: '父菜单名称', width: parseInt($(this).width() * 0.07), align: 'center'},
                    {field: 'type', title: '菜单类型', width: parseInt($(this).width() * 0.07), align: 'center'}
                    
                ]], toolbar: '#tbClass', 
                onClickRow: function (row) {
                	$classinfo.treegrid('cascadeCheck', {
                        id: row.id,
                        deepCascade: true //深度级联
                    });
                }
            });
                
            
            $("#addTeach").click(function () {
                $.modalDialog({
                    title: "添加教师",
                    width: 600,
                    height: 400,
                    href: "zznueg/manage/teastuinfo/teacherEditDlg",
                    buttons: [{
                        text: '保存',
                        iconCls: 'icon-yes',
                        handler: function () {
                            $.modalDialog.openner = $grid;
                            var f = $.modalDialog.handler.find("#form");
                            f.submit();
                        }
                    }, {
                        text: '取消',
                        iconCls: 'icon-no',
                        handler: function () {
                            $.modalDialog.handler.dialog('destroy');
                            $.modalDialog.handler = undefined;
                        }
                    }
                    ]
                });
            });

            $("#editTeach").click(function () {
            	editTeacher();	//调用编辑方法
            });

            $("#delTeach").click(function () {
                var node = $dg.datagrid('getSelected');
                if (node) {
                    var rowIndex = $dg.datagrid('getRowIndex', node);
                    $.messager.confirm("提示", "确定要删除记录吗?",
                            function (result) {
                                if (result) {
                                    $.ajax({
                                        url: "zznueg/manage/teastuinfo/delTeachStu",
                                        data: {
                                            'id': node.id
                                        },
                                        method: "POST",
                                        dataType: "JSON",
                                        success: function (rsp) {
                                            if (rsp.status) {
                                                $dg.datagrid('deleteRow', rowIndex);
                                            }
                                            $.messager.show({
                                                title: rsp.title,
                                                msg: rsp.message,
                                                timeout: 1000 * 2
                                            });
                                        },
                                        error: function () {
                                            $.messager.show({
                                                title: "提示",
                                                msg: "提交错误了！",
                                                timeout: 1000 * 2
                                            });
                                        }
                                    });
                                }
                            });
                } else {
                    $.messager.show({
                        title: "提示",
                        msg: "请选择一行记录!",
                        timeout: 1000 * 2
                    });
                }
            });
            
            //后台开设系统账户
            $("#openAccount").click(function () {
            	var row = $dg.datagrid('getSelected');
                if (row) {
                	if ("1" == row.isOpenAct) {
                		//alert("该教师已经开户，不能重复开户！");
                		$.messager.show({
	                        title: "提示",
	                        msg: "该教师已经开户，不能重复开户！",
	                        timeout: 1000 * 2
	                    });
                		return;
                	}
                	
                    $.modalDialog({
                        title: "教师开户",
                        width: 600,
                        height: 400,
                        href: "zznueg/manage/teastuinfo/openAccountDlg",
                        onLoad: function () {
                            var f = $.modalDialog.handler.find("#form");
                            f.form("load", {
                            	//为了使得教师学生信息中的字段与用户信息中的字段对应，这里需要重新定义字段名称，以便回显
                            	"id" : row.id,
                            	"userId" : row.id,
                            	"userName" : row.name,
                            	"account" : row.tsno,
                            	"status" : row.status,
                            	"userType" : row.userType
                            });                            
                        },
                        buttons: [{
                            text: '开户',
                            iconCls: 'icon-yes',
                            handler: function () {
                                $.modalDialog.openner = $grid;
                                var f = $.modalDialog.handler.find("#form");
                                f.submit();
                            }
                        },
                            {
                                text: '取消',
                                iconCls: 'icon-no',
                                handler: function () {
                                    $.modalDialog.handler.dialog('destroy');
                                    $.modalDialog.handler = undefined;
                                }
                            }]
                    });
                } else {
                    $.messager.show({
                        title: "提示",
                        msg: "请选择一行记录!",
                        timeout: 1000 * 2
                    });
                }
            });
            
            //保存教师班级关系记录
            $("#assignTeach").click(function () {
                var selections = $classinfo.treegrid('getSelections');
                var selectionTeacher = $dg.datagrid('getSelected');
                var checkedIds = [];

                $.each(selections, function (i, e) {
                	if(e.type == "CLASS") {
                		checkedIds.push(e.id);  //仅仅存储半截节点ID，即classId
                	}                    
                });
                if(checkedIds.length == 0) {
                	//alert("请选择要分配的班级，不能只选择院系节点！");
                	$.messager.show({
                    	title: "提示",
                    	msg: "请选择要分配的班级，不能只选择院系节点！",
                    	timeout: 1000 * 2
                    });
            		return;
                }
//alert(selectionTeacher.id);
//alert(checkedIds.join(","));                
                if (selectionTeacher) {
                    $.ajax({
                        url: "zznueg/manage/teastuinfo/saveTeachClassRel",
                        data: {
                            //这里的数组必须转化成字符串形式
                            //checkedClassIds: checkedIds.length == 0 ? "" : checkedIds.join(","),
                            checkedClassIds: checkedIds.join(","),
                            teachUserId: selectionTeacher.id
                        },
                        type: "POST",
                        dataType: "JSON",
                        success: function (rsp) {
                            $.messager.show({
                                title: rsp.title,
                                msg: rsp.message,
                                timeout: 1000 * 2
                            });
                        },
                        error: function () {
                            $.messager.show({
                                title: "提示",
                                msg: "分配失败！",
                                timeout: 1000 * 2
                            });
                        }
                    });
                } else {
                    $.messager.show({
                        title: "提示",
                        msg: "请选择教师！",
                        timeout: 1000 * 2
                    });
                }
            });            
                                    
            //展开全部树形菜单
            $("#expandAll").click(function () {
                var node = $classinfo.treegrid('getSelected');
                if (node) {
                	//这里一定要注意：属性可用'collapse'或'collapseAll'；但是easyui:tree的该属性参数为target，而easyui:treegrid的该属性参数为id
                	$classinfo.treegrid('expandAll', node.id);
                } else {
                    $classinfo.treegrid('expandAll');
                }
            });

            //收起全部树形菜单
            $("#collapseAll").click(function () {
                var node = $classinfo.treegrid('getSelected');
                if (node) {
                	//这里一定要注意：属性可用'expand'或'expandAll'；但是easyui:tree的该属性参数为target，而easyui:treegrid的该属性参数为id
                    $classinfo.treegrid('collapseAll', node.id);
                } else {
                    $classinfo.treegrid('collapseAll');
                }
            });

            //刷新树形菜单
            $("#refresh").click(function () {
                $classinfo.treegrid('reload');
            });
            
			//弹出批量导入学生信息对话框
            $("#fromExcel").click(function () {
            	//弹出对话框
				$(".tip").fadeIn(200);            	
            });
            
          	//点击取消按钮移除对话框
            $(".cancel").click(function() {
				$(".tip").fadeOut(100);
				$("#uploadFile").filebox("setValue","");
			});
            
        });
        
        //将编辑方法独立出来，以供其他方法调用
        function editTeacher() {
        	var row = $dg.datagrid('getSelected');
            if (row) {
                $.modalDialog({
                    title: "编辑教师",
                    width: 600,
                    height: 400,
                    href: "zznueg/manage/teastuinfo/teacherEditDlg",
                    onLoad: function () {
                        var f = $.modalDialog.handler.find("#form");
                        f.form("load", row);
                    },
                    buttons: [{
                        text: '编辑',
                        iconCls: 'icon-yes',
                        handler: function () {
                            $.modalDialog.openner = $grid;
                            var f = $.modalDialog.handler.find("#form");
                            f.submit();
                        }
                    },
                        {
                            text: '取消',
                            iconCls: 'icon-no',
                            handler: function () {
                                $.modalDialog.handler.dialog('destroy');
                                $.modalDialog.handler = undefined;
                            }
                        }]
                });
            } else {
                $.messager.show({
                    title: "提示",
                    msg: "请选择一行记录!",
                    timeout: 1000 * 2
                });
            }
        }
        
        //显示教师已经分配的班级
        function showAssigned(rowIndex, rowData) {
        	$.ajax({
                url: "zznueg/manage/teastuinfo/getClassInfoByTeacher",
                data: {                	
                    'teachUserId': rowData.id
                },
                method: "POST",
                dataType: "JSON",
                success: function (msg) {                	
                    //初始化班级信息，取消所有的选中
                    $classinfo.treegrid('unselectAll');
                    //判断是否有权限
                    if (msg.length != 0) {
                        //循环选中包含的权限
                        $.each(msg, function (i, e) {
                        	$classinfo.treegrid('select', e.classId);
                        });
                    } else {
                        $.messager.show({
                            title: "提示",
                            msg: "该教师还未分配班级!",
                            timeout: 1000 * 2
                        });
                    }
                },
                error: function () {
                    //获取失败，取消所有的选中
                    $classinfo.treegrid('unselectAll');
                    $.messager.show({
                        title: "提示",
                        msg: "获取班级信息失败!",
                        timeout: 1000 * 2
                    });
                }
            });
        }
        
		//批量导入教师/学生信息
		function batchImport() {
        	//var srcFilePath = $('#uploadFile').filebox('getValue');   //源文件目录(事实证明该目录为伪造-fake目录) alert("srcFilePath=" + srcFilePath);
        	var file = $('input[name="uploadFile"][type="file"]').prop('files')[0];   //获取文件上传对象
        	if (file == null) { alert('错误，请选择文件！'); return; } 
        	//获取文件名称  
	      	var fileName = file.name;  //alert("fileName=" + fileName);
	      	//获取文件类型名称(文件后缀名)，原始文件后缀名
	      	var src_file_typename = fileName.substring(fileName.lastIndexOf('.'), fileName.length); 
	      	//将原始文件后缀名统一转换为小写，再进行比较
	      	var file_typename = src_file_typename.toLocaleLowerCase();
	     	
	    	//这里限定上传文件文件类型必须为(.xls|.xlsx)，目前只实现了Excel97-2003(.xls)的导入
	    	//if(!(file_typename == '.xls'|| file_typename == '.xlsx')) {
	    	if(file_typename != '.xls') {
	    		alert("文件类型错误，导入的只能是后缀名为 .xls 的 Excel 97-2003 文件！");
				return;
	    	}
	    	
	    	//计算文件大小  
          	var fileSize = 0; 
          	//如果文件大小大于1024字节X1024字节，则显示文件大小单位为MB，否则为KB  
          	if (file.size > 1024 * 1024) {  
          		fileSize = Math.round(file.size * 100 / (1024 * 1024)) / 100;  	
          		if (fileSize > 50) {  
	            	alert('错误，文件超过50MB，禁止导入！'); return;  
	            }
          		fileSize = fileSize.toString() + 'MB'; 
	        } else {  
	            fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';  
	        }
          	$("#fileSize").val(fileSize);
          	
          	//获取批量导入form数据  
            var formData = new FormData($("#batchImportForm")[0]); 
          	
            $.ajax({
            	url:'zznueg/manage/teastuinfo/batchImportTeachStuInfo',  
                type: 'POST',  
                data: formData,  
                async: false,  
                cache: false,  
                contentType: false, 
                processData: false, 
                beforeSend: function () {
                	$(".tip").fadeOut(300);
                	$("#sureBtn").css({"background":"url(resources/zznueg/images/btnbg2.png)"});
                	$("#sureBtn").attr("disabled",true); 
                	$("#cancelBtn").attr("disabled",true); 
                	
                	$.messager.progress({   //开始上传文件打开进度条(这里的进度条不现实，待优化！！！)
                        title: '提示',
                        text: '文件导入中，请稍后....'
                    });
                },
                success: function (result) {  //result为json对象
                	//$(".tip").fadeOut(300);  //将对话框移除时机放在beforeSend中，line-354
    				$("#uploadFile").filebox("setValue","");
                	$("#sureBtn").css({"background":"url(resources/zznueg/images/btnbg1.png)"});
                	$("#sureBtn").attr("disabled",false); 
                	$("#cancelBtn").attr("disabled",false);
                	$.messager.progress('close');  //上传完成关闭进度条
                	//alert("import into database successfully!");                	
                	$.messager.show({
                        title: result.title,
                        msg: result.message,
                        timeout: 1000 * 2
                    });   
                	//重新加载表格数据
                	$("#dg").datagrid("reload");
                },
                error: function (result) { 
                	//alert("失败了！！！")
                	$.messager.progress('close');
                	$.messager.show({
                        title: result.title,
                        msg: result.message,
                        timeout: 1000 * 2
                    });
                }                 
            });
          	
        }
	    	
		//通过学生学号或姓名/教师工号或姓名和是否开户标志进行模糊搜索
    	function searchByTsNoAndFlag() {
    		var tsno = $("#tsnoOrName").val();
    		var name = $("#tsnoOrName").val();
    		var isOpenAct = $("#isOpenAct").val();
	        //查询参数直接添加在queryParams中    
	    	var queryParams = $("#dg").datagrid('options').queryParams;
	        queryParams.tsno = tsno;
	        queryParams.name = name;
	        queryParams.isOpenAct = isOpenAct;
	        $("#dg").datagrid('options').queryParams=queryParams;
	        $("#dg").datagrid('reload');   //重新加载datagrid的数据
	    }
	    
    </script>
</head>
<body class="easyui-layout">
	<div id="panel" data-options="border:false">
		<div class="easyui-layout" data-options="fit:true">
			<div data-options="region:'west',split:true,border:true" style="width:63%;">
				<div id="tbTeach" class="easyui-layout">
					<ul class="toolbar">
			            <shiro:hasPermission name="teachAdd">
			                <li id="addTeach"><span><img
			                        src="resources/core/images/t01.png"/></span>添加
			                </li>
			            </shiro:hasPermission>
			            <shiro:hasPermission name="teachEdit">
			                <li id="editTeach"><span><img
			                        src="resources/core/images/t02.png"/></span>修改
			                </li>
			            </shiro:hasPermission>
			            <shiro:hasPermission name="teachDel">
			                <li id="delTeach"><span><img
			                        src="resources/core/images/t03.png"/></span>删除
			                </li>
			            </shiro:hasPermission>            
			            <!-- 后台开设账户 -->
			            <shiro:hasPermission name="teachOpenAct">
			                <li id="openAccount"><span><img
			                        src="resources/core/images/t06.png"/></span>开户
			                </li>
			            </shiro:hasPermission>
			            <!-- 给教师分配班级，一个教师可以教授多个班级 -->
			            <shiro:hasPermission name="teachAssign">
				            <li id="assignTeach"><span><img
				            	src="resources/core/images/save.png"/></span>分配班级
				            </li>
			            </shiro:hasPermission>
			            <!-- 批量导入教师信息 -->
			            <shiro:hasPermission name="batchImportTeachInfo">
				            <li id="fromExcel">
				            	<span><img src="resources/core/images/excel.png"/></span>批量导入
				            </li>
			            </shiro:hasPermission>			            
			        </ul>
			        <ul class="toolbar1">
						<li><b>是否开户：</b>
			        		<select id="isOpenAct" style="height: 100%;" onchange="searchByTsNoAndFlag()">
								<option value="" selected="selected">--请选择--</ption>
								<option value="0">未开户</option>
								<option value="1">已开户</option>
							</select>
			        	</li>
						<li><input id="tsnoOrName" type="text" placeholder="输入教师工号或姓名搜索" /><img id="searchBtn" onclick="searchByTsNoAndFlag()" src="resources/zznueg/img/search.png" /></li>
					</ul>
				</div>
				<table class="tablelist" id="dg" title="教师管理"></table>
			</div>
			
			<div data-options="region:'center',border:true">
	            <div id="tbClass" class="easyui-layout">
	                <ul class="toolbar" style="padding: 6px 2px;">
	                    <li id="expandAll"><span><img
	                            src="resources/core/images/open.png"/></span>展开
	                    </li>
	                    <li id="collapseAll"><span><img
	                            src="resources/core/images/close.png"/></span>收缩
	                    </li>
	                    <li id="refresh"><span><img
	                            src="resources/core/images/refresh.png"/></span>刷新
	                    </li>
	                </ul>
	            </div>
	            <table id="classinfo" title="班级"></table>
	        </div>
			
			<div class="tip">
		        <div class="tiptop">
		            <span>提示信息</span><a></a>
		        </div>
		        <div class="tipinfo">
		            <span><img src="resources/core/images/ticon.png"/></span>
		            <div class="tipright">
		                <p>是否确认对信息的修改 ？</p>
		                <cite>如果是请点击确定按钮 ，否则请点取消。</cite>
		            </div>
		        </div>
		        <div class="tipbtn">
		            <input name="" type="button" class="sure" value="确定"/>&nbsp; <input
		                name="" type="button" class="cancel" value="取消"/>
		        </div>
		    </div>	    
		</div>	
	</div>

	<div class="tip">
		<form id="batchImportForm" method="post" enctype="multipart/form-data">
			<!-- <input name="pid" id="pid" type="hidden" /> -->
			<div class="formbody">	
				<div class="formtitle"><span>批量导入</span></div>
				<ul class="forminfo">
					<li><label>模板下载</label>
						<span style="line-height: 30px;"><b><a href="download/demo_T.xls">批量导入教师信息模板.xls</a></b></span>
					</li>
					<li><label>&nbsp;</label></li>
					<li><label>批量导入文件</label>
						<input id="uploadFile" name="uploadFile" data-options="prompt:'请选择要批量导入的文件...',buttonText:'选择'" class="dfinput easyui-filebox" style="width:345px; height:32px;"/><i>不超过50M</i>
						<input name="fileSize" id="fileSize" type="hidden" />
					</li>
					<li><label>&nbsp;</label></li>
					<li><label>&nbsp;</label></li>
				</ul>
			</div>
		</form>	
		<div class="tipbtn">
			<input id="sureBtn" name="sureBtn" type="button" class="sure" value="导入" onclick="batchImport()" />&nbsp;
			<input id="cancelBtn" name="cancelBtn" type="button" class="cancel" value="取消" />
		</div>
	</div>

</body>
</html>