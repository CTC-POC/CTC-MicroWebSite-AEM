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
		com.day.cq.wcm.api.Page" %>

            <%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0"%><%

       final ResourceBundle  resourceBundle =(ResourceBundle)application.getAttribute("LocaleResourceBundle");
        I18n i18n = new I18n(resourceBundle);

        String name = "__PhonenumberCountrycode";
        final boolean required = properties.get("required", false);
        final String requiredMessage = properties.get("requiredMessage", "");
        String title = i18n.getVar(FormsHelper.getTitle(resource, "Phone number Country code"));
        final String tooltip=properties.get("tooltip",String.class);

    

    Map<String, String> displayValues = FormsHelper.getOptions(slingRequest, resource);
    if ( displayValues == null ) {

        displayValues = new LinkedHashMap<String, String>();

        String jsonURL="/apps/informa/components/form/phonenumberCountrycode/values.json/jcr:content";

        Resource res=resourceResolver.getResource(jsonURL); 

		ValueMap jcrProp=res.adaptTo(ValueMap.class); 
		String jsonData=jcrProp.get("jcr:data",String.class); 

		Map<String,String> phonenumCountrycodeItem = new TreeMap<String,String>();
		if (jsonData != null) {     

    	JSONObject phonenumberCountrycodeObject = new JSONObject(jsonData);

    	JSONArray phonenumberCountrycodeArray = phonenumberCountrycodeObject.getJSONArray("root"); 

       for(int i = 0; i < phonenumberCountrycodeArray.length(); i++) {          

          JSONObject jsonObject = phonenumberCountrycodeArray.getJSONObject(i); 
           String phonenumberCountrycodeText=jsonObject.getString("text"); 
           String phonenumberCountrycodeValue=jsonObject.getString("value"); 
           phonenumCountrycodeItem.put(phonenumberCountrycodeText,phonenumberCountrycodeValue);  

       } 

}


        String PhonenumberCountrycode = phonenumCountrycodeItem.toString();
		String[] PhonenumberCountrycodes = PhonenumberCountrycode.substring(1, PhonenumberCountrycode.length()-1).split(",");
		currentNode.setProperty("options",PhonenumberCountrycodes);
		currentNode.getSession().save();

        displayValues = phonenumCountrycodeItem;

    }
   

	
	Resource resparent = resource.getParent();
	ValueMap parentProperties = resparent.getParent().getValueMap();
	Boolean formError = parentProperties.get("formerror",false);
	String dataplacement = "right";
	if(formError)
    {
        dataplacement="bottom";
    }
    
    ValueMap parentProps = resource.getParent().getValueMap();
	String phoneClass = parentProps.get("phoneClass","personal");
	String phoneType = parentProps.get("phoneType","Mobile");
%>
<input type="hidden" value="<%=required%>" id="<%=phoneClass%><%=phoneType%>phonenumbercountrycodereq">
<input type="hidden" value="<%=requiredMessage%>" id="<%=phoneClass%><%=phoneType%>phonenumbercountrycodereqMesg">
    <div class="form-group">
      <label for="phonenumberCountrycode" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo"><%=title%>
<%if(required==true){%>
            <span class="asterisk-sign-clr">*</span>
            <%}%>
        </label>
       <div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div">
      <select name="<%=phoneClass%><%=phoneType%>PhoneNumberCountrycode" class="form-control custom-form-control selectpicker custom-select-box <%=phoneClass%><%=phoneType%>PhoneNumberCountrycode" data-size="5" id="phonenumberCountrycode">

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


