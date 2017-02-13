<%@ page session="false" %>
<%@include file="/libs/foundation/global.jsp"%>
<%@ page import="java.text.SimpleDateFormat, com.day.cq.wcm.foundation.Image,
         com.day.cq.commons.Doctype,com.day.cq.wcm.api.components.DropTarget, com.day.cq.wcm.foundation.Placeholder,
         java.util.Calendar, com.day.cq.wcm.api.Page" %>
<%
    Resource imageRes = null;
    Node listItem = ((Page)request.getAttribute("listitem")).adaptTo(Node.class);
    String pagePath = listItem.getPath();
    if(listItem.hasNode("jcr:content")){
        listItem = listItem.getNode("jcr:content");
    }
    if (listItem.hasNode("image")) {
        Node imageNode = listItem.getNode("image");
        imageRes = resourceResolver.getResource(imageNode.getPath());
    }
    Calendar createdDate = listItem.getProperty("jcr:created").getDate();
    SimpleDateFormat date_format = new SimpleDateFormat("d MMM yyyy");
    String listItemTitle = "";
    String listItemDescription = "";
    Image img = null;
    if(imageRes != null){
        img = new Image(imageRes);
        img.setSelector(".img"); // use image script
    }
    
    if(listItem.hasProperty("jcr:description")){
        listItemDescription = listItem.getProperty("jcr:description").getString();
    }
    if(listItem.hasProperty("jcr:title")){
        listItemTitle = listItem.getProperty("jcr:title").getString();
    }
%>

<li>
    <div class="community">
        <div class="row-fluid clearfix">
            <% if(img != null) {img.draw(out); } %>
            <div class="community-detail">
                <h5><%= listItemTitle %></h5>
                <p class="date"> Created <%= date_format.format(createdDate.getTime()) %></p>
                <p><%= listItemDescription %></p>
                <a href="<%= pagePath %>.html">enter &gt;</a>
            </div>
        </div>
    </div>
</li>