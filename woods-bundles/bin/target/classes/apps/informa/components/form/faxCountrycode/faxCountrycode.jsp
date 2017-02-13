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


    String name = "__FaxCountrycode";

	final boolean required = properties.get("required", false);
	final String requiredMessage = properties.get("requiredMessage", "");

	String title = i18n.getVar(FormsHelper.getTitle(resource, "Fax Country Code"));
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

        String jsonURL="/apps/informa/components/form/faxCountrycode/values.json/jcr:content";

        Resource res=resourceResolver.getResource(jsonURL); 

		ValueMap jcrProp=res.adaptTo(ValueMap.class); 
		String jsonData=jcrProp.get("jcr:data",String.class); 

		Map<String,String> faxCountrycodeItem = new TreeMap<String,String>();
		if (jsonData != null) {     

    	JSONObject faxCountrycodeObject = new JSONObject(jsonData);

    	JSONArray faxCountrycodeArray = faxCountrycodeObject.getJSONArray("root"); 

       for(int i = 0; i < faxCountrycodeArray.length(); i++) {          

          JSONObject jsonObject = faxCountrycodeArray.getJSONObject(i); 
           String faxCountrycodeText=jsonObject.getString("text"); 
           String faxCountrycodeValue=jsonObject.getString("value"); 
           faxCountrycodeItem.put(faxCountrycodeText,faxCountrycodeValue);  


       } 

}  

 String faxCountrycode = faxCountrycodeItem.toString();
String[] faxCountrycodes = faxCountrycode.substring(1, faxCountrycode.length()-1).split(",");
currentNode.setProperty("options",faxCountrycodes);
currentNode.getSession().save();

        displayValues = faxCountrycodeItem;
    }



	ValueMap parentProps = resource.getParent().getValueMap();
	String faxClass = parentProps.get("faxClass","personal");
%>
<input type="hidden" value="<%=required%>" id="<%=faxClass%>faxcountrycodereq">
<input type="hidden" value="<%=requiredMessage%>" id="<%=faxClass%>faxcountrycodereqMesg">
    <div class="form-group">
      <label for="faxCountrycode" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo"><%=title%>
<%if(required==true){%>
            <span class="asterisk-sign-clr">*</span>
            <%}%>
        </label>
       <div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div">
      <select name="<%=faxClass%>FaxCountryCode" class="form-control custom-form-control selectpicker custom-select-box <%=faxClass%>faxCountrycode" data-size="5" id="faxCountrycode">

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

