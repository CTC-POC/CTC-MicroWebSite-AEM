package com.woods.core.model.navigation;

import java.util.List;

/**
 * NavigationVO.
 */
public class NavigationVO {

	String name;
	String url;
	List<NavigationSublevel> sublevels;

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
	 * @param id The name.
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
	 * @param id The url.
	 */
	public void setUrl(String url) {
		this.url = url;
	}
	/**
	 * Gets the sublevels.
	 * 
	 * @return The sublevels.
	 */
    public List<NavigationSublevel> getSublevels() {
		return sublevels;
	}
    /**
	 * Sets the sublevels.
	 * 
	 * @param id The sublevels.
	 */
	public void setSublevels(List<NavigationSublevel> sublevels) {
		this.sublevels = sublevels;
	}

}
