<%--

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

--%><%@ page session="false" import="com.day.cq.widget.HtmlLibraryManager,
                     com.day.text.Text,
                     java.util.Iterator,
                     com.day.cq.wcm.api.Page,
                     org.apache.jackrabbit.api.security.user.User,
                     com.day.cq.wcm.foundation.Image,
                     com.day.cq.wcm.api.WCMMode,
                     com.day.cq.wcm.foundation.ParagraphSystem,
                     com.day.cq.wcm.foundation.Paragraph,
                     com.day.cq.wcm.api.components.IncludeOptions,
                     com.adobe.cq.social.scoring.api.ScoringService,
                     org.apache.sling.api.resource.ResourceUtil,
                     com.day.cq.wcm.foundation.forms.FormsHelper,
                     com.adobe.granite.security.user.UserPropertiesManager,
                     com.adobe.granite.security.user.UserPropertiesService,
                     java.util.List,
                     java.util.Enumeration,
                     org.apache.jackrabbit.api.security.user.UserManager,
                     org.apache.jackrabbit.api.security.user.Authorizable,
                     org.apache.jackrabbit.api.security.user.Group,
                     org.apache.sling.api.resource.ValueMap,
                     java.util.ResourceBundle,
                     com.day.cq.i18n.I18n" %>
<%@include file="/libs/social/commons/commons.jsp"%>
<%
    if (wcmMode == WCMMode.EDIT) { %>
       <cq:includeClientLib categories="cq.scoring"/>
    <% }

    final String[] badges = currentStyle.get("mappings", String[].class);
    
    final ScoringService scoreService = sling.getService(ScoringService.class);
    final UserPropertiesService userPropertiesService  = sling.getService(UserPropertiesService.class);
    final UserPropertiesManager upm = userPropertiesService.createUserPropertiesManager(resourceResolver);
    UserProperties userProperties = null;
    UserManager userManager = resourceResolver.adaptTo(UserManager.class);
    boolean handled = false;

	String moderatorGroup = currentStyle.get("moderatorGroup", String.class);
	String selectedBadge = "";

    // first preference
    String authorizableId = (String) request.getAttribute("userId");

    String path = (String)request.getAttribute("javax.servlet.include.path_info");

    if(authorizableId == null ) {
        List<Resource> resources = FormsHelper.getFormEditResources(slingRequest);
        if (resources != null && resources.size() > 0) {
            // second preference: formchooser-mode, get the requested resource
            Resource userProfileResource = resources.get(0);
            userProperties = upm.getUserProperties(userProfileResource.adaptTo(Node.class));
            authorizableId = userProperties.getAuthorizableID();
        } else {
            authorizableId = loggedInUserID;
        }
    }
    if (!"anonymous".equals(authorizableId)) {
		if (moderatorGroup != null && !"".equals(moderatorGroup)) {
            Authorizable authorizable = userManager.getAuthorizable(authorizableId);
            Iterator<Group> memberOf = authorizable.memberOf();
            while (memberOf.hasNext()) {
                Group currentGroup = memberOf.next();
                if (currentGroup.getPath().equals(moderatorGroup)) {
                    selectedBadge = "moderator";

                    handled = true;

                    break;
                }
            }
		}
		if(badges != null && "".equals(selectedBadge)){
            for (String badge : badges) {
                String[] segmentBadgeMap = badge.split("#");
                if (segmentBadgeMap !=null) {
                    String segmentPath = segmentBadgeMap[0];
                    String userBadge = segmentBadgeMap[1];
                    userBadge = userBadge.toLowerCase();
                    //if (scoreService.resolveScoringSegment(segmentPath, authorizableId)) {
                    //    if(userBadge.equals("gold")){
                    //        if(selectedBadge.equals("") || selectedBadge.equals("silver") || selectedBadge.equals("bronze")){
                    //            selectedBadge = "gold";
                    //        }
                    //    } else if(userBadge.equals("silver")){
                    //        if(selectedBadge.equals("") || selectedBadge.equals("bronze")){
                    //            selectedBadge = "silver";
                    //        }
                    //    } else if(userBadge.equals("bronze")){
                    //        if(selectedBadge.equals("")){
                    //            selectedBadge = "bronze";
                    //        }
                    //    } else if(userBadge.equals("moderator")){
                    //        selectedBadge = "moderator";
                    //    }
                    //}
                }
            }

            handled = true;
        }

        if (handled) {
            if(!"".equals(selectedBadge)){
                if(path.contains("profiles")){
                %><span class="badge <%=selectedBadge %>"><%=selectedBadge %><span></span></span><%
                } else {
                    %><span class="badge <%=selectedBadge %>"><%=selectedBadge %></span><%
                }
            } else {
                %><span class="badge" style="color: #333333;">No Badge</span><%
            }
        }
        else {
            %><span class="badge" style="color: #333333;">Setup Badges</span><%
        }
    } else if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
        %><img src="/libs/cq/ui/resources/0.gif" class="cq-teaser-placeholder" alt=""/><%
    }
%>
