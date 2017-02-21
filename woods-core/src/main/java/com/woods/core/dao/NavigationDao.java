package com.woods.core.dao;

import org.apache.sling.commons.json.JSONObject;
/**
 * NavigationDao .
 */
@FunctionalInterface
public interface NavigationDao {
	/**
     * Gets the JSONObject.
     *
     * @return The JSONObject
     */	
 public JSONObject getProductsCatalog();
}
