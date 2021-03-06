<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ page language="java" pageEncoding="UTF-8" %>
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
    <title>用户管理</title>
    <tags:include/>
    <script type="text/javascript">
        var $dg;
        var $grid;
        $(function () {
            $dg = $("#dg");
            $grid = $dg.datagrid({
                width: 'auto',
                height: $(this).height() - 2,
                url: "manage/users/allUserByPage",
                queryParams:{},
                pagination: true,
                rownumbers: true,
                animate: true,
                fitColumns: true,
                striped: true,
                border: true,
                idField: 'userId',
                singleSelect: true,
                columns: [[
                    {
                        field: 'userName',
                        title: '用户名称',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        editor: "text"
                    },
                    {
                        field: 'account',
                        title: '用户账号',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        editor: "text"
                    },
                    {
                        field: 'userPhone',
                        title: '联系电话',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        editor: {type: 'validatebox', options: {required: true}}
                    },
                    {
                        field: 'userEmail',
                        title: '邮箱',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        editor: {type: 'validatebox', options: {required: true, validType: 'email'}}
                    },
                    {
                        field: 'prevIp',
                        title: '登录IP',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        editor: "text"
                    },
                    {
                        field: 'userDesc',
                        title: '用户描述',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        editor: "text"
                    },
                    {
                        field: 'userType',
                        title: '用户类别',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        formatter: function (value, row) {
                            if ("T" == row.userType) return "<font color=red>教师<font>";
                            else if("S" == row.userType) return "<font color=green>学生<font>";
                        },
                        editor: "text"
                    }
                ]], toolbar: '#tb'
            });

            $("#userPost").click(function () {
                //首先判断是否选择用户
                var node = $("#dg").treegrid('getSelected');
                if (node) {
                    //设置弹出窗口
                    $.modalDialog({
                        title: "用户岗位设定",
                        width: 300,
                        height: 400,
                        href: "manage/users/userPost",
                        buttons: [{
                            text: '保存',
                            iconCls: 'icon-yes',
                            handler: function () {
                                //获取弹出窗口中的控件ID
                                var f = $.modalDialog.handler.find("#postList");
                                //获取该控件被选中的成员
                                var selections = f.tree('getChecked');

                                //处理成可以当成参数传输的形式
                                var checkedIds = [];
                                $.each(selections, function (i, e) {
                                    checkedIds.push(e.id);
                                });
                                //异步调用处理
                                $.ajax({
                                    url: "manage/users/saveUserPost",
                                    data: {
                                        //这里的数组必须转化成字符串形式
                                        isCheckedIds: checkedIds.length == 0 ? "" : checkedIds.join(","),
                                        userId: node.userId
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
                                //关闭弹出窗口
                                $.modalDialog.handler.dialog('destroy');
                                $.modalDialog.handler = undefined;
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
                } else {
                    $.messager.show({
                        title: "提示",
                        msg: "请先选择要设置的用户!",
                        timeout: 1000 * 2
                    });
                }
            });

            $("#userRole").click(function () {
                //首先判断是否选择用户
                var node = $("#dg").treegrid('getSelected');
                if (node) {
                    //设置弹出窗口
                    $.modalDialog({
                        title: "用户角色设定",
                        width: 300,
                        height: 400,
                        href: "manage/users/userRole",
                        buttons: [{
                            text: '保存',
                            iconCls: 'icon-yes',
                            handler: function () {
                                //获取弹出窗口中的控件ID
                                var f = $.modalDialog.handler.find("#roleList");
                                //获取该控件被选中的成员
                                var selections = f.datalist('getSelections');
                                //处理成可以当成参数传输的形式
                                var checkedIds = [];
                                $.each(selections, function (i, e) {
                                    checkedIds.push(e.roleId);
                                });
                                //异步调用处理
                                $.ajax({
                                    url: "manage/users/saveUserRoles",
                                    data: {
                                        //这里的数组必须转化成字符串形式
                                        isCheckedIds: checkedIds.length == 0 ? "" : checkedIds.join(","),
                                        userId: node.userId
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
                                //关闭弹出窗口
                                $.modalDialog.handler.dialog('destroy');
                                $.modalDialog.handler = undefined;
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
                } else {
                    $.messager.show({
                        title: "提示",
                        msg: "请先选择要设置的用户!",
                        timeout: 1000 * 2
                    });
                }
            });

            $("#userPmsn").click(function () {
                //首先判断是否选择用户
                var node = $("#dg").treegrid('getSelected');
                if (node) {
                    //设置弹出窗口
                    $.modalDialog({
                        title: "用户权限设定",
                        width: 600,
                        height: 400,
                        href: "manage/users/userPmsn",
                        buttons: [{
                            text: '保存',
                            iconCls: 'icon-yes',
                            handler: function () {
                                //获取弹出窗口中的控件ID
                                var f = $.modalDialog.handler.find("#function");
                                //获取该控件被选中的成员
                                var selections = f.treegrid('getSelections');
                                //处理成可以当成参数传输的形式
                                var checkedIds = [];
                                $.each(selections, function (i, e) {
                                    checkedIds.push(e.id);
                                });
                                //异步调用处理
                                $.ajax({
                                    url: "manage/users/saveUserPmsn",
                                    data: {
                                        //这里的数组必须转化成字符串形式
                                        isCheckedIds: checkedIds.length == 0 ? "" : checkedIds.join(","),
                                        userId: node.userId
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
                                //关闭弹出窗口
                                $.modalDialog.handler.dialog('destroy');
                                $.modalDialog.handler = undefined;
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
                } else {
                    $.messager.show({
                        title: "提示",
                        msg: "请先选择要设置的用户!",
                        timeout: 1000 * 2
                    });
                }
            });

            $("#addUser").click(function () {
                $.modalDialog({
                    title: "添加用户",
                    width: 600,
                    height: 400,
                    href: "manage/users/usersEditDlg",
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

            $("#updateUser").click(function () {
                var row = $dg.datagrid('getSelected');
                if (row) {
                    $.modalDialog({
                        title: "编辑用户",
                        width: 600,
                        height: 400,
                        href: "manage/users/usersEditDlg",
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
            });

            $("#delUser").click(function () {
                var node = $dg.datagrid('getSelected');
                if (node) {
                    var rowIndex = $dg.datagrid('getRowIndex', node);
                    $.messager.confirm("提示", "确定要删除记录吗?",
                            function (result) {
                                if (result) {
                                    $.ajax({
                                        url: "manage/users/delUser",
                                        data: {
                                            'userId': node.userId
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
        });
        
        //根据用户账号和用户类型进行（模糊）检索
        function searchByAccountAndUserType() {
        	var account = $("#account").val();
    		var userType = $("#userType").val();
	        //查询参数直接添加在queryParams中    
	    	var queryParams = $("#dg").datagrid('options').queryParams;
	        queryParams.account = account;
	        queryParams.userType = userType;
	        $("#dg").datagrid('options').queryParams=queryParams;
	        $("#dg").datagrid('reload');   //重新加载datagrid的数据
        }
        
    </script>
</head>
<body class="easyui-layout">
<div data-options="region:'center'" class="rightinfo">
    <div class="easyui-layout" id="tb">
        <ul class="toolbar">
            <shiro:hasPermission name="userAdd">
                <li id="addUser"><span><img
                        src="resources/core/images/t01.png"/></span>添加
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="userEdit">
                <li id="updateUser"><span><img
                        src="resources/core/images/t02.png"/></span>修改
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="userDel">
                <li id="delUser"><span><img
                        src="resources/core/images/t03.png"/></span>删除
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="userPost">
                <li id="userPost"><span><img
                        src="resources/core/images/save.png"/></span>设定岗位
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="userRole">
                <li id="userRole"><span><img
                        src="resources/core/images/save.png"/></span>关联角色
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="userPmsn">
                <li id="userPmsn"><span><img
                        src="resources/core/images/save.png"/></span>特殊授权
                </li>
            </shiro:hasPermission>
        </ul>
        <ul class="toolbar1">
        	<li><b>用户类别：</b>
        		<select id="userType" style="height: 100%;" onchange="searchByAccountAndUserType()">
					<option value="" selected="selected">--请选择--</ption>
					<option value="S">学生</option>
					<option value="T">教师</option>
				</select>
        	</li>
			<li><input id="account" type="text" placeholder="输入用户账号搜索" /><img id="searchBtn" onclick="searchByAccountAndUserType()" src="resources/core/images/search1.png" /></li>
		</ul>
    </div>
    <table class="tablelist" id="dg" title="用户"></table>

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
</body>
</html>