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
%>
<form ng-controller="AppSettingsFormController" name="appSettings" ng-submit="submit()">

    <div ng-show="settingsUpdateComplete" class="feedback" >
        <%= i18n.get("Settings updated successfully") %>
    </div>

    <label class="topcoat-list__header" for="appVersion"><%= i18n.get("Version") %>:</label>

    <div class="formContent">
        <input ng-model="appVersion" type="text" disabled class="topcoat-text-input" />
    </div>

    <label class="topcoat-list__header" for="serverURL"><%= i18n.get("Content Update Server URL") %>:</label>

    <div class="formContent">
        <input ng-model="serverURL" type="url" class="topcoat-text-input" />
    
        <button ng-disabled="appSettings.$pristine" class="topcoat-button--cta" type="submit" ><%= i18n.get("Save") %></button>
    </div>
</form>