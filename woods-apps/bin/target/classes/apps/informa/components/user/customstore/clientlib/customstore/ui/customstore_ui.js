/*
| Copyright 2013 Adobe
|
| Licensed under the Apache License, Version 2.0 (the "License");
| you may not use this file except in compliance with the License.
| You may obtain a copy of the License at
|
| http://www.apache.org/licenses/LICENSE-2.0
|
| Unless required by applicable law or agreed to in writing, software
| distributed under the License is distributed on an "AS IS" BASIS,
| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
| See the License for the specific language governing permissions and
| limitations under the License.
*/

if (CQ_Analytics.CustomStoreMgr ) {


    // HTML template

     CQ_Analytics.CustomStoreMgr.template = 
        "<label for=''>%value%";

    CQ_Analytics.CustomStoreMgr.templateRenderer = function(value) {


         var template = CQ_Analytics.CustomStoreMgr.template;
        return template.replace(/%value%/g, value);


     }


    CQ_Analytics.CustomStoreMgr.renderer = function(store, divId) {

        // first load data
		// CQ_Analytics.CustomStoreMgr.loadData();

		$CQ("#" + divId).children().remove();

		var name = CQ_Analytics.ProfileDataMgr.getProperty("formattedName");
		var templateRenderer = CQ_Analytics.CustomStoreMgr.templateRenderer;

        // Set title
		$CQ("#" + divId).addClass("cq-cc-customstore");
		var div = $CQ("<div>").html(name + " Extended Properties");
		$CQ("#" + divId).append(div);           


		var data = this.getJSON();

        if (data) {
            var obj = JSON.parse(JSON.stringify(data));
            if(JSON.stringify(data)!='{}'){
             	$CQ("#" + divId).append(templateRenderer('healthcare'));
            }


        }

		$CQ(".customstore-input").change(function(){
            var value = false;
        	if ($CQ(this).attr("checked")) {
            	value = true;
        	}
        	var key = $CQ(this).attr("name");
        	$CQ("label[for='customstore-input-" + key + "']").toggleClass('checked');
        	var newValue = (value === true)?"true":"false";
			CQ_Analytics.CustomStoreMgr.setTraitValue(key,newValue);
        	CQ_Analytics.ProfileDataMgr.fireEvent("update");
    	});         

    }

    CQ_Analytics.CustomStoreMgr.setTraitValue = function(trait, newValue) {

        var data = CQ_Analytics.CustomStoreMgr.data;
        if (data) {
            data[trait + '/value'] = newValue;
        }
    };

    
	CQ_Analytics.ClickstreamcloudMgr.register(CQ_Analytics.CustomStoreMgr);

}