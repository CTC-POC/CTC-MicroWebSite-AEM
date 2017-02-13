    <%@page session="false"%><%--
    /*************************************************************************
     *
     * ADOBE CONFIDENTIAL
     * __________________
     *
     *  Copyright 2012 Adobe Systems Incorporated
     *  All Rights Reserved.
     *
     * NOTICE:  All information contained herein is, and remains
     * the property of Adobe Systems Incorporated and its suppliers,
     * if any.  The intellectual and technical concepts contained
     * herein are proprietary to Adobe Systems Incorporated and its
     * suppliers and are protected by trade secret or copyright law.
     * Dissemination of this information or reproduction of this material
     * is strictly forbidden unless prior written permission is obtained
     * from Adobe Systems Incorporated.
     **************************************************************************/
    --%>
    
    <%--
      Social Login Component - uses cloud service configs as 'providers'.
    --%>
    
    <%@include file="/libs/foundation/global.jsp"%>
<%@ page import="com.day.cq.wcm.foundation.forms.ValidationInfo,
                 com.day.cq.wcm.foundation.forms.FormsConstants,
                 com.day.cq.wcm.foundation.forms.FormsHelper,
                 org.apache.sling.api.resource.Resource,
                 org.apache.sling.api.resource.ResourceUtil,
                 org.apache.sling.api.resource.ValueMap,
                 com.day.cq.commons.inherit.InheritanceValueMap,
                 java.util.concurrent.atomic.AtomicReference,
                 com.day.cq.commons.inherit.HierarchyNodeInheritanceValueMap,
                 java.util.Map,
				 java.util.Random,
				 java.util.Date"%>
                     <% 
                        Resource resource1 = currentPage.getContentResource();
                        InheritanceValueMap valueMap = new HierarchyNodeInheritanceValueMap(resource1);
                        String facebookId = valueMap.getInherited("fbAppId","");
						Resource resource2 = currentPage.getContentResource();
                        InheritanceValueMap valueMap1 = new HierarchyNodeInheritanceValueMap(resource2);
                        String twitterAppId = valueMap1.getInherited("twitterAppId","");
						Resource resource3 = currentPage.getContentResource();
                        InheritanceValueMap valueMap2 = new HierarchyNodeInheritanceValueMap(resource2);
                        String linkedInId = valueMap2.getInherited("linkedInAppId","");
						%>
<div id="linkedJs"></div>
<div id="fb-root"></div>
<script>
localStorage.removeItem('socialsignup');
localStorage.removeItem('birthDay');
localStorage.removeItem('email');
localStorage.removeItem('firstName');
localStorage.removeItem('lastName');
localStorage.removeItem('location');

</script>

<script>
  $('<script>')
    .attr('type', 'text/javascript')
	.attr('src', 'https://platform.linkedin.com/in.js')
    .text('api_key: '+'<%=linkedInId%>')
    .replaceAll('#linkedJs');
