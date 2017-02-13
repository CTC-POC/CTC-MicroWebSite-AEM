<%@page session="false" import="com.day.cq.wcm.api.WCMMode,
        com.adobe.cq.social.ugcbase.SocialUtils,
        com.adobe.cq.social.ugcbase.core.SocialResourceUtils,
	com.day.cq.wcm.api.components.DropTarget,
	com.adobe.granite.socialgraph.GraphNode,
	com.adobe.granite.socialgraph.SocialGraph,
	com.adobe.granite.socialgraph.Relationship,
	com.adobe.granite.socialgraph.Direction,
	org.apache.jackrabbit.api.security.user.User,
	org.apache.jackrabbit.api.security.user.Group,
	com.adobe.granite.security.user.UserPropertiesManager,
	com.adobe.granite.security.user.UserProperties,
	org.apache.jackrabbit.api.security.user.Authorizable,
	org.apache.sling.api.resource.ResourceResolverFactory,
	org.apache.sling.api.resource.ResourceUtil,
	com.day.cq.wcm.foundation.forms.FormsHelper,
	org.apache.sling.api.resource.ValueMap,
	com.adobe.granite.security.user.UserPropertiesService,
	java.util.List,
	javax.jcr.Node,
	javax.jcr.RepositoryException,
	javax.jcr.PathNotFoundException,
	com.adobe.cq.social.group.api.GroupConstants,
	com.adobe.cq.social.group.api.GroupUtil,
	java.util.Comparator,
	java.util.Collections,
	com.day.cq.i18n.I18n,
	java.util.ArrayList,
	java.lang.Integer,
	java.util.Iterator" %>
