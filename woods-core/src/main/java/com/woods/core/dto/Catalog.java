package com.woods.core.dto;

import java.util.List;
/**
 * Catalog.
 */
public class Catalog {

	private String id;
	private String name;
	private String type;
	private String url;
	private List<CatalogVersions> catalogVersions;

	/**
     * Gets the catalogVersions.
     * 
     * @return The catalogVersions.
     */
	public List<CatalogVersions> getCatalogVersions() {
		return catalogVersions;
	}
	/**
     * Sets the catalogVersions.
     * 
     * @param catalogVersions The catalogVersions.
     */
	public void setCatalogVersions(List<CatalogVersions> catalogVersions) {
		this.catalogVersions = catalogVersions;
	}
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
     * Gets the type.
     * 
     * @return The type.
     */
	public String getType() {
		return type;
	}
	/**
     * Sets the type.
     * 
     * @param type The type.
     */

	public void setType(String type) {
		this.type = type;
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

}
