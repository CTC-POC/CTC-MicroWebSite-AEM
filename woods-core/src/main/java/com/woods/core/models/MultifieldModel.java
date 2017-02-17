package com.woods.core.models;

import javax.inject.Inject;
import javax.inject.Named;

import org.apache.sling.api.resource.Resource;
import org.apache.sling.models.annotations.Model;
import org.apache.sling.models.annotations.Optional;


@Model(adaptables = Resource.class)
public class MultifieldModel {
	@Inject
	@Optional
	private String title;
	
	@Inject
	@Optional
	private boolean externalUrl=false;

	@Inject
	@Optional
	private boolean openInNewWindow=false;
	@Inject
	@Optional
	private String linkPath;
	@Inject
	@Optional
	private String url;
	@Inject
	@Optional
	private String openUrlInNewWindow;
	
	@Inject
	@Optional
	private String imagePath;
	@Inject
	@Optional
	private String text;
	@Inject
	@Optional
	private String altText;
	
	@Inject
	@Optional
	private String titledescription;
	
	@Inject
	@Optional
	private String image;
	
	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public String getTitledescription() {
		return titledescription;
	}
	
	public boolean isExternalUrl() {
		return externalUrl;
	}

	public void setExternalUrl(boolean externalUrl) {
		this.externalUrl = externalUrl;
	}

	public void setTitledescription(String titledescription) {
		this.titledescription = titledescription;
	}

	public String getImagePath() {
		return imagePath;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getAltText() {
		return altText;
	}

	public void setAltText(String altText) {
		this.altText = altText;
	}

	public String getOpenUrlInNewWindow() {
		return openUrlInNewWindow;
	}

	public void setOpenUrlInNewWindow(String openUrlInNewWindow) {
		this.openUrlInNewWindow = openUrlInNewWindow;
	}

	

	public void setLinkPath(String linkPath) {
		this.linkPath = linkPath;
	}

	public boolean isOpenInNewWindow() {
		return openInNewWindow;
	}

	public void setOpenInNewWindow(boolean openInNewWindow) {
		this.openInNewWindow = openInNewWindow;
	}

	public String getLinkPath() {
		return linkPath;
	}

	public String getTitle() {
		return title;
	}


	public String getUrl() {
		return url;
	}

	

}
