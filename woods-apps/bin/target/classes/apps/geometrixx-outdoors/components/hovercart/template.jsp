<%@page session="false"%><%--

  ADOBE CONFIDENTIAL
  __________________

   Copyright 2011 Adobe Systems Incorporated
   All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.
--%>
<%@include file="/libs/foundation/global.jsp" %><%
%><%@ page pageEncoding="UTF-8"
           import="com.adobe.cq.commerce.api.CommerceConstants,
                   com.day.cq.i18n.I18n,
                   org.apache.commons.lang.StringUtils,
                   java.util.Locale,
                   java.util.ResourceBundle" %><%
%><%

    final Locale pageLocale = currentPage.getLanguage(false);
    final ResourceBundle bundle = slingRequest.getResourceBundle(pageLocale);
    final I18n i18n = new I18n(bundle);

    String checkoutPage = WCMUtils.getInheritedProperty(currentPage, resourceResolver, CommerceConstants.PN_CHECKOUT_PAGE_PATH);
    if (!StringUtils.isBlank(checkoutPage)) {
        checkoutPage = resourceResolver.map(request, checkoutPage) + ".html";
    }

%><div id="cq-hovercart">
    <div class="cq-hovercart-border">
        <div class="cq-hovercart-inner">
            <h1>{{title}}</h1>
            {{#unless cartEmpty}}
            <% if (!StringUtils.isBlank(checkoutPage)) { %>
                <a class="cq-hovercart-checkout" href="<%= xssAPI.getValidHref(checkoutPage) %>"><%= i18n.get("Checkout") %> ➙</a>
            <% } %>
            <table>
                {{#each entries}}
                <tr data-product-page="{{this.page}}">
                    <td class="cq-hovercart-thumb"><img src="{{this.thumbnail}}" width="64" alt="{{this.title}}"/></td>
                    <td class="cq-hovercart-product-title">
                        <a href="{{this.page}}">{{this.title}}</a>
                        {{#if this.properties}}
                            {{#if this.properties.wrapping-selected}}
                                {{#if this.properties.wrapping-label}}
                                <div class="cq-hovercart-wrapping">Gift wrapping message: {{this.properties.wrapping-label}}</div>
                                {{/if}}
                                {{#unless this.properties.wrapping-label}}
                                <div class="cq-hovercart-wrapping">Gift wrapping selected</div>
                                {{/unless}}
                            {{/if}}
                        {{/if}}
                        {{#if this.promotion}}
                            {{#each this.promotion}}
                                <div class="cq-hovercart-promotion">{{{this.message}}}</div>
                            {{/each}}
                        {{/if}}
                    </td>
                    <td class="cq-hovercart-quantity">{{this.quantity}}</td>
                    <td class="cq-hovercart-price">{{this.priceFormatted}}</td>
                </tr>
                {{/each}}
                {{#each promotions}}{{#if this.message}}{{#unless this.cartEntry}}
                <tr>
                    <td class="cq-hovercart-promotion" colspan="4">{{{this.message}}}</td>
                </tr>
                {{/unless}}{{/if}}{{/each}}
            </table>
            {{/unless}}
            <div class="clearfix"></div>
        </div>
    </div>
</div>
