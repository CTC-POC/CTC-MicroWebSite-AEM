<%@page contentType="text/html" pageEncoding="utf-8" session="false"
	import="com.day.cq.wcm.foundation.Search,
                  com.adobe.cq.commerce.api.CommerceQuery,
                  com.day.cq.i18n.I18n,
                  com.day.text.Text,
                  java.util.Locale"%>
<%@include file="/libs/foundation/global.jsp"%>

<%

    Search search = new Search(slingRequest);
 	Locale pageLang = currentPage.getLanguage(false);
    final I18n i18n = new I18n(slingRequest.getResourceBundle(pageLang));
    int absLevel = 2;
    Page homePage = currentPage.getAbsoluteParent(absLevel);
    String home = homePage != null ? homePage.getPath() : Text.getAbsoluteParent(currentPage.getPath(), absLevel);
	String freeTextLabel = properties.get("freetext","Search");

%>

<cq:includeClientLib categories="cq.commerce" />
  <div data-sly-test="${wcmmode.edit}" data-emptytext="Header Search"
	class="cq-placeholder"></div>
<div
	class="col-xs-12 col-sm-12 col-md-12 navbar-right paddingZero mobilePadding ${properties.spacingstylestop} ${properties.spacingstylesbottom}" id="header_search">
	<form class="navbar-form paddingZero search-form" role="search" action="<%= properties.get("searchresult") %>.html" method="get">
		<div class="input-group">
            <label for="search-field" class="obscure"><%=freeTextLabel%></label>
			<input type="text" aria-label="search" class="form-control" placeholder="<%= i18n.get(freeTextLabel) %>" name="<%= CommerceQuery.PARAM_QUERYTEXT %>" id="search-field" 
				value="<%= xssAPI.encodeForHTMLAttr(search.getQuery()) %>" style="border-radius: 0;">
			<div class="input-group-btn">
				<button class="search-submit btn btn-default"
                style="border-radius: 0; background-color: #000;" type="submit" aria-label="Search">
					<i class="glyphicon glyphicon-search" style="color: #ccc;"></i>
				</button>
			</div>
		</div>
	</form>
</div>
