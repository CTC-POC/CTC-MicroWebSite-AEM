package com.woods.core.servicehelper.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.commons.json.JSONException;
import org.apache.sling.commons.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.woods.core.servicehelper.SSLUtilities;
import com.woods.core.servicehelper.WoodsHttpClient;

@Component(metatype = true, label = "Woods Rest Client", description = "Service that enables communication with hybris", immediate = true)
@Service(WoodsHttpClient.class)
public class WoodsHttpClientImpl implements WoodsHttpClient {

	private static final Logger log = LoggerFactory
			.getLogger(WoodsHttpClientImpl.class);

	@Override
	public JSONObject getProductCatalog(String endpointUrl, String resource) {

		log.info("Inside WoodsHttpClientImpl---- getProductCatalog");
		String responseJson = doGetResponse(endpointUrl, resource);
		JSONObject jsonObj = null;
		try {
			jsonObj = new JSONObject(responseJson);
		} catch (JSONException e) {

			log.error("Exception in getProductCatalog" + e.getMessage());
		}
		return jsonObj;
	}

	private String doGetResponse(String endpointUrl, String resource) {
		log.info("Inside WoodsHttpClientImpl---- doGetResponse");
		HttpURLConnection con;
		URL url;
		String response = null;
		try {

			url = new URL(endpointUrl);
			SSLUtilities.trustAllHostnames();
			SSLUtilities.trustAllHttpsCertificates();
			con = (HttpsURLConnection) url.openConnection();

			con.setConnectTimeout(100000);
			con.setRequestProperty("Content-Type", "application/json");

			BufferedReader in = new BufferedReader(new InputStreamReader(
					con.getInputStream()));
			String inputLine;
			StringBuffer res = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {
				res.append(inputLine);
			}
			in.close();
			con.disconnect();
			response = res.toString();
		} catch (Exception e) {

			log.error("Exception in doGetResponse" + e.getMessage());
		}
		return response;

	}

	protected Object getResponseObject(final String responseAsJson,
			final Class<?> clazz) {
		if (clazz != null && clazz.isAssignableFrom(String.class)) {
			return responseAsJson;
		}
		ObjectMapper om = new ObjectMapper();
		try {
			return om.readValue(responseAsJson, clazz);
		} catch (Exception e) {
			log.error("Exception In getResponseObject" + e.getMessage());
		}
		return om;

	}

}
