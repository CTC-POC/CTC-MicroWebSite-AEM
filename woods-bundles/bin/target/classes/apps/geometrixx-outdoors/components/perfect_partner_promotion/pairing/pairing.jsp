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
%><%@page contentType="text/html" pageEncoding="utf-8" import="
      com.adobe.cq.commerce.api.Product,
      com.day.cq.wcm.api.WCMMode,
      com.day.cq.wcm.api.components.DropTarget,
      com.day.cq.i18n.I18n,
      com.adobe.cq.commerce.common.CommerceHelper" %><%
%><%@include file="/libs/foundation/global.jsp"%><%
    I18n i18n = new I18n(slingRequest);

    String path1 = properties.get("firstProductPath", String.class);
    Page page1 = path1 != null ? pageManager.getPage(path1) : null;
    Product prod1 = page1 != null ? CommerceHelper.findCurrentProduct(page1) : null;

    String path2 = properties.get("secondProductPath", String.class);
    Page page2 = path2 != null ? pageManager.getPage(path2) : null;
    Product prod2 = page2 != null ? CommerceHelper.findCurrentProduct(page2) : null;

    %>
<li><div class="product-pairing-label"><%= i18n.get("Pairing: ") %></div>
    <div class="<%= DropTarget.CSS_CLASS_PREFIX %>firstproduct li-bullet product-pairing first"> <%
        if (prod1 != null) { %>
            <img src="<%= xssAPI.getValidHref(prod1.getThumbnailUrl(80)) %>" width="80" height="60" alt="<%= xssAPI.encodeForHTMLAttr(prod1.getTitle()) %>"/>
            <div>
                <strong><%= xssAPI.encodeForHTML(prod1.getTitle()) %></strong><br/>
                <%= xssAPI.encodeForHTML(prod1.getSKU()) %>
            </div> <%
        } else if (WCMMode.fromRequest(request) != WCMMode.DISABLED) {
            if (path2 != null) { %>
            <img src="/libs/cq/ui/resources/0.gif" class="cq-product-not-found" alt=""> <div  class="cq-product-not-found"><%= i18n.get("Catalog page not found.") %></div> <%
            } else { %>
            <img src="/libs/cq/ui/resources/0.gif" class="cq-reference-placeholder" alt=""> <%
            }
        } %>
    </div>
    <div class="<%= DropTarget.CSS_CLASS_PREFIX %>secondproduct li-bullet product-pairing second"> <%
        if (prod2 != null) { %>
            <img src="<%= xssAPI.getValidHref(prod2.getThumbnailUrl(80)) %>" width="80" height="60" alt="<%= xssAPI.encodeForHTMLAttr(prod2.getTitle()) %>"/>
            <div>
                <strong><%= xssAPI.encodeForHTML(prod2.getTitle()) %></strong><br/>
                <%= xssAPI.encodeForHTML(prod2.getSKU()) %>
            </div> <%
        } else if (WCMMode.fromRequest(request) != WCMMode.DISABLED) {
            if (path2 != null) { %>
        <img src="/libs/cq/ui/resources/0.gif" class="cq-product-not-found" alt=""> <div  class="cq-product-not-found"><%= i18n.get("Catalog page not found.") %></div> <%
        } else { %>
            <img src="/libs/cq/ui/resources/0.gif" class="cq-reference-placeholder" alt=""> <%
            }
        } %>
    </div>
</li>
