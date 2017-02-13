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
     * Define the namespace for the actions.
     */
    hobs.actions.Sistine = {};

    var _handleDemoMode = function(stepOptions, selector, color, text, options) {
        if (stepOptions.demoMode === true) {
            var el = hobs.utils.highlightElement(selector, color, text, $.extend({}, options, {type: 'CENTER_BOX'}));
            this.setDemoModeHighlightDOMEl(el);
        }
    };

    var _trigger = function(el, type, options) {
        var evt = hobs.window.document.createEvent('MouseEvent');
        evt.initMouseEvent(type, true, false, null, null,
            options.clientX, options.clientY, options.clientX, options.clientY,
            false, false, false, false, options.button, null);
        evt = $.extend(evt, {width: 0, height: 0}, options);
        el.dispatchEvent(evt);
    };

    /**
     * Trigger a simple tap event on the specified element.
     *
     * @param  {jQuery}  $el       The element to trigger the event on
     * @param  {Integer} [delay=0] Delay between the various steps in the tap event
     */
    var _tap = function($el, delay) {
        var el = $($el).get(0);

        // Default event options to pass along
        var options = {
            pointerId: 1,
            bubbles: true
        };

        // Trigger the events
        _trigger(el, 'pointerdown', $.extend(options, {}));

        // el.dispatchEvent(new hobs.window.PointerEvent('pointerdown', $.extend(options, {})));
        window.setTimeout(function() {
            _trigger(el, 'pointerup', $.extend(options, {}));

            // el.dispatchEvent(new hobs.window.PointerEvent('pointerup', $.extend(options, {})));
        }, delay || 0);
    };

    /**
     * Trigger a swipe action on the specified element.
     *
     * @param  {jQuery}   $el       The element to trigger the event on
     * @param  {Object[]} positions The positions for the swipe actions (start, middle, end)
     * @param  {Integer}  [delay=0] Delay between the various steps in the swipe event
     */
    var _swipe = function($el, positions, delay) {
        var el = $($el).get(0);

        // Default event options to pass along
        var options = {
            pointerId: 1,
            bubbles: true,
            pressure: 0.5,
            clientX: 0,
            clientY: 0
        };

        // Trigger the events
        _trigger(el, 'pointerdown', $.extend(options, positions[0]));
        window.setTimeout(function() {
            _trigger(el, 'pointermove', $.extend(options, positions[1]));
        }, delay || 0);
        window.setTimeout(function() {
            _trigger(el, 'pointermove', $.extend(options, positions[2]));
            _trigger(el, 'pointerup', $.extend(options, positions[2]));
        }, 1.4 * delay || 0);
    };

    /**
     * Create a test step for the specified action.
     *
     * @param  {String}   label       The label for the action to trigger
     * @param  {Function} actionFnc   The action the test step needs to trigger
     * @param  {Function} [passedFnc] The success message to return
     * @param  {Function} [failedFnc] The failure message to return
     *
     * @return {TestStep} The test step for the specified action
     */
    var _sistineTestStep = function(label, actionFnc, passedFnc, failedFnc) {
        var testStep = function(selector, options) {
            var self = this;
            var checkTrueFct = null;

            this.selector = selector;

            checkTrueFct = function(opts) {
                // Process dynamic parameters
                var sel = hobs.handleDynParameters(self.selector, opts);

                // Handle Demo Mode
                _handleDemoMode.call(self, opts, sel, 'blue', label || 'Pointer event');

                actionFnc(hobs.find(sel, opts.context), options, (function() {
                    this.dfr().resolve({result: hobs.Chaining.Step.STATE_PASSED});
                }).bind(this));

            };

            var _options = $.extend({}, options, {checkTrueFct: checkTrueFct});

            hobs.jQSelectorPollCheckTestStep.call(this, null, null, selector, _options);
        };

        testStep.prototype = new hobs.jQSelectorPollCheckTestStep(); // eslint-disable-line new-cap

        // Overwrite result messages
        testStep.prototype['res-msg-' + hobs.Chaining.Step.STATE_PASSED] = passedFnc || function() {
                return 'Triggered action on DOM element "' + this.selector + '"';
            };

        testStep.prototype['res-msg-' + hobs.Chaining.Step.STATE_FAILED] = failedFnc || function() {
            return 'DOM element "' + this.selector + '" not found';
        };

        return testStep;

    };

    /**
     * Simple tap action.
     *
     * @param  {String} selector  The selector to the element
     * @param  {Map}    [options] Options for the action
     */
    hobs.actions.Sistine.tap = _sistineTestStep('Tap',
        function($el, options, next) {
            _tap($el);
            next();
        },
        function() {
            return 'Tapped DOM element "' + this.selector + '"';
        }
    );

    /**
     * Double tap action.
     *
     * @param  {String} selector  The selector to the element
     * @param  {Map}    [options] Options for the action
     */
    hobs.actions.Sistine.doubletap = _sistineTestStep('Double Tap',
        function($el, options, next) {
            var secondTap = function(ev) {
                window.setTimeout(function() {
                    _tap($el);
                    next();
                }, 0);
            };
            $el.one('pointerup', secondTap);
            _tap($el);
        },
        function() {
            return 'Double-tapped DOM element "' + this.selector + '"';
        }
    );

    /**
     * Simple press action.
     *
     * @param  {String}  selector            The selector to the element
     * @param  {Map}     [options]           Options for the action
     * @param  {Integer} [options.delay=500] The duration for the press event
     */
    hobs.actions.Sistine.press = _sistineTestStep('Press',
        function($el, options, next) {
            _tap($el, options.delay || 500);
            next();
        },
        function() {
            return 'Pressed DOM element "' + this.selector + '"';
        }
    );

    /**
     * Left swipe action.
     *
     * @param  {String} selector  The selector to the element
     * @param  {Map}    [options] Options for the action
     */
    hobs.actions.Sistine.swipeLeft = _sistineTestStep('Swipe Left',
        function($el, options, next) {
            var pos = {
                start: options && options.swipeStart || 100,
                end: options && options.swipeEnd || 0
            };
            pos.middle = (pos.start - pos.end) / 2;

            _swipe($el, [{clientX: pos.start}, {clientX: pos.middle}, {clientX: pos.end}], 100);
            next();
        },
        function() {
            return 'Swiped left DOM element "' + this.selector + '"';
        }
    );

    /**
     * Right swipe action.
     *
     * @param  {String} selector  The selector to the element
     * @param  {Map}    [options] Options for the action
     */
    hobs.actions.Sistine.swipeRight = _sistineTestStep('Swipe Right',
        function($el, options, next) {
            var pos = {
                start: options && options.swipeStart || 0,
                end: options && options.swipeEnd || 100
            };
            pos.middle = (pos.end - pos.start) / 2;

            _swipe($el, [{clientX: pos.start}, {clientX: pos.middle}, {clientX: pos.end}], 100);
            next();
        },
        function() {
            return 'Swiped right DOM element "' + this.selector + '"';
        }
    );

    /**
     * Up swipe action.
     *
     * @param  {String} selector  The selector to the element
     * @param  {Map}    [options] Options for the action
     */
    hobs.actions.Sistine.swipeUp = _sistineTestStep('Swipe Up',
        function($el, options, next) {
            var pos = {
                start: options && options.swipeStart || 100,
                end: options && options.swipeEnd || 0
            };
            pos.middle = (pos.start - pos.end) / 2;

            _swipe($el, [{clientY: pos.start}, {clientY: pos.middle}, {clientY: pos.end}], 100);
            next();
        },
        function() {
            return 'Swiped up DOM element "' + this.selector + '"';
        }
    );

    /**
     * Down swipe action.
     *
     * @param  {String} selector  The selector to the element
     * @param  {Map}    [options] Options for the action
     */
    hobs.actions.Sistine.swipeDown = _sistineTestStep('Swipe Down',
        function($el, options, next) {
            var pos = {
                start: options && options.swipeStart || 0,
                end: options && options.swipeEnd || 100
            };
            pos.middle = (pos.end - pos.start) / 2;

            _swipe($el, [{clientY: pos.start}, {clientY: pos.middle}, {clientY: pos.end}], 100);
            next();
        },
        function() {
            return 'Swiped down DOM element "' + this.selector + '"';
        }
    );

    hobs.registerCustomActions('sistine', hobs.actions.Sistine);

}(window.hobs, window.jQuery));
