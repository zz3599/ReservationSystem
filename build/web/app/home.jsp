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
    </head>
    <body>        
        <ul class="menu">
            <li><a href="home.jsp">Home</a></li>
            <li><a href="news.asp">News</a></li>
            <li><a href="contact.asp">Contact</a></li>
            <li><a href="about.asp">About</a></li>
        </ul>
        
        <h2>Hello ${user.fullname}</h2>
    <c:choose>
  <c:when test="${user.usertype == 0}">
      <p>admin</p>
  </c:when>
  <c:when test="${user.usertype == 1}">
      <p>viewer</p>
  </c:when>
  <c:otherwise>
    <p>user</p>
  </c:otherwise>
</c:choose>

</body>
</html>
