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
--%><%
%><%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" 
           import="java.util.List" %><%
%>            <footer class="topcoat-tab-bar full app-tab-bar" ng-init="selectedTab = 'tab0'">
<% 
    String[] tabBarPages = currentStyle.get("pages", new String[0]);
    for (int i = 0; i < tabBarPages.length; i++) {
        String tabId = "tab" + i;
        String tabBarPagePath = tabBarPages[i];
        Page tabBarPage = pageManager.getPage(tabBarPagePath);
%>                <label class="topcoat-tab-bar__item">
                    <input type="radio" ng-checked="selectedTab === '<%= xssAPI.encodeForJSString(tabId) %>'">
                    <button class="topcoat-tab-bar__button full icon-<%= xssAPI.encodeForHTMLAttr(tabBarPage.getName()) %>"
                            ng-click="goTab('<%= request.getContextPath() %><%= xssAPI.getValidHref(tabBarPagePath) %>',
                                    '<%= xssAPI.encodeForJSString(tabBarPage.getTitle()) %>', '<%= xssAPI.encodeForJSString(tabId) %>')">
                        <%= xssAPI.encodeForHTML(tabBarPage.getTitle()) %>
                    </button>
                </label>
<%
    }
%>
            </footer>