package com.woods.core.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.commons.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.woods.core.dao.NavigationDao;
import com.woods.core.mapper.NavigationMapper;
import com.woods.core.model.navigation.NavigationVO;
import com.woods.core.service.NavigationService;

@Component(metatype = true, label = "Woods  NavigationServiceImpl", immediate = true)
@Service(NavigationService.class)
public class NavigationServiceImpl implements NavigationService {

	protected static final Logger log = LoggerFactory
			.getLogger(NavigationServiceImpl.class);
	
     @Reference
	private NavigationDao navigationDao;

	@Override
	public List<NavigationVO> getNavigationProducts() {
		
		log.info("Inside NavigationServiceImpl------ getNavigationProducts");
		List<NavigationVO> navigationVO = new ArrayList<>();
		try {
			JSONObject catalog = navigationDao.getProductsCatalog();
			log.info("Json Object from navigationDao.getProductsCatalog()"
					+ catalog);			
			navigationVO = NavigationMapper.getNavigationModel(navigationVO,catalog);
			log.info("NavigationVO list from mapper class" + navigationVO);
		} catch (Exception e) {
			log.error("Exception occured in <---NavigationService::getNavigationProducts",e);
		}
		return navigationVO;
	}

}
