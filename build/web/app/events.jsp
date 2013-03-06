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
        <script src="../js/main.js"></script>
        <link rel="stylesheet" type="text/css" href="../css/main.css">
        <link rel="stylesheet" type="text/css" href="../css/jquery-ui-1.9.2.custom.min.css">
    </head>
    <body>
        <h1>Event Listing</h1>
        <div id="listevents">
            <c:forEach items="${events}" var="e">
                <div class="" id="${e.id}">${e.location}, starttime: ${e.startTime}, endtime: ${e.endTime}</div>            
            </div>
        </c:forEach>
        <c:if test="${user.usertype == 0}">
            <div id="addevent">
                <p>Add Event<p>
                <form id="addeventform" name="addevent">
                    Location: <input id="location" type="text" name="location"/><br>
                    Supervisor: <input type="text" id="supervisor" name="supervisor"/><br>
                    Start: <input type="text" id="startTime" name="startTime" value="" class=""><br>
                    End: <input type="text" id="endTime" name="endTime" value="" class=""><br>
                    <input type="hidden" name="action" value="addevent"><br>
                    <br><input id="addeventsubmit" type="submit">
                </form>
            </div>
            <div id="errors"></div>
        </c:if>
    </body>
    <script>
        $(document).ready(function() {
            if($('#addevent').length === 0) return;
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
                var location, supervisor, stime, etime;
                var parent = $('#listevents');
                var template = "<div id={{id}}> {{location}}, startime: {{startTime}}, endtime: {{endTime}}</div>";
                if (!(location = $('#location').val()) || !(supervisor = $('#supervisor').val()) ||
                        !(stime = $('#startTime').val()) || !(etime = $('#endTime').val())) {
                    $('#errors').text('Please fill all fields');
                } else {
                    $('#errors').hide();
                    //var datastring = 'action=addevent&location=' + location + '&supervisor=' + supervisor + '&startTime=' +
                    //       stime + '&endTime=' + etime;
                    var datastring = $('#addeventform').serialize();
                    $.ajax({
                        type: 'POST',
                        url: 'events',
                        data: $('#addeventform').serialize(),
                        success: function(data) {
                            try {
                                $(Mustache.render(template, JSON.parse(data))).appendTo(parent);
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
