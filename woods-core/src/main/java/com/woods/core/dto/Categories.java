package com.woods.core.dto;

import java.util.List;

/**
 * Categories.
 */
public class Categories {
	
	
	private String id;
	
	private String name;
	
	private String url;
	
	private List<Subcategories> subcategories = null;
	
	

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
     * Gets the name.
     * 
     * @return The name.
     */
	public String getName() {
	return name;
	}

	/**
     * Sets the name.
     * 
     * @param name The name.
     */
	public void setName(String name) {
	this.name = name;
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
     * Gets the subcategories.
     * 
     * @return The subcategories.
     */
	public List<Subcategories> getSubcategories() {
	return subcategories;
	}

	/**
     * Sets the subcategories.
     * 
     * @param subcategories The subcategories.
     */
	public void setSubcategories(List<Subcategories> subcategories) {
	this.subcategories = subcategories;
	}

	
	

}
