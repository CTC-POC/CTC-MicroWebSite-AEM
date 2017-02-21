package com.woods.core.components;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import javax.inject.Inject;
import javax.inject.Named;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.models.annotations.Model;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Column control component.
 */
@Model(adaptables = Resource.class)
public class ColumnControl
{ 
	
	 private final Logger log = LoggerFactory.getLogger(ColumnControl.class);
	 private Resource resource;
	 private static final String DEFAULT_COLUMNS = "1-col";

    private String[] columnsCssClass;
    private boolean childColumnControl;
    
    @Inject
    public ColumnControl(@Named("resource") Resource resource) {
        this.resource = resource;

        init();
    }
    
    protected void init() {
        populateColumnList( );
        
    }
    
    /**
     * This method is used to get all the child nodes of the multifield
     */
    private void populateColumnList() 
    {
    	// Get columns
    	ValueMap properties = resource.adaptTo(ValueMap.class);
    	final String columns = properties.get("columns", DEFAULT_COLUMNS);
    	Properties prop = new Properties();
    	InputStream in = ColumnControl.class.getResourceAsStream("/columnControl.properties");
    	try {  		
			prop.load(in);
		} catch (IOException e) {
			log.error("Exception Occured" + e);
		}
    	columnsCssClass = prop.getProperty(columns).split(",");

       // Determine if column control is a child of another column control
       childColumnControl = false;
       Resource parentResource = resource.getParent();
       while (parentResource != null && !"jcr:content".equals(parentResource.getName()))
       {
           if ("foundation/components/iparsys".equals(parentResource.getResourceType()))
           {
               childColumnControl = true;
               break;
           }
           parentResource = parentResource.getParent();
           
       }
    }
    
    /**
     * Gets the columns CSS class.
     * 
     * @return The columns CSS class.
     */
    public String[] getColumnsCssClass() {
		return columnsCssClass;
	}
    /**
     * Indicates if the column control is a child of another column control.
     * 
     * @return If the column control is a child of another column control.
     */
	public boolean isChildColumnControl() {
		return childColumnControl;
	}

}
