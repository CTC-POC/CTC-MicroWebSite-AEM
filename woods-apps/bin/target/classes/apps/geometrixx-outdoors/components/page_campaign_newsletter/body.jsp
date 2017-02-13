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

  Newsletter body script.

  ==============================================================================
--%>
<%@page import="com.day.cq.widget.HtmlLibraryManager, com.day.cq.commons.Externalizer,com.day.cq.wcm.api.WCMMode" %>
<%@include file="/libs/foundation/global.jsp" %>
<%
    Externalizer externalizer = resourceResolver.adaptTo(Externalizer.class);
%>

<body class="nlBody">

    <%
        if (WCMMode.fromRequest(slingRequest) != WCMMode.DISABLED) {
            %><cq:include path="clickstreamcloud" resourceType="cq/personalization/components/clientcontext"/><%
        }
    %>
    <%-- need another wrapping table for the "reset" styles to be applied --%>
    <table id="backgroundTable">
        <tr><td><cq:include path="." resourceType="mcm/campaign/components/status"/></td></tr>
        <tr>
            <td align="center">
                <table width="610">
                    <tr>
                        <td height="45" colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="right" class="nlHeaderHint" colspan="3"><cq:include path="redirect" resourceType="mcm/components/personalization" /></td>
                    </tr>
                    <tr>
                        <td colspan="3"><img src="/etc/designs/geometrixx-outdoors/images/campaign_newsletter/header.png" class="nlHeaderImage"></td>
                    </tr>
                    <tr>
                        <td height="25" colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="nlContentTeaser" colspan="3"><img src="/etc/designs/geometrixx-outdoors/images/campaign_newsletter/content-teaser.jpg" width="610" /></td>
                    </tr>
                    <tr>
                        <td bgcolor="#ffffff" height="23" colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td bgcolor="#ffffff" width="30">&nbsp;</td>
                        <td bgcolor="#ffffff" width="566" class="nlContentWrapper" align="left">
                            <table class="nlContentTable" width="100%">
                                <tr>
                                    <td width="576"><cq:include path="title" resourceType="/libs/mcm/campaign/components/heading" /></td>
                                </tr>
                                <tr>
                                    <td height="1" class="nlContentSeparator"><img src="/etc/designs/geometrixx-outdoors/images/campaign_newsletter/separator-grey.gif" width="550" height="1" /></td>
                                </tr>
                                <tr>
                                    <td height="8">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="564" cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td valign="top" width="300">
                                                    <div class="nlPar">
                                                        <cq:include path="par" resourceType="/libs/mcm/campaign/components/parsys" />
                                                    </div>
                                                </td>
                                                <td width="12">&nbsp;</td>
                                                <td width="252" valign="top">
                                                    <table cellspacing="0" cellpadding="0" border="0">
                                                        <tr>
                                                            <td width="16" height="20">&nbsp;</td>
                                                            <td bgcolor="#f7f7f7" width="20">&nbsp;</td>
                                                            <td bgcolor="#f7f7f7" width="180">&nbsp;</td>
                                                            <td bgcolor="#f7f7f7" width="20">&nbsp;</td>
                                                            <td width="16">&nbsp;</td>
                                                        </tr>
                                                        <tr>
                                                            <td rowspan="3" valign="bottom" align="right"><img src="/etc/designs/geometrixx-outdoors/images/campaign_newsletter/box-left.gif" width="10" height="137"></td>
                                                            <td bgcolor="#f7f7f7" background="<%= externalizer.relativeLink(slingRequest, "/etc/designs/geometrixx-outdoors/images/campaign_newsletter/box-fill-content.gif") %>" class="nlPar2Bgrd">&nbsp;</td>
                                                            <td bgcolor="#f7f7f7" background="<%= externalizer.relativeLink(slingRequest, "/etc/designs/geometrixx-outdoors/images/campaign_newsletter/box-fill-content.gif") %>" class="nlPar2Bgrd">
                                                                <div class="nlPar">
                                                                    <cq:include path="parRight" resourceType="/libs/mcm/campaign/components/parsys" />
                                                                </div>
                                                            </td>
                                                            <td bgcolor="#f7f7f7" background="<%= externalizer.relativeLink(slingRequest, "/etc/designs/geometrixx-outdoors/images/campaign_newsletter/box-fill-content.gif") %>" class="nlPar2Bgrd">&nbsp;</td>
                                                            <td rowspan="3" valign="bottom" align="left"><img src="/etc/designs/geometrixx-outdoors/images/campaign_newsletter/box-right.gif" width="11" height="137"></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3" bgcolor="#f7f7f7" height="20" background="<%= externalizer.relativeLink(slingRequest, "/etc/designs/geometrixx-outdoors/images/campaign_newsletter/box-fill-border.gif") %>" class="nlPar2Bgrd">&nbsp;</td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3"><img src="/etc/designs/geometrixx-outdoors/images/campaign_newsletter/box-bottom.gif" width="220" height="17"></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td bgcolor="#ffffff" width="14">&nbsp;</td>
                    </tr>
                    <tr>
                        <td bgcolor="#ffffff" height="25" class="nlCornersBottom" colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td height="28" colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="nlBanner" colspan="3">
                            <div class="nlBannerContent">
                                <cq:include path="footer" resourceType="/libs/foundation/components/parsys" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td height="25" colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="nlFooter" align="center" colspan="3">
                            <p>Copyright &copy; 2013 Adobe. All rights reserved.</p>
                            <cq:include path="unsubscribe" resourceType="mcm/components/personalization" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <cq:include path="cloudservices" resourceType="cq/cloudserviceconfigs/components/servicecomponents"/>
</body>
