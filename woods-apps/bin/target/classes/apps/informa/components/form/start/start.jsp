<%@page session="false"%><%--
  Copyright 1997-2009 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Form 'start' component

  Draws the start of a form

--%><%@include file="/libs/foundation/global.jsp"%>
<%
%><%@ page import="com.day.cq.wcm.foundation.forms.ValidationInfo,
                 com.day.cq.wcm.foundation.forms.FormsConstants,
                 com.day.cq.wcm.foundation.forms.FormsHelper,
                 org.apache.sling.api.resource.Resource,
                 org.apache.sling.api.resource.ResourceUtil,
                 org.apache.sling.api.resource.ValueMap,
                 com.day.cq.commons.inherit.InheritanceValueMap,
                 java.util.concurrent.atomic.AtomicReference,
                 java.util.Locale,
                 com.day.cq.commons.inherit.HierarchyNodeInheritanceValueMap,
                 java.util.Map,
				 java.util.Random,
java.util.ResourceBundle,
                 org.apache.commons.lang.LocaleUtils,
javax.servlet.jsp.PageContext,

                 org.apache.sling.scripting.jsp.util.JspSlingHttpServletResponseWrapper, com.day.cq.wcm.foundation.Placeholder,java.text.SimpleDateFormat,java.util.Date"%><%
%><cq:setContentBundle/>
<cq:include script="abacus.jsp"/>
<%
   SimpleDateFormat dateFormat  = new SimpleDateFormat("dd-MM-yyyy");
String lang = WCMUtils.getInheritedProperty(currentPage, resourceResolver, "lang");
        final Locale myLocale;
		final ResourceBundle resourceBundle;

        if(lang !=null)
	{
        if(lang.contains("-"))
        {
            String[] language = lang.split("-"); 
            myLocale = new Locale(language[0], language[1]);
        }
        else
        {
            myLocale = LocaleUtils.toLocale(lang);
        }
        resourceBundle = slingRequest.getResourceBundle(myLocale);
}
else
{
    resourceBundle = slingRequest.getResourceBundle(null);
}

pageContext.setAttribute("LocaleResourceBundle",resourceBundle,PageContext.APPLICATION_SCOPE);

%>


 <%  FormsHelper.startForm(slingRequest, new JspSlingHttpServletResponseWrapper(pageContext)); %>

   <div class="form"><%
    %><%= Placeholder.getDefaultPlaceholder(slingRequest, "Form Start", "", "cq-marker-start") %><%
    componentContext.setDecorate(true);
    // check if we have validation erros
    final ValidationInfo info = ValidationInfo.getValidationInfo(request);
    if ( info != null ) {
        %><p class="form_error"><fmt:message key="Please correct the errors and send your information again."/></p><%
        final String[] msgs = info.getErrorMessages(null);
        if ( msgs != null ) {
            for(int i=0;i<msgs.length;i++) {
                %><p class="form_error"><%=msgs[i]%></p><%
            }
        }
    }
%>
<% 

		Boolean emailCheck = (Boolean)properties.get("emailcheck",Boolean.class);
		Boolean marketerEmailCheck = (Boolean)properties.get("marketerEmailCheck",Boolean.class);

        String from = (String)properties.get("from",String.class);
        String[] mailTo = (String[])properties.get("mailTo",String[].class);
        String[] cc = (String[])properties.get("cc",String[].class);
        String[] bcc = (String[])properties.get("bcc",String[].class);
        String subject = (String)properties.get("subject",String.class);
		String template = (String)properties.get("template",String.class);
		String thankyouPage = (String)properties.get("thankyouPage",String.class);
		String marketerTemplate = (String)properties.get("marketerTemplate",String.class);
        String paymentRedirection = (String)properties.get("paymentRedirection",String.class);

Resource resparent = resource.getParent();
ValueMap parentProperties = resparent.getParent().getValueMap();
String eventRelationship = parentProperties.get("./eventRelationship","");
String formType = parentProperties.get("./formType","");

Resource resource1 = currentPage.getContentResource();
InheritanceValueMap valueMap = new HierarchyNodeInheritanceValueMap(resource1);
String eventEditionCode = valueMap.getInherited("eventEditionCode","");
String eventEditionLongName = valueMap.getInherited("eventEditionLongName","");
String registrationCheck = valueMap.getInherited("./registrationCheck","");
String languageCode = parentProperties.get("./defaultLanguage","");

		if(emailCheck==null)
            emailCheck=false;
%>


<% 	if(mailTo!=null){
    for (String d: mailTo) { %>
<input type="hidden" name="mailTo" value=<%=d%>>
<% } 
}%>
<% 
    if(bcc!=null){
    for (String s: bcc) { %>
<input type="hidden" name="bcc" value=<%=s%>>
<% }
} %>


<% 	if(cc!=null){
    for (String d: cc) { %>
<input type="hidden" name="cc" value=<%=d%>>
<% } 
}%>

<input type="hidden" name="emailCheck" value="<%=emailCheck%>">
<input type="hidden" name="marketerEmailCheck" value="<%=marketerEmailCheck%>">

<input type="hidden" name="from" value="<%=from%>">
<input type="hidden" name="subject" value="<%=subject%>">
<input type="hidden" name="template" value="<%=template%>">
<input type="hidden" name="marketerTemplate" value="<%=marketerTemplate%>">     
<input type="hidden" name="thankyouPage" value="<%=thankyouPage%>.html">  
<input type="hidden" name="currentPage" value="<%=request.getRequestURI()%>">
<input type="hidden" name="paymentRedirection" value="<%=paymentRedirection%>.html">        

<input type="hidden" name="sessionID" value=""/>
<input type="hidden" name="registrationMethod" value="RM_ONLN"/>
<input type="hidden" name="registrationStatus" value="RS_PRERGSTR"/>
<input type="hidden" name="attendanceStatus" value=""/>
<input type="hidden" name="actionDateTime" value="<%=dateFormat.format(new Date())%>"/>
<input type="hidden" name="eventEditionCode" value="<%=eventEditionCode%>"/>
<input type="hidden" name="eventEditionLongName" value="<%=eventEditionLongName%>"/>
<input type="hidden" name="productName" value="<%=pageProperties.get("siteName")%>"/>
<input type="hidden" name="visitorType" value="<%=eventRelationship%>"/>     
<input type="hidden" name="languageCode" value="<%=languageCode%>"/>
<input type="hidden" name="formType" value="<%=formType%>"/>
<input type="hidden" name="registrationCheck" value="<%=registrationCheck%>"/>

       <input type="hidden" name="formTitle" id="formTitle" />

      <script>

		var getval = $("#formTitleId").attr('formtitlevalue');

          var setval = $("#formTitle").val(getval);

       </script>


<!-- modal -->                           
       <div id="formSubmissionModal" class="modal fade modalCustomCss" role="dialog">
           <div class="modal-dialog">
               <div class="modal-content panel-body">
                   <div class="modal-header">
                       <button aria-hidden="true" data-dismiss="modal" class="close" type="button"><i class="fa fa-times fa-1x"></i></button>
                       <h2 id="myLargeModalLabel2" class="modal-title"></h2>
                   </div>
                   <div class="modal-body">
                       <p></p>
                       
                       <button class="btn buttomCommonCss" id="okbtn" aria-hidden="true" data-dismiss="modal">OK</button>
                   </div>
               </div>
           </div>
       </div>
<!-- end modal -->       
