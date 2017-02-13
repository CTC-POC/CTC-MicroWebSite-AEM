<%--

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

  ==============================================================================

  Script to display an error message on a page when the cookie based cart store overflows.

--%><%
%><%@ page import="
    com.adobe.cq.commerce.common.AbstractJcrCommerceSession,
    com.day.cq.i18n.I18n" %><%
%><%@ include file="/libs/foundation/global.jsp" %><%
%><%
    boolean error = AbstractJcrCommerceSession.hasCookieOverflow(slingRequest, slingResponse);
    if (error) {
        final I18n i18n = new I18n(slingRequest);
%>    <script>
            $(window).load(function(){
                window.alert('<%=i18n.get("The cart store is full. The shopping cart was not updated.")%>');
            });
        </script><%
    }
%>