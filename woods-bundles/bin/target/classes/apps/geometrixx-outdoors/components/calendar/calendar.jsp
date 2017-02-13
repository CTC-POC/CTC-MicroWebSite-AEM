<%@ taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0"%>
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

     Community List

--%>
<%@include file="/libs/foundation/global.jsp"%>
<%
%>
<%@ page
  import="
            java.util.Calendar,
            java.util.Locale,
            java.util.List,
            java.util.ResourceBundle,
            java.util.TimeZone,
            java.util.Iterator,
            javax.jcr.query.Query,
            javax.jcr.Node,
            javax.jcr.RepositoryException,
            org.apache.jackrabbit.JcrConstants,
            org.apache.sling.api.resource.Resource,
            com.adobe.cq.social.calendar.CalendarConstants,
            com.adobe.cq.social.calendar.CalendarException,
            com.adobe.cq.social.calendar.CalendarManager,
            com.adobe.cq.social.calendar.CalendarUtil,
            com.adobe.cq.social.calendar.CqCalendar,
            com.adobe.cq.social.commons.CollabUtil,
            com.adobe.granite.security.user.UserProperties,
            com.day.cq.commons.jcr.JcrUtil,
            com.day.cq.i18n.I18n
  "%><div>
<cq:includeClientLib categories="cq.social.group" />
<cq:includeClientLib categories="cq.social.calendar.fullcalendar" />
<cq:includeClientLib categories="cq.social.calendar.calendar" />
<cq:includeClientLib categories="cq.social.calendar.eventbasics" />
<%
        final Locale pageLocale = currentPage.getLanguage(true);
        final ResourceBundle resourceBundle = slingRequest.getResourceBundle(pageLocale);
        final I18n i18n = new I18n(resourceBundle);
        final Session session = slingRequest.getResourceResolver().adaptTo(Session.class);

        String[] monthName =
            {i18n.get("Jan"), i18n.get("Feb"), i18n.get("Mar"), i18n.get("Apr"), i18n.get("May"), i18n.get("Jun"),
                i18n.get("Jul"), i18n.get("Aug"), i18n.get("Sep"), i18n.get("Oct"), i18n.get("Nov"), i18n.get("Dec")};

        Node node = resource.adaptTo(Node.class);
        Resource ugcCalResource = resourceResolver.getResource("/content/usergenerated" + node.getPath());
        CalendarManager ugcCalMgr = null;
        CqCalendar calendar = null;
        String ugcPath = "/content/usergenerated" + node.getPath();
        String submitEventLink = ugcPath + "/.form.create.html" + currentPage.getPath() + "/eventeditor";
        String timeZoneID = pageProperties.getInherited("calendar/timeZone", TimeZone.getDefault().getID());
        TimeZone timeZone = CalendarUtil.getTimeZone(timeZoneID);
        String dateMonth = "/" + CalendarUtil.getDatePath(Calendar.getInstance(), true);
        String divId = "mini-calendar-" + CollabUtil.generateRandomString(5);
        if (ugcCalResource != null) {
            ugcCalMgr = ugcCalResource.getResourceResolver().adaptTo(CalendarManager.class);
            calendar = ugcCalMgr.getCalendar(ugcPath);
            submitEventLink =
                ugcCalResource.getPath() + "/.form.create.html" + currentPage.getPath()
                        + "/eventeditor?wcmmode=disabled";
        } else {
            if (CollabUtil.canAddNode(session, currentPage.getPath())) {
                try {
                    // Check for calendar page //specific to community samples
                    final Node calNode = JcrUtil.createPath(ugcPath, JcrConstants.NT_UNSTRUCTURED, session);
                    if (!calNode.isNodeType(CalendarConstants.MIX_CALENDAR)) {
                        calNode.addMixin(CalendarConstants.MIX_CALENDAR);
                        // set default resource type
                        calNode.setProperty("sling:resourceType", "social/calendar");
                    }
                    CollabUtil.save(slingRequest.getResourceResolver());
                    calendar = resourceResolver.getResource(calNode.getPath()).adaptTo(CqCalendar.class);
                } catch (final RepositoryException e) {
                    throw new CalendarException("Cannot create calendar at " + ugcPath, e);
                }
            }
        }
        final ValueMap values = resource.adaptTo(ValueMap.class);
        final boolean showAll = (values != null) ? values.get("showAll", false) : false;
    String calPaths = "";
        final UserProperties loggedInUserProperties = slingRequest.getResourceResolver().adaptTo(UserProperties.class);
        final String loggedInUserID = (loggedInUserProperties == null) ? null : loggedInUserProperties.getAuthorizableID();

    if(showAll) {
            final String calendarType = resource.getResourceType();
            String root = currentPage.getPath();
            if (root.indexOf("subcommunities") > 0) {
                //nested community
                root = root.substring(0, root.indexOf("subcommunities")-1);
            }
            root = currentPage.getParent().getPath();
            // get community root page
            if(root.lastIndexOf("/")>0) {
                root = root.substring(0, root.lastIndexOf("/"));
            }
            List<String> allCalendars = null;
            for(String cal:allCalendars){
                calPaths = calPaths + ";" + "/content/usergenerated" + cal;
            }
            if(calPaths.length()>=1){
                calPaths = calPaths.substring(1);
            }

        }else{
            calPaths = ugcPath;
        }
