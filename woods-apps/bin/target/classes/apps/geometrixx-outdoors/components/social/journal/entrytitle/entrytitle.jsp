<%@page session="false"%><%--
  Copyright 1997-2008 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Title component.

  Draws a title either store on the resource or from the page

--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@ page import="java.text.DateFormat,
                   java.util.Locale,
                   java.util.ResourceBundle,
                   com.adobe.cq.social.ugcbase.SocialUtils,
                   com.adobe.cq.social.ugcbase.core.SocialResourceUtils,
                   com.adobe.cq.social.commons.Comment,
                   com.adobe.cq.social.journal.Journal,
                   com.adobe.cq.social.journal.JournalEntry,
                   com.adobe.granite.security.user.UserProperties,
                   com.day.cq.commons.Externalizer,
                   com.day.cq.commons.date.DateUtil,
                   com.day.cq.i18n.I18n" %>
<%
    final ResourceBundle bundle = slingRequest.getResourceBundle(currentPage.getLanguage(true));
    final JournalEntry entry = resource.adaptTo(JournalEntry.class);
    final Journal journal = entry.getJournal();
    final Externalizer externalizer = sling.getService(Externalizer.class);
    final String defaultAvatar = externalizer.absoluteLink(slingRequest,
                                                           slingRequest.getScheme(),
                                                           SocialUtils.DEFAULT_AVATAR);
    final String absoluteDefaultAvatar = externalizer.absoluteLink(slingRequest, slingRequest.getScheme(), SocialUtils.DEFAULT_AVATAR);

    String resourceAuthorAvatar = null;
    String profileUrl = null;

    if (entry.getTextComment() != null) {
        final String authorId = entry.getTextComment().getProperty(Comment.PROP_AUTHORIZABLE_ID, String.class);
        final UserProperties userProperties = SocialResourceUtils.getUserProperties(resourceResolver,
            authorId);

        resourceAuthorAvatar = SocialResourceUtils.getAvatar(userProperties, absoluteDefaultAvatar, SocialUtils.AVATAR_SIZE.THIRTY_TWO);

        String profilePage = WCMUtils.getInheritedProperty(currentPage, resourceResolver, "cq:socialProfilePage");
        profileUrl = profilePage != null ? userProperties.getNode().getPath()  + ".form.html" + profilePage : "#anonymous#";
    }


    if(!entry.isPage()) {%>
        <div class="detail-top row clearfix">
            <div class="avatar-column">
                <a href="<%=xssAPI.getValidHref(profileUrl)%>"><img style="width:45px;height:45px" src="<%=xssAPI.getValidHref(resourceAuthorAvatar)%>" alt="<%=xssAPI.encodeForHTMLAttr(entry.getAuthor())%>" title="<%=xssAPI.encodeForHTMLAttr(entry.getAuthor())%>"/></a>
            </div>
            <div class="info-column">
                <div class="text-heading">
                    <h1><%= xssAPI.filterHTML(entry.getTitle()) %></h1>
                    <span><%
                        if (!Journal.ANONYMOUS.equals(entry.getAuthor())) {%>
                        <span class="username"><a href="#"><%= xssAPI.encodeForHTML(I18n.get(bundle, "{0}", "Used to display a journal entry's author", entry.getAuthor())) %></a></span><%
                        }%>
                        <%=DateFormat.getDateInstance(DateFormat.MEDIUM,Locale.ENGLISH).format(entry.getDate())%>
                    </span>
                </div>
            </div>
        </div><%
    }%><%

%>
