<%-- 
    Document   : reserve
    Created on : Mar 6, 2013, 4:05:54 PM
    Author     : brook
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Make a Reservation</title>
        <script src="../js/jquery-1.9.1.min.js"></script>
        <script src="../js/jquery-ui-1.9.2.custom.min.js"></script>
        <script src="../js/jquery-ui-timepicker-addon.js"></script>
        <script src="../js/mustache.min.js"></script>
        <link rel="stylesheet" type="text/css" href="../css/main.css">
        <link rel="stylesheet" type="text/css" href="../css/jquery-ui-1.9.2.custom.min.css">
    </head>
    <body>
        <h1>Reservations</h1>
        
        <c:if test="${user.usertype == 2}">
            <div id="yourslot">
                <c:if test="${yourslot != null}">
                    Your reservation time: 
                    <c:out value="${yourslot}"/>
                </c:if>
            </div>
            
        </c:if>
        <div id="eventdetails">
            <p>Event Details</p>
            Event: <c:out value="${event.title}"/><br>
            Date: <c:out value="${event.date}"/><br>
            Location: <c:out value="${event.location}"/><br>
            Supervisor/TA: <c:out value="${event.supervisor}"/><br>
        </div>
        <br>
        <div id="reservedtimes">
            <c:forEach items="${slots}" var="slot">
                <div class="" id="${slot.id}"> 
                    start: ${slot.start}, end: ${slot.end}

                    <c:if test="${user.usertype != 2}">
                        <c:if test="${slot.user != null}"> 
                            reserved user: <c:out value="${slot.user.fullname}"/>
                        </c:if>
                        <c:if test="${slot.user == null}"> 
                            open
                        </c:if>
                    </c:if>
                    <c:if test="${user.usertype == 2}">
                        <c:if test="${slot.user != null}"> 
                            reserved
                        </c:if>
                        <c:if test="${slot.user == null}"> 
                            open
                        </c:if>
                    </c:if>
                </div>
            </c:forEach>
        </div>
        <div id="messages">            
        </div>
    </body>

    <script>
        $(document).ready(function() {
            var messages = $('#messages');
            var yourslot = $('#yourslot');
            $('#reservedtimes').delegate('div', 'click', function() {
                var slotnum = this.id;
                var textcontent = $(this).text();
                if (textcontent.indexOf('open') === -1) {
                    messages.text('You selected a reserved time slot');
                    return;
                }
                $.ajax({
                    type: 'POST',
                    url: 'reserve?action=reserve',
                    data: {'slotnum': slotnum},
                    success: function(data) {
                        if (data === 'success') {
                            messages.text('You successfully made a reservation');
                            //yourslot.text()
                            //change color/text of the slotnum
                        } else if(data === 'denied'){
                            messages.text('You do not have permission to make a reservation');
                        } else {
                            messages.text('Database error');
                        }
                    }
                });
            });
            var etemp = "<div id={{id}}> {{location}}, startime: {{startTime}}, endtime: {{endTime}}</div>";
            var reservedslots = [];
            if ($('#searchusers').length === 0) {
                //user and viewer cannot do anything below here
                return;
            }
        });

    </script>

</html>
