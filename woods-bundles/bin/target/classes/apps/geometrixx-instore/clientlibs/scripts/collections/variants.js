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
define('geometrixx/collections/variants', [
    'underscore',
    'jquery',
    'backbone',
    'geometrixx/models/variant'
], function(_, $, Backbone, Variant) {
    'use strict';

    /**
     * @constructor
     * @augments module:Backbone.Collection
     */
    var ProductVariantCollection = Backbone.Collection.extend(/** @lends ProductVariantCollection.prototype */{

        /**
         * The model for the collection
         *
         * @type {Variant}
         */
        model: Variant,

        /**
         * The url to fetch the collection.
         *
         * @returns {String} the url for the collection
         */
        url: function() {
            return Granite.HTTP.externalize(this.path + '/_jcr_content.json');
        },

        /**
         * Generic initialization for the collection.
         *
         * @param {Backbone.Models[]} [models] The initial models for this collection.
         * @param {Map} config The optional configuration options
         * @param {String} config.path The base url to load the collection from
         */
        initialize: function(models, config) {
            this.path = config && config.path;
        },

        /**
         * Parse the specified content into a collection.
         *
         * @param {String|Array} response A string representation or the actual models to be parsed.
         * @returns {Variant[]} the parsed variants
         */
        parse: function(response) {
            var variants = [];
            if (response) {
                var data = $.isArray(response) ? response : JSON.parse(response).children;
                _.each(data, function(product) {
                    variants.push(
                        new Variant({
                            title: product.title,
                            path: product.path,
                            basePath: product.basePath,
                            imageHref: product.imageHref
                        })
                    );
                });
            }
            return variants;
        }

    });

    // return the collection
    return ProductVariantCollection;

});
