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


ContextHub.console.log('[+] loading [contexthub.module.contexthub.eventdata] renderer.eventdata.js');

;(function() {

   /* todo: don't use Class() */
    var EventDataRenderer = new Class({
        extend: ContextHub.UI.BaseModuleRenderer,

        defaultConfig: {
            icon: "coral-Icon--user",

            title: 'Event Data Information',

            storeMapping: {
                eventdata: 'eventdata'
            },

            template:

            '<p class="contexthub-module-line2"><b>Event Region &nbsp; : &nbsp;{{eventdata.analyticsRegion}}&nbsp;, Buisiness Unit &nbsp; : &nbsp;{{eventdata.analyticsBusinessUnit}}&nbsp; </b></p>'+
            	'<p class="contexthub-module-line2">'+
            			'<b>Brand : </b>{{eventdata.analyticsBrand}}, &nbsp;'+ 
            			'<b>Site Index :  </b>{{eventdata.analyticsSiteIndex}}, &nbsp;'+
            			'<b>Event Series :  </b>{{eventdata.analyticsEventSeries}}, &nbsp;'+
            			'<b>Event Edition :  </b>{{eventdata.analyticsEventEdition}}, &nbsp;'+
            			'<b>Event Edition Code :  </b>{{eventdata.analyticseventEditionCode}}, &nbsp;'+
            			'<b>Vertical :  </b>{{eventdata.analyticsVertical}}, &nbsp;'+
            			'<b>Exhibition Id :  </b>{{eventdata.analyticsExhibitionId}}'+
            	'</p>'


        }
    });


    ContextHub.UI.registerRenderer('contexthub.eventdata', new EventDataRenderer());

}());