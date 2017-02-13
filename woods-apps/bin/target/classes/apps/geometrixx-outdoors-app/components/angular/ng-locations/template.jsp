<%@ page import="com.day.cq.wcm.api.WCMMode" %>
<%--
  ADOBE CONFIDENTIAL
  __________________

   Copyright 2013 Adobe Systems Incorporated
   All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.
--%><%
%><%@page session="false" %><%
%><%@include file="/libs/foundation/global.jsp" %><%
%><%@page import="com.adobe.cq.mobile.angular.data.util.FrameworkContentExporterUtils,
                 com.day.cq.wcm.api.WCMMode,
                 com.day.cq.wcm.foundation.Placeholder,
                 com.day.cq.i18n.I18n" %><%
%><cq:include script="overhead.jsp"/><%

    I18n i18n = new I18n(slingRequest);

    String showSearch = properties.get("./showSearch", "off");
    Boolean includeSearch = (showSearch.equalsIgnoreCase("true") || showSearch.equalsIgnoreCase("on"));
    request.setAttribute("includeSearch", includeSearch);
    request.setAttribute("locationPath", properties.get("./locations", ""));

%>

<c:choose>
    <c:when test="${empty locationPath}">
        <c:if test="${wcmMode}">
            <cq:text property="text" escapeXml="true"
                     placeholder="<%= Placeholder.getDefaultPlaceholder(slingRequest, component, null) %>"/>
        </c:if>
    </c:when>
    <c:otherwise>
        <div class="locations" ng-controller="LocationListCtrl" ng-init="init('<c:out value="${componentDataPath}"/>')">
            <div class="location-list" ng-cloak ng-hide="showMap">
                <cq:include script="list.jsp" />
            </div>
            <div class="location-map" ng-show="showMap">
                <cq:include script="map.jsp" />
            </div>
            <div class="location-search">
                <div class="topcoat-navigation-bar">
                    <div class="topcoat-navigation-bar__item left quarter">
                        <a class="topcoat-icon-button--quiet" ng-click="showMap=!showMap" ng-hide="showMap">
                            <span class="topcoat-icon topcoat-icon--location"></span>
                        </a>
                        <a class="topcoat-icon-button--quiet" ng-click="showMap=!showMap" ng-show="showMap">
                            <span class="topcoat-icon topcoat-icon--menu-stack"></span>
                        </a>
                    </div>
                    <c:if test="${includeSearch}">
                        <div class="topcoat-navigation-bar__item center half">
                            <input type="search" placeholder="<%=i18n.get("search city")%>" class="topcoat-search-input" ng-model="query">
                        </div>
                        <div class="topcoat-navigation-bar__item right">
                            <a class="topcoat-icon-button--quiet" ng-click="locate(true)">
                                <span class="topcoat-icon topcoat-icon--search"></span>
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
            <div cq-toast toast-options="{'timeout': 2000}"><p>{{toast.message}}</p></div>
        </div>
    </c:otherwise>
</c:choose>