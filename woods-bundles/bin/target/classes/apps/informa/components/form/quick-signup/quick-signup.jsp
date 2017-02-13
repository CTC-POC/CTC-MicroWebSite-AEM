<div data-sly-test="${wcmmode.edit}" data-emptytext="Informa Quick Sign Up" class="cq-placeholder"></div>
<%@page session="false"%><%@include file="/libs/foundation/global.jsp"%><%
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
		com.day.cq.commons.inherit.HierarchyNodeInheritanceValueMap,
		com.day.cq.wcm.api.Page" %>

<%

	final ResourceBundle  resourceBundle =(ResourceBundle)application.getAttribute("LocaleResourceBundle");
	I18n i18n = new I18n(resourceBundle);
	boolean required = properties.get("required", false);
	String requiredMessage = properties.get("requiredMessage", "");
	String signupText = i18n.getVar(properties.get("signupText","I would like to Sign Up with Informa"));
    String questionsLabel = properties.get("questionsLabel","Question");
	String security =  properties.get("security","Secret Questions");
	String answerLabel =  properties.get("answerLabel","Answer");
	String password =  properties.get("password","Set Password");
	String passwordLabel = properties.get("passwordLabel","Password");
	String confirmPasswordLabel = properties.get("confirmPasswordLabel","Confirm Password");
	String text =  properties.get("text","By Signing up you will agree to");
	String linkTitle =  properties.get("linkTitle","Terms and Conditions.");
	String linkPath =  properties.get("linkPath","");
	String checkPath = properties.get("checkPath","false");
    String questionsTooltip=properties.get("questionsTooltip",String.class);
	String answerTooltip=properties.get("answerTooltip",String.class);
	String questionQSErrorMessage = properties.get("questionQSErrorMessage","Security question is required");
	String answerQSErrorMessage = properties.get("answerQSErrorMessage","Security answer is required");
	String passwordQSErrorMessage = properties.get("passwordQSErrorMessage","Password is required");
	String confirmQSPasswordErrorMessage = properties.get("confirmQSPasswordErrorMessage","The confirm password is required");
	String passwordQSValidationErrorMessage = properties.get("passwordQSValidationErrorMessage","Password is weak");
	String passwordsQSValidationMessage = properties.get("passwordsQSValidationMessage","Passwords do not match");
	Resource resparent = resource.getParent();
	ValueMap parentProperties = resparent.getParent().getValueMap();
	Boolean formError = parentProperties.get("formerror",false);
	String dataplacement = "right";
    String passwordRule=properties.get("passwordRule", String.class);
	if(formError)
    {
        dataplacement="bottom";
    }
  

    String[] securityQuestions= new String[100];

	Resource quickResource = resourceResolver.getResource(currentPage.getPath());
	HierarchyNodeInheritanceValueMap hierarchyNodeInheritanceValueMap = new HierarchyNodeInheritanceValueMap(quickResource);
	String pagePath = hierarchyNodeInheritanceValueMap.getInherited("signInPagePath", String.class);
	String signInPath = pagePath+".html";



    Map<String, String> displayValues = FormsHelper.getOptions(slingRequest, resource);
    if ( displayValues == null ) {

        displayValues = new LinkedHashMap<String, String>();
        
        String jsonURL="/apps/informa/components/form/quick-signup/values.json/jcr:content";

        Resource res=resourceResolver.getResource(jsonURL); 

		ValueMap jcrProp=res.adaptTo(ValueMap.class);

		String jsonData=jcrProp.get("jcr:data",String.class); 

		Map<String,String> securityQuestionsItem = new LinkedHashMap<String,String>();

		if (jsonData != null) {     

    	JSONObject securityObject = new JSONObject(jsonData);

    	JSONArray securityArray = securityObject.getJSONArray("root"); 

		JSONObject jsonObject;
        String securityText; 
        String secutityValue;    

       for(int i = 0; i < securityArray.length(); i++) {          

           jsonObject = securityArray.getJSONObject(i); 
           securityText=jsonObject.getString("text"); 
           secutityValue=jsonObject.getString("value"); 

           securityQuestionsItem.put(securityText,secutityValue);
           securityQuestions[i]= securityText;

       } 

	}  

    currentNode.setProperty("options",securityQuestions);
    currentNode.getSession().save();
    displayValues = securityQuestionsItem;
    }

%>
 

<input type="hidden" id="questionQSErrorMessage" value="<%=questionQSErrorMessage%>">  
<input type="hidden" id="answerQSErrorMessage" value="<%=answerQSErrorMessage%>">
<input type="hidden" id="passwordQSErrorMessage" value="<%= passwordQSErrorMessage%>">
<input type="hidden" id="confirmQSPasswordErrorMessage" value="<%=confirmQSPasswordErrorMessage%>">  
<input type="hidden" id="passwordQSValidationErrorMessage" value="<%=passwordQSValidationErrorMessage%>"> 
<input type="hidden" id="passwordsQSValidationMessage" value="<%=passwordsQSValidationMessage%>"> 
<input type="hidden" name="signInPagePath" value="<%=signInPath%>">

