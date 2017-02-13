<%@page	contentType="text/html" pageEncoding="UTF-8" session="false"%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><%@ page import="org.apache.jackrabbit.util.Text,java.util.List,
                     com.day.cq.wcm.foundation.Sitemap,com.day.cq.wcm.foundation.Sitemap.*,
                     com.day.cq.wcm.api.PageFilter,
                     com.day.cq.wcm.api.PageManager"%><%@include file="/libs/foundation/global.jsp"%><%
    String rootPath = properties.get("rootPath", "");
    if (rootPath.length() > 0) {
        if (rootPath.startsWith("path:")) {
            rootPath = rootPath.substring(5,rootPath.length());
        }
    } else {
        long absParent = currentStyle.get("absParent", 2L);
        rootPath = currentPage.getAbsoluteParent((int) absParent).getPath();
    }
    Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(rootPath);
    Sitemap stm = new Sitemap(rootPage);
	List<Link> sitemapPages = stm.getLinks();
	pageContext.setAttribute("sitemapPages", sitemapPages);
	slingResponse.setContentType("application/xml");
%><?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
<c:forEach items="${sitemapPages}" var="sitemap">
	<url>
      <loc>${sitemap.path}</loc>
      <title>${sitemap.title}</title>
	</url>
</c:forEach>
</urlset>