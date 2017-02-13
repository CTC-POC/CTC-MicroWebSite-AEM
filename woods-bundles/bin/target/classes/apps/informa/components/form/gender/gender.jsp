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
        com.day.cq.wcm.foundation.forms.FormsHelper,
		java.util.ResourceBundle,
		com.day.cq.i18n.I18n,
        org.apache.sling.commons.json.JSONArray,
		org.apache.sling.commons.json.JSONObject,
		org.apache.sling.commons.json.*,               
		com.day.cq.wcm.api.Page" %><%

	final ResourceBundle  resourceBundle =(ResourceBundle)application.getAttribute("LocaleResourceBundle");
    I18n i18n = new I18n(resourceBundle);
    String name = "__Gender";
	final boolean required = properties.get("required", false);
	final String requiredMessage = properties.get("requiredMessage", "");

	String title = i18n.getVar(FormsHelper.getTitle(resource, "Gender"));
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

        String jsonURL="/apps/informa/components/form/gender/values.json/jcr:content";

        Resource res=resourceResolver.getResource(jsonURL); 

		ValueMap jcrProp=res.adaptTo(ValueMap.class); 
		String jsonData=jcrProp.get("jcr:data",String.class); 

		Map<String,String> genderItem = new LinkedHashMap<String,String>();
		if (jsonData != null) {     

    	JSONObject genderObject = new JSONObject(jsonData);

    	JSONArray genderArray = genderObject.getJSONArray("root"); 

       for(int i = 0; i < genderArray.length(); i++) {          

          JSONObject jsonObject = genderArray.getJSONObject(i); 
           String genderText=jsonObject.getString("text"); 
           String genderValue=jsonObject.getString("value"); 
           genderItem.put(genderText,genderValue);  
       }

       }

        String Gender = genderItem.toString();
		String[] Genders = Gender.substring(1, Gender.length()-1).split(",");
		currentNode.setProperty("options",Genders);
		currentNode.getSession().save();

            displayValues = genderItem;

    }


%>
<input type="hidden" value="<%=required%>" id="genderreq">
<input type="hidden" value="<%=requiredMessage%>" id="genderreqMesg">
    <div class="form-group">
      <label for="Gender" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo"><%=title%>
<%if(required==true){%>
            <span class="asterisk-sign-clr">*</span>
            <%}%>
        </label>
       <div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div">
      <select name="gender" class="form-control custom-form-control selectpicker custom-select-box gender" data-size="5" id="Gender">

        <%
        for(String key : displayValues.keySet()) {
            String v = xssAPI.encodeForHTML(key);
            String t = displayValues.get(key);
            t = xssAPI.encodeForHTML(t);
            
                %>

          <option value="<%=v%>"><%=t%></option><%                        
            
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


