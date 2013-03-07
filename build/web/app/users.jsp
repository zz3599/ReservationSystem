<%-- 
    Document   : users
    Created on : Mar 6, 2013, 12:55:04 PM
    Author     : brook
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Users</title>
        <script src="../js/jquery-1.9.1.min.js"></script>
        <script src="../js/jquery-ui-1.9.2.custom.min.js"></script>
        <script src="../js/jquery-ui-timepicker-addon.js"></script>
        <script src="../js/mustache.min.js"></script>
        <link rel="stylesheet" type="text/css" href="../css/main.css">
        <link rel="stylesheet" type="text/css" href="../css/jquery-ui-1.9.2.custom.min.css">
    </head>
    <body>
        <h1>Manage Users</h1>
        <div id="usersdiv">
            <c:forEach items="${users}" var="user">
                <div class="" id="${user.id}">${user.fullname}, handle: ${user.username}</div>            
            </c:forEach>
        </div>
        <div id="adduser">
            <p>Add User<p>
            <form id="adduserform" name="adduser" action="">
                Username: <input type="text" name="username"/><br>
                Password: <input type="password" name="password"/><br> 
                Name: <input type="text" name="fullname"/><br>
                Role: <select name="usertype"><option value="0">Administrator</option><option value="1">Viewer</option><option value="2">User</option></select>
                <input type="hidden" name="action" value="adduser">
                <br><input id="submit" type="submit">
            </form>
        </div>
        <div id="errors"></div>

    </body>
    <script>
        $(document).ready(function() {
            $('#submit').click(function(e) {
                e.preventDefault();
                var parent = $('#usersdiv');
                var template = "<div id={{id}}> {{fullname}}, handle: {{username}}</div>";
                $.ajax({
                    type: "POST",
                    url: "users",
                    data: $('#adduserform').serialize(),
                    success: function(data) {
                        try {
                            var newuser = $(Mustache.render(template, JSON.parse(data)));
                            newuser.appendTo(parent);
                        } catch (e) {
                            $('#errors').text('Someone already has the username.');
                        }

                    },
                    error: function(t) {
                        alert(t);
                    }
                });
            });
        });

    </script>
</html>
