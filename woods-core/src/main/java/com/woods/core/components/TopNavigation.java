package com.woods.core.components;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.inject.Inject;

import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.models.annotations.Model;
import org.apache.sling.models.annotations.injectorspecific.SlingObject;

import com.day.cq.wcm.api.Page;
import com.day.cq.wcm.api.PageManager;
import com.woods.core.model.navigation.NavigationVO;
import com.woods.core.models.ParentPage;
import com.woods.core.service.NavigationService;

/**
 * 
 * Top Navigation Component.
 *
 */
@Model(adaptables = Resource.class)
public class TopNavigation {

	private int absParent;

	private List<ParentPage> pageList = new ArrayList<>();
	
	private List<NavigationVO> childPage = new ArrayList<>();

	@Inject
	NavigationService navigationService;

	@SlingObject
	Resource resource;

	/**
	 * populateMenuList() method is used to get all the child nodes.
	 */
	@PostConstruct
	private void populateMenuList() {
		ValueMap properties = resource.adaptTo(ValueMap.class);

		String columns = properties.get("absParent", String.class);
		if (columns != null) {
			absParent = Integer.parseInt(columns);

			final PageManager pageManager = resource.getResourceResolver()
					.adaptTo(PageManager.class);
			Page currentPage = pageManager.getContainingPage(resource);
			Page rootPage = currentPage.getAbsoluteParent(absParent);
			Iterator<Page> rootPageIterator = rootPage.listChildren();
			while (rootPageIterator.hasNext()) {
				ParentPage parentPage = new ParentPage();
				Page childPage = rootPageIterator.next();
				if(!childPage.getProperties().get("hideInNav", false))
				{
				parentPage.setParentPageTitle(childPage.getTitle());
				parentPage.setParentPagePath(childPage.getPath());
				

				pageList.add(parentPage);
				}
			}

		}
		childPage = navigationService.getNavigationProducts();

	}

	public List<NavigationVO> getChildPage() {
		return childPage;
	}

	public List<ParentPage> getPageList() {
		return pageList;
	}

}
