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
        <script src="jquery-1.9.1.min.js"></script>
        <title>Login</title>
    </head>
    <body>
        <form name="form" id="loginForm" action="LoginServlet" method="post">
            Username: <input type="text" size="20" name="username"> <br>
            Password: <input type="password" size="20" name="password"> <br>
            <input type="submit">            
        </form>
        <div><c:out value="${requestScope.errorMessage}"/></div>
    </body>
    <script>
        $(document).ready(function(){
           $('#submit').click(function(){
              $.ajax({
                  type: "POST",
                  url: "LoginServlet",
                  data: $('#loginForm').serialize(),
                  success: function(result){    
                      alert(result);
                      if(result === 'true'){
                          //redirect to the main page
                          $('#errors').text('');
                          window.location = "./app/home.jsp";
                      } else {                          
                          $('#errors').text('Invalid credentials');
                      }
                  }
              }); 
           });
        });
        
    </script>
</html>
