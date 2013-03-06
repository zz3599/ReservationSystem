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
        <script src="../js/main.js"></script>
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
        </div>
    </c:if>
</body>
<script>
    $(document).ready(function() {
        var events = $('#events');
        var reservedeventid, reserveduserid;
        //for the selected user
        $('#events').delegate('div', 'click', function() {
            if ($(this).attr('reserved') === 'true')
                return;
            reservedeventid = this.id;
            $('#eventid').text(this.textContent);
        });
        //for the matching users
        $('#matchingusers').delegate('div', 'click', function(){            
            reserveduserid = this.id;
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
                                    //make the div a different color
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
                    alert('failed');
                    //no events 
                }
            }
        });
        if($('#searchusers').length > 0){
            createSearchUserBar();
        }
        function createSearchUserBar() {
            var template = "<div id={{id}}>{{fullname}} (handle: {{username}})</div>";
            $('#query').keyup(function(event) {
                var text = this.value;
                if(!text || text.length === 0) {
                    $('#matchingusers').empty();
                    return;
                }
                $.post("users?action=finduser", {'query': text}, function(data) {
                    //update a div to show the results
                    try {
                        $('#matchingusers').empty();
                        $.each(data, function(i, d) {
                            var elem = $(Mustache.render(template, d)).appendTo($('#matchingusers'));
                        });
                    } catch (e) {
                    }

                });
            });
        }
    });

</script>

</html>
