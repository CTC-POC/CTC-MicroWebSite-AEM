package com.woods.core.components;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;

import org.apache.sling.api.resource.Resource;
import org.apache.sling.models.annotations.Model;
import org.apache.sling.models.annotations.injectorspecific.SlingObject;

import com.woods.core.models.MultifieldModel;
/**
 * Multifield.
 */
@Model(adaptables = Resource.class)
public class Multifield {
	
	private static final String ITEM_CHILD = "multi";
	
	private List<MultifieldModel> childList = new ArrayList();

	@SlingObject
	private Resource resource;

	/**
	 * This method is used to get all the child nodes of the multifield
	 */
	@PostConstruct
	private void populateChildList() {
	

		final Resource itemsResource = resource.getChild(ITEM_CHILD);
		if (null != itemsResource) {
			final Iterable<Resource> multiResources = itemsResource
					.getChildren();

			for (Resource childResource : multiResources) {
				final MultifieldModel lists = childResource
						.adaptTo(MultifieldModel.class);
				childList.add(lists);

}
		}
	}
	 /**
     * Gets the childList.
     * 
     * @return The childList.
     */
	public List<MultifieldModel> getChildList() {
		return childList;
	}
}
