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

    var searchFormActionPathDeferred = Q.defer();
    var queryTextParam = "q";
    
    
    ResourceUtils.getContainingPage(granite.resource).then(function (containingPage) {
        var pagePath = containingPage.path;
        var searchAction = ResourceUtils.getRelativeParent(pagePath, 2) + "/toolbar/search.html";
        searchFormActionPathDeferred.resolve(searchAction);
    }, function () {
        searchFormActionPathDeferred.resolve("");
    });
    
    var language = "";
    if (wcm && wcm.currentPage) {
        language = wcm.currentPage.properties["jcr:language"];
    }
    
    var queryString = granite.request.parameters[queryTextParam];
    
    return {
        searchFormAction: searchFormActionPathDeferred.promise,
        pageLanguage: language,
        querytextParam: queryTextParam,
        queryString: queryString
    };
});