<div class="form-group"> 
	<label for="I would like to Sign Up with Informa" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo">&nbsp; </label>
	<div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div  interestcheckBox forms-custom-radio-btn quicksingupformclass">
		<div class="checkbox form-custom-checkbox col-md-12 col-sm-12" >
			<input type="checkbox" value="true"  id="quickSignupwithInforma" name="quickSignupwithInforma" >
			 <label for="quickSignupwithInforma" > <span> <%= signupText %></span></label> 
		 </div> 
	</div>
</div> 
<div  id="quickSignupdiv" >

<div class="form-group">
<label for="question" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo signupsub-title"><%= security%> </label>
</div>
<div class="form-group">
    <label for="question" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo "><%= questionsLabel %><span class="asterisk-sign-clr">*</span></label>
     <div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div quicksignupquestion">
      <select name="securityQuestion" class="form-control custom-form-control selectpicker custom-select-box quicksignupquestion" data-size="5" id="securityQuestion" disabled="disabled">
          <%
            for(String key : displayValues.keySet()) {
            String v = xssAPI.encodeForHTML(key);
            String t = displayValues.get(key);
            t = xssAPI.encodeForHTML(t);

          if(v.equals("Select the Security Questions")){
            %>
			<option value=""><%=t%></option>
          <%
        }
        else{

          %>
  			<option value="<%=v%>"><%=t%></option><%                     

        }
    }
		%>


	  </select>

		<span class="custom-tool-tip ">
		<a  href="javascript:void(0)" class="tooltip-mobile hidden-xs" data-toggle="tooltip" data-placement="right" title="<%=questionsTooltip%>">
		<img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
		</a>
		<a  href="javascript:void(0)" class="tooltip-mobile visible-xs " data-toggle="tooltip" data-placement="bottom" title="<%=questionsTooltip%>">
		<img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
		</a>
		</span>
	</div>
</div>        
<div class="form-group">
	<label for="Answer" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo"><%= answerLabel%><span class="asterisk-sign-clr">*</span></label>
	<div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div">
		<input aria-labelledby="answer" id="answer" name="securityAnswer" class="form-control custom-form-control" type="text" disabled="disabled">
		<span class="custom-tool-tip ">
		<a  href="javascript:void(0)" class="tooltip-mobile hidden-xs" data-toggle="tooltip" data-placement="right" title="<%=answerTooltip%>">
		<img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
		</a>
		<a  href="javascript:void(0)" class="tooltip-mobile visible-xs " data-toggle="tooltip" data-placement="bottom" title="<%=answerTooltip%>">
		<img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
		</a>
		</span>
	</div>
</div>

<div class="form-group">
	<label for="question" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo signupsub-title"><%= password%></label>
</div>
<div class="form-group">
	<label for="password" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo"><%= passwordLabel%><span class="asterisk-sign-clr">*</span></label>
	<div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div">
		<input aria-labelledby="password" id="password" name="password" class="form-control custom-form-control" type="password" disabled="disabled">
        <span class="glyphicon glyphicon-eye-open eyespanquick"></span>
		<span class="custom-tool-tip ">
		<a  href="javascript:void(0)" class="tooltip-mobile hidden-xs" data-toggle="tooltip" data-placement="right" title="<%=passwordRule%>">
		<img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
		</a>
		<a  href="javascript:void(0)" class="tooltip-mobile visible-xs " data-toggle="tooltip" data-placement="bottom" title="<%=passwordRule%>">
		<img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
		</a>
		</span>
	</div>  
</div>
<div class="form-group">
	<label for="confirmPassword" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo"><%= confirmPasswordLabel%><span class="asterisk-sign-clr">*</span></label>
	<div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div">
	 <input aria-labelledby="confirmPassword" id="confirmPassword" name="confirmPassword" class="form-control custom-form-control" type="password" disabled="disabled">
     <span class="glyphicon glyphicon-eye-open eyespanquick"></span>

	</div>     
</div>
<div class="form-group">
	<label for="I would like to Sign Up with Informa" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo">&nbsp; </label>
	<div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div  interestcheckBox forms-custom-radio-btn">
		<div class="checkbox form-custom-checkbox col-md-12 col-sm-12">
			<input type="checkbox" value="termsandConditions" id="TermsandConditions" primary="" name="termsandConditions" data-bv-field="TermsandConditions" disabled="disabled">
            <label for="TermsandConditions" primary=""> <span> <%= text%>
                <%
                    if("false".equals(checkPath)){
                        linkPath = linkPath+".html";
                    }

				%>

                <a href="<%= linkPath%>"><%= linkTitle%></a></span></label>
		 </div>
	</div>
</div>  
</div>



