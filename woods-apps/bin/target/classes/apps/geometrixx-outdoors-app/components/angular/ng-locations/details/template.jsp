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
%><%@page import="com.day.cq.i18n.I18n,
                 com.adobe.cq.mobile.angular.data.util.FrameworkContentExporterUtils" %><%

    I18n i18n = new I18n(slingRequest);

    String componentPath = resource.getPath();
    request.setAttribute("componentDataPath", FrameworkContentExporterUtils.getJsFriendlyResourceName(componentPath));

%><article class="location-details" ng-cloak ng-controller="LocationDetailsCtrl" ng-init="init('<c:out value="${componentDataPath}"/>')">

    <div class="location-header">
        <cq:include path="ng-image" resourceType="mobileapps/components/image" />
        <div class="phone-btn">
            <button ng-click="phone($event)" class="topcoat-button--cta"><i class="topcoat-icon topcoat-icon--call-light"></i><%=i18n.get("Call Store")%>: {{location.phone | phonenumber}}</button>
        </div>
    </div>

    <div class="location-content">
        <h2><%=i18n.get("Address")%></h2>
        <div class="location-container">
            <h3>{{location.name}}</h3>
            <p>{{location.address}}</p>
        </div>
        <h2><%=i18n.get("Hours")%></h2>
        <div class="location-container">
            <div class="location-hours" ng-repeat="hour in location.formattedHours">
                <span><h3>{{hour.day}}</h3></span>
                <span><p>{{hour.time}}</p></span>
            </div>
        </div>
        <h2><%=i18n.get("Map")%></h2>
        <div class="location-container">
            <div class="location-map">
                <cq-map zoom="12"
                        maptype="roadmap"
                        center="origin"
                        markers="location"
                        refresh="showMap">
                    Loading map...
                </cq-map>
            </div>
        </div>
        <h2><%=i18n.get("Notes")%></h2>
        <div class="location-container">
            <p>{{location.description}}</p>
        </div>
    </div>

</article>