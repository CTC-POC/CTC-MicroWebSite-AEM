<%@ page session="false"
         import="com.day.cq.commons.jcr.JcrUtil,
         com.day.cq.wcm.api.WCMMode,
         java.util.Iterator" %><%--
--%><%@include file="/libs/foundation/global.jsp"%><%

    String xiUrl = "/etc/clientlibs/foundation/swfobject/swf/expressInstall.swf";

    // find swf
    Resource swfDir = resourceResolver.getResource("/etc/designs/geometrixx/clientlibs/flash");
    Iterator<Resource> rIter = swfDir.listChildren();
    String flashUrl = null;
    while (rIter.hasNext()) {
        Resource r = rIter.next();
        if (r.getName().startsWith("cq-flashapp-geo-parsys-")) {
            flashUrl = r.getPath();
            break;
        }
    }

    String width = properties.get("width", "600");
    String height = properties.get("height", "600");
    String flashVersion = properties.get("flashVersion", "10.2.0");
    String menu = properties.get("menu", "");
    menu = "show".equals(menu) ? "true" : "false";
    String params = "{ menu:\"" + menu + "\",wmode:\"" + xssAPI.encodeForJSString(properties.get("wmode", "opaque")) + "\"}";


    String[] attrs = properties.get("attrs", "").split(",");
    String jsAttrs = "{";
    for (int i = 0; i < attrs.length; i++) {
        // position of first colon
        int pos = attrs[i].indexOf(":");
        if (pos == -1) continue; // skip none name/value pairs
        String key = xssAPI.getValidJSToken(attrs[i].substring(0, pos), "XSS");
        String value = xssAPI.encodeForJSString(attrs[i].substring(pos+1));
        jsAttrs += (jsAttrs.length() > 1 ? ", " : "") + key + ":" + "\"" + value + "\"";
    }
    jsAttrs += "}";
    String id = JcrUtil.createValidName(resource.getPath()) + "_swf";
    id = id.replaceAll("[\\.\\-\\+]", "");

    %>
<link rel="stylesheet" type="text/css" href="/etc/clientlibs/foundation/swfhistory/history.css" />
<script src="/etc/clientlibs/foundation/swfhistory/history.js" language="javascript"></script>
<div style="border: 1px solid #ff8080">
    <div id="<%= id %>">&nbsp;</div>
</div>
<cq:includeClientLib js="cq.swfobject" />
    <script type="text/javascript">
        // create "flash component"
        var comp = CQ.wcm.FlashComponent.register({id:"<%= id %>"});

        // draw flash movie
        var flashVars = {
            currentPagePath: "<%= xssAPI.getValidHref(currentPage.getPath()) %>",
            resourcePath: "<%= xssAPI.getValidHref(resource.getPath()) %>",
            flashId: comp.flashId,
            wcmMode: "<%= WCMMode.fromRequest(request).name() %>"
        };
        var e = document.getElementById("<%= id %>");
        if (e) e.style.display = "block";
        if (window.CQ_swfobject) {
            CQ_swfobject.embedSWF(
                "<%= xssAPI.getValidHref(request.getContextPath() + flashUrl) %>",
                "<%= id %>",
                "<%= xssAPI.encodeForJSString(width) %>",
                "<%= xssAPI.encodeForJSString(height) %>",
                "<%= xssAPI.encodeForJSString(flashVersion) %>",
                "<%= request.getContextPath() + xiUrl %>",
                flashVars,
                <%= params %>,
                <%= jsAttrs %>
            );
        }

    </script>
