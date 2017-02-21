package com.woods.core.dto;


/**
 * Subcategories.
 */
public class Subcategories {
	
	private String id;
	
    private String name;
	
    private String[] subcategories;
  
    private String url;
  
    /**
     * Gets the id.
     * 
     * @return The id.
     */
    public String getId ()
    {
        return id;
    }
    /**
     * Sets the id.
     * 
     * @param id The id.
     */
    public void setId (String id)
    {
        this.id = id;
    }
    /**
     * Gets the name.
     * 
     * @return The name.
     */
    public String getName ()
    {
        return name;
    }
    /**
     * Sets the name.
     * 
     * @param name The name.
     */
    public void setName (String name)
    {
        this.name = name;
    }
    /**
     * Gets the subcategories.
     * 
     * @return The subcategories.
     */
    public String[] getSubcategories ()
    {
        return subcategories;
    }
    /**
     * Sets the subcategories.
     * 
     * @param subcategories The subcategories.
     */
    public void setSubcategories (String[] subcategories)
    {
        this.subcategories = subcategories;
    }
    /**
     * Gets the url.
     * 
     * @return The url.
     */
    public String getUrl ()
    {
        return url;
    }
    /**
     * Sets the url.
     * 
     * @param url The url.
     */
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
