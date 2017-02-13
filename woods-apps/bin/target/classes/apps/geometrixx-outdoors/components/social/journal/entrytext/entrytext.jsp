<%--

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

  ==============================================================================

  Journal: Entry component

  ==============================================================================

--%><%@page session="false" import="java.util.ResourceBundle"%>
<%@ page import="com.adobe.cq.social.journal.Journal,
                   com.adobe.cq.social.journal.JournalEntry,
                   com.adobe.cq.social.journal.JournalManager,
                   com.day.cq.wcm.api.WCMMode,
                   java.security.AccessControlException,
                   org.apache.sling.api.resource.Resource" %><%
%><%@include file="/libs/social/commons/commons.jsp" %><%


    JournalManager journalMgr = resource.getResourceResolver().adaptTo(JournalManager.class);
    JournalEntry entry = resource.adaptTo(JournalEntry.class);

    String text = entry.getText();

    if ("".equals(text) && WCMMode.fromRequest(request) == WCMMode.EDIT) {
        %><img src="/libs/cq/ui/resources/0.gif" class="cq-text-placeholder" alt=""><%
    }

    %><%= xssAPI.filterHTML(text) %><%

    if (entry.hasAttachments()) {%>
    <ul class="entry-attachment-list">
        <%for (Resource res : entry.getAttachments()) {
            final ValueMap vm = resource.adaptTo(ValueMap.class);
            final Resource contentRes = res.getChild("jcr:content");
            String mimeType = contentRes == null ? null : contentRes.adaptTo(ValueMap.class).get("jcr:mimeType", String.class);
            if (mimeType != null && mimeType.contains("image")) {
                %>
                <li><a href="<%=xssAPI.getValidHref(res.getPath())%>"><img src="<%=res.getPath()%>.thumb.160.200.png"/></a></li>
                <%
            } else {
                %>
                <li><div class="comment-attachment"><img src="/etc/clientlibs/foundation/comments/images/documenticon.png"/><a href="<%=xssAPI.getValidHref(res.getPath())%>"><%=xssAPI.filterHTML(res.getName())%></a></div></li>
                <%}
            }
            %>
    </ul><%
    }

    if (Journal.VIEW_EDIT.equals(journalMgr.getView(request)) &&
            WCMMode.fromRequest(request) == WCMMode.EDIT) {

        // only allow editing if user has sufficient permissions
        try {
            Session session = slingRequest.getResourceResolver().adaptTo(Session.class);
            session.checkPermission(currentPage.getPath(), "set_property");

            %><script type="text/javascript">
           CQ.WCM.onEditableReady("<%= xssAPI.encodeForJSString(currentPage.getContentResource(JournalEntry.NODE_TEXT).getPath()) %>",
                function(editable) {
                    CQ.wcm.EditBase.showDialog(editable, CQ.wcm.EditBase.EDIT);
                }
            );
            </script><%
        } catch (AccessControlException ace) {
            // todo: handle insufficient permissions
        }

    }


%>
