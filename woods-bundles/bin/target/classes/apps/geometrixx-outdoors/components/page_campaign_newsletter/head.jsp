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

  Default head script of newsletter pages.

  Draws the HTML head with some default content:
  - initialization of the WCM
  - sets the HTML title

  ==============================================================================

--%><%@include file="/libs/foundation/global.jsp" %><%
%><%@ page import="com.day.cq.commons.Doctype,
                   com.day.cq.wcm.api.WCMMode,org.apache.commons.lang3.StringEscapeUtils" %><%
    String xs = Doctype.isXHTML(request) ? "/" : "";
%><head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"<%=xs%>>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="keywords" content="<%= WCMUtils.getKeywords(currentPage) %>"<%=xs%>>
    <title><%= currentPage.getTitle() == null ? StringEscapeUtils.escapeHtml4(currentPage.getName()) : StringEscapeUtils.escapeHtml4(currentPage.getTitle()) %></title>
    <%
    if (WCMMode.fromRequest(request) != WCMMode.DISABLED) {
        %>
        <cq:include script="/libs/wcm/core/components/init/init.jsp"/>
        <cq:includeClientLib categories="mcm.campaign.ui.classic,cq.mcm,cq.mcm.newsletter.emulator"/>
        <sling:include path="<%= resource.getPath() %>" replaceSelectors="init" resourceType="mcm/components/newsletter/emailclient/base"/>
        <%
    } else {
    	slingRequest.setAttribute(ComponentContext.BYPASS_COMPONENT_HANDLING_ON_INCLUDE_ATTRIBUTE, true); 
    }
