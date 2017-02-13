<%--

  Listeners component.

  This is a listeners components

--%><%
%><%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" %><%
%><%
	// TODO add you code here
%>



 Dialog Listener

<script type="text/javascript">
   function manageTabs(box,tab,noSwitch)
    {var tabs=['tab1','tab2','tab3'];
     var index=tabs.indexOf(tab);if(index==-1) 
        return;for(var i=1;i<=tabs.length;i++){if(index==i){box.unhideTabStripItem(i);}
                                              else{box.hideTabStripItem(i);}}box.doLayout();if(!noSwitch)box.activate(index);}

</script>