</script>
<script>
window.fbAsyncInit = function() {
    FB.init({
appId      : <%=facebookId%>,
xfbml      : true,
version    : 'v2.7'
    });
};
(function(d, s, id){
var js, fjs = d.getElementsByTagName(s)[0];
if (d.getElementById(id)) {return;}
js = d.createElement(s); js.id = id;
js.src = "//connect.facebook.net/en_US/sdk.js";
fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
//FaceBook Dependency End

function initiateFBLogin() {
    FB.login(function(response) {
    fetchUserDetail();
    }, {
        scope: 'email'
    });
}
function setCookie(cookieName, cookieValue) {
	var d = new Date();
	d.setTime(d.getTime() + (30 * 60 * 1000));
	var expires = "expires=" + d.toUTCString();
	document.cookie = cookieName + "=" + cookieValue + ";" + expires + ";path=/";
}
function checkInformaProfile(emailSel) {
    if(emailSel != undefined) {
        $.ajax({
            type:'POST',
            url:'/content/data/informa/servlet/informaVisitor',
            data:'action=validateUser&email='+emailSel,
            success: function(res){
                if(res ==0) {	
                	setCookie('isLoggedIn', true);	
                    this.dialogValues = $('#signinButtonDialog');
                    if(this.dialogValues.data("redirectpage")!=undefined)
                    var redirectPage = this.dialogValues.data("redirectpage").trim();
                    localStorage.setItem("socialsignup", " ");
                    var host = window.location.host;
                    var protocol = window.location.protocol + "//";
                    var redirectURL = protocol + host + redirectPage + ".html";
                    window.location.replace(redirectURL);       
                }
                if(res ==-1) {
                    this.dialogValues = $('#signupButtonDialog');
                    if(this.dialogValues.data("signupredirectpage")!=undefined)
                        var redirectPage = this.dialogValues.data("signupredirectpage").trim();
                    localStorage.setItem("socialsignup", "socialsignup");
                    var host = window.location.host;
                    var protocol = window.location.protocol + "//";
                    var redirectURL = protocol + host +redirectPage + ".html";
                    window.location.replace(redirectURL);     
                }
            }
        });
    } else {
        localStorage.setItem("socialsignup", " ");
        var modal = $("#signinPageModal").modal({
            backdrop: 'static',
            keyboard: false,
            show:true
        });
        modal.find('.modal-title').html('<i class="fa fa-exclamation-triangle fa-3x" style="color:red" aria-hidden="true"></i>').css('text-align','center');
        modal.find('.modal-body > p').html("Error occured while fetching email from social media.Please try after sometime").css('text-align','center');
    }
}


function fetchUserDetail() {
        console.log('Welcome!  Fetching your information.... ');
        FB.api('/me?fields=first_name,birthday,middle_name,last_name,email,gender,location', function(response) {
            var emailSel = response.email;
            localStorage.setItem("email", emailSel);
            localStorage.setItem("firstName", response.first_name);
            localStorage.setItem("lastName", response.last_name);
            localStorage.setItem("birthDay", response.birthday);
            localStorage.setItem("location", response.location);
            console.log(response);
            if(response.code=="190") {	
                console.log("Error-->")
                initiateFBLogin();
            }
            checkInformaProfile(emailSel);
        });
}
function fbLogoutUser() {
    FB.getLoginStatus(function(response) {

        if (response && response.status === 'connected') {
            FB.logout(function(response) {           
            });
        }
    });
}
function checkFacebookLogin() {

    FB.getLoginStatus(function(response) {

    	if (response.status === 'connected') {
    		initiateFBLogin();
    	} else if (response.status === 'not_authorized') {
            alert("User is not authorized");
        }else {
    		initiateFBLogin();
		}
	});
}

function twitterPrepopulate() {
OAuth.initialize('<%=twitterAppId%>')
$(document).ready(function(){
    OAuth.popup('twitter', {
        authorize: {
            force_login: true
        }
    }).then(function(twitter) {
    	console.log("Then");
        return twitter.me();
    }).done(function(me) {
		console.log("Done");
        console.log(JSON.stringify(me, null, 2));
    }).error(function(err) {
        alert('something goes wrong...');
    })
});
}
</script>


<script>
function OnLinkedInFrameworkLoad() {
	console.log("OnLinkedInFrameworkLoad");
    //IN.Event.on(IN, "auth", OnLinkedInAuth);
    IN.User.authorize(OnLinkedInAuth, null);
}
function OnLinkedInAuth() {
	console.log("OnLinkedInAuth");
    IN.API.Profile("me").fields("first-name", "last-name", "email-address","location","industry", "date-of-birth").result(ShowProfileData);
}
function ShowProfileData(profiles) {
	console.log(profiles.values[0]);
    var member = profiles.values[0];
    var id=member.id;
    var firstName=member.firstName; 
    var lastName=member.lastName; 
    var photo=member.pictureUrl; 
    var headline=member.headline;
    localStorage.setItem("email", member.emailAddress);
    localStorage.setItem("firstName", member.firstName);
    localStorage.setItem("lastName", member.lastName);
    checkInformaProfile(member.emailAddress);
}
function LinkedInlogOut(){
IN.Event.onOnce(IN, 'systemReady', function() {
  try {
    IN.User.logout();
  } catch (err) {
    console.log(err);
  }
  setTimeout("goToHome()", 10000);
});
}
function goToHome() {
  console.log("LogOut");
}
</script>
<ul class="list-inline social-buttons">

 <%
     if( !facebookId.isEmpty()){
      %>

  <li>
        <a href="#facebook" data-scope="email" onclick="javacript:checkFacebookLogin();"><i class="fbIcon"></i></a>
    </li>   

 <%
   }
  %>
    <%
     if( !twitterAppId.isEmpty()){
      %>

  <li>
        <a href="#twitter" onclick="twitterPrepopulate();"><i class="twIcon"></i></a>
    </li>   

 <%
   }
  %>

    <%
     if( !linkedInId.isEmpty()){
      %>

  <li>
        <a href="#linkedin" onclick="OnLinkedInFrameworkLoad();"><i class="inIcon"></i></a>
    </li>   

 <%
   }
  %>

</ul>