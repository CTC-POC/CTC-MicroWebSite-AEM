<%--

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
--%><%@include file="/apps/geometrixx-gov/components/global.jsp" %><%
%><%@page session="false" import="
          com.day.cq.personalization.UserPropertiesUtil,
		  org.apache.sling.commons.json.JSONObject,
          com.day.cq.wcm.commons.WCMUtils,
		  com.day.cq.wcm.api.WCMMode, org.apache.sling.api.auth.Authenticator"%>


              <%
%><%@taglib prefix="personalization" uri="http://www.day.com/taglibs/cq/personalization/1.0" %><%

    final boolean isAnonymous = UserPropertiesUtil.isAnonymous(slingRequest);
    final boolean isDisabled = WCMMode.DISABLED.equals(WCMMode.fromRequest(request));
    final String loginPagePath = WCMUtils.getInheritedProperty(currentPage, resourceResolver, "cq:loginPage");

	final String uniqSuffix = resource.getPath().replaceAll("/", "-").replaceAll(":", "-");
    final String divID = "login" + uniqSuffix;
	final String loginSuffix = isDisabled && isAnonymous ? "/j_security_check" : "/connect";
    final String redirectTo = properties.get("redirectTo", "");
    final String contextPath = slingRequest.getContextPath();
    final String message = properties.get("message", i18n.get("Sign In or Register"));

%>



<nav><ul>
    <%
    if (!isAnonymous || !isDisabled) { %>
        <li class="username"><personalization:contextProfileProperty propertyName="formattedName" prefix="(" suffix=")"/></li>
    <% } %>
    <% if (!isAnonymous || !isDisabled) { %>
    <li class="signout cq-cc-profile-not-anonymous">
        <script type="text/javascript">function logout() {
            if (_g && _g.shared && _g.shared.ClientSidePersistence) {
                _g.shared.ClientSidePersistence.clearAllMaps();
            }

        <%      if( !isDisabled ) { %>
            if( CQ_Analytics && CQ_Analytics.CCM) {
                CQ_Analytics.ProfileDataMgr.loadProfile("anonymous");
                CQ.shared.Util.reload();
            }
        <%      } else { %>
            if( CQ_Analytics && CQ_Analytics.CCM) {
                CQ_Analytics.ProfileDataMgr.clear();
                CQ_Analytics.CCM.reset();
            }

            CQ.shared.Util.load("<%= resourceResolver.map(request, "/system/sling/logout") %>.html?" +
                    "<%= Authenticator.LOGIN_RESOURCE %>=<%= xssAPI.encodeForJSString(resourceResolver.map(currentPage.getPath())) %>.html");
        <%      } %>
        }</script>
        <a href="javascript:logout();"><%= i18n.get("Sign Out") %></a>
    </li>
    <% }
    if (isAnonymous || !isDisabled) { %>
	<li class="signin cq-cc-profile-anonymous"><a data-toggle="modal" href="#login_modal"><%= i18n.get("Sign In") %></a></li>

    <% }
    %>
    <script>
        $CQ(document).ready(function() {
            if (CQ_Analytics && CQ_Analytics.ProfileDataMgr) {
                var authorizableId = CQ_Analytics.ProfileDataMgr.getProperty("authorizableId");
                
                if (!authorizableId || authorizableId == "anonymous") {
                    $CQ(".cq-cc-profile-anonymous").show();
                    $(".signin").css('display','inline');

                } else {
                    $CQ(".cq-cc-profile-not-anonymous").show();
                    $(".signout").css('display','inline');

                }
            }
        });
    </script>

</ul></nav>

