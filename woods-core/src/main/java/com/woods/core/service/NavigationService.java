package com.woods.core.service;

import java.util.List;

import com.woods.core.model.navigation.NavigationVO;
@FunctionalInterface
public interface NavigationService {
	
	public List<NavigationVO> getNavigationProducts();

}
