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

  ==============================================================================

    Community Information

--%><%@include file="/libs/social/commons/commons.jsp"%><%
%><%@ page import="org.apache.sling.api.resource.ResourceUtil,
                     org.apache.sling.api.resource.ResourceResolver,
                     org.apache.sling.jcr.api.SlingRepository,
                     org.apache.commons.collections.IteratorUtils,
                     com.adobe.granite.security.user.UserProperties,
                     com.adobe.granite.security.user.UserPropertiesService,
                     com.adobe.granite.security.user.UserManagementService,
                     java.util.Collection,
                     java.util.Iterator,
                     java.util.Locale,
                     com.adobe.cq.social.ugcbase.SocialUtils,
                     com.adobe.cq.social.ugcbase.core.SocialResourceUtils,
                     com.adobe.cq.social.group.api.GroupConstants,
                     com.adobe.cq.social.group.api.GroupUtil" %>
<cq:includeClientLib categories="cq.social.group"/><%

    final ResourceResolver resolver = slingRequest.getResourceResolver();
    final SlingRepository repository = sling.getService(SlingRepository.class);
    final UserPropertiesService userPropertiesService  = sling.getService(UserPropertiesService.class) ;
    final UserManagementService userManagementService  = sling.getService(UserManagementService.class) ;
    final String groupRoot = userManagementService.getGroupRootPath() + "/community/";
    
    Page communityPage = currentPage.getParent();
    ValueMap cproperties = communityPage.getProperties();

    String desc = cproperties.get(GroupConstants.PROPERTY_DESCRIPTION, "");
    String author = loggedInUserID; 

    String admingroupPath = cproperties.get(GroupConstants.GROUP_ADMINGROUP, groupRoot + currentPage.getParent().getName()+ GroupConstants.GROUP_ADMINGROUP_SUFFIX);
    String adminGID = admingroupPath.substring(admingroupPath.lastIndexOf("/")+1);
    Iterator<UserProperties> admins = null;
    
    String membergroupPath = cproperties.get(GroupConstants.GROUP_MEMBERGROUP, groupRoot + currentPage.getParent().getName()+ GroupConstants.GROUP_MEMBERGROUP_SUFFIX);
    String memberGID = membergroupPath.substring(membergroupPath.lastIndexOf("/")+1);
    Iterator<UserProperties> members = null;
    //TODO: need to fill out members that are group, not just minus 1 for the admin group 
    int memberNum = (members != null)?  IteratorUtils.toList(members).size() : 0;
    
    //pass to user state toggle component
    request.setAttribute(GroupConstants.GROUP_MEMBERGROUP, membergroupPath);

    //search for forum under actionPath
    String rootPath = communityPage.getPath();
    if(rootPath.indexOf("subcommunities")>=0){
        //get top level community path
        rootPath = rootPath.substring(0, rootPath.indexOf("subcommunities")-1);
    }
    if(rootPath.indexOf("/")>=0){
        //get communities path
        rootPath = rootPath.substring(0, rootPath.lastIndexOf("/")-1);
    }
%>

<div class="description"><%= xssAPI.filterHTML(desc) %></div>
<div class="sidebar member-count clearfix">
    <h2><%=i18n.get("Community Members")%></h2>
    <span class="count"><%= memberNum %></span>
</div>

<div class="sidebar title clearfix">
    <h2><%= i18n.get("Community Administrators:") %></h2>
</div>
<ul class="admins">

<%
if(admins!=null){
    while(admins.hasNext()) {
        final UserProperties admin = admins.next();    
        String formattedName = xssAPI.encodeForHTML(admin.getProperty(UserProperties.GIVEN_NAME) + " " + admin.getProperty(UserProperties.FAMILY_NAME));
        String avatarPath = SocialResourceUtils.getAvatar(admin, SocialUtils.DEFAULT_AVATAR, SocialUtils.AVATAR_SIZE.THIRTY_TWO);
        log.info("name:"+formattedName);
        %><li class="admin-listing">
        <div class="avatar">
        <img src="<%= xssAPI.getValidHref(avatarPath) %>"  alt="<%= xssAPI.encodeForHTMLAttr(formattedName) %>" title="<%= xssAPI.encodeForHTMLAttr(formattedName) %>"/><%= formattedName %>
        </div>
        </li><%
    }
}   
%>
</ul>

<%
//show invite to join button for group members
if(author != null && GroupUtil.isMember(userPropertiesService, resolver, author , memberGID)){
%><div>
    <form class="groupForm" action="<%= xssAPI.getValidHref(communityPage.getPath()) %>.form.html<%= xssAPI.getValidHref(rootPath) %>/invite" method="GET">
        <input type="hidden" name="groupid" value="<%= xssAPI.encodeForHTMLAttr(communityPage.getName()) %>">
        <input name="submit" value="<%=i18n.get("INVITE TO JOIN")%>" type="submit" class="invite">
    </form>
</div><%
}

//show edit group button for group admins
if(author != null && GroupUtil.isMember(userPropertiesService, resolver, author , adminGID)){
%><div>
    <form class="groupForm" action="<%= xssAPI.getValidHref(communityPage.getPath()) %>.form.html<%= xssAPI.getValidHref(rootPath) %>/editcommunity" method="GET">
        <input type="hidden" name="groupid" value="<%= xssAPI.encodeForHTMLAttr(communityPage.getName()) %>">
        <input name="submit" value="<%=i18n.get("EDIT COMMUNITY")%>" type="submit" class="editGroup">
    </form>
</div><%
}


%>
