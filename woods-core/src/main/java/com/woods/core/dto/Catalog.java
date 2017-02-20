package com.woods.core.dto;

import java.util.List;


public class Catalog {

	private String id;
	private String name;
	private String type;
	private String url;
	private List<CatalogVersions> catalogVersions;

	
	public List<CatalogVersions> getCatalogVersions() {
		return catalogVersions;
	}

	public void setCatalogVersions(List<CatalogVersions> catalogVersions) {
		this.catalogVersions = catalogVersions;
	}

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

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

}
