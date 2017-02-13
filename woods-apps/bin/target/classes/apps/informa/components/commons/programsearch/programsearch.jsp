<%@page session="false"%><%@ page
	import="com.informa.service.ProgramSearchService,com.informa.service.impl.ProgramSearchServiceImpl,com.informa.dto.ProjectSearchResultDTO,
    com.day.cq.i18n.I18n,java.util.List,java.util.Map,java.util.Set,java.util.Arrays"%>
<%@include file="/libs/foundation/global.jsp"%>
<%
%><cq:setContentBundle source="page" />
<%
    I18n i18n = new I18n(slingRequest);
   	ProgramSearchService programSearchService = sling.getService(ProgramSearchService.class);
	String freeTextLabel = properties.get("freetext", i18n.get("Free Text", "Free Text"));
	String noResultText = properties.get("noResultText", i18n.get("No Results Found", "No Results Found"));
	String searchPath = properties.get("url", String.class);
	List<String> fieldOneList = (properties.get("fieldOneList", String.class)!=null ? Arrays.asList(properties.get("fieldOneList", String.class).split(",")):null);
	List<String> fieldTwoList = (properties.get("fieldTwoList", String.class)!=null ? Arrays.asList(properties.get("fieldTwoList", String.class).split(",")):null);
	List<String> fieldThreeList = (properties.get("fieldThreeList", String.class)!=null ? Arrays.asList(properties.get("fieldThreeList", String.class).split(",")):null);
	String title = properties.get("title","Program Title");
	String searchTitle = properties.get("searchTitle","Search");
	String searchLimit = properties.get("searchLimit","-1");
	String designPath = currentDesign.getPath();
	Map<String,List<ProjectSearchResultDTO>> projectSearchResultDTO = programSearchService.searchProgram(searchPath,request.getParameter("fieldOne"),request.getParameter("fieldTwo"),request.getParameter("fieldThree"),request.getParameter("freeText"),searchLimit);
	Set<String> keyset = projectSearchResultDTO.size()!=0 ? projectSearchResultDTO.keySet() : null;
	int i=0;
	int searchResultsCount = 0;
%>

