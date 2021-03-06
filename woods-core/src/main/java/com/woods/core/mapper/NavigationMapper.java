package com.woods.core.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.sling.commons.json.JSONArray;
import org.apache.sling.commons.json.JSONException;
import org.apache.sling.commons.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.woods.core.dto.Catalog;
import com.woods.core.dto.CatalogVersions;
import com.woods.core.dto.Categories;
import com.woods.core.model.navigation.NavigationSublevel;
import com.woods.core.model.navigation.NavigationVO;
/**
 * NavigationMapper .
 */
public class NavigationMapper {
	protected static final Logger log = LoggerFactory
			.getLogger(NavigationMapper.class);

	private NavigationMapper() {

	}

	/**
	 * get User data and map it from DTO to VO
	 */
	@SuppressWarnings("null")
	public static List<NavigationVO> getNavigationModel(
			List<NavigationVO> navigationVO, JSONObject catalogjson) {
		log.debug("Inside NavigationMapper----------getNavigationModel");
		Catalog catalog = new Catalog();
		List<CatalogVersions> catalogVersionsList = new ArrayList<>();
		if (null != catalogjson) {
			try {
				catalog.setId(catalogjson.get("id").toString());
				catalog.setName(catalogjson.get("name").toString());
				catalog.setType(catalogjson.get("type").toString());
				catalog.setUrl(catalogjson.get("url").toString());
				JSONArray array = new JSONArray(catalogjson.get(
						"catalogVersions").toString());

				CatalogVersions catalogVersions = new CatalogVersions();
				catalogVersions.setId(array.getJSONObject(1).get("id")
						.toString());
				catalogVersions.setUrl(array.getJSONObject(1).get("url")
						.toString());
				JSONArray categoriesarray = new JSONArray(array
						.getJSONObject(1).get("categories").toString());
				int k=0;
				while (k < categoriesarray.length()) {

					if (categoriesarray.getJSONObject(k).get("name").toString().equalsIgnoreCase("WOODS PRODUCTS")) {
				Categories categories = new Categories();
				categories.setId(categoriesarray.getJSONObject(k).get("id")
						.toString());
				categories.setUrl(categoriesarray.getJSONObject(k).get("url")
						.toString());
				JSONArray subcategoriesarray = new JSONArray(categoriesarray
						.getJSONObject(k).get("subcategories").toString());
				int i = 0;
				while (i < subcategoriesarray.length()) {

					if (subcategoriesarray.getJSONObject(i).has("name")) {
						List<NavigationSublevel> navigationSublevelLsit = new ArrayList<>();
						NavigationVO navigation = new NavigationVO();
						navigation.setName(subcategoriesarray.getJSONObject(i)
								.get("name").toString());
						navigation.setUrl(subcategoriesarray.getJSONObject(i)
								.get("url").toString());
						navigationVO.add(navigation);
						JSONArray subcategoriesOnearray = new JSONArray(
								subcategoriesarray.getJSONObject(i)
										.get("subcategories").toString());
						int j = 0;
						while (j < subcategoriesOnearray.length()) {

							if (subcategoriesOnearray.getJSONObject(j).has(
									"name")) {
								NavigationSublevel navigationSublevel = new NavigationSublevel();
								navigationSublevel
										.setName(subcategoriesOnearray
												.getJSONObject(j).get("name")
												.toString());
								navigationSublevel
										.setUrl(subcategoriesOnearray
												.getJSONObject(j).get("url")
												.toString());
								navigationSublevelLsit.add(navigationSublevel);
								j++;
							} else {
								j++;
							}

						}

						navigation.setSublevels(navigationSublevelLsit);
						i++;
					} else {
						i++;
					}
				}

				catalogVersionsList.add(catalogVersions);

				catalog.setCatalogVersions(catalogVersionsList);
           k++;
			} 
					else
					{
						k++;
					}
				}
			}catch (JSONException e) {

				log.error("Exception in mapper", e);
			}

		}
		log.debug("End of mapper" + navigationVO);
		return navigationVO;

	}
}