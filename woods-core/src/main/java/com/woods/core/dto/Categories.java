package com.woods.core.dto;

import java.util.List;


public class Categories {
	
	
	private String id;
	
	private String name;
	
	private String url;
	
	private List<Subcategories> subcategories = null;
	
	

	
	public String getId() {
	return id;
	}

	
	public void setId(String id) {
	this.id = id;
	}

	
	public String getName() {
	return name;
	}

	
	public void setName(String name) {
	this.name = name;
	}

	
	public String getUrl() {
	return url;
	}

	
	public void setUrl(String url) {
	this.url = url;
	}

	
	public List<Subcategories> getSubcategories() {
	return subcategories;
	}

	
	public void setSubcategories(List<Subcategories> subcategories) {
	this.subcategories = subcategories;
	}

	
	

}
