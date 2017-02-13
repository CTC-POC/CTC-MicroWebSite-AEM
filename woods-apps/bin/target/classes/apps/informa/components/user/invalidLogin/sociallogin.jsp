<html>

<%@page session="false"%><%--
/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * __________________
 *
 *  Copyright 2012 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/
--%>

<%--
  Social Login Component - uses cloud service configs as 'providers'.
--%>

<%@include file="/libs/foundation/global.jsp"%>
<%@page contentType="text/html; charset=utf-8"
	import="javax.jcr.Session,
                                                       org.apache.sling.api.resource.Resource,
                                                       org.apache.sling.commons.json.JSONObject,
                                                       com.adobe.granite.security.user.UserProperties,
                                                       com.adobe.granite.security.user.UserPropertiesManager,
                                                       com.day.cq.i18n.I18n,
                                                       com.day.cq.security.Authorizable,
                                                       com.day.cq.personalization.UserPropertiesUtil,
                                                       com.day.cq.wcm.api.WCMMode,
                                                       com.day.cq.wcm.webservicesupport.Configuration,
                                                       com.day.cq.wcm.webservicesupport.ConfigurationManager"%>

<cq:includeClientLib categories="apps.informa.social.all" />
<cq:includeClientLib categories="apps.informa.social.jquery" /> 
<cq:includeClientLib categories="cq.social.connect" />

<%

    // getting the username of the logged-in user
    Session session = resourceResolver.adaptTo(Session.class);
    final String userId = session.getUserID().replace("\"", "\\\"").replace("\r", "\\r").replace("\n", "\\n");
    pageContext.setAttribute("userId", userId);

    ConfigurationManager cfgMgr = resourceResolver.adaptTo(ConfigurationManager.class);
    Configuration facebookConfiguration = null;
	Configuration twitterConfiguration = null;
    String[] services = pageProperties.getInherited("cq:cloudserviceconfigs", new String[]{});
    int connectServiceCount = 0;
    if (cfgMgr != null) {
        facebookConfiguration = cfgMgr.getConfiguration("facebookconnect", services);
        twitterConfiguration = cfgMgr.getConfiguration("twitterconnect", services);
        if (facebookConfiguration != null){
            connectServiceCount++;
        }
        if (twitterConfiguration != null){
            connectServiceCount++;
        }

    }

    I18n i18n = new I18n(slingRequest);
    final String uniqSuffix = resource.getPath().replaceAll("/", "-").replaceAll(":", "-");
    final String divID = "sociallogin" + uniqSuffix;

    final boolean isAnonymous = userId.equals("anonymous");
    final boolean isDisabled = WCMMode.DISABLED.equals(WCMMode.fromRequest(request));
    final String loginSuffix = isDisabled && isAnonymous ? "/j_security_check" : "/connect";
    final String redirectTo = properties.get("redirectTo", "") +".html";
    final String contextPath = slingRequest.getContextPath();
    final JSONObject dialogConfig = new JSONObject();
    Integer dialogWidth = 630;
    Integer dialogHeight = 400;
    dialogConfig.putOpt("width", dialogWidth);
    dialogConfig.putOpt("height", dialogHeight);
    dialogConfig.put("dialogClass", "sociallogin-dialog");
%>
    <%= request.getParameter("errorMessage") %>
<script type="text/javascript">

    $CQ(document).ready(function () {
        //listening for this global event - triggered from SocialAuth.js - $CQ.SocialAuth.oauthCallbackComplete
        //any element can subscribe to this event to perform custom functionality post-oauth-callback completion
        //the social login component will listen for it here to perform the appropriate redirect as configured
        $CQ(document).bind('oauthCallbackComplete', function(ev, userId) {
            //oauthCallbackComplete happened
            CQ_Analytics.ProfileDataMgr.loadProfile(userId);
            <% if (redirectTo != null && redirectTo.length() > 0) { %>
                CQ.shared.Util.reload(null, '<%= xssAPI.encodeForJSString(contextPath + redirectTo) %>');
            <% } else { %>
                CQ.shared.Util.reload();
            <% } %>
        });

        $CQ('.geosociallogin-signin-<%= xssAPI.encodeForJSString(divID) %>').on('click', function(ev){
            ev.preventDefault();
            var config = <%=dialogConfig.toString()%>;
            $CQ.SocialAuth.sociallogin.showDialog('<%= xssAPI.encodeForJSString(divID) %>', config);
        });
    });

</script>

<%
        if (facebookConfiguration != null) {
            Resource configResource = facebookConfiguration.getResource();
            Page configPage = configResource.adaptTo(Page.class);
            final String configid = configPage.getProperties().get("oauth.config.id", String.class);
    %>

<div class="col-md-3 col-sm-3 col-xs-6 paddingZero">
            <div class="form-group form-fo2-next btn-fo2-next form-fo10-next">
<input type="submit" class="btnnew" tabindex="9993" 
	 name="create" value="Sign in with Facebook" &rsaquo;"
	onclick="$CQ.SocialAuth.sociallogin.doOauth(
                           '<%= xssAPI.encodeForJSString(divID) %>',
                           '<%= xssAPI.encodeForJSString(configPage.getPath()) %>',
                           '<%= xssAPI.encodeForJSString(configid) %>',
                           '<%= loginSuffix %>',
                           '<%= xssAPI.encodeForJSString(contextPath) %>');return false;" style="margin-left:66px !important;"/>

          </div>
		</div>
<%
        }
        %>
<% if (twitterConfiguration != null) {
            Resource configResource = twitterConfiguration.getResource();
            Page configPage = configResource.adaptTo(Page.class);
            final String configid = configPage.getProperties().get("oauth.config.id", String.class);
    %>

<div class="col-md-3 col-sm-3 col-xs-6 paddingZero">
            <div class="form-group form-fo2-next btn-fo2-next form-fo10-next">
<input type="submit" class="btnnew" tabindex="9993"
	 name="create"  value="Sign in with Twitter" &rsaquo;"
                       onclick="$CQ.SocialAuth.sociallogin.doOauth(
                           '<%= xssAPI.encodeForJSString(divID) %>',
                           '<%= xssAPI.encodeForJSString(configPage.getPath()) %>',
                           '<%= xssAPI.encodeForJSString(configid) %>',
                           '<%= loginSuffix %>',
                           '<%= xssAPI.encodeForJSString(contextPath) %>'
                       );return false;" style="margin-left:121px;"/>

<%
        }
        %>
    </html>