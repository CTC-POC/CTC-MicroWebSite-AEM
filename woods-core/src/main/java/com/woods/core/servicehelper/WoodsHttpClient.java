package com.woods.core.servicehelper;

import org.apache.sling.commons.json.JSONObject;

public interface WoodsHttpClient {

	JSONObject getProductCatalog(final String endpointUrl, final String resource);

}
