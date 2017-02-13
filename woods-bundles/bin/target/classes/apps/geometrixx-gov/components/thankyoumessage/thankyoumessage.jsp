<%@page session="false" %><%--
  ADOBE CONFIDENTIAL
  __________________

   Copyright 2014 Adobe Systems Incorporated
   All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.
--%><%
%><%@include file="/apps/geometrixx-gov/components/global.jsp" %>
<div class="container">

<%

    String refID = slingRequest.getParameter("submitID");
    if(refID==null){
    refID="#########";
    }
	String user = slingRequest.getParameter("owner");
	if(user==null){
    user="User";
    }
	String adaptiveFormTitle = slingRequest.getParameter("guideName");
	if(adaptiveFormTitle==null){
    adaptiveFormTitle="Application";
    }


%>

             <div class="row col-lg-12 col-xs-12 thanks-page">
             	<!-- CTA for iPhone full screen toggle -->
                <div class="col-xs-2 hidden pull-right text-left iphone-collapse fullscreen-toggle">
                    &nbsp;
                </div>
                <!--/ CTA for iPhone full screen toggle -->
                <!-- page heading -->
                <div class="row col-lg-8 col-md-8 col-sm-8 col-xs-12 nobrdbg">
                    <h3 class="col-lg-7 col-md-8 text-upper nopad-left"><%= i18n.get("Thank You") %></h3>
                </div>
                <!--/ form headings -->
                <!-- row -->	
                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12 nopad nobrdbg">
                    <!-- left container -->
                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 nopad nobrdbg">
                            <!-- content panel -->
                            <div class="col-lg-12 col-sm-12 col-xs-12 nopad si-docs-container clearfix">

                                <p><%= i18n.get("Congratulations ! Your ","Thank you with user name")%><span class="text-blue"><%=adaptiveFormTitle%></span><span><%= i18n.get(" has been submitted. Please note down your Application Tracking Number ")%></span>
                                    <span class="text-blue"><%=refID%>.</span></p>
                                <p><%= i18n.get("You can also call 1-877-222-XXX to check the status of your application. ")%><br><%= i18n.get("Please specify your application tracking number.")%></p>
                    			<!--<p><%= i18n.get("You are also eligible for the following services:") %></p>
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 nopad">
                                    <div class="col-lg-6 col-md-8 col-sm-8 col-xs-12 nopad-left">
                                        <ol>
                                        	<li><a href="#" class="text-blue"><%= i18n.get("Request for Hardship Determination") %></a></li>
                                        </ol>                               
                                    </div>
                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-12">
                                       <button type="button" class="btn btn-primary text-upper"><span><%= i18n.get("Apply") %></span></button>
                                    </div>
                                 </div>-->          
                            </div>
                            <!--/ content panel -->
                    </div>
                    <!--/ left container -->
                    <!-- empty right container -->
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 nobrdbg text-center">
                       &nbsp; 
                    </div>
                    <!--/ empty right container -->
                </div>              
                <!-- /row  -->
             </div>	
        </div>