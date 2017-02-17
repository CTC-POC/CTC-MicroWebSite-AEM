package com.woods.core.components;

import java.util.ArrayList;

import javax.inject.Inject;
import javax.inject.Named;

import org.apache.sling.api.resource.Resource;
import org.apache.sling.models.annotations.Model;

import com.woods.core.models.MultifieldModel;

@Model(adaptables = Resource.class)
public class Multifield {
	
	private static final String ITEM_CHILD = "multi";
	
	private ArrayList<MultifieldModel> childList = new ArrayList<>();
	private Resource resource;
	
	@Inject
	public Multifield(@Named("resource") Resource resource) {
		this.resource = resource;

		init();
	}
	
	protected void init() {
		populateChildList(childList);

	}

	/**
	 * This method is used to get all the child nodes of the multifield
	 */
	private void populateChildList(final ArrayList<MultifieldModel> childList) {
	
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
	public ArrayList<MultifieldModel> getChildList() {
		return childList;
	}
}
