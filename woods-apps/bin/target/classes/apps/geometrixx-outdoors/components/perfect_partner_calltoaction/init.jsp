<%@page session="false"%><%--
  ADOBE CONFIDENTIAL
  __________________

   Copyright 2013 Adobe Systems Incorporated
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
%><%@ include file="/libs/foundation/global.jsp" %>
<%@ page import="java.text.MessageFormat,
                 java.util.HashMap,
                 java.util.Map,
                 com.adobe.cq.commerce.api.CommerceService,
                 com.adobe.cq.commerce.api.CommerceSession,
                 com.adobe.cq.commerce.api.Product,
                 com.adobe.cq.commerce.api.promotion.Promotion,
                 com.adobe.cq.commerce.api.promotion.PromotionHandler,
                 com.adobe.cq.commerce.common.AbstractJcrCommerceSession,
                 com.adobe.cq.commerce.common.CommerceHelper,
                 com.day.cq.i18n.I18n,
                 com.day.cq.wcm.api.WCMMode,
                 com.day.cq.commons.ImageResource,
                 info.geometrixx.commons.PerfectPartnerPromotionHandler" %><%

    I18n i18n = new I18n(slingRequest);

    String message = (String)request.getAttribute("message");

    if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
        String heading = (String)request.getAttribute("heading");
        if (heading.length() == 0) {
            heading = i18n.get("Perfect Partner Call to Action");
        }
        request.setAttribute("heading", heading);

        String referenceTitle = "{" + i18n.get("Reference Product") + "}";
        String crossSellTitle = "{" + i18n.get("Cross-sell Product") + "}";
        message = MessageFormat.format(message, "", referenceTitle, crossSellTitle);
        request.setAttribute("message", message);

        request.setAttribute("imageUrl", "/libs/cq/ui/resources/0.gif");
        request.setAttribute("imageClass", "cq-teaser-placeholder");
    } else {
        CommerceService commerceService = resource.adaptTo(CommerceService.class);
        CommerceSession commerceSession = commerceService.login(slingRequest, slingResponse);

        Map<String, String> potentials = new HashMap<String, String>();

        if (commerceSession instanceof AbstractJcrCommerceSession) {
            java.util.List<Promotion> promos = ((AbstractJcrCommerceSession) commerceSession).getActivePromotions();
            for (Promotion p : promos) {
                PromotionHandler ph = p.adaptTo(PromotionHandler.class);
                if (ph instanceof PerfectPartnerPromotionHandler) {
                    ((PerfectPartnerPromotionHandler) ph).getPotentials(commerceSession, p, potentials);
                }
            }
        }

        if (potentials.isEmpty()) {
            request.setAttribute("hideAll", true);
            return;
        }

        String referenceProductPagePath = potentials.keySet().iterator().next();
        String crossSellProductPagePath = potentials.get(referenceProductPagePath);
        Page page1 = pageManager.getPage(referenceProductPagePath);
        Page page2 = pageManager.getPage(crossSellProductPagePath);
        Product referenceProduct = page1 != null ? CommerceHelper.findCurrentProduct(page1) : null;
        Product crossSellProduct = page2 != null ? CommerceHelper.findCurrentProduct(page2) : null;

        if (referenceProduct == null || crossSellProduct == null) {
            request.setAttribute("hideAll", true);
            return;
        }

        String referenceTitle = referenceProduct.getTitle();
        String crossSellTitle = crossSellProduct.getTitle();
        message = MessageFormat.format(message, "", referenceTitle, crossSellTitle);
        request.setAttribute("message", message);

        request.setAttribute("callToActionUrl", crossSellProductPagePath + ".html");

        // get a transparent thumbnail so we can composite it nicely over the background:
        final ImageResource productImage = crossSellProduct.getImage();
        if (productImage != null) {
            productImage.setSelector(".thumbnail.140.transparent");
            productImage.setExtension(".gif");
            request.setAttribute("imageUrl", resourceResolver.map(productImage.getHref()));
        }
    }

%>
