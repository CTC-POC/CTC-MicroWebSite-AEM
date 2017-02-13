<%@ page import="
    com.day.cq.wcm.api.WCMMode"
        %>

<%@include file="/libs/foundation/global.jsp" %>

<cq:includeClientLib categories="apps.informa.global"/>

<cq:include script="/libs/wcm/core/components/init/init.jsp"/> 
<%String pageTitle = currentPage.getTitle(); %>
<h1><%=pageTitle%></h1>
<script language="javascript" type="text/javascript">
  $(document).ready(function() {
  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });
});
</script>
<% WCMMode mode = WCMMode.fromRequest(request);
if (mode != WCMMode.PREVIEW ) 
{ %>
<cq:include path="eventSelection" resourceType="/libs/foundation/components/parsys"/>
<%}%>

<cq:include path="par" resourceType="/libs/foundation/components/parsys"/>