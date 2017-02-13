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
%><%@include file="/libs/foundation/global.jsp" %><%
%><%@ page session="false"
			import="com.adobe.cq.mobile.angular.data.util.FrameworkContentExporterUtils,
			        com.day.cq.wcm.api.WCMMode" %>
<%
    // Set attributes to be consumed by template.jsp
    boolean wcmMode = WCMMode.fromRequest(request) != WCMMode.DISABLED;
    request.setAttribute("wcmMode", wcmMode);

    // In edit mode, links must point directly to the page.
    // Otherwise, they should be in the form `#/path/to/page`
    String hrefPrefix = (wcmMode) ? "" : "#";
    String hrefSuffix = (wcmMode) ? ".html" : "";
    request.setAttribute("hrefPrefix", hrefPrefix);
    request.setAttribute("hrefSuffix", hrefSuffix);

    // Controller for this component
    request.setAttribute("componentDataPath", FrameworkContentExporterUtils.getJsFriendlyResourceName(resource.getPath()));
%>