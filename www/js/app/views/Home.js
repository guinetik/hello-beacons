define(function (require) {
    "use strict";
    var $ = require('jquery');
    var _ = require('underscore');
    var Backbone = require('backbone');
    var models = require('app/models/beacon');
    var BeaconsListView = require('app/views/BeaconsListView');
    var tpl = require('text!tpl/Home.html');
    var template = _.template(tpl);
    var self;
    return Backbone.View.extend({
        initialize: function () {
            self = this;
            this.beaconsCollection = new models.BeaconCollection();

            //valores para testar no emulador
            /*var beacon = new models.Beacon();
            beacon.set("uuid", "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0");
            beacon.set("distance", 'Immediate');
            beacon.set("accuracy", 0.377744);
            beacon.set("major", '0');
            beacon.set("minor", '1');
            self.beaconsCollection.add(beacon);
            var beacon = new models.Beacon();
            beacon.set("uuid", "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0");
            beacon.set("distance", 'Far');
            beacon.set("accuracy", 0.377744);
            beacon.set("major", '0');
            beacon.set("minor", '1');
            self.beaconsCollection.add(beacon);*/

            this.render();
        },
        events: {
            "change #toggle_search": "toggleBeacon"
        },
        beaconsCollection: null,
        beaconsList: null,
        toggleBeacon: function (e) {
            var checked = e.target.checked;
            if (checked) {
                $('#txt_status').html("<strong>Searching for beacons</strong>");
                self.startMonitoring()
            } else {
                self.beaconsCollection.reset();
                $('#txt_status').html("<strong>Not searching for beacons</strong>");
                self.stopMonitoring();
            }
        },
        stopMonitoring: function () {
            cordova.exec(self.appendMessage, function (error) {
                $("#toggle_search").prop('checked', false);
                $('#txt_status').html("<strong>" + error + "</strong>");
            }, "IBeaconLauncher", "stop", []);
        },
        startMonitoring: function () {
            cordova.exec(self.appendMessage, function (error) {
                $("#toggle_search").prop('checked', false);
                $('#txt_status').html("<strong>" + error + "</strong>");
            }, "IBeaconLauncher", "launch", []);
        },
        appendMessage: function (message) {
            var msg = JSON.parse(message);
            if (msg.beacons.length > 0) {
                self.beaconsCollection.reset();
                //TODO melhorar esse loop aqui para funcionar com beacons em multiplas distancias
                for (var i = 0; i < msg.beacons.length; i++) {
                    var obj = msg.beacons[i];
                    var beacon = new models.Beacon();
                    beacon.set("uuid", obj.uuid);
                    beacon.set("distance", obj.distance);
                    beacon.set("accuracy", obj.accuracy);
                    beacon.set("major", obj.major);
                    beacon.set("minor", obj.minor);
                    self.beaconsCollection.add(beacon);
                }

            }
            $('#txt_status').html("<strong>" + msg.message + "<strong>");
            setTimeout(self.restartMonitoring, 1000);
        },
        restartMonitoring: function () {
            if ($("#toggle_search").prop('checked')) {
                self.startMonitoring();
            } else {
                $('#txt_status').html("<strong>Not searching for beacons</strong>");
            }
        },
        render: function () {
            this.$el.html(template());
            this.beaconsList = new BeaconsListView({collection: this.beaconsCollection, el: $(".scroller", this.el)});
            return this;
        }
    });

});