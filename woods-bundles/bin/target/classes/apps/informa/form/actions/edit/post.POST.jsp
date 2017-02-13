<%--
  Copyright 1997-2011 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Form 'action' component

  Handle form POST

--%><%@page session="false" %><%
%><%@page import="java.util.*,
                  org.apache.sling.api.resource.Resource,
                  org.apache.sling.api.request.RequestParameter,
                  com.day.cq.wcm.foundation.forms.FormResourceEdit,java.util.Enumeration,  java.io.PrintWriter, java.io.ByteArrayOutputStream"%><%
%><sling:defineObjects/>
<% 
                      //PrintWriter pw=response.getWriter();
		ByteArrayOutputStream output = new ByteArrayOutputStream();	
		response.setContentType("application/x-pdf");
		response.setHeader("Content-Disposition:","attachment; filename=test.pdf");
		Enumeration en=request.getParameterNames();
		String htmlData="<table border='1'><tr><td colspan='2'>A simple VISA form</td></tr>";
		while(en.hasMoreElements())
		{
			Object objOri=en.nextElement();
			String param=(String)objOri;
			String value=request.getParameter(param);
            if(!param.contains("_")&&!param.contains(":")&&!param.contains("Submit"))
            	htmlData+= "<tr><td>"+param+"</td>" + "<td>"+value+"</td></tr>";
		}

        htmlData+= "</table>";
        byte buf[] = htmlData.getBytes(); 
        output.write(buf); 
        response.setContentLength(output.size());
        response.getOutputStream().write(output.toByteArray());
		response.getOutputStream().flush();
		output.close();
//pw.println(htmlData);
//pw.close();

                      %>


