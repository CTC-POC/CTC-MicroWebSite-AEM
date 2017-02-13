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
		com.informa.components.commons.Multifield,
		com.informa.components.commons.model.MultifieldModel,
		java.util.Iterator,
        org.apache.sling.commons.json.JSONArray,
		org.apache.sling.commons.json.JSONObject,
		org.apache.sling.commons.json.*,               
		com.day.cq.wcm.api.Page" %>
<% 
final ResourceBundle  resourceBundle =(ResourceBundle)application.getAttribute("LocaleResourceBundle");
	I18n i18n = new I18n(resourceBundle);
        
		final String tooltip=properties.get("tooltip",String.class);
        Resource resparent = resource.getParent();
        ValueMap parentProperties = resparent.getParent().getValueMap();
        Boolean formError = parentProperties.get("formerror",false);
        String dataplacement = "right";
        if(formError)
        {
            dataplacement="bottom";
        }		

		final String title =  i18n.getVar(properties.get("jcr:title", "Product Type")) ;
		final String defaultText =properties.get("jcr:defaultText", "Please select the product type");
        final boolean required = properties.get("required", false);
        final String requiredMessage = properties.get("requiredMessage", "");


		Multifield multifield=resource.adaptTo(Multifield.class);
        MultifieldModel productTypes = null;
        Iterator listOfProducts=null;
        List productList=multifield.getChildList();

        if( null != productList && !productList.isEmpty()){
			listOfProducts=productList.iterator();
        }	



%>
<input type="hidden" value="<%=required%>" id="producttypereq">
<input type="hidden" value="<%=requiredMessage%>" id="producttypereqMesg">
    <div class="form-group">
      <label for="productType" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo"><%=title%>
<%if(required==true){%>
            <span class="asterisk-sign-clr">*</span>
            <%}%>
        </label>
       <div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div">
      <select name="informaProductCode" class="form-control custom-form-control selectpicker custom-select-box productType" data-size="5" id="productType">
          <% if(null != listOfProducts){

          %>

			<option value=""><%= defaultText %></option> 
          <%

                while(listOfProducts.hasNext()){
				productTypes = (MultifieldModel)listOfProducts.next();



			%>  
          <option value="<%= productTypes.getNatureOfBusinessCode()%>"><%= productTypes.getBusinessHiddenName() %></option>   
          <%
             }
        		} 
else{
 %>   
			 <option value=""><%= defaultText %></option> 
<%
}
      	 %>     
       </select>
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
    
