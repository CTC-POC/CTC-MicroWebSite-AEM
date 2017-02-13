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
--%><%
%><%@ page session="false"
        import="com.day.cq.commons.TidyJSONWriter,
                com.adobe.cq.address.api.location.LocationManager,
                com.adobe.cq.address.api.location.Location"%><%
%><%@include file="/libs/foundation/global.jsp"%><%
%><%@include file="../utils.jsp" %><%

    response.setContentType("application/json");
    response.setCharacterEncoding("utf-8");

    //
    // Return location as JSON data
    //
    TidyJSONWriter writer = new TidyJSONWriter(response.getWriter());

    writer.setTidy(true);

    LocationManager locMgr = slingRequest.getResourceResolver().adaptTo(LocationManager.class);
    Location location = locMgr.getLocation(properties.get("./location", String.class));
    writeLocation(writer, location);

    response.flushBuffer();

%>