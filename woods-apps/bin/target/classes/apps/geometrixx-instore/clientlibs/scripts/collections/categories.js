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
define('geometrixx/collections/categories', [
    'underscore',
    'jquery',
    'backbone',
    'geometrixx/models/category',
    'geometrixx/collections/products'
], function(_, $, Backbone, Category, ProductCollection) {
    'use strict';

    /**
     * @constructor
     * @augments module:Backbone.Collection
     */
    var CategoryCollection = Backbone.Collection.extend(/** @lends CategoryCollection.prototype */{

        /**
         * The model for the collection
         *
         * @type {Category}
         */
        model: Category,

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
         * @returns {Category[]} the parsed categories
         */
        parse: function(response) {
            var categories = [];
            if (response) {
                var data = $.isArray(response) ? response : JSON.parse(response).children;
                var products;
                _.each(data, function(catalog) {
                    products = new ProductCollection();
                    products.models = products.parse(catalog.children);
                    categories.push(
                        new Category({
                            title: catalog.title,
                            path: catalog.path,
                            products: products
                        })
                    );
                });
            }
            return categories;
        }

    });

    // return the collection
    return CategoryCollection;

});
