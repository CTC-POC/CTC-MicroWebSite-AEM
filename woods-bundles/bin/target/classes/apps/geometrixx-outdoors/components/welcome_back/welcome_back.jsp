<%@page session="false"%><%--
  ADOBE CONFIDENTIAL
  __________________

   Copyright 2014 Adobe Systems Incorporated
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

    String message = properties.get("message", "");
    String defaultMessage = properties.get("defaultMessage", "");

    String idScopingSuffix = resource.getPath().replaceAll("/","-").replaceAll(":","-");
    String componentId = "component-" + idScopingSuffix;
    String messageId = "message-" + idScopingSuffix;

%>
<script type="text/javascript">
    $CQ(function() {
        function doUpdate() {
            var show = true;
            var m = document.getElementById("<%= xssAPI.encodeForJSString(messageId) %>");
            if (m) {
                var name = null;
                var abandoned = null;

                if (window.ContextHub && ContextHub.getStore("profile")) {
                    name = ContextHub.getStore("profile").getItem("givenName");
                }

                if (window.ContextHub && ContextHub.getStore("abandonedproducts")) {
                    var recent = ContextHub.getStore("abandonedproducts").recent(1, true);
                    if (recent && recent.length > 0) {
                        abandoned = recent[0].title;
                    }
                }

                if (name && name.length > 0 && abandoned && abandoned.length > 0) {
                    m.innerHTML = "<%= xssAPI.encodeForJSString(message) %>".replace(/\{1\}/g, name).replace(/\{2\}/g, abandoned);
                } else if (name && name.length) {
                    m.innerHTML = "<%= xssAPI.encodeForJSString(defaultMessage) %>".replace(/\{1\}/g, name);
                } else {
                    show = false;
                }
            }
            $CQ("#<%= xssAPI.encodeForJSString(componentId) %>").toggle(show);
        }

        $CQ(document).ready(function() {
            doUpdate();

            if (window.ContextHub) {
                ContextHub.eventing.on(ContextHub.Constants.EVENT_STORE_UPDATED + ":profile", function(event, data) {
                    doUpdate();
                });
                ContextHub.eventing.on(ContextHub.Constants.EVENT_STORE_UPDATED + ":abandonedproducts", function(event, data) {
                    doUpdate();
                });
            }
        });
    });
</script>
<div id="<%= xssAPI.encodeForHTMLAttr(componentId) %>" class="geometrixx-welcome" style="display: none">
    <p class="message" id="<%= xssAPI.encodeForHTMLAttr(messageId) %>"><%= xssAPI.encodeForHTML(message) %></p>
</div>
