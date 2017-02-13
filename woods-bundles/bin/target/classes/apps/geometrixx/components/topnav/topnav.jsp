<%@page session="false"%><%--
  Copyright 1997-2010 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Top Navigation component

  Draws the top navigation

--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@ page import="com.day.cq.commons.Doctype,
        com.day.cq.wcm.api.PageFilter,
        com.day.cq.wcm.foundation.Navigation,
        com.day.text.Text,
        com.adobe.cq.wcm.launches.utils.LaunchUtils" %><%

    int absParent = currentStyle.get("absParent", 2);
    Page homePage = currentPage.getAbsoluteParent(absParent);
    String home = homePage != null ? homePage.getPath() : Text.getAbsoluteParent(currentPage.getPath(), 2);
    if(LaunchUtils.isLaunchBasedPath(home)){
        return;
    }

    PageFilter filter = new PageFilter(request);
    Navigation nav = new Navigation(currentPage, absParent, filter, 3);
    String xs = Doctype.isXHTML(request) ? "/" : "";

    // help linkchecker to increase performance
    String linkCheckerHint = filter.isIncludeInvalid() ? "" : "x-cq-linkchecker=\"valid\"";

%><div class="topnav">
    <div class="left_curve">
        <div class="right_curve">
            <ul id="topnav">
                <li class="home"><a href="<%= xssAPI.getValidHref(home) %>.html"><img src="/etc/designs/default/0.gif" alt="Home" <%=xs%>></a></li>
                <%
                    for (Navigation.Element e: nav) {
                        switch (e.getType()) {
                            case NODE_OPEN:
                %><ul><%
                    break;
                case ITEM_BEGIN:
            %><li <%= e.hasChildren() ? "class=\"noleaf\"" : "" %>><a href="<%= xssAPI.getValidHref(e.getPath()) %>.html" <%= linkCheckerHint %>><%= xssAPI.encodeForHTML(e.getRawTitle()) %></a><%
                    break;
                case ITEM_END:
            %></li><%
                    break;
                case NODE_CLOSE:
            %></ul><%
                            break;
                    }
                }
            %>
                <li class="sep1">&nbsp;</li>
            </ul>
        </div>
    </div>
</div>
