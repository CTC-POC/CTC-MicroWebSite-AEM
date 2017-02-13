<%@page session="false"%><%--

 ADOBE CONFIDENTIAL
 __________________

  Copyright 2012 Adobe Systems Incorporated
  All Rights Reserved.

 NOTICE:  All information contained herein is, and remains
 the property of Adobe Systems Incorporated and its suppliers,
 if any.  The intellectual and technical concepts contained
 herein are proprietary to Adobe Systems Incorporated and its
 suppliers and are protected by trade secret or copyright law.
 Dissemination of this information or reproduction of this material
 is strictly forbidden unless prior written permission is obtained
 from Adobe Systems Incorporated.

 ============================================================================
 
 Top Users Component

--%><%@page import="com.day.cq.commons.jcr.JcrConstants,
                    com.day.cq.wcm.api.WCMMode,
                    com.day.cq.wcm.api.Page,
                    com.day.cq.wcm.api.PageFilter,
                    com.day.cq.commons.Externalizer,
                    com.day.cq.i18n.I18n,
                    com.adobe.cq.social.ugcbase.SocialUtils,
                    com.adobe.cq.social.ugcbase.core.SocialResourceUtils,
                    com.adobe.granite.security.user.UserProperties,
                    com.adobe.granite.security.user.UserPropertiesManager,
                    com.adobe.granite.security.user.UserPropertiesService,
                    org.apache.sling.api.resource.Resource,
                    org.apache.sling.api.resource.ResourceResolver,
                    org.apache.sling.api.resource.ResourceUtil,
                    org.apache.sling.api.resource.ValueMap,
                    org.apache.sling.commons.json.JSONObject,
                    org.apache.sling.commons.json.JSONArray,
                    info.geometrixx.commons.util.GeoHelper,
                    info.geometrixx.commons.GeometrixxReportService,
                    org.apache.commons.lang3.StringUtils,
                    java.util.Locale,
                    java.util.ResourceBundle" %><%
%><%@include file="/libs/foundation/global.jsp" %><%

final Locale pageLocale = currentPage.getLanguage(true);
final ResourceBundle resourceBundle = slingRequest.getResourceBundle(pageLocale);
final I18n i18n = new I18n(resourceBundle);

final GeometrixxReportService reportService = sling.getService(info.geometrixx.commons.GeometrixxReportService.class);
final UserPropertiesService userPropertiesService  = sling.getService(UserPropertiesService.class) ;
final UserPropertiesManager upm = userPropertiesService.createUserPropertiesManager(resourceResolver);
final Externalizer externalizer = sling.getService(Externalizer.class);

String divId = "cq-reportlet-" + resource.getName();
String selectId = "dateSelector" + resource.getName();
final String NN_REPORT = "report";
final String NN_REPORTSELECTOR = ".sitecatalystreport.json";
String servletURI = resource.getPath() + "/report/thirtyday" + NN_REPORTSELECTOR;

String reportletTitle = properties.get("title", "");
final String absoluteDefaultAvatar = externalizer.absoluteLink(slingRequest, slingRequest.getScheme(), SocialUtils.DEFAULT_AVATAR);
String membersPath = currentPage.adaptTo(Node.class).getPath() + ".html";
if(currentPage != null && currentStyle != null && currentPage.getAbsoluteParent(currentStyle.get("absParent", 4)) != null)
  membersPath = currentPage.getAbsoluteParent(currentStyle.get("absParent", 4)).getPath() + "/members.html";
Resource reportResource = resource.getChild("report/thirtyday");
JSONObject reportDataJSON = reportResource == null ? null : reportService.getReportData(reportResource);

//iterate and add avatar url
JSONArray users = reportDataJSON == null ? new JSONArray() : reportDataJSON.getJSONArray("eventdata.commenterName");
if(users.length() > 0) {
    for (int i=0;i<users.length();i++){
        JSONObject user = users.getJSONObject(i);
        String resourceAuthorID = user.getString("name");
        final UserProperties userProperties = SocialResourceUtils.getUserProperties(resourceResolver,
            resourceAuthorID);
        if(userProperties == null) continue;

        String resourceAuthorName = userProperties.getDisplayName();
        if(StringUtils.isBlank(resourceAuthorName)){
            resourceAuthorName = userProperties.getProperty(UserProperties.GIVEN_NAME);
        }

        String resourceAuthorAvatar = SocialResourceUtils.getAvatar(userProperties, absoluteDefaultAvatar, SocialUtils.AVATAR_SIZE.THIRTY_TWO);
        user.put("displayName", resourceAuthorName);
        user.put("avatarurl", resourceAuthorAvatar);
        user.put("joinDate", "Joined June 21 1986");
        user.put("badge", "Bronze");
        user.put("replies", "8");
    }
} 
%>

<cq:includeClientLib categories="cq.social.analytics" />
<div class="diagonal-line-outer">
    <div class="diagonal-line-inner">
       <div class="section-title clearfix">
			<p>Top Contributors</p>
        </div>
        <div class="top-contributors">
            <ul>
                <%  if(users.length() > 0) {
                        for (int i=0;i<users.length();i++){
                            JSONObject user = users.getJSONObject(i);
                        if(user.optString("displayName", null) == null) {
                            log.debug("top user not found:{}", user.getString("name"));
                            continue;
                        }
                        request.setAttribute("userId", user.getString("name"));
                    %>
                        <li>
                            <div class="contributor clearfix">
                                <div class="contributor-avatar">
                                    <img src="<%=user.getString("avatarurl")%>">
                                </div>
                                <div class="contributor-detail">
                                    <a href="<%=user.getString("userUrl")%>"><%=user.getString("displayName")%></a>
                                    <p><%=user.getString("joinDate")%></p>
                                    <cq:include path="user-badge" resourceType="/apps/geometrixx-media/components/badgelist" />
                                </div>
                                <div class="replies-count">
                                    <span class="hits"><%=user.getString("replies")%></span>
                                    <img src="/etc/designs/geometrixx-media/clientlibs/img/comment.png">
                                </div>
                            </div>
                        </li>            
                    <%} 
                } %>
            </ul>
        </div>
    </div>        
</div>