%>

    <style type="text/css">
		/* Client-specific Styles */
		#outlook a {padding:0;} /* Force Outlook to provide a "view in browser" menu link. */
		body{width:100% !important; -webkit-text-size-adjust:100%; -ms-text-size-adjust:100%; margin:0; padding:0;}
		/* Prevent Webkit and Windows Mobile platforms from changing default font sizes.*/
		.ExternalClass {width:100%;} /* Force Hotmail to display emails at full width */
		.ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div {line-height: 100%;}
		/* Forces Hotmail to display normal line spacing.  More on that: http://www.emailonacid.com/forum/viewthread/43/ */
		#backgroundTable {margin:0; padding:0; width:100% !important; line-height: 100% !important; background-color: #292826;}
		/* End reset */

		/* Some sensible defaults for images
		Bring inline: Yes. */
		img {outline:none; text-decoration:none; -ms-interpolation-mode: bicubic;}
		a img {border:none;}
		.image_fix {display:block;}

		/* Yahoo paragraph fix
		Bring inline: Yes. */
		p {margin: 1em 0;}

		/* Hotmail header color reset
		Bring inline: Yes. */
		h1, h2, h3, h4, h5, h6 {color: black !important;}

		h1 a, h2 a, h3 a, h4 a, h5 a, h6 a {color: blue !important;}

		h1 a:active, h2 a:active,  h3 a:active, h4 a:active, h5 a:active, h6 a:active {
		color: red !important; /* Preferably not the same color as the normal header link color.  There is limited support for psuedo classes in email clients, this was added just for good measure. */
		}

		h1 a:visited, h2 a:visited,  h3 a:visited, h4 a:visited, h5 a:visited, h6 a:visited {
		color: purple !important; /* Preferably not the same color as the normal header link color. There is limited support for psuedo classes in email clients, this was added just for good measure. */
		}

		/* Outlook 07, 10 Padding issue fix
		Bring inline: No.*/
		table td {border-collapse: collapse;}

    /* Remove spacing around Outlook 07, 10 tables
    Bring inline: Yes */
    table { border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt; }

		/* Styling your links has become much simpler with the new Yahoo.  In fact, it falls in line with the main credo of styling in email and make sure to bring your styles inline.  Your link colors will be uniform across clients when brought inline.
		Bring inline: Yes. */
		a {color: #EE5A29;}


		/***************************************************
		****************************************************
		MOBILE TARGETING
		****************************************************
		***************************************************/
		@media only screen and (max-device-width: 480px) {
			/* Part one of controlling phone number linking for mobile. */
			a[href^="tel"], a[href^="sms"] {
						text-decoration: none;
						color: blue; /* or whatever your want */
						pointer-events: none;
						cursor: default;
					}

			.mobile_link a[href^="tel"], .mobile_link a[href^="sms"] {
						text-decoration: default;
						color: orange !important;
						pointer-events: auto;
						cursor: default;
					}

		}

		/* More Specific Targeting */

		@media only screen and (min-device-width: 768px) and (max-device-width: 1024px) {
		/* You guessed it, ipad (tablets, smaller screens, etc) */
			/* repeating for the ipad */
			a[href^="tel"], a[href^="sms"] {
						text-decoration: none;
						color: blue; /* or whatever your want */
						pointer-events: none;
						cursor: default;
					}

			.mobile_link a[href^="tel"], .mobile_link a[href^="sms"] {
						text-decoration: default;
						color: orange !important;
						pointer-events: auto;
						cursor: default;
					}
		}

		@media only screen and (-webkit-min-device-pixel-ratio: 2) {
		/* Put your iPhone 4g styles in here */
		}

		/* Android targeting */
		@media only screen and (-webkit-device-pixel-ratio:.75){
		/* Put CSS for low density (ldpi) Android layouts in here */
		}
		@media only screen and (-webkit-device-pixel-ratio:1){
		/* Put CSS for medium density (mdpi) Android layouts in here */
		}
		@media only screen and (-webkit-device-pixel-ratio:1.5){
		/* Put CSS for high density (hdpi) Android layouts in here */
		}
		/* end Android targeting */


        /* --- Component CSS --- */

        div.textimage div.image {
            float: left;
            margin: 0 8px 8px 0;
        }
        
        div.textimage.image_left div.image {
        }
        
        div.textimage.image_right div.image {
            float: right !important;
            margin: 0 0 8px 8px !important;
        }
        
        .clear {
            clear: both;
        }
        
        
        /* --- Overrides --- */
        
        #backgroundTable {
            background-color: #474747 !important;
        }
        
        
        /* --- Some CSS for Adobe Campaign rich editor client -- */

        p {
            font-size: 13px;
        }


        /* --- Newsletter CSS --- */
        

        .nlBody {
            background-color: #474747 !important;
            font-family: sans-serif;
            font-size: 13px;
            margin: 0;
            padding: 0;
        }
        
        .nlContentTable h1 {
            font-family: sans-serif;
            font-size: 18px;
        }
        
        .nlMainTable td, .nlContentTable td {
            padding: 0;
        }
        
        .nlHeaderHint {
            color: #ffffff;
            font-size: small;
        }
        
        .nlHeaderImage {
            width: 610px;
        }
        
        .nlContentTeaser {
            line-height: 0;
        }
                        
        .nlContentSeparator {
            line-height: 0;
        }
              
        .nlPar p {
            margin-top: 0;
            font-family: sans-serif;
            line-height: 150%;
        }

        .nlPar h1 {
            margin-top: 0;
            font-family: sans-serif;
        }

        .nlPar .parRight {
            width: 180px;
        }

        .nlPar .parRight h1 {
            color: #7a7a7a !important;
            font-size: 15px;
        }
        
        .nlPar .parRight p {
            color: #7a7a7a;
        }
        
        .nlMainTable td.nlBanner {
            width: 180px;
            margin-left: 30px;
            padding: 2px 2px 2px 2px;
            border-radius: 5px; 
            -moz-border-radius: 5px; 
            -webkit-border-radius: 5px;
            background-color: #ffffff;
            border: 2px;
        }
        
        td.nlPar2Bgrd {
            background-repeat: no-repeat;
            background-position: bottom;
        }

        .nlBanner {
            margin-left: 30px;
            padding: 2px 2px 2px 2px;
            border-radius: 5px; 
            border: 2px;
            -moz-border-radius: 5px; 
            -webkit-border-radius: 5px;
            background-color: #ffffff;
        }
        
        .nlBannerContent {
            background: -moz-linear-gradient(bottom, #ffffff 0%, #d9d9d9 100%);
            background: -webkit-linear-gradient(bottom, #ffffff 0%, #d9d9d9 100%);
            background: -o-linear-gradient(bottom, #ffffff 0%, #d9d9d9 100%);
            background: -ms-linear-gradient(bottom, #ffffff 0%, #d9d9d9 100%);
            padding: 4px;
            /* IE 8 compatibility */
            filter: progid:DXImageTransform.Microsoft.gradient(enabled='true', startColorstr=#ffd9d9d9, endColorstr=#ffffffff);
            /* IE 7 compatibility */
            zoom: 1;
        }
        
        .nlFooter {
            font-size: small;
            color: #aaaaaa;
        }
        
        .nlFooter p {
            margin: 0;
            line-height: 150%;
        }
        
        .nlCornersBottom {
            border-radius: 0px 0px 5px 5px; 
            -moz-border-radius: 0px 0px 5px 5px; 
            -webkit-border-radius: 0px 0px 5px 5px; 
        }

	</style>

</head>
