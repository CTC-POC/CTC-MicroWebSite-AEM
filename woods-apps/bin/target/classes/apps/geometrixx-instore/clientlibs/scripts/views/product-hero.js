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
define('geometrixx/views/product-hero', [
    'underscore',
    'jquery',
    'util/Util',
    'views/BaseView',
    'geometrixx/views/product-thumbnail',
    'geometrixx/views/star-rating'
], function(_, $, Util, BaseView, ProductThumbnailView, StarRatingView) {
    'use strict';

    /**
     * Default view options.
     *
     * @type {Map}
     * @static
     */
    var DEFAULT_OPTIONS = {
    };

    var ProductHeroView = BaseView.extend(/** @lends ProductHeroView.prototype */ {

        /**
         * Class name for the wrapping element of the view.
         *
         * @type {String}
         */
        className: 'geo-ProductHeroView',

        /**
         * Sistine options.
         *
         * @type {Object}
         */
        sistineOptions: {
            events: {
                'doubletap': '_handleProductActivation'
            },
            recognizers: [
                {name: 'tap', options: {eventName: 'doubleTap', taps: 2}}
            ]
        },

        /**
         * @constructor
         * @extends BaseView
         *
         * @param {Object} [options] An object of configurable options.
         */
        constructor: function(options) {
            this._initOptions(options, DEFAULT_OPTIONS);
            ProductHeroView.__super__.constructor.apply(this, arguments);
            this._sistine.add(new Sistine.Tap({
                eventName: 'doubletap',
                taps: 2,
                delegate: this.delegate,
                delegateScope: this
            }));
        },

        /**
         * Handle the activation of a product.
         *
         * @param {Event} ev The event that triggered the action
         */
        _handleProductActivation: function(ev) {
            this.$el.trigger('product-activate', [
                this.model,
                0 || Math.floor(ev.pointer.events[0].clientX / this.options.display.deviceWidth)
            ]);
        },

        /**
         * Instantiate the template markup with the provided data.
         *
         * @param {Product} product The product to render the template with.
         * @returns {String} the HTML string for the instantiated template
         */
        _template: function(product) {
            // var tpl = _.template('<div><img src="<%= product.get("imageHref") %>"/></div>');
            // return tpl({product: product});

            var tpl = _.template(
                '<div class="u-screens-alignHorizontal">' +
                    '<div class="u-screens-alignVertical">' +
                        '<div class="geo-ProductHeroView-title"><%= title %></div>' +
                    '</div>' +
                '</div>'
            );
            return tpl({
                href: Granite.HTTP.externalize(product.get('imageHref')),
                title: product.get('title')
            });
        },

        /**
         * Render the view.
         *
         * @returns {ProductHeroView} the view
         */
        render: function() {
            // prevent re-render
            if (this.setRendered(true)) {
                return this;
            }
            var $content = $(this._template(this.model));
            $content.find('.u-screens-alignVertical').prepend(
                new ProductThumbnailView({
                    model: this.model,
                    rendition: '/_jcr_content/renditions/cq5dam.web.1280.1280.jpeg'
                }).render().$el
            );
            this.$el
                .prepend($content)
                .css({
                    width: this.options.width,
                    height: this.options.height
                });

            StarRatingView.create(this.$el.find('.u-screens-alignVertical'), {
                model: this.model
            });
            return this;
        }

    });

    // return the view
    return ProductHeroView;

});
