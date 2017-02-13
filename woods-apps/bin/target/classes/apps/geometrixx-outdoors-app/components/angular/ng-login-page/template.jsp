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
%><%@ page session="false"
           import="com.day.cq.i18n.I18n"  %><%
%><%@include file="/libs/foundation/global.jsp"%><%
    I18n i18n = new I18n(slingRequest);
    final String homePagePath = "/content/phonegap/geometrixx-outdoors/en/home";
%>
<cq:include path="navigation" resourceType="geometrixx-outdoors-app/components/angular/ng-navigationbar"/>
<div class="page-content ng-login-page" ng-controller="LoginPageFormController">
    <header>
        <h2><%= i18n.get("Login") %></h2>
    </header>
    <section class="login">
        <input type="text" class="topcoat-text-input" ng-model="username" placeholder="<%= i18n.get("username") %>" autocorrect="off" autocapitalize="none">
        <br>
        <br>
        <input type="password" class="topcoat-text-input" ng-model="password" placeholder="<%= i18n.get("password") %>">
        <p class="error" ng-show="errorMessage">{{errorMessage}}</p>
        <br>
        <br>
        <button class="topcoat-button--cta" ng-click="login('<%= request.getContextPath() %><%= xssAPI.getValidHref(homePagePath) %>', '<%= i18n.get("Home") %>')"><%= i18n.get("Login") %></button>
    </section>
</div>