<div id="ExibitorProject">
	<div class="visitor-container exihibitor-projects-container ${properties.spacingstylestop} ${properties.spacingstylesbottom}">
		<div class="exhibitorProjectsInnerBoxes">
			<h2 class="exhibitorProjectsMainTitle"><%=title%></h2>
			<!-- Exibitor Projects Search Starts -->
			<div class="searchbarProjects">
				<div class="header_search_bar content_bg">
					<div class="header_search_bar1">
						<p class="searchTitle"><%=searchTitle%></p>

						<div class="text_box col-sm-3">
						 <label class="sr-only" for="search_freeText">Search</label>
							<input type="text" name="q"
								class="col-sm-12 paddingZero search projectSearchFields"
								id="search_freeText"
								placeholder="<%= xssAPI.encodeForHTML(freeTextLabel) %>"
								value="<%=request.getParameter("freeText")!=null ? request.getParameter("freeText"):"" %>">
						</div>
						<div class="dd_box col-sm-9 paddingZero">
							<%if(null != fieldOneList){%>
							<div class="search-select-boxes paddingZero">
								<select id="sector_data" class="projectSearchFields col-sm-3">
									<%for(String fieldOne:fieldOneList){%>
									<option value="<%=fieldOne%>"
										<%if(request.getParameter("fieldOne")!=null && request.getParameter("fieldOne").equals(fieldOne)){ %>
										selected <%}%>><%=fieldOne%></option>
									<%}%>
								</select>
							</div>
							<%}
										if(null != fieldTwoList){%>
							<div class="search-select-boxes paddingZero">
								<select id="country_data" class="projectSearchFields col-sm-3">
									<%for(String fieldTwo:fieldTwoList){%>
									<option value="<%=fieldTwo%>"
										<%if(request.getParameter("fieldTwo")!=null && request.getParameter("fieldTwo").equals(fieldTwo)){ %>
										selected <%}%>><%=fieldTwo%></option>
									<%}%>
								</select>
							</div>
							<%}
										if(null != fieldThreeList){%>
							<div class="search-select-boxes paddingZero">
								<select id="city_data" class="projectSearchFields col-sm-3">
									<%for(String fieldThree:fieldThreeList){%>
									<option value="<%=fieldThree%>"
										<%if(request.getParameter("fieldThree")!=null && request.getParameter("fieldThree").equals(fieldThree)){ %>
										selected <%}%>><%=fieldThree%></option>
									<%}%>

								</select>
							</div>
							<%}%>
							<input id="url" name="url" value="${properties.url}"
								type="hidden"> <input id="designpath" name="designpath"
								value="<%=designPath%>" type="hidden">
							<button role= "Searchbutton" type="button"
								class="btn btn-info col-sm-3 search_filter_button" id="btn-info">
								<span class="glyphicon glyphicon-search search-icons"></span>
							</button>
						</div>

					</div>
				</div>
			</div>

			<%if(properties.get("resultStyle", "image-gird").equals("image-gird")){                   
							if(null!=keyset && keyset.size()>0){%>
			<!-- Filter result -->
			<div class="row">
				<div class="searchContainer container-fluid">
					<!-- class="content_bg" -->
					<div class="row">
						<ul class="tab_li_items">
							<% for(String projectData:keyset){
        															for(ProjectSearchResultDTO projectDTOData:projectSearchResultDTO.get(projectData)){ ++searchResultsCount ;%>
							<li onclick="return searchcount(<%= searchResultsCount%>);" class='searchResult col-sm-4 img-boxs searchResultImageTitle'
								data-toggle='modal'
								data-id='<%=projectDTOData.getLocation()%>.html'
								data-target='#myModal' style="height:324px">
								<%if(null != projectDTOData.getImagePath()){%>
<div class="row"><img class='img-responsive first_box_projects' src='<%=projectDTOData.getImagePath()%>' alt='Informa' /></div>
                                    
                                    <%}%>
								<div class='row content-title projectsContentsDetails'>
									
										<p class='box-contents-title informaTextEllipsis informaBlockElement pull-left' title="<%=projectDTOData.getName()%>"><%=projectDTOData.getName()%><img class='img-responsive projects-box-arrows pull-right' src="<%=designPath%>/clientlibs/images/arrow1.png" alt='Informa' /></p>
							
								</div>
							</li>
							<%}
    														}%>
						</ul>
					</div>
				</div>
			</div>
			<!--Image Boxes ends-->

			<%}else{%>
            <div id="no_result">
			<%= xssAPI.encodeForHTML(noResultText) %>
            </div>
			<%}%>
		</div>
	</div>
	<input type = "hidden" value = "<%= searchResultsCount %>" id = "analyticsSearchResultsCount"/> 
	<input type = "hidden" value = "image-gird" id = "analyticsResultStyle"/>
	<%}else{
	if(null!=keyset && keyset.size()>0){%>
	<div class="">
		<div class="informaSearchComponent">
			<!-- Search list and tabs starts here-->

			<div class="row">
				<div >
					<div class="informaSearchlistings">
						<!-- <div class="col-lg-6 col-md-6 col-sm-16 col-xs-12">	
												</div> 
					 -->
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">



							<div class="informa-tab-panel  travel-nav-container">

								<ul id="myTab"
									class="informa-tab-panel-tabs nav nav-tabs search_tabs_informa">
									<% for(String projectData:keyset){%>
									<li class="col-sm-4 paddingZero"><a
										class="informa-tab-panel-tab-item search_tab_headings"
										href="#<%=projectData.replaceAll(" ", "")%>" data-toggle="tab"> <span
											class="informa-tab-panel-tab-title search-Tab-title"><%=projectData.replaceAll(" ", "")%></span>
									</a></li>
									<%}%>
								</ul>

								<!-- Nav tabs contents starts here-->
								<div class="tab-content search-tab-contents">
									<% for(String projectData:keyset){
                                        if(i==0){%>
									<div role="tabpanel" class="tab-pane fade in active"
										id="<%= projectData.replaceAll(" ", "") %>">
										<%}else{%>
										<div role="tabpanel" class="tab-pane fade"
											id="<%= projectData.replaceAll(" ", "") %>">
											<%}
										i++;%>


											<ul class="informaSearchTabsListsArea">
												<li class="search-listings-header"><span
													class="col-md-4 col-sm-4 col-xs-6"> <span
														class="col-md-9 col-sm-9 col-xs-11 paddingZero">Title</span>

														<span
														class="col-md-3 col-sm-3 col-xs-1 paddingZero search_icons_right">
															<span
															class="col-md-12 col-sm-12 col-xs-12 paddingZero search-sorts-dticons">
																<a href="#up"><span class="searchSortup"
																	aria-hidden="true"></span></a>
														</span> <span
															class="col-md-12 col-sm-12 col-xs-12 paddingZero search-category-sort search-sorts-dticons">
																<a href="#down"><span class="searchSortdown"
																	aria-hidden="true"></span></a>
														</span>
													</span>
												</span> <span class="col-md-4 col-sm-4 col-xs-6"> <span
														class="col-md-10 col-sm-10 col-xs-11 paddingZero">Location</span>

														<span
														class="col-md-2 col-sm-2 col-xs-1 paddingZero search_icons_right">
															<span
															class="col-md-12 col-sm-12 col-xs-12 paddingZero search-sorts-dticons">
																<a href="#up"><span class="searchSortup"
																	aria-hidden="true"></span></a>
														</span> <span
															class="col-md-12 col-sm-12 col-xs-12 paddingZero search-category-sort search-sorts-dticons">
																<a href="#down"><span class="searchSortdown"
																	aria-hidden="true"></span></a>
														</span>
													</span>



												</span> <span class="col-md-4 col-sm-4 col-xs-6 hidden-xs">
														<span class="col-md-10 col-sm-10 col-xs-10 paddingZero"><span
															class="mobile-categories">Completion Date</span></span> <span
														class="col-md-2 col-sm-2 col-xs-2 paddingZero search_icons_right searchSortCatIconThree">
															<span
															class="col-md-12 col-sm-12 col-xs-12 paddingZero search-sorts-dticons">
																<a href="#up"><span class="searchSortup"
																	aria-hidden="true"></span></a>
														</span> <span
															class="col-md-12 col-sm-12 col-xs-12 paddingZero search-category-sort search-sorts-dticons">
																<a href="#down"><span class="searchSortdown"
																	aria-hidden="true"></span></a>
														</span>
													</span>




												</span></li>
											</ul>
											<div class="divtable accordion-xs">
												<% for(ProjectSearchResultDTO projectDTOData:projectSearchResultDTO.get(projectData)){ ++searchResultsCount;%>
												<div class="tr">

													<div class="accordion-xs-toggle search-toggle-mobile">

														<div
															class="td col-xs-4 col-sm-4 col-md-4 Sort-categoryOne categoryfirst-mobile">
                                                                <a href="<%=projectDTOData.getLocation()%>.html"><%=projectDTOData.getName()%></a></div>

														<div
															class="td  col-xs-4 col-sm-4 col-md-4 Sort-categorytwo categorysecond-mobile"><%=projectDTOData.getLocation()%></div>


													</div>

													<div class="accordion-xs-collapse">
														<div class="inner">
															<div class="td Sort-categoryThree col-xs-3 col-sm-4 col-md-4">
																<span class="mobile-categories visible-xs"><%=projectDTOData.getLocation()%>:</span>
																<%=projectDTOData.getCompletionDate()%></div>
														</div>
													</div>

												</div>
												<%}%>
											</div>

										</div>
										<%}%>
										<!-- Nav tabs contents ends here-->
										<input type = "hidden" value = "<%= searchResultsCount %>" id = "analyticsSearchResultsCount"/> 
                                         <input type = "hidden" value = "list" id = "analyticsResultStyle"/>
									</div>
								</div>
							</div>
						</div>
					</div>

					<!-- Search list and tabs ends here-->

				</div>

			</div>

		</div>
	</div>
	<%}else{%>
    <div id="no_result">
	<%= xssAPI.encodeForHTML(noResultText) %>
    </div>
	<%}
							}%>
</div>
<!-- pop up data-->
<%if(properties.get("resultStyle", "image-gird").equals("image-gird")){
    if(null!=keyset && keyset.size()>0){%>
<div class="row">
	<div class="container modelSearchContainer">
		<div class='modal fade' id='myModal' role='dialog'>
			<div class="modal-dialog modal-lg">
				<!-- Modal content-->
				<div
					class="modal-content informa-details-modal visitors-modal-content">
					<div class="modal-header informa-details-modalHeader">
						<p class="close informa-details-closeBtn visitors-close"
							data-dismiss="modal"
							background="<%=designPath%>/clientlibs/images/close.png"></p>
					</div>
					<div id="project-detail-page"></div>
				</div>
			</div>
		</div>

	</div>
</div>
<%}
}%>
