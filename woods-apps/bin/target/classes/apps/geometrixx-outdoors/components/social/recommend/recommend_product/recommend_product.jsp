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
%><%@ page contentType="text/html; charset=utf-8" import="
    com.adobe.cq.commerce.api.CommerceService,
    com.adobe.cq.commerce.api.CommerceSession,
    com.adobe.cq.commerce.api.Product,
    com.adobe.cq.commerce.common.CommerceHelper,
    com.day.cq.wcm.api.WCMMode,
    com.day.cq.wcm.api.components.DropTarget"
%><%

    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "product";

    String path = properties.get("./path", String.class);
    Page productPage = path != null ? pageManager.getPage(path) : null;
    Product product = productPage != null ? CommerceHelper.findCurrentProduct(productPage) : null;

    if (product != null) {
        String title = product.getTitle();
        String description = product.getDescription();

        String imagePath = product.getImageUrl();
        if (imagePath.indexOf(".") == -1) {
            imagePath += ".banner.jpg";
        }

        CommerceService commerceService = productPage.adaptTo(CommerceService.class);
        CommerceSession commerceSession = commerceService.login(slingRequest, slingResponse);
        String price = commerceSession.getProductPrice(product);
%>
        <a href="<%= xssAPI.getValidHref(path) %>.html">
            <img src="<%= xssAPI.getValidHref(imagePath) %>" width="146" height="146" alt="" />
            <div class="description">
                <p><span><%= xssAPI.encodeForHTML(title) %></span> <strong><%= xssAPI.encodeForHTML(price) %></strong></p>
                <span class="bg"></span>
            </div>
            <span class="inset-shadow"></span>
        </a>
        <script>
            jQuery(function($) {
                var isMobile = $("body").is(".page-mobile");
                $(".recommend_product:last").closest(".campaign").addClass(isMobile ? "campaign-products-mobile" : "campaign-products");
            });
        </script>
<%

    } else {
        if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
            %><p><img src="/libs/cq/ui/resources/0.gif" class="cq-reference-placeholder <%= ddClassName %>" alt=""></p><%
        }
    }

%>
