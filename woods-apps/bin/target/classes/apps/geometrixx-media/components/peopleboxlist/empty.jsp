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

 People List component sub-script

--%><%@ page session="false" import="com.day.cq.wcm.api.WCMMode,
                                     com.day.cq.i18n.I18n,
                                     com.day.cq.wcm.foundation.Placeholder"%><%
%><%@include file="/libs/foundation/global.jsp"%>
<%
    final I18n i18n = new I18n(slingRequest);
    if (WCMMode.fromRequest(slingRequest) == WCMMode.EDIT){
        if (Placeholder.isAuthoringUIModeTouch(slingRequest)) {
            %><%= Placeholder.getDefaultPlaceholder(slingRequest, i18n.get("Empty People Box List"), "", "cq-list-placeholder") %><%
        } else {
            %><img src="/libs/cq/ui/resources/0.gif" class="cq-list-placeholder" alt=""><%
        }
    } else {
        %><div class="error"><p><%= i18n.get("No people in List") %></p></div><%
    }

%>
