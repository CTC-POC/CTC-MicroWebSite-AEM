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

  ==============================================================================

  Blog: Content script (included by body.jsp)

  ==============================================================================

--%><%@ page import="com.adobe.cq.social.blog.Blog,
                     com.adobe.cq.social.blog.BlogManager,
                     com.adobe.cq.social.blog.BlogEntry"
   %><%
%><%@include file="/libs/foundation/global.jsp" %>
<%@include file="/libs/social/commons/commons.jsp" %><cq:include path="journal" resourceType="social/journal/components/hbs/journal"/>
