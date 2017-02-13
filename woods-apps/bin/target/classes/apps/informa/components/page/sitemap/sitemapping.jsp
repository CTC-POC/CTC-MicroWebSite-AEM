<%@page session="false"%><%--
  Copyright 1997-2008 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Text component

  Draws text. If it's not rich text it is formatted beforehand.

--%><%@
    page
	import="org.apache.jackrabbit.util.Text, com.day.cq.wcm.foundation.Sitemap,
    com.day.cq.wcm.api.PageFilter, java.util.LinkedList, java.util.Iterator,
    com.day.cq.wcm.foundation.Sitemap.Link, com.day.cq.wcm.api.PageManager"%>
<%
%><%@include file="/libs/foundation/global.jsp"%>
<%

    String rootPath = properties.get("rootPath", "");
    if (rootPath.length() > 0) {
        if (rootPath.startsWith("path:")) {
            rootPath = rootPath.substring(5,rootPath.length());
        }
    } else {
        long absParent = currentStyle.get("absParent", 2L);
        rootPath = currentPage.getAbsoluteParent((int) absParent).getPath();
    }%>
<div class="container">
	<div class="row">
		<div class="col-md-12">

			<div id="SiteMap">
				<ul class="paddingZero">
					<li class="col-md-3 col-sm-3">
						<% Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(rootPath);
                    Sitemap stm = new Sitemap(rootPage); 
                    LinkedList<Link> links=stm.getLinks();
                    Iterator<Link> it=links.iterator(); 
                    boolean endli=false; 
                    int count=0; 
					boolean firstLi = true;
                    int listSize=links.size(); 
                    int limit=listSize/4; 
                    while(it.hasNext()){ 
                       Link l=it.next(); 
                       if(l.getLevel()>0){
                           count++; 
                           }
                    if(count>=limit && l.getLevel()==1) {
                        if(!(limit ==1 && count ==1 && firstLi )){
                            endli=true; count=0;
                        }
                        else{
							firstLi = false;
                        }
                        } 
                        if(endli==true) {
                    endli=false;
                            %>
					</li>
					<li class="col-md-3 col-sm-3">
						<% }%> <% if(l.getLevel()==1){%>
						<div class="col-md-12 mainBox">
							<a href="<%=l.getPath()%>.html"><%=l.getTitle()%></a>
						</div> <% } if (l.getLevel()==2 ){%>
						<ul class="sub-levels">
							<li>
								<div class="col-md-12 subBox">
									<a href="<%=l.getPath()%>.html"><%=l.getTitle()%></a>
								</div>
							</li>

						</ul> <% } if (l.getLevel()==3){%>
						<ul class="sub-sub-levels">
							<li>
								<div class="col-md-12 subBox">
									<a href="<%=l.getPath()%>.html"><%=l.getTitle()%></a>
								</div>
							</li>

						</ul> <% }%> <%
    }


    %>
					</li>

				</ul>
			</div>
		</div>
	</div>
</div>