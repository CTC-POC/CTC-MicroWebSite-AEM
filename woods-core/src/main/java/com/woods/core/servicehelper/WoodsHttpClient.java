package com.woods.core.servicehelper;

import org.apache.sling.commons.json.JSONObject;
/**
 * WoodsHttpClient .
 */
@FunctionalInterface
public interface WoodsHttpClient {
	/**
     * Gets the JSONObject.
     * @param endpointurl String.
     * @return The JSONObject
     */	
	JSONObject getProductCatalog(final String endpointUrl);

}
