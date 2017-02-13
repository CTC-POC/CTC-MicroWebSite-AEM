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
%><head>

    <script>
        <%-- Adds a js class to the <html> element to create custom CSS rules if JS is enabled/disabled --%>
        document.documentElement.className+=' js';
        <%-- Makes HTML5 elements listen to CSS styling in IE6-8 (aka HTML5 Shiv) - this is using the IE conditional comments feature --%>
        /*@cc_on(function(){var e=['abbr','article','aside','audio','canvas','details','figcaption','figure','footer','header','hgroup','mark','meter','nav','output','progress','section','summary','time','video'];for (var i = e.length; i-- > 0;) document.createElement(e[i]);})();@*/
    </script>
    <%-- Include jQuery as a single lib (instead of 3 separate libs, as the stats components would later do) --%>
    <cq:includeClientLib categories="apps.informa.social.jquery"/>
    <% currentDesign.writeCssIncludes(pageContext); %>
    <cq:includeClientLib categories="apps.informa.social.all"/>
    <cq:include path="config" resourceType="cq/personalization/components/clientcontext_optimized/config"/>
    <sling:include path="contexthub" resourceType="granite/contexthub/components/contexthub"/>
    <cq:include script="/libs/wcm/core/components/init/init.jsp"/>

</head>
    <cq:include path="par" resourceType="foundation/components/parsys"/>
