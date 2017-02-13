<%--
/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2013 Adobe Systems Incorporated
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
 **************************************************************************/
--%><%
%><%@page session="false" contentType="text/html; charset=utf-8"%><%
%><%@page import="com.day.cq.i18n.I18n" %><%
%><%@include file="/libs/foundation/global.jsp"%><%
    I18n i18n = new I18n(slingRequest);
    final String detailsPath = properties.get("./details", currentPage.getPath() + "/details");
%><div class="topcoat-list">
    <h3 class="topcoat-list__header"><%=i18n.get("Local Store")%></h3>
    <ul class="topcoat-list__container location">
        <li class="topcoat-list__item" ng-repeat="location in locations | limitTo:1" ng-controller="LocationItemCtrl">
            <a x-cq-linkchecker="skip" ng-click="details('<%= xssAPI.getValidHref(detailsPath) %>')">
                <div class="location-address">
                    <h2>{{location.name}}</h2>
                    <p>{{location.address}}</p>
                    <button ng-click="phone($event)" class="topcoat-button--cta"><i class="topcoat-icon topcoat-icon--call-light"></i><%=i18n.get("Call Store")%></button>
                    <button ng-click="directions($event)" class="topcoat-button--cta"><i class="topcoat-icon topcoat-icon--location-light"></i><%=i18n.get("Directions")%></button>
                </div>
                <span class="distance">{{location.distance | distance}}</span>
                <span class="next"><i class="topcoat-icon topcoat-icon--next"></i></span>
            </a>
        </li>
    </ul>
</div>
<div class="topcoat-list">
    <h3 class="topcoat-list__header"><%=i18n.get("Other Stores")%></h3>
    <ul class="topcoat-list__container location">
        <li class="topcoat-list__item" ng-repeat="location in locations | omit:1" ng-controller="LocationItemCtrl">
            <a x-cq-linkchecker="skip" ng-click="details('<%= xssAPI.getValidHref(detailsPath) %>')">
                <div class="location-address">
                    <h2>{{location.name}}</h2>
                    <p>{{location.address}}</p>
                </div>
                <span class="distance">{{location.distance | distance}}</span>
                <span class="next"><i class="topcoat-icon topcoat-icon--next"></i></span>
            </a>
        </li>
    </ul>
</div>