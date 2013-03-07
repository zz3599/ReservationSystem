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
        <title>Login</title>
    </head>
    <body>
        <form name="form" id="loginForm" action="LoginServlet" method="post">
            Username: <input type="text"  name="username"> <br>
            Password: <input type="password" name="password"> <br>
            <input type="submit" value="Login">            
        </form>
        <div><c:out value="${requestScope.errorMessage}"/></div>
    </body>    
</html>
