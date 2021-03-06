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
    <title>岗位用户查看</title>
    <tags:include/>
    <script type="text/javascript">

        $(function () {
            $('#postList').tree({
                url: 'manage/users/getPostList',
                animate: true,
                onClick: function (node) {
                    var type = node.pid;
                    var url = "";
                    switch (type) {
                        case "POST":
                            url = "manage/users/findUserByPost/" + node.id;
                            break;
                        case "DIV":
                            url = "manage/users/findUserByDiv/" + node.id;
                            break;
                        default:
                            url = "manage/users/findUserByCo/" + node.id;
                    }
                    getUserList(url);
                }
            });

            getUserList("manage/users/allUserByPage");
        });

        function getUserList(url) {
            $("#dg").datagrid({
                width: 'auto',
                height: $(this).height() - 2,
                url: url,
                pagination: true,
                animate: true,
                rownumbers: true,
                fitColumns: true,
                striped: true,
                border: true,
                idField: 'userId',
                singleSelect: true,
                columns: [[
                    {
                        field: 'userId',
                        title: '用户序号',
                        width: parseInt($(this).width() * 0.05),
                        align: 'center',
                        editor: "text"
                    }, {
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
                        title: '用户类型',
                        width: parseInt($(this).width() * 0.1),
                        align: 'center',
                        formatter: function (value, row) {
                            if ("T" == row.userType) return "<font color=red>教师<font>";
                            else if("S" == row.userType) return "<font color=green>学生<font>";
                        },
                        editor: "text"
                    }
                ]], toolbar: '#tb',
                onLoadSuccess: function (data) {
                    if (data == null) {
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
        }
    </script>
</head>
<body class="easyui-layout">
<div data-options="region:'west'" style="padding:10px 0px 0px 5px;width:250px;background-color: #eff8fc">
    <ul id="postList"/>
</div>
<div data-options="region:'center'" class="rightinfo">
    <table class="tablelist" id="dg" title="用户"></table>
</div>
</body>
</html>