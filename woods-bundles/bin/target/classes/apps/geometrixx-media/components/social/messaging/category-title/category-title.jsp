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
%><%@include file="/apps/geometrixx-media/global.jsp" %><%
%><%@page session="false"%><%
    ValueMap vm = currentPage.getProperties();
    String title = vm.get("jcr:title", "");
    String subtitle = vm.get("subtitle", "");
%>

<div class="row-fluid title-and-navigation-div">
    <div class="span8 title messaging-page-title"><%= xssAPI.encodeForHTML(title) %>
        <span class="navigation-menu-link"><%=i18n.get("Navigate ")%><i class="icon-chevron-down icon-white"></i></span>
    </div>
    <div class="messagebox-navigation-menu-top">
        <cq:include path="../grid-2-par" resourceType="wcm/foundation/components/responsivegrid" />
    </div>
</div>
<div class="row-fluid">
    <hr class="span12 stripeHr"/>
</div>