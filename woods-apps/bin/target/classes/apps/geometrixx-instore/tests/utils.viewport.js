/*
 * ADOBE CONFIDENTIAL
 *
 * Copyright 2015 Adobe Systems Incorporated
 * All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 */

(function(hobs, $) {
    'use strict';

    /**
     * Checks if the element(s) specified by the selector is in the viewport or not.
     *
     * @param  {String}  selector            The selector to the element(s)
     * @param  {Boolean} [isInViewport=true] `true` to check if it is, `false` to check if it isn't
     * @param  {Map}     [options]           Options for the test step
     */
    hobs.actions.Assertions.isInViewport = function(selector, isInViewport, options) {
        var self = this;
        this.selector = selector;
        this.isInViewport = isInViewport !== (void 0) ? isInViewport : true;

        var _checkFct = function(opts) {
            // Process dynamic parameters
            var sel = hobs.handleDynParameters(self.selector, opts);
            var inViewport = hobs.handleDynParameters(self.isInViewport, opts);

            var $element = hobs.find(sel, opts.context);

            // Check if the elements are inside the viewport
            if (inViewport) {
                return $element.length > 0 && Array.prototype.reduce.call($element.map(
                    function() {
                        var rect = this.getBoundingClientRect();
                        return Math.ceil(rect.left) >= 0
                            && Math.floor(rect.right) <= $(hobs.context().window).width()
                            && Math.ceil(rect.top) >= 0
                            && Math.floor(rect.bottom) <= $(hobs.context().window).height();
                    }),
                    function(allVisible, thisVisible) {
                        return allVisible && thisVisible;
                    },
                    true);
            }

            // Check if the elements are outside the viewport
            return $element.length === 0 || Array.prototype.reduce.call($element.map(
                function() {
                    var rect = this.getBoundingClientRect();
                    return Math.ceil(rect.left) >= $(hobs.context().window).width()
                        || Math.floor(rect.right) <= 0
                        || Math.ceil(rect.top) >= $(hobs.context().window).height()
                        || Math.floor(rect.bottom) <= 0;
                }),
                function(allHidden, thisHidden) {
                    return allHidden && thisHidden;
                },
                true);
        };

        hobs.PollCheckTestStep.call(this, null, null, _checkFct, options);
    };

    hobs.actions.Assertions.isInViewport.prototype = new hobs.PollCheckTestStep();

    // Overwrite result messages
    hobs.actions.Assertions.isInViewport.prototype['res-msg-' + hobs.Chaining.Step.STATE_PASSED] = function() {
        return (this.isInViewport ? '' : 'NOT ') + 'in viewport as expected "' + this.selector + '"';
    };

    hobs.actions.Assertions.isInViewport.prototype['res-msg-' + hobs.Chaining.Step.STATE_FAILED] = function() {
        return (this.isInViewport ? 'NOT ' : '') + ' in viewport NOT as expected "' + this.selector + '"';
    };

}(window.hobs, window.jQuery));
