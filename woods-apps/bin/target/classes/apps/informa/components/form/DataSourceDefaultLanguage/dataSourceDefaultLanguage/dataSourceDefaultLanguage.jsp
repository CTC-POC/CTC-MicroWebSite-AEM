<%@page session="false" import="

                  org.apache.sling.api.resource.Resource,
                  org.apache.sling.api.resource.ResourceUtil,
                  org.apache.sling.api.resource.ValueMap,
                  org.apache.sling.api.resource.ResourceResolver,
                  org.apache.sling.api.resource.ResourceMetadata,
                  org.apache.sling.api.wrappers.ValueMapDecorator,
                  java.util.List,
                  java.util.ArrayList,
                  java.util.HashMap,
                  java.util.LinkedHashMap,
                  java.util.Locale,
                  java.util.Map,
                  org.apache.sling.commons.json.JSONArray,
                  org.apache.sling.commons.json.JSONObject,

                  com.adobe.granite.ui.components.ds.DataSource,
                  com.adobe.granite.ui.components.ds.EmptyDataSource,
                  com.adobe.granite.ui.components.ds.SimpleDataSource,
                  com.adobe.granite.ui.components.ds.ValueMapResource"
%><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><cq:defineObjects/><%
  
// set fallback
request.setAttribute(DataSource.class.getName(), EmptyDataSource.instance());
ResourceResolver resolver = resource.getResourceResolver();

//Create an ArrayList to hold data
List<Resource> fakeResourceList = new ArrayList<Resource>();
ValueMap vm = new ValueMapDecorator(new HashMap<String, Object>());

String jsonURL="/apps/informa/components/form/container-form/defaultLanguage.json/jcr:content";
Resource res=resourceResolver.getResource(jsonURL); 

		ValueMap jcrProp=res.adaptTo(ValueMap.class); 
		String jsonData=jcrProp.get("jcr:data",String.class); 

		Map<String,String> EventRelationshipItem = new LinkedHashMap<String,String>();
		if (jsonData != null) {     

    	JSONObject EventRelationshipObject = new JSONObject(jsonData);

    	JSONArray EventRelationshipArray = EventRelationshipObject.getJSONArray("root"); 

       for(int i = 0; i < EventRelationshipArray.length(); i++) {          

          JSONObject jsonObject = EventRelationshipArray.getJSONObject(i); 
           String EventRelationshipText=jsonObject.getString("text"); 
           String EventRelationshipValue=jsonObject.getString("value"); 
           vm = new ValueMapDecorator(new HashMap<String, Object>());


           vm.put("value",EventRelationshipValue);
 	       vm.put("text",EventRelationshipText);
           fakeResourceList.add(new ValueMapResource(resolver, new ResourceMetadata(), "nt:unstructured", vm));

       } 
  }




//Create a DataSource that is used to populate the drop-down control
DataSource ds = new SimpleDataSource(fakeResourceList.iterator());
request.setAttribute(DataSource.class.getName(), ds);
 
%>