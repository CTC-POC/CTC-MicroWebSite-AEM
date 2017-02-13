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
/* globals hobs */
(function(window, hobs) {
    'use strict';

    var DEBUG = false;
    var PLAYER_PATH = '/content/mobileapps/cq-screens-player/firmware.html';

    var selectors = {
        firmware: {
            tooltip: {
                container: '.aem-ScreensPlayer-tooltip',
                inner: '.aem-ScreensPlayer-tooltip-inner'
            }
        },
        app: {
            geometrixx: {
                catalog: {
                    products: {
                        view: '.geo-ProductThumbnailView'
                    }
                }
            }
        }
    };

    var data = {
        app: {
            geometrixx: {
                path: '/content/screens/geometrixx/apps/virtual-showroom',
                image1: '/content/screens/geometrixx/apps/virtual-showroom/en/men/coats/edmonton-winter'
            }
        }
    };

    new hobs.TestSuite('Screens - Geometrixx Devices',
        {path: '/apps/geometrixx-instore/tests/geometrixx-devices.js', register: true})

        .addTestCase(new hobs.TestCase('Single display', {
            demoMode: DEBUG,
            after: hobs.screens.steps.resetContext
        })
            .navigateTo(PLAYER_PATH + '/content/screens/geometrixx/locations/demo/flagship/single/device0')
            .wait(3000)
            .asserts.exists(selectors.firmware.tooltip.inner + ':eq(0)')
            .asserts.exists(selectors.firmware.tooltip.inner + ':eq(1)', false)
            .click(selectors.firmware.tooltip.container) // switch to geometrixx instore app
            .wait(3000)
            .screens.setChannelContext()
            .asserts.exists('body[data-apppath="' + data.app.geometrixx.path + '"]') // instore app must be loaded
            .asserts.isInViewport(selectors.app.geometrixx.catalog.products.view + '[data-path="' + data.app.geometrixx.image1 + '"]', false) // first image product should not be in viewport
        )

        .addTestCase(new hobs.TestCase('Dual display', {
            demoMode: DEBUG,
            after: hobs.screens.steps.resetContext
        })
            .navigateTo(PLAYER_PATH + '/content/screens/geometrixx/locations/demo/flagship/dual/device0')
            .wait(3000)
            .asserts.exists(selectors.firmware.tooltip.inner + ':eq(0)')
            .asserts.exists(selectors.firmware.tooltip.inner + ':eq(1)')
            .asserts.exists(selectors.firmware.tooltip.inner + ':eq(2)', false)
            .click(selectors.firmware.tooltip.container) // switch to geometrixx instore app
            .wait(3000)
            .screens.setChannelContext()
            .asserts.exists('body[data-apppath="' + data.app.geometrixx.path + '"]') // instore app must be loaded
            .asserts.isInViewport(selectors.app.geometrixx.catalog.products.view + '[data-path="' + data.app.geometrixx.image1 + '"]') // some products should be in viewport
        );

}(window, hobs));
