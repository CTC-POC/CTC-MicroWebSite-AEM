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
                com.adobe.cq.address.api.location.Location,
                com.adobe.cq.address.api.location.Coordinates,
                org.apache.sling.commons.json.JSONException,
                org.apache.commons.lang3.StringUtils"%><%
%><%!
    public void writeLocation(final TidyJSONWriter writer, final Location location) throws JSONException {
        writer.object();
        if (location != null) {
            writer.key("path").value(location.getPath());
            writer.key("name").value(location.getTitle());
            writer.key("description").value(location.getDescription());
            if (location.getCoordinates() != null) {
                writeCoordinates(writer, location.getCoordinates());
            }
            String address = location.getFullAddress();
            address = address.replaceAll(System.getProperty("line.separator"), " ").trim();
            writer.key("address").value(address);
            writer.key("phone").value(location.getPhone());
            writer.key("hours").array();
            writeHours(writer, location.getHours());
            writer.endArray();
        }
        writer.endObject();
    }

    private void writeHours(final TidyJSONWriter writer, final String[] hours) throws JSONException {
        if (hours == null) return;
        for (String hour : hours) {
            if (StringUtils.isBlank(hour)) {
                continue;
            }
            writer.value(hour);
        }
    }

    private void writeCoordinates(final TidyJSONWriter writer, final Coordinates coords) throws JSONException {
        writer.key("coordinates").object();
        writer.key("lat").value(coords.getLat());
        writer.key("lng").value(coords.getLng());
        writer.endObject();
    }
%>