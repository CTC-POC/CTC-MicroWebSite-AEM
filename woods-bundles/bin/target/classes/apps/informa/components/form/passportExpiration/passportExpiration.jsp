<%@page session="false"%>
<%@include file="/libs/foundation/global.jsp"%>
<%@ page import="com.day.cq.wcm.foundation.forms.FormsHelper,
        com.day.cq.wcm.foundation.forms.LayoutHelper,
        java.util.Locale,
		java.util.ResourceBundle,
		com.day.cq.i18n.I18n" %><%
		
final ResourceBundle  resourceBundle =(ResourceBundle)application.getAttribute("LocaleResourceBundle");
I18n i18n = new I18n(resourceBundle); 

    final String name = "passportExpiration";
	final String id = FormsHelper.getFieldId(slingRequest, resource);
    final boolean required = properties.get("required",false);
	final String requiredMsg=properties.get("requiredMessage"," ");

    final String title = FormsHelper.getTitle(resource, i18n.get("Passport Expiration"));

    final String tooltip=properties.get("tooltip",String.class);

	Resource resparent = resource.getParent();
	ValueMap parentProperties = resparent.getParent().getValueMap();
	Boolean formError = parentProperties.get("formerror",false);
	String dataplacement = "right";
	if(formError)
    {
        dataplacement="bottom";
    }

%>
<input type="hidden" value="<%=required%>" id="passportExpirationreq">
<input type="hidden" value="<%=requiredMsg%>" id="passportExpirationreqMesg">
<input type="hidden" value="<%=title%>" name="passportExpirationLabel">
    <div class="form-group">
        <label for="passportExpiration" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo"><%=title%>
            <%if(required==true){%>
            <span class="asterisk-sign-clr">*</span>
            <%}%>
        </label>
        <div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div">
          <input type="text" name="passportExpiration" id="passportExpiration" data-select="datepicker" class="form-control custom-form-control resetdate" readonly>
             <% 
                if(tooltip!=null){
                %>  
                 <span class="custom-tool-tip ">
            <a  href="javascript:void(0)" class="tooltip-mobile hidden-xs" data-toggle="tooltip" data-placement="<%=dataplacement%>" title="<%=tooltip%>">
                <img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
            </a>
            <a  href="javascript:void(0)" class="tooltip-mobile visible-xs " data-toggle="tooltip" data-placement="bottom" title="<%=tooltip%>">
                <img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
            </a>
            </span>
                <%}%>
    </div></div>
