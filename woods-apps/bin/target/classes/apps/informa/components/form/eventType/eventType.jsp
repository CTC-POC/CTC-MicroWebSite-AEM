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

  Draws an element of a form

--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@ page import="java.util.LinkedHashMap,
        java.util.List,
        java.util.*,
        java.util.Map,
        java.util.Collections,
        com.day.cq.wcm.foundation.forms.FormsHelper,
        com.day.cq.wcm.foundation.forms.LayoutHelper,
		java.util.Locale,
		java.util.ResourceBundle,
		com.day.cq.i18n.I18n,
        org.apache.sling.commons.json.JSONArray,
org.apache.sling.commons.json.JSONObject,org.apache.sling.commons.json.*,
com.day.cq.wcm.api.PageFilter,         
com.day.cq.wcm.api.NameConstants,         
com.day.cq.wcm.api.Page" %><%

final ResourceBundle resourceBundle = slingRequest.getResourceBundle(null);
I18n i18n = new I18n(resourceBundle); 

    String name = "__EventType";
    if(name != null)
	name = xssAPI.encodeForHTMLAttr(name);
    String id = FormsHelper.getFieldId(slingRequest, resource);
  
    final boolean hideTitle = properties.get("hideTitle", false);
final boolean required = properties.get("required", false);
	final String requiredMessage = properties.get("requiredMessage", "");
    final String title = FormsHelper.getTitle(resource, i18n.get("Event Type"));

    final List<String> values = FormsHelper.getValuesAsList(slingRequest, resource);
final String tooltip=properties.get("tooltip",String.class);
Resource resparent = resource.getParent();
	ValueMap parentProperties = resparent.getParent().getValueMap();
	Boolean formError = parentProperties.get("formerror",false);
	String dataplacement = "right";
	if(formError)
    {
        dataplacement="bottom";
    }

    Map<String, String> displayValues = FormsHelper.getOptions(slingRequest, resource);
    if ( displayValues == null ) {
        displayValues = new LinkedHashMap<String, String>();

        String jsonURL="/apps/informa/components/form/eventType/values.json/jcr:content";

        Resource res=resourceResolver.getResource(jsonURL); 

		ValueMap jcrProp=res.adaptTo(ValueMap.class); 
		String jsonData=jcrProp.get("jcr:data",String.class); 

		Map<String,String> eventTypeItem = new LinkedHashMap<String,String>();
		if (jsonData != null) {     

    	JSONObject eventTypeObject = new JSONObject(jsonData);

    	JSONArray eventTypeArray = eventTypeObject.getJSONArray("root"); 

       for(int i = 0; i < eventTypeArray.length(); i++) {          

          JSONObject jsonObject = eventTypeArray.getJSONObject(i); 
           String eventTypeText=jsonObject.getString("text"); 
           String eventTypeValue=jsonObject.getString("value"); 
           eventTypeItem.put(eventTypeText,eventTypeValue);  


       } 

}  

String eventType = eventTypeItem.toString();
String[] eventTypes = eventType.substring(1, eventType.length()-1).split(",");
currentNode.setProperty("options",eventTypes);
currentNode.getSession().save();

        displayValues = eventTypeItem;
    }
    final boolean multiSelect = FormsHelper.hasMultiSelection(resource);
    final String width = xssAPI.encodeForHTMLAttr(properties.get("width", ""));
%>
<input type="hidden" value="<%=required%>" id="eventtypereq">
<input type="hidden" value="<%=requiredMessage%>" id="eventtypereqMesg">
    <div class="form-group">
      <label for="Event Type" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo"><%=title%>
<%if(required==true){%>
            <span class="asterisk-sign-clr">*</span>
            <%}%>
        </label>
       <div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div">
      <select name="Event Type" class="form-control custom-form-control selectpicker custom-select-box" data-size="5" id="Event Type">
          <option disabled selected>Select EventType</option>
        <%
        for(String key : displayValues.keySet()) {
            String v = xssAPI.encodeForHTML(key);
            String t = displayValues.get(key);
            t = xssAPI.encodeForHTML(t);
            if ( values.contains(v) ) {
                %><option value="<%=v%>" selected><%=t%></option><%
            } else {
                %>

          <option value="<%=v%>"><%=t%></option><%                        
            }
        }
        %></select>
           <% 
                if(tooltip!=null){
                      %>  
                     <span class="custom-tool-tip  ">
            <a  href="javascript:void(0)" class="tooltip-mobile hidden-xs" data-toggle="tooltip" data-placement="<%=dataplacement%>" title="<%=tooltip%>">
                <img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
            </a>
            <a  href="javascript:void(0)" class="tooltip-mobile visible-xs " data-toggle="tooltip" data-placement="bottom" title="<%=tooltip%>">
                <img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
            </a>
            </span>
                <%}%>
          </div>
        </div>
    <%
    LayoutHelper.printDescription(FormsHelper.getDescription(resource, ""), out);
    LayoutHelper.printErrors(slingRequest, name, hideTitle, out);
%>

