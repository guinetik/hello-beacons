define(function (require) {
    "use strict";
    var $ = require('jquery'),
        _ = require('underscore'),
        Backbone = require('backbone'),
        tpl = require('text!tpl/BeaconList.html'),
        template = _.template(tpl);
    return Backbone.View.extend({
        initialize: function () {
            this.render();
            this.collection.on("reset", this.render, this);
            this.collection.on("add", this.render, this);
        },
        render: function () {
            this.$el.html(template({beacons: this.collection.toJSON()}));
            return this;
        }
    });
});