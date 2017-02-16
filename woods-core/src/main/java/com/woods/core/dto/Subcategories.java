package com.woods.core.dto;



public class Subcategories {
	
	private String id;
	
    private String name;
	
    private String[] subcategories;
  
    private String url;
  
    public String getId ()
    {
        return id;
    }
  
    public void setId (String id)
    {
        this.id = id;
    }
  
    public String getName ()
    {
        return name;
    }
   
    public void setName (String name)
    {
        this.name = name;
    }
   
    public String[] getSubcategories ()
    {
        return subcategories;
    }
    
    public void setSubcategories (String[] subcategories)
    {
        this.subcategories = subcategories;
    }
    
    public String getUrl ()
    {
        return url;
    }
   
    public void setUrl (String url)
    {
        this.url = url;
    }

    @Override
    public String toString()
    {
        return "ClassPojo [id = "+id+", name = "+name+", subcategories = "+subcategories+", url = "+url+"]";
    }
}
