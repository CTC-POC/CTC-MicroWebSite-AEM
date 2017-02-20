package com.woods.core.servicehelper;

import org.apache.sling.commons.json.JSONObject;

@FunctionalInterface
public interface WoodsHttpClient {

	JSONObject getProductCatalog(final String endpointUrl);

}
