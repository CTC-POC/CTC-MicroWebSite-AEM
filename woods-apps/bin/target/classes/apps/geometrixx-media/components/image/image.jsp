<%@page session="false"%><%--
  Copyright 1997-2010 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Form 'element' component

  Draws an image element of a form

--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@ page import="java.util.ResourceBundle,
        com.day.cq.commons.Doctype,
        com.day.cq.wcm.foundation.Image,
        com.day.cq.wcm.foundation.forms.FormsHelper,
        com.day.cq.wcm.foundation.forms.LayoutHelper,
        java.util.Locale" %><%
    final Locale pageLocale = currentPage.getLanguage(true);
    final ResourceBundle bundle = slingRequest.getResourceBundle(pageLocale);
    String name = FormsHelper.getParameterName(resource);
    String id = FormsHelper.getFieldId(slingRequest, resource);
    boolean required = FormsHelper.isRequired(resource);
    final boolean hideTitle = properties.get("hideTitle", false);
    boolean readOnly = FormsHelper.isReadOnly(slingRequest, resource);
    String title = FormsHelper.getTitle(resource, bundle.getString("Image"));
    Resource imgRes = FormsHelper.getResource(slingRequest, resource, name);
    Image img = null;
    if (imgRes != null) {
        img = new Image(imgRes);
        img.setDoctype(Doctype.fromRequest(request));
        img.setItemName(Image.NN_FILE, ".");
        img.setSelector("img");
        img.setNoPlaceholder(true);
        Long width = properties.get("width", Long.class);
        if (width != null) {
            img.set(Image.PN_HTML_WIDTH, String.valueOf(width));
        }
        Long height = properties.get("height", Long.class);
        if (height != null) {
            img.set(Image.PN_HTML_HEIGHT, String.valueOf(height));
        }
    }

    String inputID = "";
    if (currentNode != null) {
        inputID = currentNode.getPath().replace("/","").replace(":","-");
    }
    %><div class="form_row">
        <% LayoutHelper.printTitle(id, title, required, hideTitle, out); %>
<%
    if (img != null) {
        %><div class="form_rightcol"><% img.draw(out); %></div><%
    }
    if (!readOnly) {
        String msg;
        if (img != null) {
            msg = bundle.getString("Upload new image:");
        } else {
            msg = bundle.getString("Upload image:");
        }
%>
        <div class="form_rightcol hidden"><input id="<%=inputID %>" class="<%= FormsHelper.getCss(properties, "form_field form_field_file") %>" name="<%= name %>" type="file" size="28"></div>
        <a href="#" id="<%=inputID%>_link"><%=msg%></a>
        <script type="text/javascript">
            $(function(){
                $("#<%=inputID%>_link").on('click', function(e){
                    e.preventDefault();
                    $("#<%=inputID%>:hidden").trigger('click');
                });
            });
        </script>
<%
    }
%>
    </div><%
    LayoutHelper.printDescription(FormsHelper.getDescription(resource, ""), out);
%>
