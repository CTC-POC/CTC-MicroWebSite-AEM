package com.woods.core.service;

import java.util.List;
import com.woods.core.model.navigation.NavigationVO;
/**
 * NavigationService.
 */
@FunctionalInterface
public interface NavigationService {
	/**
     * Gets the List<NavigationVO>.
     *
     * @return The naviagtionVoList
     */	
	public List<NavigationVO> getNavigationProducts();

}
