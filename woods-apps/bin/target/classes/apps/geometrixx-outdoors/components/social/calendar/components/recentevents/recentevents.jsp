<%@page session="false"%><%@ taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %>
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
  Show [maxEvents] most recent events in history.

--%>
<%@include file="/libs/foundation/global.jsp" %>
<%
%>
<%@ page import="com.day.cq.i18n.I18n,
                 org.apache.commons.collections.IteratorUtils,
                 org.apache.commons.lang.StringUtils,
                 org.apache.sling.api.request.RequestParameter,
                 org.apache.sling.api.resource.ResourceResolver,
                 org.apache.sling.api.resource.ResourceUtil,
                 javax.jcr.Node,
                 javax.jcr.NodeIterator,
                 java.util.Locale,
                 java.util.ResourceBundle,
                 java.util.Calendar,
                 java.util.Comparator,
                 java.util.TreeSet,
                 java.util.SortedSet,
                 java.util.Iterator,
                 java.text.SimpleDateFormat,
                 com.day.cq.wcm.foundation.Placeholder" %>
<cq:includeClientLib categories="cq.social.group"/>
<%

    final Locale pageLocale = currentPage.getLanguage(true);
    final ResourceBundle resourceBundle = slingRequest.getResourceBundle(pageLocale);
    final I18n i18n = new I18n(resourceBundle);

    String[] monthName = {i18n.get("Jan"), i18n.get("Feb"),
            i18n.get("Mar"), i18n.get("Apr"), i18n.get("May"), i18n.get("Jun"), i18n.get("Jul"),
            i18n.get("Aug"), i18n.get("Sep"), i18n.get("Oct"), i18n.get("Nov"),
            i18n.get("Dec")};
    
    String componentTitle = properties.get("title", "");
    String calendarPagePath = properties.get("calendarPagePath", ""); %>

    <div class="title clearfix">
        <h2><%
            if(componentTitle != null) { %>
                <%=xssAPI.encodeForHTML(componentTitle) %><%
            } 
            else { %>
                <%= i18n.get("Events")%><%
            }%>
        </h2><%
        if(calendarPagePath != null && calendarPagePath != "") { %>
            <a href="<%= xssAPI.getValidHref(calendarPagePath) %>.html"><%= i18n.get("calendar +") %></a><%
        }%>
    </div><%

    if(calendarPagePath != null && calendarPagePath != "") {

        String calendarPath = calendarPagePath + "/jcr:content/par/calendar";

        Resource r = slingRequest.getResourceResolver().getResource(calendarPath);
        Node calendarNode = r.adaptTo(Node.class);
        
        if (calendarNode.hasNode("events")) { %>
            <div class="sidebar-content"><%
            Iterator<Node> iterator = calendarNode.getNode("events").getNodes();
            
            // Comparator for event nodes
            Comparator<Node> comp = new Comparator<Node>() {
                public int compare(Node n1, Node n2) {
                    try {
                        Calendar d1 = n1.getProperty("start").getDate();
                        Calendar d2 = n2.getProperty("start").getDate();
                        if (d1 == null && d2 == null) return 0;
                        if (d1 == null || d1.before(d2) ) return -1;
                        if (d2 == null || d1.after(d2) ) return 1;
                        return 0;
                    } catch (Exception e) {
                        return 0;
                    }
                }
            };

            // Prefilter and sort events
            TreeSet<Node> set = new TreeSet<Node>(comp);
            while (iterator.hasNext()) { 
                Node childNode = iterator.next();
                
                Calendar now = Calendar.getInstance();
                Calendar start = childNode.getProperty("start").getDate();
                Calendar end = childNode.getProperty("end").getDate();
                
                if(start.before(now)) {
                    set.add(childNode);
                }
            }

            // Use the iterator of our sorted set, not the original one
            iterator = set.iterator();

            // Is maxEvents configured?
            Integer maxEvents = properties.get("maxEvents", Integer.class);            
            if (maxEvents == null) maxEvents = 3;

            // Output events
            Integer i = set.size() + 1;
            while (iterator.hasNext()) { 
                Node childNode = iterator.next();
                i--;
                
                // Only output most recent events
                if (i > maxEvents) continue;
               
                // TODO These formats are not localized.
                SimpleDateFormat formatter = new SimpleDateFormat("EEEE, MMM. d, yyyy hh:mm a");
                SimpleDateFormat eventTimeFormatter = new SimpleDateFormat("k:mm a");
                
                String eventTitle = childNode.getProperty("jcr:title").getString();
                
                Calendar now = Calendar.getInstance();
                Calendar start = childNode.getProperty("start").getDate();
                Calendar end = childNode.getProperty("end").getDate();
                
                String startDate = formatter.format(start.getTime());
                String endDate = formatter.format(end.getTime());
                
                boolean multiDay = false;
                String dateFull = startDate;
                if (!startDate.equals(endDate)) {
                    multiDay = true;
                    dateFull = startDate + " " + i18n.get("to") + " " + endDate;
                }
                %>
                <div class="slot clearfix">
                    <a class="clickable clearfix" href="<%= xssAPI.getValidHref(calendarPagePath) %>.html">
                        <div class="event-date">
                            <span><%= monthName[start.get(Calendar.MONTH)] %></span>
                            <h2><%= start.get(Calendar.DAY_OF_MONTH) %></h2>
                        </div>
                        <div class="text-heading">  
                            <h1><%= xssAPI.encodeForHTML(eventTitle) %></h1>
                            <span class="date"><%= xssAPI.encodeForHTML(dateFull) %></span>
                        </div>
                    </a>
                </div><%
            }%>
            </div><%
        } else {
            // TODO: define behavior here. For now, don't render sideblock content if there are no events. 
        }
    }
    else { %>
        <%= Placeholder.getDefaultPlaceholder(slingRequest, i18n.get("Recent Events - No calendar page path set."), "", "error") %>
   <% }
%>
