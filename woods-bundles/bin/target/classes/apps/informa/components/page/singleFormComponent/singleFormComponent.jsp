<%@ page import="
    com.day.cq.wcm.api.WCMMode"
        %>

<%@include file="/libs/foundation/global.jsp" %>

<cq:include script="/libs/wcm/core/components/init/init.jsp"/> 
<%String pageTitle = currentPage.getTitle(); %>
<h1><%=pageTitle%></h1>

<% WCMMode mode = WCMMode.fromRequest(request);
if (mode != WCMMode.PREVIEW ) 
{ %>
<cq:include path="eventSelection" resourceType="/libs/foundation/components/parsys"/>
<%}%>

<cq:include path="par" resourceType="/libs/foundation/components/parsys"/>