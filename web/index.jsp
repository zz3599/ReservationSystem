<%-- 
    Document   : index
    Created on : Mar 4, 2013, 1:18:02 PM
    Author     : brook
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="css/main.css">
        <link rel="stylesheet" type="text/css" href="css/jquery-ui-1.9.2.custom.min.css">
        <title>Login</title>
    </head>
    <body>
        <form name="form" class="loginform" id="loginForm" action="LoginServlet" method="post">
            Username: <input type="text"  name="username"> <br>
            Password: <input type="password" name="password"> <br>
            <input class="loginbutton" type="submit" value="Login">
            <div><c:out value="${requestScope.errorMessage}"/></div>
        </form>
    </body>    
</html>
