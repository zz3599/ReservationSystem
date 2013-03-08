<%-- 
    Document   : events
    Created on : Mar 6, 2013, 12:53:07 PM
    Author     : brook
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Events</title>
        <script src="../js/jquery-1.9.1.min.js"></script>
        <script src="../js/jquery-ui-1.9.2.custom.min.js"></script>
        <script src="../js/jquery-ui-timepicker-addon.js"></script>
        <script src="../js/mustache.min.js"></script> 
        <link rel="stylesheet" type="text/css" href="../css/main.css">
        <link rel="stylesheet" type="text/css" href="../css/jquery-ui-1.9.2.custom.min.css">
    </head>
    <body>
        <h1>Event Listing</h1>
        <div id="listevents">
            <c:forEach items="${events}" var="e">
                <div class="" id="${e.id}">
                    Event: ${e.title} <br>
                    Location: ${e.location}  <br>
                    TA: ${e.supervisor} <br>
                    Starts: ${e.startTime} <br>
                    Ends: ${e.endTime} <br>
                    <a href="reserve?eventid=${e.id}">Reserve</a>
                </div>  
                <br>
            </c:forEach>
            
        </div>
        <c:if test="${user.usertype == 0}">
            <div id="addevent">
                <p>Add Event<p>
                <form id="addeventform" name="addevent">
                    Title(something descriptive) <input id="title" type="text" name="title"/><br>
                    Location: <input id="location" type="text" name="location"/><br>
                    Supervisor: <input type="text" id="supervisor" name="supervisor"/><br>
                    Start: <input type="text" id="startTime" name="startTime" value="" class=""/><br>
                    End: <input type="text" id="endTime" name="endTime" value="" class=""/><br>
                    Slot Duration (minutes)<input type="text" id="duration" name="duration" value=""/><br>
                    <input type="hidden" name="action" value="addevent"><br>
                    <br><input id="addeventsubmit" type="submit">
                </form>
            </div>
            <div id="errors"></div>
        </c:if>
    </body>
    <script>
        $(document).ready(function() {
            if ($('#addevent').length === 0)
                return;
            var startDateTextBox = $('#startTime');
            var endDateTextBox = $('#endTime');

            startDateTextBox.datetimepicker({
                dateFormat: "yy-mm-dd",
                timeFormat: "hh:mm:ss",
                onClose: function(dateText, inst) {
                    if (endDateTextBox.val() !== '') {
                        var testStartDate = startDateTextBox.datetimepicker('getDate');
                        var testEndDate = endDateTextBox.datetimepicker('getDate');
                        if (testStartDate > testEndDate)
                            endDateTextBox.datetimepicker('setDate', testStartDate);
                    }
                    else {
                        endDateTextBox.val(dateText);
                    }
                },
                onSelect: function(selectedDateTime) {
                    endDateTextBox.datetimepicker('option', 'minDate', startDateTextBox.datetimepicker('getDate'));
                }
            });
            endDateTextBox.datetimepicker({
                dateFormat: "yy-mm-dd",
                timeFormat: "hh:mm:ss",
                onClose: function(dateText, inst) {
                    if (startDateTextBox.val() !== '') {
                        var testStartDate = startDateTextBox.datetimepicker('getDate');
                        var testEndDate = endDateTextBox.datetimepicker('getDate');
                        if (testStartDate > testEndDate)
                            startDateTextBox.datetimepicker('setDate', testEndDate);
                    }
                    else {
                        startDateTextBox.val(dateText);
                    }
                },
                onSelect: function(selectedDateTime) {
                    startDateTextBox.datetimepicker('option', 'maxDate', endDateTextBox.datetimepicker('getDate'));
                }
            });
            $('#addeventsubmit').click(function(e) {
                e.preventDefault();
                var location, supervisor, stime, etime, title, duration;
                var parent = $('#listevents');
                var template = '<br><div id={{id}}> Event: {{title}} <br> Location: {{location}}  <br>' + 
                    'TA: {{supervisor}}<br>Starts: {{startTime} <br>Ends: {{endTime}}</div>';
                if (!(location = $('#location').val()) || !(supervisor = $('#supervisor').val()) ||
                        !(stime = $('#startTime').val()) || !(etime = $('#endTime').val()) ||
                        !(title = $('#title').val()) || !(duration = $('#duration').val())) {
                    $('#errors').text('Please fill all fields');
                } else {
                    $('#errors').hide();
                    var datastring = $('#addeventform').serialize();
                    $.ajax({
                        type: 'POST',
                        url: 'events',
                        data: $('#addeventform').serialize(),
                        success: function(data) {
                            try {
                                var datao = JSON.parse(data);
                                var newevent = $(Mustache.render(template, datao)).appendTo(parent);
                                var newlink = $("<a>", {href: 'reserve?id=' + datao.id}).appendTo(newevent);
                                $('#errors').hide();
                            } catch (e) {
                                $('#errors'), text('Time conflict with another event');
                            }
                        },
                        error: function(er) {
                            alert(er);
                        }
                    });

                }
            });
        });
    </script>
</html>
