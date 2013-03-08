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
        <div class="horizontal">
            <ul id="mainmenu"class="menu">
                <li><a href="home.jsp">Home</a></li>
                <li><a href="logout">Logout</a></li>
                    <c:choose>
                        <c:when test="${user.usertype == 0}">
                        <li><a id="manageusers" href="users">Manage Users</a></li>
                        <li><a id="viewevents" href="events">View/Create Events</a></li>
                        <li><a id="assignuser" href="assign">Assign User To Event</a></li>
                        </c:when>
                        <c:when test="${user.usertype == 1}">
                        <li><a id="viewevents" href="events">View Events</a></li>
                        </c:when>
                        <c:otherwise>
                        <li><a id="viewevents" href="events">View Events</a></li>
                        </c:otherwise>
                    </c:choose>
            </ul>
        </div>
        <h1>Manage Users</h1>
        <h2>Click any user to delete</h2>
        <div class="list" id="usersdiv">
            <c:forEach items="${users}" var="user">
                <div class="" id="${user.id}">
                    ${user.fullname}, username: ${user.username}, 
                    role: 
                    <c:choose>
                        <c:when test="${user.usertype == 0}">
                            administrator
                        </c:when>
                        <c:when test="${user.usertype == 1}">
                            viewer
                        </c:when>
                        <c:otherwise>
                            user
                        </c:otherwise>
                    </c:choose>

                </div>            
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
                var template = "<div id={{id}}> {{fullname}}, username: {{username}}, handle: {{username}}</div>";
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
            $('#usersdiv').delegate("div", "click", function(e) {
                var id = this.id;
                $.ajax({
                    type: 'POST',
                    url: 'users',
                    data: {action: 'removeuser', id: id},
                    success: function(data) {
                        if (data === 'success') {
                            $('#' + id).remove();
                        }
                    }
                });

            });
        });

    </script>
</html>
