package com.woods.core.model.navigation;

import java.util.List;

public class NavigationVO {
	
   String name;
   String url;
   List<NavigationSublevel> sublevels;
   public String getName() {
	return name;
}
public void setName(String name) {
	this.name = name;
}
public String getUrl() {
	return url;
}
public void setUrl(String url) {
	this.url = url;
}
public List<NavigationSublevel> getSublevels() {
	return sublevels;
}
public void setSublevels(List<NavigationSublevel> sublevels) {
	this.sublevels = sublevels;
}

   

}
