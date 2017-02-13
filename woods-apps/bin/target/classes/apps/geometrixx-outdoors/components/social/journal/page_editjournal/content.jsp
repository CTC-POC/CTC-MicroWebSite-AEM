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
%><%@ page import="java.security.AccessControlException,
                    java.util.List,
                    org.apache.sling.api.SlingHttpServletRequest,
                    com.day.cq.security.profile.Profile,
                    com.day.cq.i18n.I18n,
                    com.day.text.Text,
                    com.day.cq.wcm.foundation.forms.FormsHelper,
                    com.adobe.cq.social.commons.CollabUtil,
                    com.adobe.cq.social.journal.Journal,
                    com.adobe.cq.social.journal.JournalEntry,
                    com.adobe.cq.social.journal.JournalManager,
                    com.adobe.cq.social.journal.JournalUtil" %><%
%><%@include file="/libs/foundation/global.jsp" %><%

    JournalManager journalMgr = resource.getResourceResolver().adaptTo(JournalManager.class);
    //JournalEntry entry = journalMgr.getJournalEntry(slingRequest, resource.getPath());
    JournalEntry entry = null;
    final List<Resource> editResources = FormsHelper.getFormEditResources(slingRequest);
    if (null != editResources && editResources.size() > 0) {
        String entryPath = editResources.get(0).getPath();
        entry = journalMgr.getJournalEntry(slingRequest, entryPath );
    }
    String authorizable = "";

    // force login if user has no create permission on journal page
    try {
        if(entry!=null && !CollabUtil.hasModeratePermissions(entry.getTextComment().getResource()) && !CollabUtil.isResourceOwner(entry.getTextComment().getResource())){
            throw new AccessControlException("user has no permission to create journal.");
        }

        // draw entry form
        %>
        <%
    } catch (AccessControlException ace) {

        %>
          <h3 style="margin-left:40px"><%= I18n.get(slingRequest.getResourceBundle(currentPage.getLanguage(true)), "Edit journal Form: access denied. Please ") %>
          <a style="text-decoration:underline; color:#06c;" onclick="$CQ.SocialAuth.sociallogin.showDialog('sociallogin-content-geometrixx-outdoors-en-support-jcr-content-userinfo-sociallogin');return false;"><%= I18n.get(slingRequest.getResourceBundle(currentPage.getLanguage(true)), "Log In") %></a>
          </h3><p/><%
    }
%>
