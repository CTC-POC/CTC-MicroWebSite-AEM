<%@page import="com.cognifide.zg.webapp.commons.impl.widgets.multifield.CompositeSectionModel" %>
<%@include file="/libs/foundation/global.jsp"%>
<div>
    <%
		CompositeSectionModel model = new CompositeSectionModel(resource, slingRequest);
		pageContext.setAttribute("model", model);
	%>
	<c:forEach items="${model.valueMap}" var="item">
		<c:set var="granite.ui.form.values" value="${item.value}" scope="request" />
		<sling:include resource="${item.key}" />
		<c:set var="granite.ui.form.values" value="${model.original}" scope="request" />
	</c:forEach>
</div>