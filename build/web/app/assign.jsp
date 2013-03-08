<%-- 
    Document   : assign
    Created on : Mar 7, 2013, 7:18:59 PM
    Author     : brook
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" 
           uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="../js/jquery-1.9.1.min.js"></script>
        <script src="../js/jquery-ui-1.9.2.custom.min.js"></script>
        <script src="../js/jquery-ui-timepicker-addon.js"></script>
        <script src="../js/mustache.min.js"></script>
        <link rel="stylesheet" type="text/css" href="../css/main.css">
        <link rel="stylesheet" type="text/css" href="../css/jquery-ui-1.9.2.custom.min.css">
        <title>Assign Users</title>
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
        <c:if test="${user.usertype == 0}">
            <div>
                <h2>Click to select</h2>
                <h3>Event Listing</h3>
                <div class="list" id="listevents">
                    <c:forEach items="${events}" var="e">
                        <div class="" id="${e.id}">
                            Event: ${e.title} <br>
                            Location: ${e.location}  <br>
                            TA: ${e.supervisor} <br>
                            Starts: ${e.startTime} <br>
                            Ends: ${e.endTime}
                        </div>  
                        <br>
                    </c:forEach>
                </div>
                <p>Select a user:</p>
                <div id="searchusers">
                    Search for users by name/username: <input id="query" type="text" /><br>
                    <div id="matchingusers"></div>
                </div>
                <div id="selecteddiv">
                Selected Event: <div id="selectedevent"></div>
                Selected User:<div id="selecteduser"></div>
                </div>
                <button id="confirmreserve" type="button">Confirm Assignment</button>
                <div id="errors"></div>
            </div>
        </c:if>
    </body>
    <script>
        $(document).ready(function() {
            var errors = $('#errors'), reservedeventid, reserveduserid;
            //for the selected user
            $('#listevents').delegate('div', 'click', function() {
                errors.text('');
                if ($(this).attr('reserved') === 'true') {
                    errors.text('Event is already reserved');
                    return;
                }
                reservedeventid = this.id;
                $('#selectedevent').text(this.textContent);
            });
            //for the matching users
            $('#matchingusers').delegate('div', 'click', function() {
                reserveduserid = this.id.split('_')[1];
                $('#selecteduser').text(this.textContent);
            });
            createSearchUserBar();
            $('#confirmreserve').click(function() {
                errors.text('');
                if (!reservedeventid || !reserveduserid) {
                    errors.text('You did not select a valid event/user');
                    return;
                }
                $.ajax({
                    type: 'POST',
                    url: 'assign?action=assignuser',
                    data: {userid: reserveduserid, eventid: reservedeventid},
                    success: function(res) {
                        var user = $('#selecteduser').text();
                        if (res === 'success') {
                            //$('#' + reservedeventid).attr('reserved', 'true');
                            $('#errors').text('Assigned ' + user);
                            //change the color of the event
                        } else {
                            //failed, do something
                            $('#errors').text(user + ' is already assigned to event');

                        }
                    },
                    error: function(x, t, e) {
                        alert(t);
                    }
                });
            });


            function createSearchUserBar() {
                var template = "<div id=user_{{id}}>{{fullname}} (handle: {{username}})</div>";
                $('#query').keyup(function(event) {
                    var text = this.value;
                    if (!text || text.length === 0) {
                        $('#matchingusers').empty();
                        return;
                    }
                    $.post("users?action=finduser", {'query': text}, function(data) {
                        //update a div to show the results
                        try {
                            $('#matchingusers').empty();
                            $.each(data, function(i, d) {
                                $(Mustache.render(template, d)).appendTo($('#matchingusers'));
                            });
                        } catch (e) {
                        }

                    });
                });
            }
        });
    </script>

</html>
