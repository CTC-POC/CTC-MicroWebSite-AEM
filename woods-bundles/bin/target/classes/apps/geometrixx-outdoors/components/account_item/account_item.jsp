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
    com.adobe.granite.security.user.UserProperties,
    org.apache.commons.lang.StringUtils,
    java.util.List,
    java.util.Arrays,
    java.util.LinkedList,
    com.day.cq.wcm.mobile.api.device.DeviceGroup,
    com.day.cq.wcm.mobile.api.device.DeviceGroupList"
%><%

    String title = GeoHelper.getTitle(resource, currentPage);
    String link  = properties.get("href", String.class);
    String description = properties.get("jcr:description", String.class);

    if (link != null) {
        if (link.contains("${profile.path}")) {
            final UserProperties userProperties = slingRequest.getResourceResolver().adaptTo(UserProperties.class);
            link = link.replace("${profile.path}", userProperties.getNode().getPath());
        }

        //
        // Determine a list of selectors which should be added to url:
        //
        DeviceGroupList deviceGroups = currentPage.adaptTo(DeviceGroupList.class);
        String deviceSelectors = "";
        if (deviceGroups != null) {
            List<String> selectors = Arrays.asList(slingRequest.getRequestPathInfo().getSelectors());
            List<String> deviceGroupList = new LinkedList<String>();

            if (selectors.size() > 0) {
                for (final DeviceGroup group : deviceGroups) {
                    String groupName = group.getName();

                    if ((groupName != null) && selectors.contains(groupName)) {
                        deviceGroupList.add(group.getName());
                    }
                }
            }

            if (deviceGroupList.size() > 0) {
                deviceSelectors = "." + StringUtils.join(deviceGroupList, ".");
            }
        }
        if (deviceSelectors.length() > 0) {
            link = link.replaceFirst("\\.html", deviceSelectors + ".html");
        }
    }

%>
<table class="account-item">
    <tr>
        <td class="item"><a href="<%= xssAPI.getValidHref(link) %>"><h3><%= xssAPI.encodeForHTML(title) %></h3></a></td>
        <td class="description"><%= xssAPI.encodeForHTML(description) %></td>
    </tr>
</table>
