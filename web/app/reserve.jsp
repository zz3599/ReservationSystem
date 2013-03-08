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
        <h1>Reservations</h1>

        <c:if test="${user.usertype == 2}">
            <div id="yourslot">
                <div id="yourslotid" style="display:none;"><c:out value="${yourslot.id}"/></div>
                <c:if test="${yourslot != null}">
                    Your reservation time: 
                    <c:out value="${yourslot.start}"/> to <c:out value="${yourslot.end}"/>
                </c:if>
            </div>

        </c:if>
        <div id="eventdetails">
            <h4>Event Details</h4>
            Event: <c:out value="${event.title}"/><br>
            Date: <c:out value="${event.date}"/><br>
            Location: <c:out value="${event.location}"/><br>
            Supervisor/TA: <c:out value="${event.supervisor}"/><br>
            Slot duration: <c:out value="${event.duration}"/><br>
        </div>
        <br>
        <div class="list" id="reservedtimes">
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
            var yourslotid = $('#yourslotid');
            var template = 'Your reservation time: {{stime}}';
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
                        if (data === 'fail') {
                            messages.text('Database error');

                        } else if (data === 'denied') {
                            messages.text('You do not have permission to make a reservation');
                        } else {//success
                            messages.text('You successfully made a reservation');
                            var obj = JSON.parse(data);
                            yourslot.text(Mustache.render(template, obj));
                            var oldreservedslot = yourslotid.text();

                            var oldslot = $('#' + oldreservedslot);
                            var newtext = $('#' + oldreservedslot).text().replace('reserved', 'open');
                            oldslot.text(newtext);

                            //update the slotnum in hidden field
                            yourslotid.text(slotnum);

                            var newreservedslot = $('#' + slotnum);
                            var newR = newreservedslot.text().replace('open', 'reserved');
                            newreservedslot.text(newR);
                            //change color/text of the slotnum
                        }
                    }
                });
            });
        });

    </script>

</html>
