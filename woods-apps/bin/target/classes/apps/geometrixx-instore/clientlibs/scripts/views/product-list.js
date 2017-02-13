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
define('geometrixx/views/product-list', [
    'underscore',
    'jquery',
    'util/Util',
    'views/BaseView',
    'geometrixx/views/product-thumbnail',
    'ux/views/SwipeGridView',
    'scroll/ScrollView'
], function(_, $, Util, BaseView, ProductThumbnailView, SwipeGridView, ScrollView) {
    'use strict';

    /**
     * Default view options.
     *
     * @type {Map}
     * @static
     */
    var DEFAULT_OPTIONS = {
        width: 300,
        height: 1080
    };

    var ProductListView = BaseView.extend(/** @lends ProductListView.prototype */ {

        /**
         * Class name for the wrapping element of the view.
         *
         * @type {String}
         */
        className: 'geo-ProductListView',

        /**
         * Sistine options.
         *
         * @type {Object}
         */
        sistineOptions: {
            events: {
                'tap .geo-ProductThumbnailView': '_handleProductSelection'
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
            ProductListView.__super__.constructor.apply(this, arguments);
            this._sistine.add(new Sistine.Tap({
                eventName: 'tap',
                taps: 1,
                delegate: this.delegate,
                delegateScope: this
            }));
        },

        /**
         * Generic initialization for this view
         */
        initialize: function() {
            this._views = [];
        },

        /**
         * Destroy the view.
         *
         * @returns {ProductListView} the destroyed view
         */
        destroy: function() {
            if (this._views) {
                this._views = null;
            }

            if (this._scrollview) {
                this._scrollview.destroy();
                this._scrollview = null;
            }

            return ProductListView.__super__.destroy.apply(this, arguments);
        },

        /**
         * Retrieve the view for the specified coordinates in the SwipeGridView.
         *
         * @param {Integer} x the column coordinates
         * @param {Integer} y the row coordinates
         * @returns {Backbone.View|null} the backbone view at the specified coordinates, or null
         */
        provide: function(x, y) {
            if (y < 0) {
                return null;
            }
            if (y < this._views.length) {
                var v = this._views[y];
                return v.el || v;
            }
            return null;
        },

        /**
         * Handle the selection of a product.
         *
         * @param {Event} ev The event that triggered the action.
         */
        _handleProductSelection: function(ev) {
            this.$el.find('.geo-ProductThumbnailView').removeClass('active');

            var selectedView = ev.target.viewController;
            if (selectedView) {
                selectedView.$el.addClass('active');
                this.$el.trigger('select-product', [selectedView.model]);
            }
        },

        /**
         * Render a product.
         *
         * @param {Product} product The product model for the view
         * @returns {ProductThumbnailView} the product view
         */
        _renderProduct: function(product) {
            var productThumbnailView = new ProductThumbnailView({
                model: product,
                rendition: '/_jcr_content/renditions/cq5dam.thumbnail.319.319.png'
            });
            this._views.push(productThumbnailView.render());
            return productThumbnailView;
        },

        /**
         * Render the view.
         *
         * @returns {ProductListView} the view
         */
        render: function() {
            var self = this;

            // prevent re-render
            if (this.setRendered(true)) {
                return this;
            }
            this.$el
                .css({
                    width: this.options.width,
                    height: this.options.height
                });

            this._scrollview = new ScrollView(this.$el, {
                direction: ScrollView.DIRECTION_Y,
                edgeMargin: [0, 0],
                snap: true,
                maxPointers: 2
            });

            var startElement;
            _.each(this.model.get('products').models, this._renderProduct, this);
            this._scrollview.splice(_.map(this._views, function(v) {
                if (v.model === self.options.selectedItem) {
                    startElement = v.el;
                }
                return v.el;
            }));
            this.invalidate();
            window.requestAnimationFrame(function() {
                self._scrollview.scrollTo(startElement);
            });
            return this;
        },

        invalidate: function() {
            var self = this;
            window.requestAnimationFrame(function() {
                self._scrollview.recalculateSize();
                self._scrollview.invalidateAll();
            });
            return this;
        }

    });

    // return the view
    return ProductListView;

});
