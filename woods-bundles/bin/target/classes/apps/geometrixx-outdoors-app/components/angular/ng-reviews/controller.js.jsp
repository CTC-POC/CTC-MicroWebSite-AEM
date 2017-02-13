<%--
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
--%><%@ page session="false" %><%
%><%@include file="/libs/foundation/global.jsp" %><%
%><%
    slingResponse.setContentType("application/javascript");
%>

$scope.reviewDataPath = '<%= resource.getPath() %>';

if ($scope.wcmMode === false) {
    var sku = $routeParams.id;
    var productPath = '/' + sku.substring(0, 2) + '/' + sku.substring(0, 4) + '/' + sku + '/jcr:content/content-par/ng-reviews';

    var reviewPath = '<%= resource.getPath() %>';
    var newReviewPath = reviewPath.replace('/jcr:content/content-par/ng-reviews', productPath)

    $scope.reviewDataPath = newReviewPath;
} 