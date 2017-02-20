package com.woods.core.dao;

import org.apache.sling.commons.json.JSONObject;

@FunctionalInterface
public interface NavigationDao {
	
 public JSONObject getProductsCatalog();
}
