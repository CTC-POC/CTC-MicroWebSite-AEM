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
<%

	final ResourceBundle  resourceBundle =(ResourceBundle)application.getAttribute("LocaleResourceBundle");
I18n i18n = new I18n(resourceBundle);

		
    String name = "title";

   
	final boolean required = properties.get("required", false);
	final String requiredMessage = properties.get("requiredMessage", "");
    String title = i18n.getVar(FormsHelper.getTitle(resource, "Title"));
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

        String jsonURL="/apps/informa/components/form/title/values.json/jcr:content";

        Resource res=resourceResolver.getResource(jsonURL); 

		ValueMap jcrProp=res.adaptTo(ValueMap.class); 
		String jsonData=jcrProp.get("jcr:data",String.class); 

		Map<String,String> TitleItem = new LinkedHashMap<String,String>();
		if (jsonData != null) {     

    	JSONObject TitleObject = new JSONObject(jsonData);

    	JSONArray TitleArray = TitleObject.getJSONArray("root"); 

       for(int i = 0; i < TitleArray.length(); i++) {          

          JSONObject jsonObject = TitleArray.getJSONObject(i); 
           String TitleText=jsonObject.getString("text"); 
           String TitleValue=jsonObject.getString("value"); 
           TitleItem.put(TitleText,TitleValue);  

       } 

}

String Title = TitleItem.toString();
String[] Titles = Title.substring(1, Title.length()-1).split(",");
currentNode.setProperty("options",Titles);
currentNode.getSession().save();

 displayValues = TitleItem;
    }

    
%>
<input type="hidden" value="<%=required%>" id="titlereq">
<input type="hidden" value="<%=requiredMessage%>" id="titlereqMesg">
    <div class="form-group">
      <label for="title" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo"><%=title%>
<%if(required==true){%>
            <span class="asterisk-sign-clr">*</span>
            <%}%>
        </label>
     <div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div">
      <select name="title" class="form-control custom-form-control selectpicker custom-select-box title" data-size="5" id="title">

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
<input type="hidden" name="titleSelectedText" id="titleText">    

<script>
       var selectedText ="";
       var selectedValue ="";
 		$(function () {
        $("#title").change(function () {
            selectedText = $(this).find("option:selected").text();
            selectedValue = $(this).val();
                 $("#titleText").val(selectedText);
        });
    });

</script>



