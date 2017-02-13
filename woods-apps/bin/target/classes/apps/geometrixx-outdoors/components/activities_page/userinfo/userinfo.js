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
var global = this;
use(["/libs/wcm/foundation/components/utils/ResourceUtils.js",
     "/libs/sightly/js/3rd-party/q.js"], function (ResourceUtils, Q) {
    
    var language = "";
    if (wcm && wcm.currentPage) {
        language = wcm.currentPage.properties["jcr:language"];
    }
    
    var isAnonymous = true;
    var logoutLinkUrl = "";
    var resourcePath = new String(granite.resource.path);
    var clientContextId = "profile-formattedName-" + resourcePath.replace(/[\/ :]/g, "_");
    
    if (global.Packages) {
        try {
            isAnonymous = global.Packages.com.day.cq.personalization.UserPropertiesUtil.isAnonymous(request);
            var resourceResolver = resource.getResourceResolver();
            logoutLinkUrl = resourceResolver.map(request, "/system/sling/logout") 
                + ".html?resource=" + resourceResolver.map(wcm.currentPage.path) + ".html";
        } catch (e) {
            log.error(e);
        }
    }
    
    var accountPagePathPromise = Q.defer();
    var smartListPagePathPromise = Q.defer();
    var mailboxPagePathPromise = Q.defer();
    
    ResourceUtils.getContainingPage(granite.resource).then(function (containingPage) {
        ResourceUtils.getInheritedPageProperty(containingPage, "cq:accountPage").then(function(accountPage) {
            accountPagePathPromise.resolve(accountPage + ".html");
        });

        ResourceUtils.getInheritedPageProperty(containingPage, "cq:smartListPage").then(function(smartListPage) {
            smartListPagePathPromise.resolve(smartListPage + ".html");
        });

        ResourceUtils.getInheritedPageProperty(containingPage, "cq:mailboxPag").then(function(mailboxPage) {
            mailboxPagePathPromise.resolve(mailboxPage + ".html");
        })
    });
    
    return {
        pageLanguage: language,
        logoutLinkUrl: logoutLinkUrl,
        isAnonymous: isAnonymous,
        accountPagePath: accountPagePathPromise.promise,
        smartListPagePath: smartListPagePathPromise.promise,
        mailboxPagePath: mailboxPagePathPromise.promise,
        clientContextId: clientContextId,
        wcmmode: global.wcmmode,
        resourcePath: global.granite.resource.path
    };
});
