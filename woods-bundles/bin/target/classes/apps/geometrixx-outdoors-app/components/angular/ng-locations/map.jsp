<%@page session="false"%><%--
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
--%>

<%@include file="/libs/foundation/global.jsp"%><%
%><%@ page contentType="text/html; charset=utf-8"%><%
%><cq-map zoom="12"
          maptype="roadmap"
          center="origin"
          markers="locations"
          refresh="showMap"
          cq-on-marker-click="selectedLocation = object; infoWindow.open(marker.getMap(), marker);">
    Loading map...
</cq-map>
<div cq-info-window="infoWindow">
    <h4>{{selectedLocation.name}}</h4>
    <p>{{selectedLocation.address}}</p>
</div>