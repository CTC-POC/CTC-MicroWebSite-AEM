<%--
  Copyright 1997-2010 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Top Navigation component include.

--%><%@page session="false"
            contentType="text/html"
            pageEncoding="utf-8" %><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><cq:defineObjects /><%

    %><cq:include path="topnav" resourceType="geometrixx/components/topnav"/><%

    // we get the last modification date of the page to help browser caching
    response.setDateHeader("Last-Modified", currentPage.getLastModified().getTimeInMillis());
%>