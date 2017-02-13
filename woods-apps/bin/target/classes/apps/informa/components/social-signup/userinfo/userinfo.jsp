<html>
    <head>
        <meta charset="UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
		<title>Informa Visitors</title>
		<!-- Bootstrap -->
		<link href="css/bootstrap.css" rel="stylesheet">
		<link href="css/font-awesome.min.css" rel="stylesheet">
		<!-- <link href="css/main.css" rel="stylesheet"> -->
		<!-- <link href="css/style.css" rel="stylesheet" type="text/css" /> -->
		<link href="css/registration.css" rel="stylesheet" type="text/css" />
		<link href="css/forms.css" rel="stylesheet" type="text/css" />

		<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
		<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
		<!--[if lt IE 9]>
		  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
		  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
		<![endif]--> 

		</head>
		
        <body >

   
  <body>
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
--%><%@include file="/libs/foundation/global.jsp"%>
<%
%><%@page
	import="java.util.Locale,
                  com.day.cq.i18n.I18n,
                  com.day.cq.personalization.UserPropertiesUtil,
                  com.day.cq.wcm.api.WCMMode,
                  org.apache.sling.api.auth.Authenticator"%>
<%
%><%@taglib prefix="personalization"
	uri="http://www.day.com/taglibs/cq/personalization/1.0"%>
<cq:includeClientLib categories="signuplib" />
<cq:includeClientLib categories="cq.social.connect" />
<%

    Locale pageLang = currentPage.getLanguage(false);
    final I18n i18n = new I18n(slingRequest.getResourceBundle(pageLang));

    boolean supportSimulation = !WCMMode.fromRequest(request).equals(WCMMode.DISABLED);

    final boolean isAnonymous = UserPropertiesUtil.isAnonymous(slingRequest);
%>
<% if (!isAnonymous || supportSimulation) { %>
<div class="overlay hidden-xs"></div>      
	<div class="container-fluid">
		<div class="container" style="margin-bottom:25px;">
			<div class="registrationTabs">
            <label for="message" style="color:#547D2A;padding:0px; margin:0px; padding-left:2px;"></label>
		  <!-- Form FO2 Starts Here -->	
          <form method="#">
				<div class="form-main-fo2">
					<div class="form-alignments-fo2">
						<h3 class="form-fo2-title">User information</h3>
						<div class="row form-fo2-contents">
							<div class="row">
								<div class="col-xs-12 col-sm-6 form-group">
									<div class="row fo2-alg">
										<div class="col-xs-12 col-sm-3 form-group">
											<label class="control-label forms-title-color-fo form-filedfirst-fo2-label form-label-name-fo2"><b>First Name :</b></label>
										</div>
										<div class="col-xs-12 col-sm-8 paddingZero form-filedfirst-fo2">
											<label class="control-label forms-title-color-fo form-filedfirst-fo2-label form-label-name-fo2"><personalization:contextProfileProperty propertyName="givenName" /></label>
										</div>
									</div>
									<div class="row fo2-alg">
										<div class="col-xs-12 col-sm-3 form-group">
											<label class="control-label forms-title-color-fo form-filedfirst-fo2-label form-label-name-fo2"><b>Email :</b></label>
										</div>
										<div class="col-xs-12 col-sm-8 paddingZero form-filedfirst-fo2">
											<label class="control-label forms-title-color-fo form-filedfirst-fo2-label form-label-name-fo2"><personalization:contextProfileProperty propertyName="email"/></label>
										</div>
									</div>
									<div class="row fo2-alg">
										<div class="col-xs-12 col-sm-3 form-group">
                                            <label class="control-label forms-title-color-fo form-filedfirst-fo2-label form-label-name-fo2"><b><a href="/content/informa-poc/en/login.html" style="color:#1B1361 !important;">Sign out</a></label>
										</div>
									</div>


								</div>								
								<div class="col-xs-12 col-sm-6 form-group paddingFo1Right">
									<div class="row fo2-alg">
										<div class="col-xs-12 col-sm-4 form-group">
										   <label class="control-label forms-title-color-fo form-filedfirst-fo2-label form-label-name-fo2"><b> Last Name :</b></label>
										</div>
										<div class="col-xs-12 col-sm-8 paddingZero">
											<label class="control-label forms-title-color-fo form-filedfirst-fo2-label form-label-name-fo2"><personalization:contextProfileProperty propertyName="familyName" /></label>
										</div>
									</div>
									<div class="row fo2-alg">
										<div class="col-xs-12 col-sm-4 form-group">
											<label class="control-label forms-title-color-fo form-filedfirst-fo2-label form-label-name-fo2"><b>AuthorizableI d :</b></label>
										</div>
										<div class="col-xs-12 col-sm-8 paddingZero">
											<label class="control-label forms-title-color-fo form-filedfirst-fo2-label form-label-name-fo2"><personalization:contextProfileProperty propertyName="authorizableId" /></label>
										</div>
									</div>

								</div>

							</div>	
						</div>
					</div>
				</div>
			  <input name="action" id="action" type="hidden" value="signUp">
             </form> 
		  <!-- Form FO2 ends Here -->
			</div>
		</div>       
	</div>

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

<script
		type="text/javascript">function logout() {
            if (_g && _g.shared && _g.shared.ClientSidePersistence) {
                _g.shared.ClientSidePersistence.clearAllMaps();
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

           	window.location="http://localhost:4502/content/informa-poc/en/login.html";  

        }</script> 
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
</html>