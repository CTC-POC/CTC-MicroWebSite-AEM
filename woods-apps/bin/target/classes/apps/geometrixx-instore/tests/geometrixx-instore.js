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

    var cache = {};

    var selectors = {
        app: {
            view: '.geo-App'
        },
        logo: {
            view: '.geo-LogoView'
        },
        catalog: {
            view: '.geo-CatalogView',
            current: '.screens-SwipeGrid-cell:last-child .geo-CatalogView',
            cover: {
                view: '.geo-CatalogCoverView',
                demo: '[style*="cover-images/mens"]',
                background: '.geo-CatalogView-background'
            }
        },
        category: {
            view: '.geo-CategoryView'
        },
        product: {
            view: '.geo-ProductHeroView',
            current: '.screens-SwipeGrid-cell:last-child .geo-ProductHeroView',
            demo: '[data-path*="men/shirts/ashanti-nomad"]',
            thumbnail: '.geo-ProductThumbnailView',
            callout: {
                view: '.geo-CatalogCoverView .geo-ProductCalloutView',
                button: '.geo-CatalogCoverView .icon-info'
            },
            fullscreen: {
                view: '.geo-ProductFullscreenView',
                bigThumbnail: '.geo-ProductFullscreenView-content .geo-ProductThumbnailView',
                smallThumbnail: '.geo-ProductFullscreenView-drawer .geo-ProductThumbnailView',
                description: '.geo-ProductFullscreenView .geo-ProductDescriptionView',
                button: '.geo-ProductFullscreenView-content .icon-menu'
            }
        }
    };

    new hobs.TestSuite('Screens - Geometrixx Instore Demo',
        {path: '/apps/geometrixx-instore/tests/geometrixx-instore.js', register: true})

        // The app should have some initial structure
        .addTestCase(new hobs.TestCase('App structure', {demoMode: DEBUG})
            .navigateTo('/content/screens/geometrixx/apps/virtual-showroom.html')
            .asserts.exists(selectors.app.view)
            .asserts.exists(selectors.logo.view)
            .asserts.exists(selectors.catalog.view)
            .asserts.exists(selectors.catalog.cover.view)
            .asserts.exists(selectors.category.view)
            .asserts.exists(selectors.product.view)
            .asserts.exists(selectors.product.callout.view)
            .asserts.exists(selectors.product.callout.button)
        )

        // It should be possible to swipe up and down to switch catalogs
        .addTestCase(new hobs.TestCase('Switch catalog', {demoMode: DEBUG})

            // Check the initial catalog is visible
            .asserts.isVisible([selectors.catalog.cover.view,
                selectors.catalog.cover.background + selectors.catalog.cover.demo].join(' '))
            .asserts.isInViewport([selectors.catalog.cover.view,
                selectors.catalog.cover.background + selectors.catalog.cover.demo].join(' '))
            .execSyncFct(function() {
                cache.currentCatalog = hobs.find(selectors.catalog.cover.view + ':last');
                cache.initialCatalog = cache.currentCatalog;
                cache.previousCatalog = cache.currentCatalog;
            })

            // Swipe to another catalog
            .sistine.swipeUp(selectors.catalog.cover.view + ':last')
            .asserts.isInViewport([selectors.catalog.cover.view,
                selectors.catalog.cover.background + selectors.catalog.cover.demo].join(' '), false)
            .asserts.isVisible(selectors.catalog.cover.view)
            .asserts.isInViewport(selectors.catalog.cover.view + ':last')
            .asserts.isTrue(function() {
                cache.currentCatalog = hobs.find(selectors.catalog.cover.view + ':last');
                return cache.previousCatalog.get(0) !== cache.currentCatalog.get(0);
            })
            .execSyncFct(function() {
                cache.previousCatalog = cache.currentCatalog;
            })

            // Swipe back to the initial catalog
            .sistine.swipeDown(selectors.catalog.cover.view + ':last')
            .asserts.isVisible(selectors.catalog.cover.view + ':first')
            .asserts.isInViewport([selectors.catalog.cover.view,
                selectors.catalog.cover.background + ':not(' + selectors.catalog.cover.demo + ')'].join(' '), false)
            .asserts.isVisible([selectors.catalog.cover.view,
                selectors.catalog.cover.background + selectors.catalog.cover.demo].join(' '))
            .asserts.isInViewport([selectors.catalog.cover.view,
                selectors.catalog.cover.background + selectors.catalog.cover.demo].join(' '))
            .asserts.isTrue(function() {
                cache.currentCatalog = hobs.find(selectors.catalog.cover.view + ':last');
                return cache.previousCatalog.get(0) !== cache.currentCatalog.get(0)
                    && cache.currentCatalog.get(0) === cache.initialCatalog.get(0);
            })
        )

        // It should be possible to toggle the callouts when tapping the buttons
        .addTestCase(new hobs.TestCase('Toggle product callouts', {demoMode: DEBUG})

            // There should be buttons and callouts on the current catalog, and the callouts should be hidden
            .asserts.exists([selectors.catalog.current, selectors.product.callout.view].join(' '))
            .asserts.exists([selectors.catalog.current, selectors.product.callout.button].join(' '))
            .asserts.isVisible(selectors.product.callout.view, false)
            .asserts.isTrue(function() {
                return hobs.find(selectors.product.callout.view).length >= 2;
            })

            // Tapping a callout should show it
            .sistine.tap(selectors.product.callout.button + ':eq(0)')
            .asserts.isVisible(selectors.product.callout.view + ':eq(0)')

            // Tapping it again should close it
            .sistine.tap(selectors.product.callout.button + ':eq(0)')
            .asserts.isVisible(selectors.product.callout.view + ':eq(0)', false)

            // Tapping a second callout when one is already open should close it
            .sistine.tap(selectors.product.callout.button + ':eq(0)')
            .asserts.isVisible(selectors.product.callout.view + ':eq(0)')

            .sistine.tap(selectors.product.callout.button + ':eq(1)')
            .asserts.isVisible(selectors.product.callout.view + ':eq(0)', false)
            .asserts.isVisible(selectors.product.callout.view + ':eq(1)')

            .sistine.tap(selectors.product.callout.button + ':eq(1)')
            .asserts.isVisible(selectors.product.callout.view + ':eq(1)', false)
        )

        // Position on the right category for the rest of the test cases
        .addTestCase(new hobs.TestCase('Select a specific product category', {demoMode: DEBUG})

            // Position on the right category
            .asserts.exists([selectors.catalog.current, selectors.catalog.cover.view].join(' '))

            .sistine.swipeLeft([selectors.catalog.current, selectors.catalog.cover.view].join(' '))
            .asserts.isInViewport([selectors.catalog.current, selectors.catalog.cover.view].join(' '), false)
            .asserts.isVisible([selectors.catalog.current, selectors.category.view].join(' ') + ':lt(2)')
            .asserts.isInViewport([selectors.catalog.current, selectors.category.view].join(' ') + ':lt(2)')

            .sistine.swipeLeft([selectors.catalog.current, selectors.catalog.cover.view].join(' '))
            .asserts.isVisible([selectors.catalog.current, selectors.category.view].join(' ') + ':gt(0):lt(2)')
            .asserts.isInViewport([selectors.catalog.current, selectors.category.view].join(' ') + ':gt(0):lt(2)')

            .sistine.swipeLeft([selectors.catalog.current, selectors.catalog.cover.view].join(' '))
            .asserts.isVisible([selectors.catalog.current, selectors.category.view].join(' ') + ':gt(1):lt(3)')
            .asserts.isInViewport([selectors.catalog.current, selectors.category.view].join(' ') + ':gt(1):lt(3)')
            .asserts.exists([selectors.catalog.current, selectors.category.view].join(' ') + ':gt(1):lt(3) ' +
                selectors.product.demo)

        )

        // It should be possible to swipe up and down between products
        .addTestCase(new hobs.TestCase('Switch product', {demoMode: DEBUG})

            // Check initial product is visible
            .asserts.isVisible(
                [selectors.product.view, selectors.product.thumbnail + selectors.product.demo].join(' '))
            .asserts.isInViewport(
                [selectors.product.view, selectors.product.thumbnail + selectors.product.demo].join(' '))
            .execSyncFct(function() {
                cache.currentProduct = hobs.find([selectors.catalog.current, selectors.category.view + ':eq(2)',
                    selectors.product.current].join(' '));
                cache.initialProduct = cache.currentProduct;
                cache.previousProduct = cache.currentProduct;
            })

            // Swipe to another product
            .sistine.swipeUp([selectors.product.view, selectors.product.thumbnail + selectors.product.demo].join(' '))
            .asserts.isTrue(function() {
                cache.currentProduct = hobs.find([selectors.catalog.current, selectors.category.view + ':eq(2)',
                    selectors.product.current].join(' '));
                return cache.previousProduct.get(0) !== cache.currentProduct.get(0);
            })
            .execSyncFct(function() {
                cache.previousProduct = cache.currentProduct;
            })
            .asserts.isInViewport(
                [selectors.product.view, selectors.product.thumbnail + selectors.product.demo].join(' '), false)

            // Sipw back to the initial product
            .sistine.swipeDown([selectors.product.view, selectors.product.thumbnail + selectors.product.demo].join(' '))
            .asserts.isInViewport(
                [selectors.product.view, selectors.product.thumbnail + selectors.product.demo].join(' '))
            .asserts.isTrue(function() {
                cache.currentProduct = hobs.find([selectors.catalog.current, selectors.category.view + ':eq(2)',
                    selectors.product.current].join(' '));
                return cache.previousProduct.get(0) !== cache.currentProduct.get(0)
                    && cache.currentProduct.get(0) === cache.initialProduct.get(0);
            })

        )

        // Double-tapping should toggle the fullscreen view for the product
        .addTestCase(new hobs.TestCase('Open fullscreen product', {demoMode: DEBUG})

            // Open the product fullscreen view
            .asserts.isVisible(
                [selectors.product.view, selectors.product.thumbnail + selectors.product.demo].join(' '))
            .asserts.isInViewport(
                [selectors.product.view, selectors.product.thumbnail + selectors.product.demo].join(' '))

            .sistine.doubletap([selectors.product.view, selectors.product.thumbnail + selectors.product.demo].join(' '))
            .asserts.exists(selectors.product.fullscreen.view)
            .asserts.exists(selectors.product.fullscreen.bigThumbnail)
            .asserts.exists(selectors.product.fullscreen.smallThumbnail)
            .asserts.exists(selectors.product.fullscreen.description)
            .asserts.exists(selectors.product.fullscreen.button)
            .asserts.isVisible(selectors.product.fullscreen.view)

            // The selected product in the fullscreen view is the right one
            .asserts.isVisible(selectors.product.fullscreen.smallThumbnail)
            .asserts.isInViewport(selectors.product.fullscreen.smallThumbnail + selectors.product.demo)
            .asserts.hasCssClass(selectors.product.fullscreen.smallThumbnail + selectors.product.demo, 'active')
            .asserts.isVisible(selectors.product.fullscreen.bigThumbnail)
            .asserts.isInViewport(selectors.product.fullscreen.bigThumbnail + selectors.product.demo)

        )

        // Tapping one of the small thumbnails should change the product in the view
        .addTestCase(new hobs.TestCase('Change product', {demoMode: DEBUG})
            .asserts.exists(selectors.product.fullscreen.smallThumbnail + ':eq(1)')

            .sistine.tap(selectors.product.fullscreen.smallThumbnail + ':eq(1)')
            .asserts.hasCssClass(selectors.product.fullscreen.smallThumbnail + ':eq(0)', 'active', false)
            .asserts.hasCssClass(selectors.product.fullscreen.smallThumbnail + ':eq(1)', 'active')
            .asserts.isTrue(function() {
                var $smallThumbnails = hobs.find(selectors.product.fullscreen.smallThumbnail);
                var $bigThumbnail = hobs.find(selectors.product.fullscreen.bigThumbnail);
                return $smallThumbnails.eq(1).attr('data-path') === $bigThumbnail.attr('data-path');
            })
            .wait(300)

        )

        // Tapping the menu icon should toggle the product details
        .addTestCase(new hobs.TestCase('Toggle product details', {demoMode: DEBUG})

            // The description panel should be hidden by default
            .asserts.isVisible(selectors.product.fullscreen.button)
            .asserts.isInViewport(selectors.product.fullscreen.button)
            .asserts.isVisible(selectors.product.fullscreen.description)
            .asserts.isInViewport(selectors.product.fullscreen.description, false)

            // Tapping the menu icon should show the description panel
            .sistine.tap(selectors.product.fullscreen.button)
            .asserts.isVisible(selectors.product.fullscreen.button)
            .asserts.isInViewport(selectors.product.fullscreen.button)
            .asserts.isVisible(selectors.product.fullscreen.description)
            .asserts.isInViewport(selectors.product.fullscreen.description)

            // Tapping the menu icon again should show hide description panel
            .sistine.tap(selectors.product.fullscreen.button)
            .asserts.isVisible(selectors.product.fullscreen.button)
            .asserts.isInViewport(selectors.product.fullscreen.button)
            .asserts.isInViewport(selectors.product.fullscreen.description, false)

        )

        // Double-tapping the big thumbnail should close the fullscreen view
        .addTestCase(new hobs.TestCase('Close category', {demoMode: DEBUG})
            .asserts.isVisible(selectors.product.fullscreen.view)
            .asserts.isInViewport(selectors.product.fullscreen.view)

            .sistine.doubletap(selectors.product.fullscreen.bigThumbnail)
            .asserts.isVisible(selectors.product.fullscreen.view, false)
            .asserts.isInViewport(selectors.product.fullscreen.view, false)

            // The visible product should now match the one that was selected in the fullscreen view
            .asserts.isInViewport(
                [selectors.product.view, selectors.product.thumbnail + selectors.product.demo].join(' '), false)
        )

        // Swiping right should bring you back to the catalog cover
        .addTestCase(new hobs.TestCase('Switch to catalog cover', {demoMode: DEBUG})
            .asserts.isInViewport([selectors.catalog.current, selectors.catalog.cover.view].join(' '), false)
            .asserts.isVisible([selectors.catalog.current, selectors.category.view + ':gt(1):lt(3)'].join(' '))
            .asserts.isInViewport([selectors.catalog.current, selectors.category.view + ':gt(1):lt(3)'].join(' '))

            .sistine.swipeRight([selectors.catalog.current, selectors.category.view].join(' '))
            .asserts.isVisible([selectors.catalog.current, selectors.category.view + ':gt(0):lt(2)'].join(' '))
            .asserts.isInViewport([selectors.catalog.current, selectors.category.view + ':gt(0):lt(2)'].join(' '))

            .sistine.swipeRight([selectors.catalog.current, selectors.category.view].join(' '))
            .asserts.isVisible([selectors.catalog.current, selectors.category.view + ':lt(2)'].join(' '))
            .asserts.isInViewport([selectors.catalog.current, selectors.category.view + ':lt(2)'].join(' '))

            .sistine.swipeRight([selectors.catalog.current, selectors.category.view].join(' '))
            .asserts.isInViewport([selectors.catalog.current, selectors.category.view].join(' '), false)
            .asserts.isInViewport([selectors.catalog.current, selectors.catalog.cover.view].join(' '))
        )

        ;

}(window, hobs));
