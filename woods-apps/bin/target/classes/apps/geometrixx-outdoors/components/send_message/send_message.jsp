<%@page session="false"%><%--

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
%><%@include file="/libs/social/commons/commons.jsp"%><%
%><%@ page import="java.util.List,
                    com.day.cq.personalization.UserPropertiesUtil,
                    com.day.cq.security.Authorizable,
                    com.day.cq.wcm.foundation.forms.FormsHelper,
                    com.adobe.granite.security.user.UserPropertiesManager,
                    com.adobe.granite.security.user.UserPropertiesService,
                    com.adobe.granite.security.user.UserProperties" %><%
%><%

    final UserPropertiesService userPropertiesService  = sling.getService(UserPropertiesService.class);
    final UserPropertiesManager upm = userPropertiesService.createUserPropertiesManager(resourceResolver);
    final boolean isAnonymousSession = UserPropertiesUtil.isAnonymous(slingRequest);
    List<Resource> resources = FormsHelper.getFormEditResources(slingRequest);
    String authorPath = "";
    if (resources != null && resources.size() > 0) {
        Resource userResource = resources.get(0);
        authorPath = userResource.getPath();
    }
	final String composeMessagePagePath = WCMUtils.getInheritedProperty(currentPage, resourceResolver, "cq:composeMessagePage");

    if(!isAnonymousSession) {
        %><input type="button" class="submitButton" onclick="location.href='<%= xssAPI.getValidHref(composeMessagePagePath)%>.html?topath=<%=authorPath%>'"  value="<%=i18n.get("Message")%>"
          ></input>
 <% } %>
