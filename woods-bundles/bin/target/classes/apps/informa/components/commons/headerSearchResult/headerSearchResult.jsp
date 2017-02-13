<%@page session="false"%><%@ page import="com.day.cq.i18n.I18n,
                                          com.day.cq.tagging.TagManager,
                                          com.day.cq.wcm.foundation.Search" %>
<%@include file="/libs/foundation/global.jsp" %><%
%><cq:setContentBundle source="page" /><%

    Search search = new Search(slingRequest);

    I18n i18n = new I18n(slingRequest);
    String searchIn = (String) properties.get("searchIn");
    String requestSearchPath = request.getParameter("path");
    if (searchIn != null) {
        // only allow the "path" request parameter to be used if it
        // is within the searchIn path configured
        if (requestSearchPath != null && requestSearchPath.startsWith(searchIn)) {
            search.setSearchIn(requestSearchPath);
        } else {
            search.setSearchIn(searchIn);
        }
    } else if (requestSearchPath != null) {
        search.setSearchIn(requestSearchPath);
    }
    
    final String escapedQuery = xssAPI.encodeForHTML(search.getQuery());
    final String escapedQueryForAttr = xssAPI.encodeForHTMLAttr(search.getQuery());
    final String escapedQueryForHref = xssAPI.getValidHref(search.getQuery());

    pageContext.setAttribute("escapedQuery", escapedQuery);
    pageContext.setAttribute("escapedQueryForAttr", escapedQueryForAttr);
    pageContext.setAttribute("escapedQueryForHref", escapedQueryForHref);

    pageContext.setAttribute("search", search);
    TagManager tm = resourceResolver.adaptTo(TagManager.class);

    Search.Result result = null;
    try {
        result = search.getResult();
    } catch (RepositoryException e) {
        log.error("Unable to get search results", e);
    }
    pageContext.setAttribute("result", result);

    String nextText = properties.get("nextText", i18n.get("Next", "Next page"));
    String noResultsText = properties.get("noResultsText", i18n.get("Your search - <b>{0}</b> - did not match any documents.", null, escapedQuery));
    String previousText = properties.get("previousText", i18n.get("Previous", "Previous page"));
    String relatedSearchesText = properties.get("relatedSearchesText", i18n.get("Related searches:"));
    String resultPagesText = properties.get("resultPagesText", i18n.get("Results", "Search results"));
    String searchButtonText = properties.get("searchButtonText", i18n.get("Search", "Search button text"));
    String spellcheckText = properties.get("spellcheckText", i18n.get("Did you mean:", "Spellcheck text if typo in search term"));

%><c:set var="trends" value="${search.trends}"/><c:set var="result" value="${result}"/><%
%>
<div class="">
  <div class="row row-custom-divider">
    <div class="col-md-12 pageSearchInforma ${properties.spacingstylestop} ${properties.spacingstylesbottom}">

  <form action="${currentPage.path}.html" role="form">
	<label class="sr-only" for="searchText">Enter the text to search</label>
    <input size="" maxlength="2048" name="q" value="${escapedQueryForAttr}" class="searchBoxInforma"  id="searchText"/>
    <input value="<%= xssAPI.encodeForHTMLAttr(searchButtonText) %>" type="submit" class="searchBtnInforma"/>
  </form>
<br/>
<c:choose>
  <c:when test="${empty result && empty escapedQuery}">
  </c:when>
  <c:when test="${empty result.hits}">
    ${result.trackerScript}
    <c:if test="${result.spellcheck != null}">
      <p><%= xssAPI.encodeForHTML(spellcheckText) %> <a href="<c:url value="${currentPage.path}.html"><c:param name="q" value="${result.spellcheck}"/></c:url>"><b><c:out value="${result.spellcheck}"/></b></a></p>
    </c:if>
    <div id="no_result"><%= xssAPI.filterHTML(noResultsText) %></div>
    <span data-tracking="{event:'noresults', values:{'keyword': '<c:out value="${escapedQuery}"/>', 'results':'zero', 'executionTime':'${result.executionTime}'}, componentPath:'<%=resource.getResourceType()%>'}"></span>
  </c:when>
  <c:otherwise>

      <c:if test="${fn:length(search.relatedQueries) > 0}">
        <br/><br/>
        <%= xssAPI.encodeForHTML(relatedSearchesText) %>
        <c:forEach var="rq" items="${search.relatedQueries}">
            <a style="margin-right:10px" href="${currentPage.path}.html?q=${rq}" class="test"><c:out value="${rq}"/></a>
        </c:forEach>
      </c:if>
      <br/>
      <c:forEach var="hit" items="${result.hits}" varStatus="status">

        <br/>
        <c:if test="${hit.extension != \"\" && hit.extension != \"html\"}">
            <span class="icon type_${hit.extension}"><img src="/etc/designs/default/0.gif" alt="*"></span>
        </c:if>

        <a href="${hit.URL}" onclick="return searchcount( ${result.startIndex+status.index + 1});" class="test1" id="headerSearchResult">${hit.title}</a>  <br/>



        <div>${hit.excerpt}</div>
        <a href="${hit.URL}" onclick="return searchcount( ${result.startIndex+status.index + 1});" class="searchLinks">
           <%=request.getScheme()%>://<%=request.getServerName()%>${hit.URL}</a>
           <c:if test="${!empty hit.properties['cq:lastModified']}"> - <c:catch><fmt:formatDate value="${hit.properties['cq:lastModified'].time}" dateStyle="medium"/></c:catch></c:if>
           <hr>
        <br/>
      </c:forEach>

      <br/>
      <c:if test="${fn:length(result.resultPages) > 1}">
        <%= xssAPI.encodeForHTML(resultPagesText) %>
        <c:if test="${result.previousPage != null}">
          <a href="${result.previousPage.URL}"><%= xssAPI.encodeForHTML(previousText) %></a>
        </c:if>
        <c:forEach var="page" items="${result.resultPages}">
          <c:choose>
            <c:when test="${page.currentPage}">${page.index + 1}</c:when>
            <c:otherwise>
              <a href="${page.URL}">${page.index + 1}</a>
            </c:otherwise>
          </c:choose>
        </c:forEach>
        <c:if test="${result.nextPage != null}">
          <a href="${result.nextPage.URL}"><%= xssAPI.encodeForHTML(nextText) %></a>
        </c:if>
      </c:if>
  </c:otherwise>
</c:choose>
      </div>
    </div>
    </div>
 	<c:if test="${result != null}">
              <input type = "hidden" value = "<%= result.getTotalMatches() %>" id = "analyticsSearchResultsCount"/> 
        	   <input type = "hidden" value = "list-view" id = "analyticsResultStyle"/>
    </c:if>