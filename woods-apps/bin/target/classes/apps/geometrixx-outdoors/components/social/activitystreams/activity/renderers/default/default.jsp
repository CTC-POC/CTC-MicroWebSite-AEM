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

--%>


<%@ page import="java.text.DateFormat,
                 com.adobe.cq.social.ugcbase.SocialUtils,
                 com.adobe.cq.social.ugcbase.core.SocialResourceUtils,
                 com.adobe.granite.activitystreams.Activity,
                 com.adobe.granite.activitystreams.ActivityCollection,
                 com.adobe.granite.activitystreams.ActivityManager,
                 com.adobe.granite.activitystreams.ActivityObject,
                 com.adobe.granite.activitystreams.ActivityStream,
                 com.adobe.granite.security.user.UserProperties,
                 com.adobe.granite.security.user.UserPropertiesManager,
                 com.adobe.granite.security.user.UserPropertiesService,
                 com.day.cq.i18n.I18n,
                 com.day.cq.wcm.api.components.IncludeOptions,
                 com.day.cq.wcm.foundation.forms.FormsHelper,
                 com.day.cq.xss.XSSProtectionException,
                 com.day.cq.xss.XSSProtectionService" %>

    <%@include file="/libs/foundation/global.jsp"%><%
%><%@include file="/libs/social/security/social-security.jsp"%><%

    //TODO: make proper use of this
    I18n i18n = new I18n(slingRequest);
    //TODO: create jira issue for adaptTo granite activity streams
    ActivityManager activityManager = sling.getService(ActivityManager.class);
    Activity activity = activityManager.getActivity(resourceResolver, resource.getPath());


    if(activity != null) {
        final UserPropertiesService userPropertiesService  = sling.getService(UserPropertiesService.class) ;
        final UserPropertiesManager upm = userPropertiesService.createUserPropertiesManager(resourceResolver);

        UserProperties userProperties = upm.getUserProperties(activity.getActorUserId(), "profile");
        String author = userProperties == null ? "private" : userProperties.getDisplayName();
        String avatar = SocialResourceUtils.getAvatar(userProperties, SocialUtils.DEFAULT_AVATAR, SocialUtils.AVATAR_SIZE.THIRTY_TWO);
        final Boolean isAnonymous = userProperties == null ? true : userProperties.getAuthorizableID().equals("anonymous");
        final String socialProfilePage = WCMUtils.getInheritedProperty(currentPage, resourceResolver, "cq:socialProfilePage");
        final String socialProfileUrl = socialProfilePage != null && !isAnonymous ? userProperties.getNode().getPath()  + ".form.html" + socialProfilePage : "##";

        XSSProtectionService xssService = sling.getService(XSSProtectionService.class);


        String title = activity.getTitle();
        if(title == null){
            title = "";
        }
        title = title.replaceAll("\\r", "");
        title = title.replaceAll("\\n", "<br>");

        try {
            title = xssService.protectFromXSS(title);
        } catch (XSSProtectionException xe) {
            log.error("failed to protect title from xss", xe);
        }

        String message = activity.getObject().getContent();
        if(message == null){
            message = "";
        }
        message = message.replaceAll("\\r", "");
        message = message.replaceAll("\\n", "<br>");

        try {
            message = xssService.protectFromXSS(message);
        } catch (XSSProtectionException xe) {
            log.error("failed to protect comment from xss", xe);
        }

        String target = "unknown";
        String targetPath = "#";
        ActivityObject targetActivityObject = activity.getTarget();
        if(targetActivityObject != null) {
            target = targetActivityObject.getDisplayName();
            targetPath = targetActivityObject.getId();
        }

        //Component design consumption
        String background="",text="",links="";

        background = "#"+currentStyle.get("background", "ffffff");
        text = "#"+currentStyle.get("text", "444444");

        //TODO implement
        links = "#"+currentStyle.get("links", "1985b5");

        %>

        <div class="entries_content" style="background-color: #<%=xssAttrWrap(xssAPI, background)%> !important;font-color:#<%=xssAttrWrap(xssAPI, text)%>">

            <div class="entry_container">

                <div class="entry_clickable">

                    <a class="entry_avatar" href="<%=xssAPI.getValidHref(socialProfileUrl)%>">
                        <div class="entry_avatar_container" style="height:32px;width:32px;background: url(<%=xssAPI.getValidHref(avatar)%>);background-repeat: no-repeat;">
                            &nbsp;
                        </div>
                    </a>

                    <span class="entry_username">
                        <%=xssAPI.encodeForHTML(author)%>
                    </span>

                    <span class="entry_item_time" data-time="<%=xssAttrWrap(xssAPI, DateFormat.getDateTimeInstance(DateFormat.LONG,DateFormat.SHORT).format(activity.getPublished()))%>">
                    </span>

                    <div class="entry_stats">
                        <span class="entry_item_reach">
                            <span>
                                <a class="activity-target" target="_blank" href="<%=xssAPI.getValidHref(targetPath+".html")%>" title="<%=xssAttrWrap(xssAPI, i18n.getVar(activity.getVerb()))%><%=i18n.get(" on ")%> <%=xssAPI.encodeForHTML(target)%>">
                                    <img src="/etc/clientlibs/social/activitystreams/clientlibs/images/blog/icon.png" title="<%=xssAttrWrap(xssAPI, i18n.getVar(activity.getVerb()))%><%=i18n.get(" on ")%><%=xssAPI.encodeForHTML(target)%>" class="entry_icon_type_container" />
                                </a>
                            </span>
                        </span>
                    </div>

                    <span class="entry_item_text">
                        <p class="entry_item_text_p">
                            <%=xssAPI.filterHTML(message)%>
                        </p>
                    </span>
                </div>
            </div>
        </div>
<%
    } else {
        out.println("Resource is not an activity");
    }
%>
