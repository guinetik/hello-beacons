define(function (require) {
    "use strict";
    var $                   = require('jquery'),
        Backbone            = require('backbone'),

        Beacon = Backbone.Model.extend({
            initialize: function () {
            }
        }),
        BeaconCollection = Backbone.Collection.extend({
            model: Beacon
        });
    return {
        Beacon: Beacon,
        BeaconCollection: BeaconCollection
    };
});