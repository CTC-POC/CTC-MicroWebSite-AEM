<%@page session="false"%><%--
/*************************************************************************
*
* ADOBE CONFIDENTIAL
* __________________
*
*  Copyright 2014 Adobe Systems Incorporated
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

<%@ page import="com.day.cq.i18n.I18n,
com.day.cq.wcm.api.WCMMode,
com.day.cq.wcm.commons.WCMUtils,
com.day.text.Text,
com.day.cq.wcm.foundation.forms.FormsHelper" %>

<%@include file="/libs/foundation/global.jsp" %>



<%
final String id = Text.getName(resource.getPath());
I18n i18n = new I18n(slingRequest);
final String action = currentPage.getPath() + "/j_security_check";
final String validationFunctionName = "cq5forms_validate_";
String signupPagePath = WCMUtils.getInheritedProperty(currentPage, resourceResolver, "cq:signupPage");
if (signupPagePath != null) signupPagePath = resourceResolver.map(signupPagePath);
String defaultRedirect = currentPage.getPath();
if (!defaultRedirect.endsWith(".html")) {
defaultRedirect += ".html";
}
boolean isDisabled = WCMMode.fromRequest(request).equals(WCMMode.DISABLED);
%>

<script type="text/javascript">
function <%=validationFunctionName%>() {
	if (CQ_Analytics) {
		var u = document.forms['<%=id%>']['j_username'].value;
		if (CQ_Analytics.Sitecatalyst) {
			CQ_Analytics.record({ event:"loginAttempt", values:{
				username:u,
				loginPage:"${currentPage.path}.html",
				destinationPage:"<%= xssAPI.encodeForJSString(defaultRedirect) %>"
			}, componentPath:'<%=resource.getResourceType()%>'});
			if (CQ_Analytics.ClickstreamcloudUI && CQ_Analytics.ClickstreamcloudUI.isVisible()) {
				return false;
			}
		}
		<% if ( !isDisabled ) {
final String contextPath = slingRequest.getContextPath();
final String authorRedirect = contextPath + defaultRedirect; %>
			if (CQ_Analytics.ProfileDataMgr) {
				if (u) {
					/*
					* AdobePatentID="B1393"
					*/
					var loaded = CQ_Analytics.ProfileDataMgr.loadProfile(u);
					if (loaded) {
						var url = CQ.shared.HTTP.noCaching("<%= xssAPI.encodeForJSString(authorRedirect) %>");
						CQ.shared.Util.load(url);
					} else {
						alert("<%=i18n.get("The user could not be found.")%>");
					}
					return false;
				}
			}
		return true;
		<% } else { %>
			if (CQ_Analytics.ProfileDataMgr) {
				CQ_Analytics.ProfileDataMgr.clear();
			}
		return true;
		<% } %>
	}
	}
	
	// for login modal
	$('#login_modal').modal({
		show: false,
		keyboard: false,
		backdrop: 'static'
	});

    $(function(){
            $("body").on("change",".userType",function() {
                if($(this).is(":checked")) {
                    $(".redirect").val("/content/geometrixx-gov/en/application-dashboard.html");
                }
                else {
                $(".redirect").val(document.location.href);
                }
            });
        });

</script>

<%
final String jReason = request.getParameter("j_reason");
if (null != jReason) {
%>
<div class="loginerror"><%=xssAPI.encodeForHTML(i18n.getVar(jReason))%>
</div>
<%
}
%>

<!-- Signin Modal Starts -->

<div class="modal fade" id="login_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
<div class="modal-dialog text-left">
	<div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3 class="modal-title" id="signinModalLabel"><%= i18n.get("Sign In")%></h3>
		</div>
		<div class="modal-body" data-spy="scroll">
			<div class="parsys_column colctrl-2c">
				<div class="parsys_column colctrl-2c-c0">
					<div class="parbase login section">
						<script type="text/javascript">
							function cq5forms_validate_login() {
								console.log("some validation will happen here.");
							}
						</script>
						
						
						<form class="form-horizontal col-lg-12 col-sm-12" role="form"
						method="POST"
						action="<%= xssAPI.getValidHref(action) %>"
						id="<%= xssAPI.encodeForHTMLAttr(id) %>"
						name="<%= xssAPI.encodeForHTMLAttr(id) %>"
						enctype="multipart/form-data"
						onsubmit="return <%=validationFunctionName%>();">
							
							<input type="hidden" name="resource" class="redirect" value="<%= xssAPI.encodeForHTMLAttr(defaultRedirect) %>">
							<input type="hidden" name="_charset_" value="UTF-8"/>							
							
							<div class="form-group">
								<label for="<%= xssAPI.encodeForHTMLAttr(id + "_username")%>" class="col-sm-4 control-label"><%= xssAPI.encodeForHTML(i18n.get("Username")) %></label>
								<div class="col-sm-8 col-xs-11">
									<input id="<%= xssAPI.encodeForHTMLAttr(id + "_username")%>" class="form-control cqusername form_field form_field_text login_username"
									type="text" name="j_username" placeholder="Username" tabindex="9990" autocapitalize="off"/>
								</div>
							</div>
							<div class="form-group">
								<label for="<%= xssAPI.encodeForHTMLAttr(id + "_password")%>" class="col-sm-4 control-label"><%= xssAPI.encodeForHTML(i18n.get("Password")) %> </label>
								<div class="col-sm-8 col-xs-11">
									<input id="<%= xssAPI.encodeForHTMLAttr(id + "_password")%>"
									class="form-control form_field form_field_text login_password cqpassword" type="password" autocomplete="off"
									name="j_password" placeholder="Password" tabindex="9991"/>
								</div>
							</div>
							<div class="form-group">
								<div class="col-sm-offset-4 col-sm-8">
									<button type="submit" id="login_submit" class="btn btn-primary form_button_submit" onclick="$CQ('#<%= xssAPI.encodeForHTMLAttr(id) %>').submit()"
									tabindex="9992"><%=i18n.get("Sign In")%></button>
								</div>
							</div>
                            <div class="form-group">
								<div class="col-sm-offset-4 col-sm-8">
                                    <div class="checkbox">
                                        <label>
                                          <input type="checkbox" class="userType" value="representative"><%=i18n.get("Login as representative")%></input>
                                        </label>
                                     </div>

								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</div>

<!-- Signin Modal Ends -->





