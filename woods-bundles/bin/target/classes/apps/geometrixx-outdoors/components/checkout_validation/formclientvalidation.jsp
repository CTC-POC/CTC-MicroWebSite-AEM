<%--
  Copyright 1997-2010 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Overlay of the Form 'start' component

  Generate the client javascript code to validate the form.

--%><%@page session="false" %><%
%>
if (typeof(shipping_address_fields_precheck) != "undefined" && typeof(billing_address_fields_precheck) != "undefined" ) {
    return (shipping_address_fields_precheck("checkout") && billing_address_fields_precheck("checkout"));
}
