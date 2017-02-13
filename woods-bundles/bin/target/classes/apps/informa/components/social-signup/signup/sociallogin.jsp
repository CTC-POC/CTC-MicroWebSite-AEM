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
	String address="";String locationVariable=null;String name=null;String firstName="";String lastName="";String fullname="";
	String country=""; String email="";
    ConfigurationManager cfgMgr = resourceResolver.adaptTo(ConfigurationManager.class);
    Configuration facebookConfiguration = null;
    Configuration twitterConfiguration = null;
	Configuration linkedinConfiguration = null;
    String[] services = pageProperties.getInherited("cq:cloudserviceconfigs", new String[]{});
    int connectServiceCount = 0;
    if (cfgMgr != null) {
        facebookConfiguration = cfgMgr.getConfiguration("facebookconnect", services);
        twitterConfiguration = cfgMgr.getConfiguration("twitterconnect", services);
        linkedinConfiguration = cfgMgr.getConfiguration("linkedinconnect", services);
        if (facebookConfiguration != null){
            connectServiceCount++;
        }
        if (twitterConfiguration != null){
            connectServiceCount++;
        }
        if(linkedinConfiguration !=null){
		    connectServiceCount++;

        }
    }
	final UserPropertiesManager upm = resourceResolver.adaptTo(UserPropertiesManager.class);
               //you can have a check to pass the parameter as twitter/facebook
		if(userId.startsWith("tw"))
        {	
            UserProperties userProperties = upm.getUserProperties(userId,"profile/twitter");
			if(userProperties!=null){ 
			for (String key : userProperties.getPropertyNames()) {

			 if(userProperties.getProperty("email")!=null)
              email = userProperties.getProperty("email").toString();
			  request.setAttribute("email",email);

             if(userProperties.getProperty("location")!=null)
            locationVariable = userProperties.getProperty("location").toString();  


             if(userProperties.getProperty("name")!=null)
            	fullname = userProperties.getProperty("name").toString();  

                String[]names=fullname.split(" ");
				firstName=names[0];

                 if(names.length>1)
                	lastName=names[1];
                
				request.setAttribute("firstName",firstName);
                request.setAttribute("lastName",lastName);
             }

		}
            if(locationVariable!=null)
            {
				String []location=locationVariable.split(",");
                address=location[0];
                country=location[1];
                request.setAttribute("address",address);
                request.setAttribute("country",country);
			}
        }
		if(userId.startsWith("fb"))
        {	
            UserProperties userProperties = upm.getUserProperties(userId,"profile/facebook");
			if(userProperties!=null){ 
			for (String key : userProperties.getPropertyNames()) {

			 if(userProperties.getProperty("email")!=null)
              email = userProperties.getProperty("email").toString();


             if(userProperties.getProperty("first_name")!=null)
            firstName = userProperties.getProperty("first_name").toString();  

             if(userProperties.getProperty("last_name")!=null)
            lastName = userProperties.getProperty("last_name").toString(); 
             }

		}	 request.setAttribute("email",email);
             request.setAttribute("firstName",firstName);
             request.setAttribute("lastName",lastName);

     }


    I18n i18n = new I18n(slingRequest);
    final String uniqSuffix = resource.getPath().replaceAll("/", "-").replaceAll(":", "-");
    final String divID = "sociallogin" + uniqSuffix;

    final boolean isAnonymous = userId.equals("anonymous");
    final boolean isDisabled = WCMMode.DISABLED.equals(WCMMode.fromRequest(request));
    final String loginSuffix = isDisabled && isAnonymous ? "/j_security_check" : "/connect";
    final String redirectTo = properties.get("redirectTo", "");
    final String contextPath = slingRequest.getContextPath();
    final String message = properties.get("message", i18n.get("Sign In or Register"));
    final JSONObject dialogConfig = new JSONObject();
    Integer dialogWidth = 630;
    Integer dialogHeight = 400;
    dialogConfig.putOpt("width", dialogWidth);
    dialogConfig.putOpt("height", dialogHeight);
    dialogConfig.put("dialogClass", "sociallogin-dialog");
%>
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

        $CQ('<%= xssAPI.encodeForJSString(divID) %>').on('click', function(ev){
            ev.preventDefault();
            var config = <%=dialogConfig.toString()%>;
            $CQ.SocialAuth.sociallogin.showDialog('<%= xssAPI.encodeForJSString(divID) %>', config);
        });

           
    });

</script>
	<ul class="list-inline social-buttons">
	<%
	        if (facebookConfiguration != null) {
	            Resource configResource = facebookConfiguration.getResource();
	            Page configPage = configResource.adaptTo(Page.class);
	            final String configid = configPage.getProperties().get("oauth.config.id", String.class);
	    %>
	<li>
	<a href="#facebook" onclick="$CQ.SocialAuth.sociallogin.doOauth(
	                           '<%= xssAPI.encodeForJSString(divID) %>',
	                           '<%= xssAPI.encodeForJSString(configPage.getPath()) %>',
	                           '<%= xssAPI.encodeForJSString(configid) %>',
	'<%= loginSuffix %>','<%= xssAPI.encodeForJSString(contextPath) %>');return false;"><i class="fbIcon"></i></a>

	    </li>
	<%
	        }
	        %>
	<% if (twitterConfiguration != null) {
	            Resource configResource = twitterConfiguration.getResource();
	            Page configPage = configResource.adaptTo(Page.class);
	            final String configid = configPage.getProperties().get("oauth.config.id", String.class);
	    %>
	
	<li>
	<a href="#twitter" onclick="$CQ.SocialAuth.sociallogin.doOauth(
	                           '<%= xssAPI.encodeForJSString(divID) %>',
	                           '<%= xssAPI.encodeForJSString(configPage.getPath()) %>',
	                           '<%= xssAPI.encodeForJSString(configid) %>',
	                           '<%= loginSuffix %>',
	                           '<%= xssAPI.encodeForJSString(contextPath) %>'
	);return false;"><i class="twIcon"></i></a> </li>
	
	<%
	        }
	        %>
<% if (linkedinConfiguration != null) {
            Resource configResource = linkedinConfiguration.getResource();
            Page configPage = configResource.adaptTo(Page.class);
            final String configid = configPage.getProperties().get("oauth.config.id", String.class);
    %>
<li>
<a href="#linkedin"  value="<%= i18n.get("Linkedin")%> &rsaquo;"
                       onclick="$CQ.SocialAuth.sociallogin.doOauth(
                           '<%= xssAPI.encodeForJSString(divID) %>',
                           '<%= xssAPI.encodeForJSString(configPage.getPath()) %>',
                           '<%= xssAPI.encodeForJSString(configid) %>',
                           '<%= loginSuffix %>',
                           '<%= xssAPI.encodeForJSString(contextPath) %>'
);return false;"><i class="inIcon"></i></a></li>

<%
        }
        %>
	    </ul>


