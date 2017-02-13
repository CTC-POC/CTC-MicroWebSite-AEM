<%@include file="/apps/geometrixx-media/global.jsp"%><%
%><%@ page session="false" %>
<div class="section-title clearfix">
    <p><%= properties.get("header", "welcome") %></p>
</div>
<div class="welcome-message">
    <cq:text property="message" />
    <cq:include path="<%= currentNode.getPath() %>" resourceType="/apps/geometrixx-media/components/textimage" />
</div>