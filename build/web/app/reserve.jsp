<%-- 
    Document   : reserve
    Created on : Mar 6, 2013, 4:05:54 PM
    Author     : brook
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <h1>Reserved Events are Highlighted</h1>
        <div id="content">
            <div id="events">
            </div>
        </div>
    <c:if test="${user.usertype == 0}">
        <div id="makereservation">
            <br>Make a reservation <br><br>
            Event id: <span id="eventid"></span><br>
            User id: <span id="userid"></span><br>

        </div>
        <div id="searchusers">
            Search for users by name/username: <input id="query" type="text" /><br>
            <div id="matchingusers"></div>
            <button id="confirmreserve" type="button">Confirm Reservation</button>
            <div id="errors"></div>
        </div>
    </c:if>
</body>
<script>
    $(document).ready(function() {
        var events = $('#events');
        var errors = $('#errors');
        var reservedeventid, reserveduserid;
        var reservedeventids = [], reserveduserids = [];
        //for the selected user
        $('#events').delegate('div', 'click', function() {
            errors.text('');
            if ($(this).attr('reserved') === 'true') {
                errors.text('Event is already reserved');
                return;
            }
            reservedeventid = this.id;
            $('#eventid').text(this.textContent);
        });
        //for the matching users
        $('#matchingusers').delegate('div', 'click', function() {
            reserveduserid = this.id.split('_')[1];
            $('#userid').text(this.textContent);
        });
        var etemp = "<div id={{id}}> {{location}}, startime: {{startTime}}, endtime: {{endTime}}</div>";
        $.ajax({
            type: 'GET',
            url: 'events?action=allevents',
            success: function(data) {
                try {
                    $.each(JSON.parse(data), function(i, d) {
                        $(Mustache.render(etemp, d)).appendTo(events);
                    });
                    $.ajax({
                        type: 'POST',
                        url: 'reserve?action=getall',
                        success: function(data) {
                            try {
                                $.each(JSON.parse(data), function(i, d) {
                                    var eventid = d.eventid;
                                    reservedeventids.push(eventid);
                                    reserveduserids.push(d.userid);
                                    //make the div a different color if reserved
                                    $('#' + eventid).attr('reserved', 'true');
                                });


                            } catch (e) {
                                //no reservations yet 
                            }
                        },
                        error: function(e) {
                            alert('error');
                        }
                    });
                } catch (e) {
                    //no events 
                }
            }
        });
        if ($('#searchusers').length === 0) {
            //user and viewer cannot do anything below here
            return;
        }
        createSearchUserBar();
        $('#confirmreserve').click(function() {
            errors.text('');
            if (!reservedeventid || !reserveduserid) {
                errors.text('You did not select a valid event/user');
                return;
            }
            if (reservedeventids.indexOf(reservedeventid) !== -1) {
                errors.text('You selected an already reserved event');
                return;
            }
            if (reserveduserids.indexOf(reserveduserid) !== -1) {
                errors.text('You selected a user already with a reservation');
                return;
            }
            $.ajax({
                type: 'POST',
                url: 'reserve?action=assignuser',
                data: {userid: reserveduserid, eventid: reservedeventid},
                success: function(res) {
                    if (res === 'success') {
                        $('#' + reservedeventid).attr('reserved', 'true');
                        //change the color of the event
                    } else {
                        //failed, do something
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
