package com.woods.core.dao.impl;

import java.util.ArrayList;
import java.util.Dictionary;
import java.util.List;

import org.apache.felix.scr.annotations.Activate;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.commons.json.JSONObject;
import org.apache.sling.commons.osgi.PropertiesUtil;
import org.modelmapper.ModelMapper;
import org.osgi.service.component.ComponentContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.woods.core.dao.NavigationDao;
import com.woods.core.mapper.NavigationMapper;
import com.woods.core.model.navigation.NavigationVO;
import com.woods.core.servicehelper.WoodsHttpClient;
import com.woods.core.servicehelper.impl.WoodsHttpClientImpl;

@Component(metatype = true, label = "Woods  NavigationDaoImpl", description = "Navigation that get sub levels from hybris", immediate = true)
@Service(NavigationDao.class)
public class NavigationDaoImpl implements NavigationDao {

	private static final Logger log = LoggerFactory
			.getLogger(NavigationDaoImpl.class);
	private static final String DEFAULT_NAVIGATION_HYBRIS_URL = "https://10.226.179.82:9002/rest/v2/ctc/catalogs/ctcProductCatalog/?options=CATEGORIES";
	private static final String HYBRIS_URL = "hybrisUrl";
	JSONObject catalog = null;

	@Reference
	private WoodsHttpClient woodsHttpsClient;

	@Property(name = HYBRIS_URL, label = "hybris navigation service URL ", description = "URL of hybris to get navigation sublevel", value = DEFAULT_NAVIGATION_HYBRIS_URL)
	protected String hybrisNavigationUrl;

	@Activate
	public void activate(final ComponentContext context) {
		final Dictionary<?, ?> properties = context.getProperties();
		hybrisNavigationUrl = PropertiesUtil.toString(
				properties.get(HYBRIS_URL), "");

	}

	@Override
	public JSONObject getProductsCatalog() {

		try {
			catalog = woodsHttpsClient.getProductCatalog(
					DEFAULT_NAVIGATION_HYBRIS_URL, "");
			List<NavigationVO> navigationVO = new ArrayList<>();
			navigationVO = NavigationMapper.getNavigationModel(navigationVO,
					catalog, new ModelMapper());
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		return catalog;
	}

}
