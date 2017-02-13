<%@page session="false"%><%--
  ADOBE CONFIDENTIAL

  Copyright 2012 Adobe Systems Incorporated
  All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and may be covered by U.S. and Foreign Patents,
  patents in process, and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.
--%>
<%@include file="/libs/social/commons/commons.jsp" %><%
%><%@ page import="java.util.List,
                   java.util.Map,
                   java.util.LinkedHashMap,
                   com.adobe.granite.security.user.UserProperties,
                   com.adobe.granite.security.user.UserPropertiesManager,
                   com.adobe.granite.security.user.UserPropertiesService,
                   com.day.cq.wcm.foundation.forms.FormsHelper" %><%
    final UserPropertiesService userPropertiesService  = sling.getService(UserPropertiesService.class);
    final UserPropertiesManager upm = userPropertiesService.createUserPropertiesManager(resourceResolver);
    List<Resource> resources = FormsHelper.getFormEditResources(slingRequest);
    if (resources != null && resources.size() > 0) {
        Resource userResource = resources.get(0);
        String authID = userResource != null ? upm.getUserProperties(userResource.adaptTo(Node.class)).getAuthorizableID() : "";//ID of user whose profile is being viewed
        UserProperties userProperties = slingRequest.getResourceResolver().adaptTo(UserProperties.class); //user properties of logged in user
        if( authID.equals(userProperties.getAuthorizableID())) {
            Object linkObject = properties.get("links");
            Map<String, String> links = new LinkedHashMap<String, String>();
            if (linkObject instanceof String) {
                String [] array = ((String)linkObject).split("=");
                links.put(array[0], array[1].startsWith("/") ? array[1] : "/" + array[1]);
            } else if (linkObject instanceof Object []) {
                for (Object entry : (Object [])linkObject) {
                    String [] array = ((String)entry).split("=");
                    links.put(array[0], array[1].startsWith("/") ? array[1] : "/" + array[1]);
                }
            }
            String linkPrefix = userProperties.getNode().getPath() + ".form.html";%>
            <div class="profileLinkProviderDiv"><%
                for (Map.Entry<String, String> entry : links.entrySet()) {%>
                    <div class="profileLinkDiv">
                        <a href="<%=linkPrefix+entry.getValue()%>"><%=i18n.get(entry.getKey())%></a>
                    </div><%
                }%>
            </div><%
        }
    }
%>