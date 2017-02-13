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
           import="com.day.cq.commons.Externalizer,
                   com.adobe.cq.mobile.angular.data.util.FrameworkContentExporterUtils,
                   com.day.cq.wcm.api.Page"%><%
%><%@include file="/libs/foundation/global.jsp" %><%
%><%
    // Controller for this component
    String locationURI = "";
    String locationPath = properties.get("./locations", "");
    if (locationPath.length() > 0) {
        locationURI = locationPath + ".json";
        Externalizer externalizer = sling.getService(Externalizer.class);
        locationURI = externalizer.publishLink(resource.getResourceResolver(), locationURI);
        // Replace localhost with server name if applicable
        if (locationURI.startsWith( "http://localhost" ) || locationURI.startsWith( "https://localhost" )) {
            String serverName = request.getServerName();
            if (serverName != null) {
                locationURI = locationURI.replaceFirst("localhost", serverName);
            }
        }
    }

    pageContext.setAttribute("locationURI", locationURI);
    pageContext.setAttribute("offline", properties.get("./offline", false));
    pageContext.setAttribute("height", properties.get("./height", ""));

    String componentPath = FrameworkContentExporterUtils.getRelativeComponentPath(resource.getPath());
    pageContext.setAttribute("componentPath", componentPath);
    pageContext.setAttribute("componentDataPath", FrameworkContentExporterUtils.getJsFriendlyResourceName(componentPath));

    slingResponse.setContentType("application/javascript");
%>
    /* Location component properties to be accessed by child controller */
    /* <c:out value='${resource.name}'/> component controller (path: <c:out value='${componentPath}'/>) */
    $scope.<c:out value="${componentDataPath}"/> = {
        locationURI: "<c:out value="${locationURI}"/>",
        offline: <c:out value="${offline}"/>,
        mapHeight: "<c:out value="${height}"/>"
    };
    data.then(function(response) {
        $scope.<c:out value="${componentDataPath}"/>.locations = response.data["<c:out value='${componentPath}'/>"].items;
    });
