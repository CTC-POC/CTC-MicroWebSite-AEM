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
        sequence: {
            item: '.cq-Sequence-item'
        },
        firmware: {
            tooltip: '.aem-ScreensPlayer-tooltip',
            osd: {
                trigger: '.aem-ScreensPlayer-osd-trigger',
                close: '.aem-ScreensPlayer-osd-close',
                visible: '.aem-ScreensPlayer-osd.is-visible',
                hidden: '.aem-ScreensPlayer-osd.is-hidden',
                button: '.aem-ScreensPlayer-osd-channelButton'
            }
        },
        app: {
            geometrixx: {
                catalog: {
                    cover: {
                        view: '.geo-CatalogCoverView',
                        demo: '[style*="cover-images/mens"]',
                        background: '.geo-CatalogView-background'
                    }
                }
            }
        },
        zones: {
            channels: '.screens-Channel',
            a1: '#screens-zone-a1',
            a2: '#screens-zone-a2'
        },
        channels: {
            idleNight: {
                item: '.cq-Sequence-item',
                image1: '[style*="surfing/PDP_4_c15"]'
            }
        }
    };

    var data = {
        app: {
            geometrixx: {
                path: '/content/screens/geometrixx/apps/virtual-showroom'
            }
        },
        channels: {
            idleNight: {
                role: 'idle-night'
            }
        },
        firmware: {
            osd: {
                trigger: {
                    clickX: 25,
                    clickY: 25
                }
            }
        }
    };

    function getOSDTrigger() {
        var context = hobs.context();
        var $ = context.window.$;
        var doc = context.window.document;
        var y = $(document).height() - data.firmware.osd.trigger.clickY;
        var els = hobs.utils.elementsFromPoint(data.firmware.osd.trigger.clickX, y, doc);

        return $(els[0]);
    }

    new hobs.TestSuite('Screens - Geometrixx Channels',
        {path: '/apps/geometrixx-instore/tests/geometrixx-channels.js', register: true})

        .addTestCase(new hobs.TestCase('Idle channel sequence', {
            demoMode: DEBUG,
            after: hobs.screens.steps.resetContext
        })
            .navigateTo(PLAYER_PATH + '/content/screens/geometrixx/locations/demo/flagship/single/device0?date=' + new Date(new Date().setHours(10)).toISOString())
            .wait(3000)
            .screens.setChannelContext()
            .asserts.exists(selectors.sequence.item + ':eq(3)')
            .asserts.exists(selectors.sequence.item + ':eq(4)', false)
            .asserts.exists(selectors.sequence.item + ':eq(0):visible')
            .asserts.exists(selectors.sequence.item + ':eq(1):hidden')
            .asserts.exists(selectors.sequence.item + ':eq(2):hidden')
            .asserts.exists(selectors.sequence.item + ':eq(3):hidden')
            .wait(3000)
            .asserts.exists(selectors.sequence.item + ':eq(0):hidden')
            .asserts.exists(selectors.sequence.item + ':eq(1):visible')
            .asserts.exists(selectors.sequence.item + ':eq(2):hidden')
            .asserts.exists(selectors.sequence.item + ':eq(3):hidden')
            .wait(3000)
            .asserts.exists(selectors.sequence.item + ':eq(0):hidden')
            .asserts.exists(selectors.sequence.item + ':eq(1):hidden')
            .asserts.exists(selectors.sequence.item + ':eq(2):visible')
            .asserts.exists(selectors.sequence.item + ':eq(3):hidden')
            .wait(3000)
            .asserts.exists(selectors.sequence.item + ':eq(0):hidden')
            .asserts.exists(selectors.sequence.item + ':eq(1):hidden')
            .asserts.exists(selectors.sequence.item + ':eq(2):hidden')
            .asserts.exists(selectors.sequence.item + ':eq(3):visible')
            .wait(3000)
            .asserts.exists(selectors.sequence.item + ':eq(0):visible')
            .asserts.exists(selectors.sequence.item + ':eq(1):hidden')
            .asserts.exists(selectors.sequence.item + ':eq(2):hidden')
            .asserts.exists(selectors.sequence.item + ':eq(3):hidden')
        )

        .addTestCase(new hobs.TestCase('Idle-Night channel sequence', {
            demoMode: DEBUG,
            after: hobs.screens.steps.resetContext
        })
            .navigateTo(PLAYER_PATH + '/content/screens/geometrixx/locations/demo/flagship/single/device0?date=' + new Date(new Date().setHours(20)).toISOString())
            .wait(3000)
            .screens.setChannelContext()
            .asserts.exists(selectors.sequence.item + ':eq(1)')
            .asserts.exists(selectors.sequence.item + ':eq(2)', false)
            .asserts.exists(selectors.sequence.item + ':eq(0):visible')
            .asserts.exists(selectors.sequence.item + ':eq(1):hidden')
            .wait(3000)
            .asserts.exists(selectors.sequence.item + ':eq(0):hidden')
            .asserts.exists(selectors.sequence.item + ':eq(1):visible')
            .wait(3000)
            .asserts.exists(selectors.sequence.item + ':eq(0):visible')
            .asserts.exists(selectors.sequence.item + ':eq(1):hidden')
        )

        .addTestCase(new hobs.TestCase('Attraction loop', {
            demoMode: DEBUG,
            after: hobs.screens.steps.resetContext
        })
            .navigateTo(PLAYER_PATH + '/content/screens/geometrixx/locations/demo/flagship/single/device0')
            .wait(3000)
            .screens.setFirmwareContext()
            .click(selectors.firmware.tooltip)
            .wait(3000)
            .screens.setChannelContext()
            .asserts.exists('body[data-apppath="' + data.app.geometrixx.path + '"]')
            .asserts.isVisible([selectors.app.geometrixx.catalog.cover.view,
                selectors.app.geometrixx.catalog.cover.background +
                selectors.app.geometrixx.catalog.cover.demo].join(' '))
            .asserts.isInViewport([selectors.app.geometrixx.catalog.cover.view,
                selectors.app.geometrixx.catalog.cover.background +
                selectors.app.geometrixx.catalog.cover.demo].join(' '))

        )

        .addTestCase(new hobs.TestCase('Dual zone', {
            demoMode: DEBUG,
            after: hobs.screens.steps.resetContext
        })
            .navigateTo(PLAYER_PATH + '/content/screens/geometrixx/locations/demo/flagship/zdual/device0')
            .wait(3000)
            .screens.setDisplayContext()
            .asserts.exists(selectors.zones.channels + ':eq(1)')
            .asserts.exists(selectors.zones.channels + ':eq(2)', false)
            .asserts.exists('iframe' + selectors.zones.a1)
            .asserts.exists('iframe' + selectors.zones.a2)
            .screens.setChannelContext(0)
            .asserts.exists(selectors.sequence.item + ':eq(3)')
            .asserts.exists(selectors.sequence.item + ':eq(4)', false)
            .screens.setChannelContext(1)
            .asserts.exists(selectors.sequence.item + ':eq(3)')
            .asserts.exists(selectors.sequence.item + ':eq(4)', false)
        )

        .addTestCase(new hobs.TestCase('OSD channel switching', {
            demoMode: DEBUG,
            after: hobs.screens.steps.resetContext
        })
            .navigateTo(PLAYER_PATH + '/content/screens/geometrixx/locations/demo/flagship/single/device0')
            .wait(3000)
            .asserts.exists(selectors.firmware.osd.hidden)
            .asserts.exists(selectors.firmware.osd.visible, false)
            .asserts.isTrue(function() {
                var elem = getOSDTrigger();
                // verify if elem that will be "tap hold" is the osd triggre
                return elem.length === 1 && elem.is(selectors.firmware.osd.trigger);
            })
            .execFct(function() {
                var elem = getOSDTrigger();
                elem.trigger('pointerdown');
            })
            .wait(3000) // give time for OSD trigger to react and for OSD to open
            .asserts.exists(selectors.firmware.osd.hidden, false)
            .asserts.exists(selectors.firmware.osd.visible)
            .click(selectors.firmware.osd.button + '[data-role=' + data.channels.idleNight.role + ']')
            .wait(3000) // channel needs to load
            .screens.setChannelContext()
            .asserts.isInViewport([selectors.channels.idleNight.item,
                'div' +
                selectors.channels.idleNight.image1].join(' '))
            .screens.setFirmwareContext()
            .click(selectors.firmware.osd.close)
            .asserts.exists(selectors.firmware.osd.hidden)
            .asserts.exists(selectors.firmware.osd.visible, false)

        );

}(window, hobs));
