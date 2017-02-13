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
define('geometrixx/views/star-rating', [
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
    };

    var StarRatingView = BaseView.extend(/** @lends StarRatingView.prototype */{

        /**
         * Class name for the wrapping element of the view.
         *
         * @type {String}
         */
        className: 'geo-StarRatingView',

        /**
         * Events that the view handles.
         *
         * @type {Map}
         */
        events: {
            // 'click .geo-StarRatingView-rate': '_handleStarPress'
        },

        /**
         * @constructor
         * @extends GenericContainerView
         *
         * @param {Object} [options] An object of configurable options.
         */
        constructor: function(options) {
            this._initOptions(options, DEFAULT_OPTIONS);
            StarRatingView.__super__.constructor.apply(this, arguments);
        },

        /**
         * Destroy the view.
         *
         * @returns {StarRatingView} the destroyed view
         */
        destroy: function() {
            return StarRatingView.__super__.destroy.apply(this, arguments);
        },

        /**
         * Handle pressing the star.
         *
         * @param {Event} ev The event that triggered the action.
         */
        _handleStarPress: function(ev) {
            var curRating = $(ev.currentTarget).data('star');
            var oldRating = +(this.model.get('rating'));
            var newSize = +(this.model.get('ratingCount')) + 1;
            var newRating = oldRating + (curRating - oldRating) / newSize;

            this.model.set({
                'rating': newRating,
                'ratingCount': newSize
            }).save();

            this._updateStars(newRating, newSize);
        },

        /**
         * Update the star rating and count.
         *
         * @param {Number} val    The new rating value
         * @param {Number} amount The new rating count
         */
        _updateStars: function(val, amount) {
            var v = Math.round(val) - 1;
            var stars = this.$el.find('.geo-StarRatingView-rate');

            stars.each(function(i, e) {
                $(e).toggleClass('is-filled', i <= v);
            });

            this.$el.find('.geo-StarRatingView-count').text(amount);
        },

        /**
         * Instantiate the template markup.
         *
         * @returns {String} the HTML string for the instantiated template
         */
        _template: function() {
            var tmpl = _.template(
                '<span class="geo-StarRatingView-rate" data-star="1">' +
                '<i class="geo-StarRatingView-rate-frame"></i>' +
                '<i class="geo-StarRatingView-rate-fill"></i>' +
                '</span>' +
                '<span class="geo-StarRatingView-rate" data-star="2">' +
                '<i class="geo-StarRatingView-rate-frame"></i>' +
                '<i class="geo-StarRatingView-rate-fill"></i>' +
                '</span>' +
                '<span class="geo-StarRatingView-rate" data-star="3">' +
                '<i class="geo-StarRatingView-rate-frame"></i>' +
                '<i class="geo-StarRatingView-rate-fill"></i>' +
                '</span>' +
                '<span class="geo-StarRatingView-rate" data-star="4">' +
                '<i class="geo-StarRatingView-rate-frame"></i>' +
                '<i class="geo-StarRatingView-rate-fill"></i>' +
                '</span>' +
                '<span class="geo-StarRatingView-rate" data-star="5">' +
                '<i class="geo-StarRatingView-rate-frame"></i>' +
                '<i class="geo-StarRatingView-rate-fill"></i>' +
                '</span>' +
                '<span class="geo-StarRatingView-count"></span>'
            );

            return tmpl({});
        },

        /**
         * Render the view.
         *
         * @returns {StarRatingView} the view
         */
        render: function() {
            StarRatingView.__super__.render.apply(this, arguments);

            var elem = $(this._template({
                title: this.model.get('title')
            }));

            this.$el.append(elem);

            this._updateStars(
                this.model.get('rating'),
                this.model.get('ratingCount')
            );

            return this;
        }

    }, {

        /**
         * Create the instance.
         *
         * @param {HTMLElement|jQuery} anchor The element to align the dialog to
         * @param {Object} [options] Options for the view
         *
         * @returns {StarRatingView} the initialized view
         */
        create: function(anchor, options) {
            var rating = new StarRatingView(options).render();

            rating.$el.appendTo(anchor);

            return rating;
        }
    });

    // return the view
    return StarRatingView;

});
