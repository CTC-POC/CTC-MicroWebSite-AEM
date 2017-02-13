<%@page session="false"%><%--
  Copyright 1997-2011 Day Management AG
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
%><%@ page import="com.day.cq.wcm.foundation.TextFormat,
                   com.day.cq.wcm.foundation.forms.FormsHelper,
                   com.day.cq.wcm.foundation.forms.LayoutHelper,
                   com.day.cq.wcm.foundation.forms.FormResourceEdit,
				   java.util.ResourceBundle,java.util.Locale,
				   com.day.cq.i18n.I18n" %><%

final ResourceBundle  resourceBundle =(ResourceBundle)application.getAttribute("LocaleResourceBundle");
I18n i18n = new I18n(resourceBundle);  
					
    final String name ="addressPostcode";
    final String id = FormsHelper.getFieldId(slingRequest, resource);
     final boolean required = properties.get("required",false);
	final String requiredMsg=properties.get("requiredMessage"," ");
    
	final String tooltip=properties.get("tooltip",String.class);
   
    String title = i18n.getVar(FormsHelper.getTitle(resource, "Address Postcode"));

   
   

	ValueMap parentProps = resource.getParent().getValueMap();
	String addressClass = parentProps.get("AddressClass","personal");
	String addressType = parentProps.get("AddressType","Shipping");
	Resource resparent = resource.getParent();
	ValueMap parentProperties = resparent.getParent().getValueMap();
	Boolean formError = parentProperties.get("formerror",false);
	String dataplacement = "right";
	if(formError)
    {
        dataplacement="bottom";
    }
    %><input type="hidden" value="<%=required%>" id="<%=addressClass%><%=addressType%>addressPostcodereq">
	<input type="hidden" value="<%=requiredMsg%>" id="<%=addressClass%><%=addressType%>addressPostcodereqMesg">
<div class="form-group">
        <label for="AddressPostcode" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo"><%=title%>
            <%if(required==true){%>
            <span class="asterisk-sign-clr">*</span>
            <%}%>
        </label>

            <div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div">
                <input aria-labelledby="AddressPostcode" name="<%=addressClass%><%=addressType%>AddressPostcode" class="form-control custom-form-control input-numbers" type="text" id="AddressPostcode">
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

