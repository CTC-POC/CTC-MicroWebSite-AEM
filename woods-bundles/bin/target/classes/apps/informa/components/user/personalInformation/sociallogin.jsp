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
	String country=""; String email="";String gender="";
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
                pageContext.setAttribute("email", email);

             if(userProperties.getProperty("location")!=null)
            locationVariable = userProperties.getProperty("location").toString();  


             if(userProperties.getProperty("name")!=null)
            	fullname = userProperties.getProperty("name").toString();  

                String[]names=fullname.split(" ");
				firstName=names[0];

                 if(names.length>1)
                	lastName=names[1];
                pageContext.setAttribute("firstName", firstName);
				pageContext.setAttribute("lastName", lastName);
             }

		}
            if(locationVariable!=null)
            {
				String []location=locationVariable.split(",");
                address=location[0];
                country=location[1];
                pageContext.setAttribute("address", address);
                pageContext.setAttribute("country", country);

			}
        }
		if(userId.startsWith("fb"))
        {	
            UserProperties userProperties = upm.getUserProperties(userId,"profile/facebook");
			if(userProperties!=null){ 
			for (String key : userProperties.getPropertyNames()) {

			 if(userProperties.getProperty("email")!=null)
              email = userProperties.getProperty("email").toString();
			 pageContext.setAttribute("email", email);

			 if(userProperties.getProperty("gender")!=null)
              gender = userProperties.getProperty("gender").toString();
				pageContext.setAttribute("gender", gender);

             if(userProperties.getProperty("first_name")!=null)
            firstName = userProperties.getProperty("first_name").toString();  
			pageContext.setAttribute("firstName", firstName);

             if(userProperties.getProperty("last_name")!=null)
            lastName = userProperties.getProperty("last_name").toString();
            pageContext.setAttribute("lastName", lastName);

             }

		}	 

     }

%>


<div id="emailValue" data-redirectpage32="${email}"></div>
<div id="firstNameValue" data-redirectpage33="${firstName}"></div>
<div id="lastNameValue" data-redirectpage34="${lastName}"></div>
<div id="genderValue" data-redirectpage35="${gender}"></div>
<div id="addressValue" data-redirectpage36="${address}"></div>
<div id="countryValue" data-redirectpage37="${country}"></div>

