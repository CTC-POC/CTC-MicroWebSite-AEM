<%@page session="false"%><%--
  ADOBE CONFIDENTIAL
  __________________

   Copyright 2012 Adobe Systems Incorporated
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
%><%@ include file="/libs/foundation/global.jsp" %><%
%><%@ page contentType="text/html; charset=utf-8" import="
        info.geometrixx.commons.util.GeoHelper,
        com.adobe.cq.commerce.api.CommerceService,
        com.adobe.cq.commerce.api.CommerceSession,
        com.day.cq.i18n.I18n,
        java.util.Map,
        java.util.ResourceBundle,
        java.util.Locale"
%><%!

    String mapTagName(String type) {
        if (type.toLowerCase().equals("small"))  return "h3";
        if (type.toLowerCase().equals("medium")) return "h2";
        if (type.toLowerCase().equals("large"))  return "h1";
        else                                     return "h1";
    }

%><%
    final Locale pageLocale = currentPage.getLanguage(false);
    final ResourceBundle bundle = slingRequest.getResourceBundle(pageLocale);
    final I18n i18n = new I18n(bundle);

    CommerceService commerceService = resource.adaptTo(CommerceService.class);
    CommerceSession session = commerceService.login(slingRequest, slingResponse);

    String orderId = slingRequest.getParameter("orderId");

    Map<String, Object> orderDetails = session.getPlacedOrder(orderId).getOrder();
    final String title = i18n.get(
            "Order placed {0}; current status: {1}",
            "hint: order status",
            (String) orderDetails.get("orderPlacedFormatted"),
            (String) orderDetails.get("orderStatus"));

    final String trackingNumber =  (String) orderDetails.get("trackingNumber");
    final String trackingUrl = (String) orderDetails.get("trackingUrl");

    final String type  = properties.get("type", currentStyle.get("defaultType", "large"));
    final String link  = properties.get("href", String.class);
    final String css = properties.get("css", "");

%>
<% if (GeoHelper.notEmpty(link)) { %><a href="<%= xssAPI.getValidHref(link) %>"><% } %>
    <cq:text value="<%= title %>" tagName="<%= mapTagName(type) %>" tagClass="<%= css %>" escapeXml="true"/>
<% if (GeoHelper.notEmpty(link)) { %></a><% } %>
<% if (GeoHelper.notEmpty(trackingNumber)) { %>
    <p><%= i18n.get("Tracking number: ") %><a href="<%= xssAPI.getValidHref(trackingUrl) %>"><%= trackingNumber %></a></p>
<% } %>
