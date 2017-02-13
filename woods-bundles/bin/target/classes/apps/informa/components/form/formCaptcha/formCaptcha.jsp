<%@include file="/libs/foundation/global.jsp" %>
    <% %>
        <%@page session="false" %>
            <% %>
                <%@ page import="com.day.cq.wcm.foundation.TextFormat,
                   com.day.cq.wcm.foundation.forms.FormsHelper,
                   com.day.cq.wcm.foundation.forms.LayoutHelper,
                   com.day.cq.wcm.foundation.forms.FormResourceEdit,
				   java.util.ResourceBundle,
				   com.informa.dao.GoogleRecaptcha,
				   com.day.cq.commons.inherit.HierarchyNodeInheritanceValueMap, 
				   com.day.cq.i18n.I18n" %><%

	final ResourceBundle  resourceBundle =(ResourceBundle)application.getAttribute("LocaleResourceBundle");
	I18n i18n = new I18n(resourceBundle);  

    final String name ="formCaptcha";
    final String id = FormsHelper.getFieldId(slingRequest, resource);
    final boolean required = properties.get("required",false);
	final String requiredMsg=properties.get("requiredMessage"," ");

    final String tooltip=properties.get("tooltip",String.class);


    String title = i18n.getVar(FormsHelper.getTitle(resource, "Form Captcha"));	
	
Resource resparent = resource.getParent();
	ValueMap parentProperties = resparent.getParent().getValueMap();
	Boolean formError = parentProperties.get("formerror",false);
	String dataplacement = "right";
	if(formError)
    {
        dataplacement="bottom";
    }
Resource resource1 = currentPage.getContentResource();
InheritanceValueMap valueMap = new HierarchyNodeInheritanceValueMap(resource1);
GoogleRecaptcha service = sling.getService(GoogleRecaptcha.class);
String recaptchaPublic=service.getPublicKey();


%>

	 <input type="hidden" value="<%=required%>" id="formCaptchareq">
     <input type="hidden" value="<%=requiredMsg%>" id="formCaptchareqMesg">
     <div class="form-group form-captcha-form-group">
     <label for="formCaptcha" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo"><%=title%>
	 <%if(required==true){%>
            <span class="asterisk-sign-clr">*</span>
            <%}%>
        </label>
<div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div captchadiv">
     <div class="g-recaptcha" id="recaptcha" name="formCaptcha" data-sitekey="<%=recaptchaPublic%>"  data-callback="vcc" style="transform:scale(0.77);-webkit-transform:scale(0.77);transform-origin:0 0;-webkit-transform-origin:0 0;"></div>


                                <% if(tooltip!=null){ %>

                                    <span class="custom-tool-tip  ">
                                        <a  href="javascript:void(0)" class="tooltip-mobile hidden-xs" data-toggle="tooltip" data-placement="<%=dataplacement%>" title="<%=tooltip%>">
                                            <img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
                                        </a>
                                        <a  href="javascript:void(0)" class="tooltip-mobile visible-xs " data-toggle="tooltip" data-placement="bottom" title="<%=tooltip%>">
                                            <img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
                                        </a>
                                    </span>
                                <%}%>

    <%if(required==true){%>
 <small class="help-block display-none" data-bv-validator="notEmpty" data-bv-for="formCaptcha" tabindex="0" role="aria-invalid" aria-labelledby="formCaptcha" data-bv-result="INVALID" >
    </small>
            <%}%>

                            </div>
                        </div>

<script>
 var vcc = function(g_recaptcha_response) {
     var $captcha = $( '#recaptcha' );

     $( '.captchadiv .help-block' ).text('');
        $captcha.removeClass( "error" );
     $captcha.parents( ".captchadiv" ).find(".help-block").removeClass("captchdisplay");
 };
</script>