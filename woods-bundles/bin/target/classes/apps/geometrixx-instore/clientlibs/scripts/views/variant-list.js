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
define('geometrixx/views/variant-list', [
    'underscore',
    'jquery',
    'util/Util',
    'views/BaseView',
    'geometrixx/views/variant'
], function(_, $, Util, BaseView, ProductVariantView) {
    'use strict';

    var ProductVariantListView = BaseView.extend(/** @lends ProductVariantListView.prototype */ {

        /**
         * Class name for the wrapping element of the view.
         *
         * @type {String}
         */
        className: 'geo-VariantListView',

        /**
         * Events that the view handles.
         *
         * @type {Map}
         *
         * @returns {Map} The registered events
         */
        events: function() {
            return _.extend({}, ProductVariantListView.prototype.events, {
                'select-variant': '_handleVariantSelected'
            });
        },

        /**
         * Handle the selection of a product variant and update the view accordingly.
         *
         * @param {Event}   ev      The event that triggered the action
         * @param {Product} variant The variant that was selected
         */
        _handleVariantSelected: function(ev, variant) {
            this.$el.find('.geo-VariantView').removeClass('active');
            $(ev.target).addClass('active');
        },

        /**
         * Render a product variant.
         *
         * @param {Product} variant The variant to render
         *
         * @returns {ProductVariantView} the product variant view
         */
        _renderVariant: function(variant) {
            return new ProductVariantView({model: variant, axis: this.options.axis}).render().$el;
        },

        /**
         * Render the view.
         *
         * @returns {ProductVariantListView} the view
         */
        render: function() {
            var $el = this.$el;
            if (this.options.axis) {
                $el.append(
                    $(document.createElement('div')).addClass('geo-VariantListView-title').text(this.options.axis + ':')
                );
                var variants = this.model.get('variants');
                variants.forEach(function(v) {
                    var variantAxis = this.options.axis && v.get(this.options.axis);
                    if (variantAxis
                            && !$el.find('[data-' + this.options.axis + '="' + encodeURI(variantAxis) + '"]').length) {
                        $el.append(this._renderVariant(v));
                    }
                }, this);
            }

            this.$el.find('.geo-VariantView--color').first().addClass('active');

            return this;
        }

    });

    // return the view
    return ProductVariantListView;

});
