/*
 * ADOBE CONFIDENTIAL
 *
 * Copyright 2014 Adobe Systems Incorporated
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
"use strict";
use(["/libs/wcm/foundation/components/utils/ResourceUtils.js",
     "/libs/sightly/js/3rd-party/q.js"], function (ResourceUtils, Q){
    
    var Constants = {
            ABSOLUTE_PARENT_PROP: "absParent",
            DEFAULT_ABSOLUTE_PARENT: 2,
            HIDE_SITE_TITLE_PROP: "hideSiteTitle"
    };
    
    var _collectNavItems = function(pageItemArray, currentIndex, collector, resultDeferred) {
        if (!collector) {
            collector = [];
        }
        
        if (!resultDeferred) {
            resultDeferred = Q.defer();
        }
        
        if (currentIndex >= pageItemArray.length) {
            resultDeferred.resolve(collector);
            
            if (collector.length > 7) {
                extraClassesDeferred.resolve("large");
            } else {
                extraClassesDeferred.resolve("");
            }
            
            return;
        }
        
        var currentItem = pageItemArray[currentIndex];
        log.debug("Found navigation item " + currentItem.path);
        ResourceUtils.getPageProperties(currentItem).then(function (currentItemPageProperties) {
            
            var title = currentItemPageProperties["navTitle"];
            if (!title) {
                title = currentItemPageProperties["jcr:title"];
            }
            if (!title) {
                title = currentItem.name;
            }
            
            log.debug("Found navigation item " + currentItem.path + " title:" + title);
            
            var shouldHide = currentItemPageProperties["hideInNav"] == "true"
                || currentItemPageProperties["hideInNav"] == true;
            
            if (!shouldHide) {
                var className = "topnav-item-" + (collector.length + 1);
                if (collector.length == 0) className += " topnav-first";
                if (currentIndex == pageItemArray.length - 1) className += " topnav-last";
                
                collector.push({
                    itemPath: currentItem.path + ".html",
                    itemTitle: title,
                    itemClass: className
                });
            }
            
            _collectNavItems(pageItemArray, currentIndex + 1, collector, resultDeferred);
        }, function() {
            _collectNavItems(pageItemArray, currentIndex + 1, collector, resultDeferred);
        });
        
        return resultDeferred.promise;
    };
    
    var absoluteParent = Constants.DEFAULT_ABSOLUTE_PARENT
    var showSiteTitle = true;
    
    if (currentStyle) {
        absoluteParent = parseInt(currentStyle.get(Constants.ABSOLUTE_PARENT_PROP, Constants.DEFAULT_ABSOLUTE_PARENT));
        var hideSiteTitle = currentStyle.get(Constants.HIDE_SITE_TITLE_PROP) == "true"
                || currentStyle.get(Constants.HIDE_SITE_TITLE_PROP) == true;
        showSiteTitle = !hideSiteTitle;
    }
    
    var extraClassesDeferred = Q.defer();
    var rootPageDeferred = Q.defer();
    var navitemDeferred = Q.defer();
    
    ResourceUtils.getContainingPage(granite.resource).then(function (containingPage) {
        var rootPath = ResourceUtils.getAbsoluteParent(containingPage.path, absoluteParent);
        ResourceUtils.getResource(rootPath).then(function (rootResource) {
            // get root page properties
            ResourceUtils.getPageProperties(rootResource).then(function (rootPageProperties) {
                var title = rootPageProperties["navTitle"];
                if (!title) {
                    title = rootPageProperties["jcr:title"];
                }
                if (!title) {
                    title = rootResource.name;
                }
                
                rootPageDeferred.resolve({
                    rootPath: rootPath + ".html",
                    rootTitle: title
                });
            });
            
            // compute children for the navigation items
            rootResource.getChildren().then(function (childResources) {
                log.debug("Collecting navigation items of page " + rootPath + ", found " + childResources.length);
                _collectNavItems(childResources, 0, undefined, navitemDeferred);
            })
        });
    });
    
    return {
        showSiteTitle: showSiteTitle,
        rootPageInfo: rootPageDeferred.promise,
        navItems: navitemDeferred.promise,
        extraClasses: extraClassesDeferred.promise
    };
});
