/*
 *
 * ADOBE CONFIDENTIAL
 * __________________
 *
 *   Copyright 2015 Adobe Systems Incorporated
 *   All Rights Reserved.
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

    var selectors = {
        authoring: {
            sidePanel: {
                components: {
                    component: '#SidePanel .sidepanel-content .sidepanel-tab-components .content-panel article'
                },
                trigger: '.js-editor-SidePanel-toggle',
                closed: '#SidePanel.sidepanel-closed',
                opened: '#SidePanel.sidepanel-opened'
            }
        }
    };

    new hobs.TestSuite('Screens - Geometrixx Authoring',
        {path: '/apps/geometrixx-instore/tests/geometrixx-authoring.js', register: true})

        .addTestCase(new hobs.TestCase('Sequence - Allowed Components', {demoMode: DEBUG})
            .navigateTo('/editor.html/content/screens/geometrixx/channels/idle.edit.html')
            .asserts.isTrue(function() {
                var win = hobs.context().window;
                var components = win.Granite.author.components.allowedComponents;
                return components && components.length > 0;
            })
            .asserts.isTrue(function() {
                var win = hobs.context().window;
                var components = win.Granite.author.components.allowedComponentsFor;
                return components['/content/screens/geometrixx/channels/idle/jcr:content/par'] &&
                    components['/content/screens/geometrixx/channels/idle/jcr:content/par'].length > 0;
            })
            .asserts.isTrue(function() {
                var $ = hobs.context().window.$;
                var opened = $(selectors.authoring.sidePanel.opened);
                if (opened.length > 0) {
                    // make sure panel is closed
                    $(selectors.authoring.sidePanel.trigger).click();
                }
                return $(selectors.authoring.sidePanel.closed).length > 0;
            })
            .click(selectors.authoring.sidePanel.trigger)
            .asserts.exists(selectors.authoring.sidePanel.components.component)
            .click(selectors.authoring.sidePanel.trigger)
        );

}(window, hobs));
