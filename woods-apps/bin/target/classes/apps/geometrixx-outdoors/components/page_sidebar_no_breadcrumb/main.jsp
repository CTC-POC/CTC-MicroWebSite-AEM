<%@page session="false"%><%--
  ADOBE CONFIDENTIAL
  __________________

   Copyright 2012 Adobe Systems Incorporated
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
%><%@ include file="/libs/foundation/global.jsp" %><%
%><%@ page contentType="text/html; charset=utf-8" %>
<div class="page-content">
    <section class="page-par">
        <cq:include path="par" resourceType="foundation/components/parsys"/>
    </section>
    <aside class="page-aside">
        <cq:include path="sidebar" resourceType="foundation/components/parsys"/>
    </aside>
</div>
<div class="page-footer">
    <cq:include script="footer.jsp"/>
</div>
<style>
.sidebar .default li, .sidebar .default li + li, .sidebar .default li + li + li {
    text-transform: uppercase;
}
.sidebar .default li + li + li + li{
    text-transform: none;
    
}
.sidebar .default li + li + li + li + li + li + li + li h4{
    text-transform: uppercase;
    padding-left:0;
}

.sidebar .default li + li + li + li h4{
    padding-left:20px  
}
</style>