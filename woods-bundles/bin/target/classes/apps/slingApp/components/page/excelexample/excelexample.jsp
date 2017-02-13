<%@include file="/libs/foundation/global.jsp"%>
<%@ page import="java.util.ArrayList,java.util.Iterator" %>

<%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %>
<h1>TemplateSling Page</h1>
<%
//create a custom.sling.Query instance
com.informa.service.ConvertxmlToString wfService = sling.getService(com.informa.service.ConvertxmlToString.class);
System.out.println("The Value::::::::::::::--->>>"+wfService);
ArrayList list = (ArrayList)wfService.parseXML();
Iterator listOfItems = list.iterator();
while(listOfItems.hasNext())
{
%>


<h5>The value is :::: <%= listOfItems.next() %></h5>

<%
}
%>

