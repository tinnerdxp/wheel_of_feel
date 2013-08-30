/* Wheel of feel main JS */

var WOF = function() {
    var client = {
        endpoints: {
            liveresults: 'http://10.215.91.204/liveresults',
            editorial:   'http://10.215.91.204/editorial',
        },
        sendRequest: function(endpoint, method, payload, callback) {
            if (callback === undefined) {
                callback = function(data, textStatus, jqXHR) {
                    console.log('Default callback called');
                };
            }

            var options = {
                url:      client.endpoints[endpoint],
                type:     method,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                crossDomain: true,
                success: callback,
                error: function(data, textStatus, jqXHR) {
                    alert(method + ' request to ' + client.endpoints[endpoint] + ' failed');
                }
            };
            if (typeof payload != undefined) {
                options.data = JSON.stringify(payload);
            }
            $.ajax(options);
        }
    };

    var that = {
        fetchAvailableProgrammes: function() {
            var callback = function(data, textStatus, jqXHR) {
                //{"joe frogs":{"before":{"happy":0,"sad":1,"disappointed":0,"angry":0}}}
                var li, a1, a2;
                $('#programmes_list').empty();
                for (var i in data) {
                    li = $('<li></li>');
                    a1 = $('<a href="javascript:void(0);">' + i + '</a>').bind({
                        click:that.edit
                    });
//                    a2 = $('<a href="javascript:void(0);">Edit</a>').bind({click:that.edit});
                    li.append(a1);
//                    li.append(a2);
                    $('#programmes_list').append(li);
                }
            }
            client.sendRequest('liveresults', 'GET', null, callback);
        },
        select: function(item) {
            console.log(item.currentTarget.childNodes[0].data);
        },
        edit: function(item) {
            var programme_name = item.currentTarget.childNodes[0].nodeValue;
            $('#new_programme').val(programme_name);
        },
        save: function() {
            client.sendRequest('editorial', 'POST', {
                act:         $('#new_programme').val(),
                phase:       $('#new_programme').parent().parent().find('input[type=radio]:checked').val(),
                image:       $('#programme_image_url').val(),
                description: $('#programme_description').val()
            });
        }
    };

    // bootstrap
    var initialize = function() {
        that.fetchAvailableProgrammes();

    };
    initialize();
    return that;
}();
