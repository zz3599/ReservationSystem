(function() {
    if (typeof jQuery === "undefined") {
        var script = document.createElement('script');
        script.type = "text/javascript";
        script.src = "http://code.jquery.com/jquery-1.9.1.min.js";
        document.getElementsByTagName('head')[0].appendChild(script);
    }

    $(document).ready(function() {
        assignHandlers();
    });

    function assignHandlers() {
        manageUsers();
        manageEvents();
    }
    function manageUsers() {
        if ($('#manageusers').length <= 0)
            return;
        $('#manageusers').click(function() {
            $.get("../UserServlet", function(data) {
                var content = $('#content').empty();
                var usersDiv = $('<div>', {id: 'allusers'}).appendTo(content);
                var modify = $('<div>', {id: 'modify'}).appendTo(content);
                $.each(data, function(i, e) {
                    var div = $('<div>', {id: e.id, text: e.fullname}).click(function() {
                        $.post('../UserServlet?action=removeuser', {'id': e.id}, function(data) {
                            if (data === 'success') {
                                $('#' + e.id).hide();
                            }
                        });
                    });
                    div.appendTo(usersDiv);
                });
                var adduserform = $('<div id="adduser"><p>Add User<p><form name="adduser" action="../UserServlet?action=adduser" method="post">' +
                        'Username: <input type="text" name="username"/><br>' +
                        'Password: <input type="password" name="password"/><br>' +
                        'Name: <input type="text" name="fullname"/><br>' +
                        'Role: <select name="usertype"><option value="0">Admin</option><option value="1">Viewer</option><option value="2">User</option></select>' +
                        '<br><input type="submit">' +
                        '</form></div>').appendTo(modify);
                getSearchUserBar().appendTo(modify);
                //for remove - attach listener to each list element
            });
        });
    }

    function manageEvents() {
        if ($('#managevents').length <= 0)
            return;
        $('#managevents').click(function() {
            $.get("../EventServlet", function(data) {
                var content = $('#content').empty();
                var eventsDiv = $('<div>', {id: 'allevents'}).appendTo(content);
                var modify = $('<div>', {id: 'modify'}).appendTo(content);
                var template = "<div id='{{id}}'>Location: {{location}}, Supervisor: {{supervisor}}</div>";
                if (data) {                    
                    $.each(data, function(i, e) {
                        var div = $('<div>').html(Mustache.render(template, e)).appendTo(eventsDiv).click(function(ev){
                            //click handler
                        });
                    });
                }
                var addeventform = $('<div id="addevent"><p>Add Event<p><form name="addevent">' +
                        'Location: <input id="location" type="text" name="location"/><br>' +
                        'Supervisor: <input type="text" id="supervisor" name="supervisor"/><br>' +
                        'Start: <input type="text" id="startTime" name="startTime" value="" class=""><br>' +
                        'End: <input type="text" id="endTime" name="endTime" value="" class=""><br>' +
                        '<br><input id="addeventsubmit" type="submit">' +
                        '</form></div>').appendTo(modify);
                $('#addeventsubmit').click(function(e) {
                    var location, supervisor, stime, etime; 
                    e.preventDefault();
                    if (!(location=$('#location').val()) || !(supervisor=$('#supervisor').val()) || 
                            !(stime=$('#startTime').val()) || !(etime=$('#endTime').val())){
                        $('#errors').text('Please fill all fields');
                    } else {
                        $('#errors').hide();
                        alert(location);
                        var datastring = 'action=addevent&location=' + location + '&supervisor=' + supervisor + '&startTime=' + 
                                stime + '&endTime=' + etime;
                        $.ajax({
                            type: 'POST',
                            url: '../EventServlet',
                            data: datastring, 
                            success: function(data){
                                $.each(data, function(i, item){
                                   $('<div>').html(Mustache.render(template, item)).appendTo(eventsDiv); 
                                });
                            },
                            error: function(er){
                                alert(er);
                            }                                   
                        });
                        
                    }
                });
                $('<div>', {id: 'errors'}).appendTo(modify);
                var startDateTextBox = $('#startTime');
                var endDateTextBox = $('#endTime');

                startDateTextBox.datetimepicker({
                    dateFormat: "yy-mm-dd",
                    timeFormat: "hh:mm:ss",
                    onClose: function(dateText, inst) {
                        if (endDateTextBox.val() != '') {
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
                        if (startDateTextBox.val() != '') {
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
            });
        });
    }

    function getSearchUserBar(id) {
        var r = $('<div>', {'id': id, 'class': 'searchusers'}).text('Search for users by name/username: ');
        var template = "<div>{{fullname}}, username: {{username}}</div>";
        $('<input type="text" />').appendTo(r).keyup(function(event) {
            var text = this.value;
            $.post("../UserServlet?action=finduser", {'query': text}, function(data) {
                //update a div to show the results
                $.each(data, function(i, e) {
                    var container = $('<div>').appendTo(r).html(Mustache.render(template, e));
                });

            });
        });
        return r;
    }


})();



