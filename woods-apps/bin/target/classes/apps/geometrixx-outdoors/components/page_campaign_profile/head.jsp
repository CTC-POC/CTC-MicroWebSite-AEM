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
    com.day.cq.commons.Externalizer,
    com.day.cq.wcm.api.WCMMode, info.geometrixx.commons.util.GeoHelper,
    com.day.cq.wcm.api.AuthoringUIMode"
        %><%

    final Externalizer externalizer = resourceResolver.adaptTo(Externalizer.class);

    final String title         = GeoHelper.getTitle(currentPage);
    final String canonicalURL  = externalizer.absoluteLink(slingRequest, "http", currentPage.getPath()) + ".html";
    final String favicon       = currentDesign.getPath() + "/favicon.ico";
    final boolean hasFavIcon   = (resourceResolver.getResource(favicon) != null);
    final String keywords      = WCMUtils.getKeywords(currentPage);
    final String description   = currentPage.getDescription();

%><head>
    <meta charset="utf-8" />
    <meta id="campaignContextHub" data-register="true" />
    <title><%= xssAPI.encodeForHTML(title) %></title>
    <link rel="canonical" href="<%= xssAPI.getValidHref(canonicalURL) %>" />
    <% if (hasFavIcon) { %><link rel="shortcut icon" href="<%= xssAPI.getValidHref(favicon) %>" /><% } %>
    <% if (GeoHelper.notEmpty(keywords)) { %><meta name="keywords" content="<%= xssAPI.encodeForHTMLAttr(keywords) %>" /><% } %>
    <% if (GeoHelper.notEmpty(description)) { %><meta name="description" content="<%= xssAPI.encodeForHTMLAttr(description) %>" /><% } %>
    <script>
        <%-- Adds a js class to the <html> element to create custom CSS rules if JS is enabled/disabled --%>
        document.documentElement.className+=' js';
        <%-- Makes HTML5 elements listen to CSS styling in IE6-8 (aka HTML5 Shiv) - this is using the IE conditional comments feature --%>
        /*@cc_on(function(){var e=['abbr','article','aside','audio','canvas','details','figcaption','figure','footer','header','hgroup','mark','meter','nav','output','progress','section','summary','time','video'];for (var i = e.length; i-- > 0;) document.createElement(e[i]);})();@*/
    </script>
    <cq:include script="/libs/wcm/core/components/init/init.jsp"/>
    <%-- Include jQuery as a single lib (instead of 3 separate libs, as the stats components would later do) --%>
    <cq:includeClientLib categories="apps.geometrixx-outdoors.jquery"/>
    <% currentDesign.writeCssIncludes(pageContext); %>
    <cq:includeClientLib categories="apps.geometrixx-outdoors.desktop.all"/>
    <%
        if (AuthoringUIMode.CLASSIC.equals(AuthoringUIMode.fromRequest(slingRequest))) {
            if (WCMMode.fromRequest(request) != WCMMode.DISABLED) {
                %><cq:includeClientLib categories="mcm.campaign.ui.classic"/><%
            }
            %><cq:include path="config" resourceType="cq/personalization/components/clientcontext_optimized/config"/><%
        } else {
            %><script type="text/javascript">
                // the geometrixx-outdoors clientlib sets this variable even though
                // ClientContext is not included in the page, which causes problems
                delete window.ClientContext;
            </script>
            <sling:include path="contexthub" resourceType="granite/contexthub/components/contexthub"/><%
        }
    %>
    <cq:include script="stats_legacy.jsp"/>
    <cq:include script="/libs/cq/cloudserviceconfigs/components/servicelibs/servicelibs.jsp"/>
    <cq:include script="init.jsp"/>
</head>
