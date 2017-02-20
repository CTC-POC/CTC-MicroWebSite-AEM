package com.woods.core.dao;

import org.apache.sling.commons.json.JSONObject;

	/**
	 * Interface NavigationDao consisting of getProductCatalog function
	 */

public interface NavigationDao {
	
	/**
	 * 
	 * getProductCatalog function with that connects to WebService
	 */
	
 public JSONObject getProductsCatalog();
}
