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
        <title>Make Reservation</title>
        <script src="../js/jquery-1.9.1.min.js"></script>
        <script src="../js/jquery-ui-1.9.2.custom.min.js"></script>
        <script src="../js/jquery-ui-timepicker-addon.js"></script>
        <script src="../js/mustache.min.js"></script>
        <link rel="stylesheet" type="text/css" href="../css/main.css">
        <link rel="stylesheet" type="text/css" href="../css/jquery-ui-1.9.2.custom.min.css">
    </head>
    <body>
        <h1>Reservations</h1>
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
                <div class="" id="${slot.id}"/> 
                    start: ${slot.start}, end: ${slot.end}
                    <c:if test="${user.usertype != 2}">
                        reserved user: 
                        <c:if test="${slot.user != null}"> 
                            <c:out value="${slot.user.fullname}"/>
                        </c:if>
                    </c:if>
                </div>
            </c:forEach>
        </div>
</body>

<script>
    $(document).ready(function() {        
        var etemp = "<div id={{id}}> {{location}}, startime: {{startTime}}, endtime: {{endTime}}</div>";
        var reservedslots = [];
//        $.ajax({
//            type: 'POST',
//            url: 'reserve',
//            data: {action: 'getall'},
//            success: function(data) {
//                try {
//                    $.each(JSON.parse(data), function(i, d) {
//                        var slotnum = d.slotnum;
//                        reservedslots.push(slotnum);
//                        //$(Mustache.render(etemp, d)).appendTo(events);
//                    });
//                    //render time slots
//                } catch (e) {
//                    //no events 
//                }
//            }
//        });
        if ($('#searchusers').length === 0) {
            //user and viewer cannot do anything below here
            return;
        }
    });

</script>

</html>
