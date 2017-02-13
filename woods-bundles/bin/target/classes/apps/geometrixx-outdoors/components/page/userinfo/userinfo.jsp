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
--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@page import="java.util.Locale,
                  com.day.cq.i18n.I18n,
                  com.day.cq.personalization.UserPropertiesUtil,
                  com.day.cq.wcm.api.WCMMode,
                  org.apache.sling.api.auth.Authenticator" %><%
%><%@taglib prefix="personalization" uri="http://www.day.com/taglibs/cq/personalization/1.0" %><%

    Locale pageLang = currentPage.getLanguage(false);
    final I18n i18n = new I18n(slingRequest.getResourceBundle(pageLang));

    boolean supportSimulation = !WCMMode.fromRequest(request).equals(WCMMode.DISABLED);

    final boolean isAnonymous = UserPropertiesUtil.isAnonymous(slingRequest);

    final String accountPagePath = WCMUtils.getInheritedProperty(currentPage, resourceResolver, "cq:accountPage");
    final String smartlistPagePath = WCMUtils.getInheritedProperty(currentPage, resourceResolver, "cq:smartListPage");
    final String mailboxPagePath = WCMUtils.getInheritedProperty(currentPage, resourceResolver, "cq:mailboxPage");
%>
<nav><ul>
<% if (!isAnonymous || supportSimulation) { %>
    <li class="user"><personalization:contextProfileProperty propertyName="formattedName" prefix="(" suffix=")"/></li>
<% }  else { %>
    <script type="text/javascript">
        if (CQ_Analytics.ProfileDataMgr) {
            CQ_Analytics.ProfileDataMgr.clear();
        }
        if (CQ_Analytics.CCM) {
            CQ_Analytics.CCM.reset();
        }
    </script>
<% } %>
    <li class="cartpage"><sling:include resourceType="geometrixx-outdoors/components/hovercart"/></li>
    <li class="smartlistpage cq-cc-profile-not-anonymous"><a href="<%= xssAPI.getValidHref(smartlistPagePath)%>.html"><%= i18n.get("My Smart Lists")%></a></li>
    <li class="cq-cc-profile-not-anonymous">
        <script>
            var data = {};
            data["messageFolder"] = "inbox";
            var messagecount;
            $.ajax({
                type: "GET",
                url: "/content/geometrixx-outdoors/en/user/mailbox/jcr:content/par/messagebox_bb17.social.json",
                async: true,
                data: data,
                success: function(json) {
                    messagecount = json["messagecount"];
                    if (messagecount > 0) {
                        $("#mailboxlink").html( $("#mailboxlink").html() + " (" + messagecount + ")");
                    }
                }
            });
        </script>
        <a href="<%= xssAPI.getValidHref(mailboxPagePath)%>.html" id="mailboxlink"><%=i18n.get("Messages")%></a>
    </li>
    <li class="accountpage cq-cc-profile-not-anonymous"><a href="<%= xssAPI.getValidHref(accountPagePath)%>.html"><%= i18n.get("My Account")%></a></li>
    <li class="signout cq-cc-profile-not-anonymous">
        <script type="text/javascript">function logout() {
            if (_g && _g.shared && _g.shared.ClientSidePersistence) {
                _g.shared.ClientSidePersistence.clearAllMaps();
            }
            if (CQ_Analytics.CartMgr) {
                CQ_Analytics.CartMgr.reset();
            }
<%      if (supportSimulation) { %>
            if (CQ_Analytics.ProfileDataMgr) {
                CQ_Analytics.ProfileDataMgr.loadProfile("anonymous");
            }
            CQ.shared.Util.reload();
<%      } else { %>
            if (CQ_Analytics.ProfileDataMgr) {
                CQ_Analytics.ProfileDataMgr.clear();
            }
            if (CQ_Analytics.CCM) {
                CQ_Analytics.CCM.reset();
            }
            CQ.shared.Util.load("<%= resourceResolver.map(request, "/system/sling/logout") %>.html?" +
                    "<%= Authenticator.LOGIN_RESOURCE %>=<%= xssAPI.encodeForJSString(resourceResolver.map(currentPage.getPath())) %>.html");
<%      } %>
        }</script>
        <a href="javascript:logout();"><%= i18n.get("Sign Out") %></a>
    </li>
    <li class="login cq-cc-profile-anonymous"><cq:include path="sociallogin" resourceType="geometrixx-outdoors/components/social/sociallogin"/></li>
    <script>
        $CQ(document).ready(function() {
            if (CQ_Analytics.ProfileDataMgr) {
                var authorizableId = CQ_Analytics.ProfileDataMgr.getProperty("authorizableId");
                if (!authorizableId || authorizableId == "anonymous") {
                    $CQ(".cq-cc-profile-anonymous").show();
                } else {
                    $CQ(".cq-cc-profile-not-anonymous").show();
                }
            }
        });
    </script>
</ul></nav>
