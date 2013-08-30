/* Wheel of feel main JS */

var WOF = function() {
    var client = {
        endpoints: {
            liveresults: 'http://10.215.91.204/liveresults',
            vote:        'http://10.215.91.204/vote',
            current:     'http://10.215.91.204/act',
            stats:       'http://10.215.91.204/acts'
        },
        getResults: function(callback) {
            var currentAct = false;

            var drawChart = function(data, textStatus, jqXHR) {
                var finished = false;
                if (currentAct.phase == '') {
                    return;
                }

                if (currentAct.phase !== 'after') {
                    // {"X-Factor":{"before":{"love":4,"joy":0,"excitment":0,"anger":0,"disgust":0,"sadness":0,"surprise":0,"fear":0}}}
                    var dataRow = {};
                    //{"act":"Another","phase":"before","description":"Anotherctor description","image":"/Another.jpg"}
                    var currentPhase       = currentAct.phase;
                    var currentActName     = currentAct.act;
                    var currentImageUrl    = currentAct.image;
                    var currentDescription = currentAct.description;

                    // set blob data
                    var img = $('<img />').attr('src', currentImageUrl).css('width', '30%').css('float', 'left').css('margin', '0 16px 16px 0').css('border-radius', '50%').css('overflow','hidden').css('display','block');
                    var p = $('<p style="margin: 0; font-family: Reem, arial, sans-serif; font-size: 1.2em;"></p>').html(currentDescription);
                    var h1 = $('<h1 style="font-family: Reem, arial, sans-serif; font-size: 2em; font-weight: bold;"></h1>').html(currentActName);
                    var div = $('<div style="margin-top: 1em;"></div>');
                    $('#blob').empty();
                    $('#blob').append(h1);
                    $(div).append(h1).append(p);
                    $('#blob').append(img);
                    $('#blob').append(div);

                    dataRow = data[currentActName][currentPhase];
                    var googleDataRow = [];
                    var dataKeys = ['Count'];
                    for (var i in dataRow) {
                        dataKeys.push(i);
                    }
                    var dataValues = ['Count'];
                    for (var j in dataRow) {
                        dataValues.push(dataRow[j]);
                    }
                    googleDataRow.push(dataKeys);
                    googleDataRow.push(dataValues);
                    var googleData = google.visualization.arrayToDataTable(googleDataRow);
                    var options = {
                        title: 'Current emotion',
                        chartArea: {left:0,top:0,width:"100%",height:"100%"},
                        bar: {groupWidth:'100%'},
                        enableInteractivity: false,
    //                    legend: {position: 'in', alignment: 'center', position: 'bottom', textStyle: {color: 'blue', fontSize: 14, fontName: 'feelings'}},
                        legend: null,
                        series: {
                            0:{color: '#79cf19', visibleInLegend: false},
                            1:{color: '#fbe500', visibleInLegend: false},
                            2:{color: '#fba617', visibleInLegend: false},
                            3:{color: '#d70014', visibleInLegend: false},
                            4:{color: '#c000e1', visibleInLegend: false},
                            5:{color: '#2841a4', visibleInLegend: false},
                            6:{color: '#3892e3', visibleInLegend: false},
                            7:{color: '#34e0c2', visibleInLegend: false}
                        }
                    };
                    var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
                    chart.draw(googleData, options);

                // it's finished - show the stats
                } else {
                    var showStats = function(data2, textStatus, jqXHR) {
                        // {"Rylan":{"description":"Rylan description","image":"/rylan.jpg"},"Ella":{"description":"Ella description","image":"/ella.jpg"}}
                        $('#blob').empty();
                        var ul, li, img, div, div2, p, h1, row1, row2, row3, chart_div;
                        div = $('<div></div>');
                        ul = $('<ul></ul>');
                        var chartDataArray = [];
                        var nasty_counter = 0;

                        for (var k in data2) {
                            nasty_counter++;
                            li = $('<li style="clear:both;"></li>');
                            img = $('<img src="' + data2[k]['image'] +'"/>').css('width', '30%').css('float', 'left').css('margin', '0 16px 16px 0').css('border-radius', '50%').css('overflow','hidden').css('display','block');
                            div2 = $('<div style="margin-top: 1em;"></div>');
//                            p = $('<p style="margin: 0; font-family: Reem, arial, sans-serif; font-size: 1.2em;"></p>').html(data2[k]['description']);
                            h1 = $('<h1 style="font-family: Reem, arial, sans-serif; font-size: 2em; font-weight: bold;"></h1>').html(k);
                            chart_div = $('<div></div>').attr('id', 'chart_' + nasty_counter).css('width', '60%').css('height','80px').css('float','left');
                            li.append(img);
                            li.append(div2.append(h1).append(p).append(chart_div));
                            ul.append(li);

                            // build data for a chart
                            for (var m in data) {
                                if (k == m) {
                                    row1 = data[m]['before'];
//                                    row2 = data[m]['after'];
                                    row3 = {};
                                    for (var n in data[m]['before']) {
                                        row3[n] = data[m]['before'][n] //+ data[m]['after'][n];
                                    }
                                    var dataValues = ['Count'];
                                    for (var o in row3) {
                                        dataValues.push(row3[o]);
                                    }
                                    var dataKeys = ['Count'];
                                    for (var p in row3) {
                                        dataKeys.push(p);
                                    }
                                    var googleDataRow = [];
                                    googleDataRow.push(dataKeys);
                                    googleDataRow.push(dataValues);
                                    chartDataArray.push(googleDataRow);
                                }
                            }

                        }
                        $('#blob').append(ul);

                        // draw charts
                        var nasty_counter_2 = 0;
                        for (var r in chartDataArray) {
                            nasty_counter_2++;
                            var googleData = google.visualization.arrayToDataTable(chartDataArray[r]);
                            var options = {
                                title: 'Current emotion',
                                chartArea: {left:0,top:0,width:"100%",height:"100%"},
                                bar: {groupWidth:'100%'},
                                enableInteractivity: false,
                                //                    legend: {position: 'in', alignment: 'center', position: 'bottom', textStyle: {color: 'blue', fontSize: 14, fontName: 'feelings'}},
                                legend: null,
                                series: {
                                    0:{color: '#79cf19', visibleInLegend: false},
                                    1:{color: '#fbe500', visibleInLegend: false},
                                    2:{color: '#fba617', visibleInLegend: false},
                                    3:{color: '#d70014', visibleInLegend: false},
                                    4:{color: '#c000e1', visibleInLegend: false},
                                    5:{color: '#2841a4', visibleInLegend: false},
                                    6:{color: '#3892e3', visibleInLegend: false},
                                    7:{color: '#34e0c2', visibleInLegend: false}
                                }
                            };
                            var chart = new google.visualization.BarChart(document.getElementById('chart_' + nasty_counter_2));
                            chart.draw(googleData, options);
                        }
                    };

                    client.sendRequest('stats', 'GET', null, showStats);

                    // hide the wheel
                    $('#wheel').hide();
                    $('#chart_div').hide();

                    // stop the refresh
                    WOF.refresh(false);
                }
            };

            var setCurrent = function(data, textStatus, jqXHR) {
                //{"act":"X-Factor","phase":"during","imageurl":"/X-Factor.jpg"}
                currentAct = data;
                client.sendRequest('liveresults', 'GET', null, drawChart);
            };

            client.sendRequest('current', 'GET', null, setCurrent);
        },
        sendClick: function(feeling) {
            client.sendRequest('vote', 'POST', {emotion:feeling}, null);
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
                    console.log(method + ' request to ' + client.endpoints[endpoint] + ' failed. TextStatus: ' + textStatus + ', data:');
                    console.log(data);
                }
            };
            if (typeof payload != undefined) {
                options.data = JSON.stringify(payload);
            }
            $.ajax(options);
        }
    };

    // render content
    var renderer = function(json) {
        //{"joe frogs":{"before":{"happy":0,"sad":1,"disappointed":0,"angry":0}}}
        var h1, h2, ul, li, paragraph1, paragraph2, paragraph3;
        for (var i in json) {
            h1 = $('<h1></h1>').text(i);
            ul = $('<ul></ul>');
            for (var j in json[i]) {
                li = $('<li></li>');
                h2 = $('<h2></h2>').html(j);
                paragraph1 = $('<p></p>').text('Happy:' + json[i][j]['happy']);
                paragraph2 = $('<p></p>').text('Sad:' + json[i][j]['sad']);
                paragraph3 = $('<p></p>').text('Disappointed:' + json[i][j]['disappointed']);
                li.append(h2);
                li.append(paragraph1);
                li.append(paragraph2);
                li.append(paragraph3);
                ul.append(li);
            }
            $('#live_stream').html(h1);
            $('#live_stream').append(ul);
        }
    };

    var that = {
        vote: function(emotion) {
            // extract the text to send out
            //var feeling = $(object).text().toLowerCase();
            client.sendClick(emotion);
            return false;
        },
        refresh: function(toggle, refreshRate) {
            var handleResponse = function(data, textStatus, jqXHR) {
                // $('#live_stream').html(data);
                renderer(data);
            };

            if (refreshRate === undefined) {
                refreshRate = 5000;
            }
            if (toggle === true) {
                that.interval = setInterval(function() {
                    client.getResults(handleResponse);
                }, refreshRate);
            } else {
                clearInterval(that.interval);
            }
        },
        interval: false
    };

    // bootstrap
    var initialize = function() {
        that.refresh(true, 1000)
    };
    initialize();
    return that;
}();
