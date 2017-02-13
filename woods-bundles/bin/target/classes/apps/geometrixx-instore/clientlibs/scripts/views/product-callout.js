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
define('geometrixx/views/product-callout', [
    'underscore',
    'jquery',
    'util/Util',
    'views/BaseView',
    'geometrixx/views/star-rating',
    'geometrixx/views/scrollable-panel'
], function(_, $, Util, BaseView, StarRatingView, ScrollablePanelView) {
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

    var ProductCalloutView = BaseView.extend(/** @lends ProductCalloutView.prototype */ {

        /**
         * Class name for the wrapping element of the view.
         *
         * @type {String}
         */
        className: 'geo-ProductCalloutView',

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
            ProductCalloutView.__super__.constructor.apply(this, arguments);
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
            var $summary = this.$el.find('.geo-ProductCalloutView-summary');
            var lineHeight = parseFloat($summary.css('line-height'));
            var direction = $(ev.target).hasClass('icon-scroll--up') ? -1 : 1;
            $summary.scrollTop($summary.scrollTop() + direction * this.options.scrollLines * lineHeight);
            this.$el.find('.icon-scroll--up').toggle($summary.scrollTop() > 0);
            this.$el.find('.icon-scroll--down').toggle(
                $summary.scrollTop() + $summary.height() < $summary.get(0).scrollHeight);
        },

        /**
         * Instantiate the template markup with the provided data.
         *
         * @param {Product} product The product to render the template with.
         * @returns {String} the HTML string for the instantiated template
         */
        _template: function(product) {
            var tpl = _.template(
                '<div class="geo-ProductCalloutView-title"><%= title %></div>' +
                '<div class="geo-ProductCalloutView-rating"></div>' +
                '<div class="geo-ProductCalloutView-image"><img src="<%= imageHref %>" alt=""/></div>' +
                '<div class="geo-ProductCalloutView-price"><%= price %></div>' +
                '<div class="geo-ProductCalloutView-summary"></div>'
            );
            return tpl({
                title: product.get('title'),
                price: parseFloat(product.get('price')).toFixed(2),
                summary: product.get('summary'),
                imageHref: Granite.HTTP.externalize(product.get('imageHref') + '/_jcr_content/renditions/cq5dam.web.1280.1280.jpeg')
            });
        },

        /**
         * Render the view.
         *
         * @returns {ProductCalloutView} the view
         */
        render: function() {
            // prevent re-render
            if (this.setRendered(true)) {
                return this;
            }
            this.$el.prepend(this._template(this.model));

            this.$el.find('.geo-ProductCalloutView-summary').append(new ScrollablePanelView({
                model: {content: this.model.get('summary')}
            }).render().$el);

            StarRatingView.create(this.$el.find('.geo-ProductCalloutView-rating'), {
                model: this.model
            });

            return this;
        }

    });

    // return the view
    return ProductCalloutView;

});
