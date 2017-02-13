<%@page session="false"%>
<%@include file="/libs/foundation/global.jsp"%><%
%><%@ page import="com.day.cq.wcm.foundation.TextFormat,
    				com.day.cq.wcm.api.WCMMode,
                   com.day.cq.wcm.foundation.forms.FormsHelper,
                   com.day.cq.wcm.foundation.forms.LayoutHelper,
                   com.day.cq.wcm.foundation.forms.FormResourceEdit,
				   java.util.ResourceBundle,java.util.Locale,
				   com.day.cq.i18n.I18n" %><%

	final ResourceBundle  resourceBundle =(ResourceBundle)application.getAttribute("LocaleResourceBundle");
	I18n i18n = new I18n(resourceBundle); 

    final String name = "contentDownload";
    final String id = FormsHelper.getFieldId(slingRequest, resource);

    String title = i18n.getVar(FormsHelper.getTitle(resource, "Content Download"));
    Resource resparent = resource.getParent();
	ValueMap parentProperties = resparent.getParent().getValueMap();
	Boolean formError = parentProperties.get("formerror",false);

    String URL = properties.get("jcr:url",String.class);
	String downloadLabel = properties.get("jcr:downloadLabel",String.class);
    String contentDownload =  properties.get("./contentDownload",String.class);
	String contentType =  properties.get("./contentType",String.class);
	String downloadImage =  properties.get("./downloadImage",String.class);
	String downloadAltText =  properties.get("./downloadAltText",String.class);

	if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
            String classicPlaceholder = "Content Download";			
        %>
	<div class="form-group">
        <label for="ContentDownload" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo"><%=title%>
        </label>
             <div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div">
				<a href= "<%=URL%>" download><%=downloadLabel%></a> 

            </div>
	    </div>
<%}%>
			<input type="hidden" name="contentDownload" id= "contentDownload" value="<%=contentDownload%>"/>
            <input type="hidden" name="contentType" id= "contentType" value="<%=contentType%>"/>
		    <input type="hidden" name="downloadLabel" id= "urlFile" value="<%=downloadLabel%>"/>
		    <input type="hidden" name="urlValue" id= "urlValue" value="<%=URL%>"/>
			<input type="hidden" name="downloadImage" id= "downloadImage" value="<%=downloadImage%>"/>
			<input type="hidden" name="downloadAltText" id= "downloadAltText" value="<%=downloadAltText%>"/>
