/*
 * ADOBE CONFIDENTIAL
 * __________________
 *
 *  Copyright 2014 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 */


ContextHub.console.log('[+] loading [contexthub.module.contexthub.pagedata] renderer.pagedata.js');

;(function() {

   /* todo: don't use Class() */
    var PageDataRenderer = new Class({
        extend: ContextHub.UI.BaseModuleRenderer,

        defaultConfig: {
            icon: "coral-Icon--user",

            title: 'Page Data',

            storeMapping: {
                pagedata: 'pagedata'
            },

            template:

           '<p class="contexthub-module-line2"><b>Page Name &nbsp; : &nbsp;{{pagedata.analyticsPageName}}&nbsp; </b></p>'+
            	'<p class="contexthub-module-line2">'+ 
            			'<b>Section : </b> {{pagedata.analyticsSection}},&nbsp; '+  
            			'<b>Subsection : </b>{{pagedata.analyticsSubSection}}, &nbsp;'+ 
            			'<b>Sub Section One :  </b>{{pagedata.analyticsSubSectionOne}}, &nbsp;'+
            			'<b>Sub Section Two :  </b>{{pagedata.analyticsSubSectionTwo}}, &nbsp;'+
            			'<b>Search Results Count :  </b>{{pagedata.analyticsSearchResultsCount}}, &nbsp;'+
						'<b>Search Results Style :  </b>{{pagedata.analyticsResultStyle}}'+
            	'</p>'

        }
    });


    ContextHub.UI.registerRenderer('contexthub.pagedata', new PageDataRenderer());

}());