%>
<aside class="calendar-detail-aside">
  <div id="<%=divId%>"></div>
</aside>
<div class="soco-calendar-detail">
  <header class="soco-event-header">
    <%
        if (CollabUtil.canAddNode(session, currentPage.getPath())) {
    %>
    <button id="calendarSubmit" type="button" class="btn action"
      onclick="return CQ.soco.calendar.eventbasics.showUGCFormAsDialog('<%=xssAPI.encodeForJSString(submitEventLink)%>', $CQ('.edit-event'))"><%= i18n.get("Submit Event!") %></button>
    <%
        }
    %>
  </header>
  <%
      if (calendar != null) {
  %>
  <div class="event-wrapper section">
    <div class="event-accordion-block"></div>
  </div>
  <%
      } else {
  %><%=i18n
                    .get("Ready to meet some of the people in your community? Whether its a happy hour mixer, a presentation your latest trip, or a clinic on gear maintenance. Create an event and have others join you.")%>
  <%
      }
  %>
</div>
  <div class="edit-event" title="Event Dialog"></div>
  <script type="text/javascript">
  $CQ(function($) { 
    <%if (calendar != null) { %>
       var calPaths = "<%=xssAPI.encodeForJSString(calPaths)%>";
       var ugcPath = calPaths.split(';');
       var divId = '#' + "<%=divId%>";
       var _cal = CQ.soco.calendar.utils.invokeFullCalendar($CQ(divId), ugcPath /*, handler*/ );
       _cal.on(CQ.soco.calendar.events.NEWEVENTSFETCHED, function(e, data) {
         if (data && data.length > 0) {
           CQ.soco.calendar.utils.createEventList($CQ('.event-accordion-block'), data, true);
           $CQ('.fc-day').removeClass('highlight');
           _cal.fullCalendar('rerenderEvents');
         } else {
           $CQ('.event-accordion-block').empty();
           $CQ('.fc-day').removeClass('highlight');
           var noEventText = CQ.shared.I18n.getMessage("No Events for this month, show all ");
           var pastEventLinkText = CQ.shared.I18n.getMessage("past events...");
           var ahref = $CQ("<a href='#'/>").text(pastEventLinkText).click(function() {
             CQ.soco.calendar.utils.createFullEventList($CQ('.event-accordion-block'), ugcPath);
           });
           $CQ('.event-accordion-block').append($CQ('<h1>' + noEventText + '</h1>').append(ahref));
         }
       });

       _cal.on(CQ.soco.calendar.events.DAYCLICK, function(e, date, filter) {
         CQ.soco.calendar.utils.filterEventList($CQ('.event-accordion-block'), date, filter);
       });

       $CQ('.event-accordion-block').on(CQ.soco.calendar.events.EVENTSDELETED, function(e, data) {
         _cal.fullCalendar('refetchEvents');
       });

       $CQ('.edit-event').on(CQ.soco.calendar.events.EVENTSMODIFIED, function(e, data) {
         _cal.fullCalendar('refetchEvents');
       });
//Sample Specific - Hide the calendar Widget in the page is landing page
       if ($CQ('body').hasClass('community-start')) {
        _cal.hide();
       }
    <%} %>
  });
  </script>
  <div style="clear:both;"></div>
</div>
