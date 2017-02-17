package com.woods.core.dto;

import java.util.List;


public class CatalogVersions {
	
	
	private String id;
	
	private String url;
	
	private List<Categories> categories = null;
	
	

	
	public String getId() {
	return id;
	}

	
	public void setId(String id) {
	this.id = id;
	}

	
	public String getUrl() {
	return url;
	}

	
	public void setUrl(String url) {
	this.url = url;
	}

	
	public List<Categories> getCategories() {
	return categories;
	}

	
	public void setCategories(List<Categories> categories) {
	this.categories = categories;
	}

	
	

	

}
