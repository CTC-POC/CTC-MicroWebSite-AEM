/*
 *
 * ADOBE CONFIDENTIAL
 * __________________
 *
 *  Copyright 2015 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 */
define('geometrixx/views/scrollable-panel', [
    'underscore',
    'jquery',
    'util/Util',
    'views/BaseView'
], function(_, $, Util, BaseView) {
    'use strict';

    /**
     * Default view options.
     *
     * @type {Map}
     * @static
     */
    var DEFAULT_OPTIONS = {
        scrollLines: 6
    };

    var ScrollablePanelView = BaseView.extend(/** @lends ScrollablePanelView.prototype */ {

        /**
         * Class name for the wrapping element of the view.
         *
         * @type {String}
         */
        className: 'geo-ScrollablePanelView',

        /**
         * Sistine options.
         *
         * @type {Object}
         */
        sistineOptions: {
            events: {
                'tap .icon-scroll': '_handleScroll'
            }
        },

        /**
         * @constructor
         * @extends BaseView
         *
         * @param {Object} [options] An object of configurable options.
         */
        constructor: function(options) {
            this._initOptions(options, DEFAULT_OPTIONS);
            ScrollablePanelView.__super__.constructor.apply(this, arguments);
            this._sistine.add(new Sistine.Tap({
                eventName: 'tap',
                taps: 1,
                delegate: this.delegate,
                delegateScope: this
            }));
        },

        /**
         * Handles scrolling the product summary view.
         *
         * @param {Event} ev The event that triggered the action
         */
        _handleScroll: function(ev) {
            var $summary = this.$el.find('.geo-ScrollablePanelView-content');
            var lineHeight = parseFloat($summary.css('line-height'));
            var direction = $(ev.target).hasClass('icon-scroll--up') ? -1 : 1;
            $summary.scrollTop($summary.scrollTop() + direction * this.options.scrollLines * lineHeight);
            this.update();
        },

        /**
         * Update the view and toggle the scroll buttons as needed.
         */
        update: function() {
            var $summary = this.$el.find('.geo-ScrollablePanelView-content');
            this.$el.find('.icon-scroll--up').toggle($summary.scrollTop() > 0);
            this.$el.find('.icon-scroll--down').toggle(
                $summary.scrollTop() + $summary.height() < $summary.get(0).scrollHeight);
        },

        /**
         * Instantiate the template markup with the provided data.
         *
         * @param {Object} panel The panel to render the template with.
         * @returns {String} the HTML string for the instantiated template
         */
        _template: function(panel) {
            var tpl = _.template(
                '<button class="icon icon-scroll icon-scroll--up"></button>' +
                '<div class="geo-ScrollablePanelView-content"><%= content %></div>' +
                '<button class="icon icon-scroll icon-scroll--down"></button>'
            );
            return tpl({
                content: panel.content
            });
        },

        /**
         * Render the view.
         *
         * @returns {ScrollablePanelView} the view
         */
        render: function() {
            // prevent re-render
            if (this.setRendered(true)) {
                return this;
            }
            this.$el.prepend(this._template(this.model));

            var $summary = this.$el.find('.geo-ScrollablePanelView-content');
            var $scrollUp = this.$el.find('.icon-scroll--up');
            var $scrollDown = this.$el.find('.icon-scroll--down');
            window.setTimeout(function() {
                $scrollUp.hide();
                $scrollDown.toggle($summary.height() < $summary.get(0).scrollHeight);
            });

            return this;
        }

    });

    // return the view
    return ScrollablePanelView;

});
