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
define('geometrixx/models/product', [
    'underscore',
    'jquery',
    'backbone',
    'geometrixx/models/variant'
], function(_, $, Backbone, ProductVariant) {
    'use strict';

    /**
     * @constructor
     * @augments module:Backbone.Model
     */
    var Product = Backbone.Model.extend(/** @lends Product.prototype */{

        /**
         * Default model options.
         *
         * @type {Map}
         * @static
         */
        defaults: {
            title: '',
            description: '',
            path: '',
            productPath: '',
            imageHref: '',
            variants: '',
            variantAxes: '',
            rating: 0,
            ratingCount: 0,
            summary: '',
            features: ''
        },

        /**
         * The url to fetch the full model details.
         *
         * @returns {String} the url for the collection
         */
        url: function() {
            return Granite.HTTP.externalize(this.get('productPath'));
        },

        /**
         * Generic initialization for the model.
         *
         * @param {Map} [options] Options for the model.
         */
        initialize: function(options) {
            if (!this.get('variants')) {
                this.set('variants', []);
            }
        },

        /**
         * Parse the specified content into a model.
         *
         * @param {String|Object} response A string representation or the actual model to be parsed.
         * @returns {Product} the parsed model
         */
        parse: function(response) {
            var product = $.isPlainObject(response) ? response : JSON.parse(response);
            var variants = [];
            var variant;
            for (var v in product.variants) {
                variant = product.variants[v];
                variants.push(new ProductVariant(variant));
            }
            product.variants = variants;

            return product;
        }

    });

    // return the model
    return Product;

});
