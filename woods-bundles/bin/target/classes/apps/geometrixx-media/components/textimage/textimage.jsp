<%--
  ADOBE CONFIDENTIAL
  __________________

   Copyright 2015 Adobe Systems Incorporated
   All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.
--%>
<%@include file="/apps/geometrixx-media/global.jsp"%><%
%><%@ page session="false" %><%
    String authorNameXss = xssAPI.encodeForHTML(properties.get("author", ""));
    String authorPositionXss = xssAPI.encodeForHTML(properties.get("position", ""));
    String authorCompanyXss = xssAPI.encodeForHTML (properties.get("company", ""));
    String imageReferenceXss = xssAPI.getValidHref(properties.get("image/fileReference", "http://placehold.it/100x100"));
%>
<div class="welcome-author clearfix">
    <img src="<%= imageReferenceXss %>">
    <div class="welcome-author-name">
        <h5><%= authorNameXss %></h5>
        <p>
            <div class="author-position"><%= authorPositionXss %></div><br>
            <%= authorCompanyXss %>
        </p>
</div>
</div>
