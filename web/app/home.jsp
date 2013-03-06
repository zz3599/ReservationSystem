<%-- 
    Document   : events
    Created on : Mar 4, 2013, 10:20:51 PM
    Author     : brook
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home</title>
        <script src="../js/jquery-1.9.1.min.js"></script>
        <script src="../js/jquery-ui-1.9.2.custom.min.js"></script>
        <script src="../js/jquery-ui-timepicker-addon.js"></script>
        <script src="../js/mustache.min.js"></script>
        <script src="../js/main.js"></script>
        <link rel="stylesheet" type="text/css" href="../css/main.css">
        <link rel="stylesheet" type="text/css" href="../css/jquery-ui-1.9.2.custom.min.css">
    </head>
    <body>        
        <ul id="mainmenu"class="menu">
            <li><a href="home.jsp">Home</a></li>
            <c:choose>
                <c:when test="${user.usertype == 0}">
                    <li><a id="manageusers" href="users">Manage Users</a></li>
                    <li><a id="viewevents" href="events">View/Create Events</a></li>
                    <li><a id="assignuser" href="reserve">Assign User To Event</a></li>
                </c:when>
                <c:when test="${user.usertype == 1}">
                    <li><a id="viewevents" href="events">View Events</a></li>
                </c:when>
                <c:otherwise>
                    <li><a id="viewevents" href="events">View Events</a></li>
                    <li><a id="makereserve" href="#">Make Reservation</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
        <h2>Hello ${user.fullname}!</h2>
        <div id="content"></div>
        <script>
            $(document).ready(function(){
               $('#mainmenu').delegate("a", "click", function(e){
                   var id = $(this).attr('id');
               }) ;
            });
            
        </script>
    </body>
</html>