<%@include file="/libs/social/commons/commons.jsp" %>

	<div id="<%= xssAPI.encodeForHTMLAttr(resource.getName())%>" class="outer grid-4-par">
		<div class="diagonal-line-outer">
			<div class="diagonal-line-inner">
				<cq:includeClientLib categories="cq.social.peoplelist"/><%

				final String profilePagePath = currentStyle.get("profileLink", String.class);
				final String rootUser = properties.get("createFrom", "loggedInUser");
				final String relationShip = properties.get("relationShip", "following");
				final String displayAs = properties.get("displayAs", "name");
				final String orderBy = properties.get("orderBy", String.class);
				final String groupId = properties.get("groupId", String.class);
				final String label = properties.get("label", "");
				final String directionConfig = properties.get("direction", "incoming");
				final Boolean includePending = properties.get("includePending", Boolean.FALSE);
				final String DEFAULT_AVATAR = "/etc/designs/default/images/social/avatar.png";

				Direction direction = Direction.INCOMING;
				if (directionConfig.equalsIgnoreCase("outgoing")) {
					direction = Direction.OUTGOING;
				}
				List<String> relations = new ArrayList<String>();
				relations.add(relationShip);
				if (includePending) {
					relations.add("pending-" + relationShip);
				}

				Integer limit = properties.get("limit", 10);
				String selector = null;
				String graphStartId = loggedInUserID;

				final UserPropertiesService userPropertiesService = sling.getService(UserPropertiesService.class);
				final UserPropertiesManager upm = userPropertiesService.createUserPropertiesManager(resourceResolver);

				if (slingRequest.getRequestPathInfo().getSelectors().length > 0) {
					selector = slingRequest.getRequestPathInfo().getSelectors()[0];
					limit = Integer.parseInt(selector);
					graphStartId = slingRequest.getRequestPathInfo().getSuffix().substring(1);
				}

				WCMMode mode = WCMMode.fromRequest(request);

				if (mode == WCMMode.EDIT) {
					//drop target css class = dd prefix + name of the drop target in the edit config
					String ddClassName = DropTarget.CSS_CLASS_PREFIX + "pages";
					%><div class="<%= ddClassName %>"><%
				}

				boolean isGroup = false;
				String group = null;
				String adminGroup = null;
				String moderatorGroup = null;
				if (selector == null && "currentUser".equalsIgnoreCase(rootUser)) {
					List<Resource> resources = FormsHelper.getFormEditResources(slingRequest);
					if (resources != null && resources.size() > 0) {
						//formchooser-mode, get the requested resource
						Resource userProfileResource = resources.get(0);
						graphStartId = upm.getUserProperties(userProfileResource.adaptTo(Node.class)).getAuthorizableID();
					}
				}

				final String GROUP_MODERATORGROUP = "moderatorgroup";
				if ("currentGroup".equalsIgnoreCase(rootUser)) {
					//derive the group and adminGroup paths based on the containing group page
					Page mainPage = currentPage;
					while (mainPage != null) {
						Resource content = mainPage.getContentResource();
						ValueMap values = ResourceUtil.getValueMap(content);
						group = values.get(relationShip + "group", "");
						if (!group.trim().equalsIgnoreCase("")) {
							adminGroup = values.get(GroupConstants.GROUP_ADMINGROUP, "");
							moderatorGroup = values.get(GROUP_MODERATORGROUP, "");
							break;
						}
						mainPage = mainPage.getParent();
						group = null;
					}
					isGroup = true;

				} else if ("specificGroup".equalsIgnoreCase(rootUser)) {
					//group set explicitly
					isGroup = true;
					group = groupId;
				}

				String adminGID = null;
				String moderatorGID = null;
				boolean isGroupAdmin = false;
				if ("currentGroup".equalsIgnoreCase(rootUser)) {
					Resource adminGroupResource = null;
					if (adminGroup != null) {
						adminGroupResource = resourceResolver.getResource(adminGroup.trim());
						if (adminGroupResource != null) {
							adminGID = adminGroupResource.adaptTo(Authorizable.class).getID();
						}
					}
					Resource moderatorGroupResource = null;
					if (moderatorGroup != null && !("".equals(moderatorGroup.trim()))) {
						moderatorGroupResource = resourceResolver.getResource(moderatorGroup.trim());
						if (moderatorGroupResource != null) {
							moderatorGID = moderatorGroupResource.adaptTo(Authorizable.class).getID();
						}
					}

					if (adminGID != null && GroupUtil.isMember(userPropertiesService, resourceResolver, loggedInUserID, adminGID)) {
						isGroupAdmin = true;
					}
				}

				if (isGroup) {
					Resource groupResource = null;
					if (group != null) {
						groupResource = resourceResolver.getResource(group.trim());
					}
					if (groupResource == null || groupResource.getResourceType().equals(Resource.RESOURCE_TYPE_NON_EXISTING)) {
						%>
							<div class="error"><p><%=  i18n.get("Unable to read group members") %>
							</p></div>
						<%
						return;
					} else {
						graphStartId = groupResource.adaptTo(Authorizable.class).getID();
						relations = new ArrayList<String>();
						if (isGroupAdmin) {
							relations.add("pending-member");
						}
						relations.add("member");
						direction = Direction.BOTH;
					}
				}

				boolean loadMore = false;
				List<People> list = new ArrayList<People>();
				SocialGraph socialGraph = resourceResolver.adaptTo(SocialGraph.class);
				if (graphStartId != null && !graphStartId.equalsIgnoreCase("anonymous")) {
					GraphNode currentUser = socialGraph.getNode(graphStartId);

					for (String relation : relations) {
						log.error("*** Current direction & relation: " + direction + " ---- " + relation + " ***");
						for (Relationship r : currentUser.getRelationships(direction, relation)) {
							String authId = r.getOtherNode(currentUser).getId();

							// skip groups and other non authorizable relations
							UserProperties userProperties = upm.getUserProperties(authId, "profile");
							if (userProperties == null || userProperties.getAuthorizableID().equals("anonymous") ||
									userProperties.getNode().getPath().contains("groups")) continue;

							if (list.size() == limit) {
								loadMore = true;
								break;
							}
							People person = new People();
							person.setId(authId);
							if (relation.contains("pending")) {
								person.setPending(true);
							}
							list.add(person);
						}
					}
				}

				if (orderBy != null || includePending) {
					Collections.sort(list, new Comparator<People>() {
						public int compare(People a, People b) {
							int result = 0;
							if (a.isPending() || b.isPending()) {
								return (new Boolean(b.isPending())).compareTo(new Boolean(a.isPending()));
							}
							try {
								if (!orderBy.equalsIgnoreCase("rep:principalName")) {
									Node x = upm.getUserProperties(a.getId(), "profile").getNode();
									Node y = upm.getUserProperties(b.getId(), "profile").getNode();
									result = x.getProperty(orderBy).getString().compareTo(y.getProperty(orderBy).getString());
								} else {
									result = a.getId().compareTo(b.getId());
								}
							} catch (Exception ex) {

							}
							return result;
						}
					});
				}
				if (!label.equalsIgnoreCase("")) {
					%><p><%= xssAPI.encodeForHTML(label) %></p><%
				}
                int totalCount = 0;
                String listTypeName = (directionConfig == "outgoing") ? "following" : "followers";
				if (!list.isEmpty()) {
                    String outputHTML = "";
                    int index = 0;
                    int quadIndex = 0;
                    for (People user : list) {
                        totalCount++;
                        UserProperties userProperties = upm.getUserProperties(user.getId(), "profile");

                        String myProfileLink = "#";
                        if (profilePagePath != null) {
                            myProfileLink = userProperties.getNode().getPath() + ".form.html" + profilePagePath;
                        }
                        if (quadIndex == 0) {
                            outputHTML += "<nav class='follow row-fluid clearfix'>";
                        }
                        String peopleListAvatar = SocialResourceUtils.getAvatar(userProperties, SocialUtils.DEFAULT_AVATAR, SocialUtils.AVATAR_SIZE.THIRTY_TWO);

                        outputHTML += "<a href='" + xssAPI.getValidHref(myProfileLink) + "' class='span3'><img src='" + xssAPI.getValidHref(peopleListAvatar) + "'/></a>";

                        request.setAttribute("index", Integer.toString(index++));
                        if ((quadIndex + 1) < 4) {
                            quadIndex++;
                        }

                        request.setAttribute("userPath", userProperties.getNode().getPath());
                        //request.setAttribute("index", Integer.toString(index++));
                        request.setAttribute("isPending", user.isPending());

                        if ("currentGroup".equalsIgnoreCase(rootUser)) {
                            outputHTML += "<sling:include path='.' resourceType='social/activitystreams/components/grouprelation'/>";
                        } else {
                            outputHTML += "<sling:include path='.' resourceType='social/activitystreams/components/togglerelation'/>";
                        }

                        if (quadIndex == 3 || index == list.size()) {
                            outputHTML += "</nav>";
                            quadIndex = 0;
                        }
                    }
                    %>
                    <div class="section-title clearfix">
                        <p><%=listTypeName%></p>
                        <span><%=totalCount%></span>
                    </div>
                    <%=outputHTML%>
					<%
                    if (loadMore) {
                    %>
                        <div class="loadmore">
                            <a href="#" onclick="CQ_Peoplelist.loadAll('<%= xssAPI.getValidHref(resource.getPath())%>','<%= xssAPI.encodeForHTMLAttr(resource.getName())%>', '<%= xssAPI.encodeForJSString(graphStartId) %>', '<%=(2 * limit)%>')"><%= i18n.get("Load More People") %></a>
                        </div>
                    <%
                    }
				} else {
					%><cq:include script="empty.jsp"/><%
				}

				if (mode == WCMMode.EDIT) {
					%></div><%
				}
				%>
			</div>
		</div>
    </div>

    <%!
        class People {
            private String id;
            private boolean isPending;

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public boolean isPending() {
                return isPending;
            }

            public void setPending(boolean isPending) {
                this.isPending = isPending;
            }
        }
    %>
