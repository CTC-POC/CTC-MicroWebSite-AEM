package com.woods.core.dto;

import java.util.List;

/**
 * CatalogVersions.
 */
public class CatalogVersions {
	
	
	private String id;
	
	private String url;
	
	private List<Categories> categories = null;
	
	/**
     * Gets the id.
     * 
     * @return The id.
     */
	public String getId() {
	return id;
	}

	/**
     * Sets the id.
     * 
     * @param id The id.
     */
	public void setId(String id) {
	this.id = id;
	}

	/**
     * Gets the url.
     * 
     * @return The url.
     */
	public String getUrl() {
	return url;
	}

	/**
     * Sets the url.
     * 
     * @param url The url.
     */
	public void setUrl(String url) {
	this.url = url;
	}

	/**
     * Gets the categories.
     * 
     * @return The categories.
     */
	public List<Categories> getCategories() {
	return categories;
	}

	/**
     * Sets the categories.
     * 
     * @param categories The categories.
     */
	public void setCategories(List<Categories> categories) {
	this.categories = categories;
	}

	
	

	

}
