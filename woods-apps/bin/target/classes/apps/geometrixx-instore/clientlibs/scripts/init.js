/*
 *
 * ADOBE CONFIDENTIAL
 * __________________
 *
 *  Copyright 2015 Adobe Systems Incorporated

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
/* globals ES6Promise */
require([
    'jquery',
    'Geometrixx',
    'util/ScreensChannel'
], function($, Geometrixx, Channel) {
    'use strict';

    ES6Promise.polyfill();

    var $body = $('body');

    var defaultConfig = {
        rootElement: $body,
        lang: $body.attr('lang') || 'en',
        devicePath: $body.data('devicepath') || '',
        displayPath: $body.data('displaypath') || '',
        appPath: $body.data('apppath') || '',
        display: {
            config: [1, 1],
            deviceWidth: $(window).width(),
            deviceHeight: $(window).height()
        }
    };

    // get the display data from the current channel
    $(function() {
        if (Channel.getDisplay()) {

            // On success, pass the display and device info to the app
            var handleDisplayDataSuccess = function(displayData) {
                console.log('geometrixx got data:', displayData);
                var config = defaultConfig;

                if (displayData.display && displayData.display.layout) {
                    var displayConfig = [
                        displayData.display.layout.numCols,
                        displayData.display.layout.numRows
                    ];

                    config.display = {
                        config: displayConfig,
                        deviceWidth: $(window).width() / displayConfig[0],
                        deviceHeight: $(window).height() / displayConfig[1]
                    };
                }
                config.devicePath = displayData.device && displayData.device.path;
                config.displayPath = displayData.display && displayData.display.path;

                window.geometrixx = new Geometrixx(config);
            };

            // On failure just initialize the app as is
            var handleDisplayDataFailure = function() {
                window.geometrixx = new Geometrixx(defaultConfig);
            };

            Channel.getDisplay().getData()
                .then(handleDisplayDataSuccess)
                .catch(handleDisplayDataFailure);

        } else {
            // defaults
            window.geometrixx = new Geometrixx(defaultConfig);
        }

    });

    // Conditionally disables context menu if debugClientLibs is turned off for "production" environment
    if (!/.*debugClientLibs.*/.test(window.location.search)) {
        $(document).on('MSHoldVisual', false);
        $(document).on('contextmenu', false);
    }
});
