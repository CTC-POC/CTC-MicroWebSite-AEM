package com.woods.core.models;

import javax.inject.Inject;
import javax.inject.Named;

import org.apache.sling.api.resource.Resource;
import org.apache.sling.models.annotations.Model;
import org.apache.sling.models.annotations.Optional;

/**
 * MultifieldModel.
 */
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
	
	/**
	 * Gets the image.
	 * 
	 * @return The image.
	 */
	public String getImage() {
		return image;
	}
	/**
	 * Sets the image.
	 * 
	 * @param id The image.
	 */
	public void setImage(String image) {
		this.image = image;
	}
	/**
	 * Gets the titledescription.
	 * 
	 * @return The titledescription.
	 */
	public String getTitledescription() {
		return titledescription;
	}
	 /**
     * Indicates if the externalUrl is selected.
     * 
     * @return selected Indicates if the externalUrl is selected.
     */
	public boolean isExternalUrl() {
		return externalUrl;
	}
	/**
	 * Sets the externalUrl.
	 * 
	 * @param id The externalUrl.
	 */
	public void setExternalUrl(boolean externalUrl) {
		this.externalUrl = externalUrl;
	}
	/**
	 * Sets the titledescription.
	 * 
	 * @param id The titledescription.
	 */
	public void setTitledescription(String titledescription) {
		this.titledescription = titledescription;
	}
	/**
	 * Gets the imagePath.
	 * 
	 * @return The imagePath.
	 */
	public String getImagePath() {
		return imagePath;
	}
	/**
	 * Sets the imagePath.
	 * 
	 * @param id The imagePath.
	 */
	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}
	/**
	 * Gets the text.
	 * 
	 * @return The text.
	 */
	public String getText() {
		return text;
	}
	/**
	 * Sets the text.
	 * 
	 * @param id The text.
	 */
	public void setText(String text) {
		this.text = text;
	}
	/**
	 * Gets the altText.
	 * 
	 * @return The altText.
	 */
	public String getAltText() {
		return altText;
	}
	/**
	 * Sets the altText.
	 * 
	 * @param id The altText.
	 */
	public void setAltText(String altText) {
		this.altText = altText;
	}
	/**
	 * Gets the openUrlInNewWindow.
	 * 
	 * @return The openUrlInNewWindow.
	 */
	public String getOpenUrlInNewWindow() {
		return openUrlInNewWindow;
	}
	/**
	 * Sets the openUrlInNewWindow.
	 * 
	 * @param id The openUrlInNewWindow.
	 */
   public void setOpenUrlInNewWindow(String openUrlInNewWindow) {
		this.openUrlInNewWindow = openUrlInNewWindow;
	}

	
   /**
	 * Sets the linkPath.
	 * 
	 * @param id The linkPath.
	 */
	public void setLinkPath(String linkPath) {
		this.linkPath = linkPath;
	}
	/**
     * Indicates if the openInNewWindow is selected.
     * 
     * @return selected Indicates if the openInNewWindow is selected.
     */
	public boolean isOpenInNewWindow() {
		return openInNewWindow;
	}
	/**
	 * Sets the openInNewWindow.
	 * 
	 * @param id The openInNewWindow.
	 */
	public void setOpenInNewWindow(boolean openInNewWindow) {
		this.openInNewWindow = openInNewWindow;
	}
	/**
	 * Gets the linkPath.
	 * 
	 * @return The linkPath.
	 */
	public String getLinkPath() {
		return linkPath;
	}
	/**
	 * Gets the title.
	 * 
	 * @return The title.
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * Gets the url.
	 * 
	 * @return The url.
	 */
	public String getUrl() {
		return url;
	}

	

}
