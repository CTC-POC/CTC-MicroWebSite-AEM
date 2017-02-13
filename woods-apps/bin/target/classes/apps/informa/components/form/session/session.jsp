<%@include file="/libs/foundation/global.jsp" %><%
%><%@ page import="com.day.cq.wcm.foundation.forms.FormsHelper,
                   com.day.cq.wcm.foundation.forms.LayoutHelper,
                   java.util.Collections,
                   java.util.List,
                   java.util.*,
                   java.util.Map,
                   java.util.Locale,
				   java.util.ResourceBundle,
				   com.day.cq.i18n.I18n,
                   org.apache.commons.lang3.StringEscapeUtils,

com.day.cq.wcm.api.PageFilter,         
com.day.cq.wcm.api.NameConstants,         
com.day.cq.wcm.api.Page" %>
<cq:includeClientLib categories="cq.widgets"/>
<%
    final ResourceBundle  resourceBundle =(ResourceBundle)application.getAttribute("LocaleResourceBundle");
    I18n i18n = new I18n(resourceBundle);  

final String name = "session";
    //final String id = FormsHelper.getFieldId(slingRequest, resource);
   final boolean required = properties.get("required",false);
	final String requiredMsg=properties.get("requiredMessage"," ");
	final String tooltip=properties.get("tooltip",String.class);

    String sessionCurrency = properties.get("./sessionCurrency","");
    String defaultSessionPrice = properties.get("./defaultSessionPrice","");
	String defaultSessionPriceRate = properties.get("./defaultSessionPriceRate","");
	String defaultSessionCode = properties.get("./defaultSessionCode","");
	String defaultSessionName =  properties.get("./defaultSessionName","");
	String defaultSessionVistorType =  properties.get("./defaultSessionVisitorType","");
	String defaultProductCode =  properties.get("./defaultProductCode","");

    String title = i18n.getVar(FormsHelper.getTitle(resource, "Session"));
    Resource resparent = resource.getParent();
	ValueMap parentProperties = resparent.getParent().getValueMap();
	Boolean formError = parentProperties.get("formerror",false);
	String dataplacement = "right";
	if(formError)
    {
        dataplacement="bottom";
    }
    %>
<input type="hidden" value="<%=required%>" id="sessionreq">
<input type="hidden" value="<%=requiredMsg%>" id="sessionreqMesg">
<div class="form-group ">
<fieldset class="custom-checkbox-fieldset">
<!--<legend class="custom-checkbox-legend forms-title-color-fo col-md-3 col-sm-3"><%=title%></legend>-->
	<input type="hidden" name="defaultSessionCode" value="<%=defaultSessionCode%>"> 
	<input type="hidden" name="defaultSessionName" value="<%=defaultSessionName%>">
	<input type="hidden" name="defaultSessionPrice" value="<%=defaultSessionPrice%>" >
	<input type="hidden" name="defaultSessionPriceRate" value="<%=defaultSessionPriceRate%>">
    <input type="hidden" name="defaultSessionVistorType" value="<%=defaultSessionVistorType%>">
    <input type="hidden" name="defaultProductCode" value="<%=defaultProductCode%>">

	<label for="Session" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo"><%=title%>
		<%if(required==true){%>
		<span class="asterisk-sign-clr">*</span>
		<%}%>
	</label>
	<div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div interest-levle-checkBox-component form-session-container-component">			
			<%
			String pagePath =  currentNode.getPath();
			final Resource childResource = resource.getChild("multi");
			String sessionCode="";
			String sessionName="";
			String sessionPrice="";
			String sessionVisitorType="";
			String productCode="";
			String currentId=null;
			String currentId1=null;
			int i=0;
			if (null != childResource)
			{
			Iterator<Resource> grandChildren = childResource.listChildren();
			while (grandChildren.hasNext()) {
			Resource grandChild = grandChildren.next();
			ValueMap properties2 = grandChild.adaptTo(ValueMap.class);
			sessionCode = properties2.get("sessionCode","");
			sessionName = properties2.get("sessionName","");
			sessionPrice = properties2.get("sessionPrice","");
            sessionVisitorType = properties2.get("sessionVisitorType","");
            productCode = properties2.get("productCode","No_Value");
			currentId = "session-"+i;
            currentId1 = "productCode"+i;
			i=i+1;
			%>
        	<div class="checkbox  formSessionContainer-topMargin interest-level-checkBox form-session-container">
					<div>
				<input type="checkbox" value="<%=sessionCode%>%@%<%=productCode%>" id="<%=currentId%>" class="sessiontotal" name="formSessionId"/> 


				<!--<label for=<%=sessionCode%>> <%=sessionName%> <%=sessionPrice%> </label>-->
				<label for=<%=sessionCode%>> 
					<span class="formSessionContainer"> 
						<p class="col-xs-12 col-sm-7 col-md-7"><%=sessionName%></p>
						<span class="formSessionPrice "><%=sessionCurrency%> <%=sessionPrice%></span>
					</span> 
				</label>
				</div>
					</div>

			<% 
			}
			} 
			%>
			<input type="hidden" name="pagePath" value="<%=pagePath%>"> 
			<input type="hidden" value="0" id="sessionId"/> 

		
		<div>
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
		
</fieldset>
</div>

<script>

    var totalSession=0; 

    $(".sessiontotal").click(function(){

        if($(this).is(':checked')==true){
            var sessionPrice=$(this).next().find('.formSessionPrice ').text();
            totalSession=totalSession+parseInt(sessionPrice);
            $("#sessionId").val(totalSession);
        }
        if($(this).is(':checked')==false){
            var sessionPrice=$(this).next().find('.formSessionPrice ').text();
            totalSession=totalSession-parseInt(sessionPrice);
            $("#sessionId").val(totalSession);
        }			
    });

</script>