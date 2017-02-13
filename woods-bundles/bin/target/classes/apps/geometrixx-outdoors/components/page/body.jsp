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
%><%@ page contentType="text/html; charset=utf-8" import="com.adobe.cq.commerce.api.CommerceService,
            com.day.cq.wcm.commons.WCMUtils, org.apache.commons.lang.StringUtils,
            com.adobe.cq.commerce.api.CommerceConstants" %><%

    final String className = component.getProperties().get("className", "");
    boolean online = true;

    final CommerceService commerceService = resource.adaptTo(CommerceService.class);
    if (commerceService == null || !commerceService.isAvailable(CommerceConstants.SERVICE_COMMERCE)) {
        final String offlinePage = WCMUtils.getInheritedProperty(currentPage, resourceResolver, "cq:offlinePage");
        if (StringUtils.isNotEmpty(offlinePage) && !offlinePage.equals(currentPage.getPath())) {
            response.sendRedirect(response.encodeRedirectURL(resourceResolver.map(offlinePage) + ".html"));
            online = false;
        }
    }

    if (online) { %>
        <body class="<%= xssAPI.encodeForHTMLAttr(className) %>">
            <cq:include path="clientcontext" resourceType="cq/personalization/components/clientcontext_optimized"/>
            <div class="page-header-content">
                <cq:include script="header.jsp"/>
			</div>
            <div id="main" class="page-main">
                <cq:include script="main.jsp"/>
            </div>
            <cq:include path="timing" resourceType="foundation/components/timing"/>
            <cq:include path="cloudservices" resourceType="cq/cloudserviceconfigs/components/servicecomponents"/>
        </body>
    <% }

%>
