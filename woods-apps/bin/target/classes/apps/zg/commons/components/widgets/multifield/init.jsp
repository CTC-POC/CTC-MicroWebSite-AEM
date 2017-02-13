<%@page import="com.cognifide.zg.webapp.commons.impl.widgets.multifield.MultifieldModel" %>
<%@include file="/libs/foundation/global.jsp"%>
<%
	MultifieldModel model = new MultifieldModel(resource, slingRequest);
	pageContext.setAttribute("model", model, PageContext.REQUEST_SCOPE);
%>