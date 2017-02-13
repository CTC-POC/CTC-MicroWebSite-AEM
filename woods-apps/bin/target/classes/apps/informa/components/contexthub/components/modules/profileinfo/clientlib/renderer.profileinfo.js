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


ContextHub.console.log('[+] loading [contexthub.module.contexthub.profileinfo] renderer.profileinfo.js');

;(function() {

   /* todo: don't use Class() */
    var ProfileinfoRenderer = new Class({
        extend: ContextHub.UI.BaseModuleRenderer,

        defaultConfig: {
            icon: "coral-Icon--user",

            title: 'Profile Information',

            storeMapping: {
                profileinfo: 'profileinfo'
            },

            template:
            '<p class="contexthub-module-line2"><b>Profile &nbsp; : &nbsp;{{profileinfo.firstName}} &nbsp; {{profileinfo.lastName}}, Email : &nbsp; {{profileinfo.webAddressPersonal}}</b></p>'+
            	'<p class="contexthub-module-line2">'+
            			'<b>Organization Name :  </b>{{profileinfo.organizationName}}, &nbsp;'+
            			'<b>Designation :  </b>{{profileinfo.designation}}, &nbsp;'+
            			'<b>Department :  </b>{{profileinfo.department}}, &nbsp;'+
            			'<b>Country :  </b>{{profileinfo.country}}'+
            	'</p>'

        }
    });


    ContextHub.UI.registerRenderer('contexthub.profileinfo', new ProfileinfoRenderer());

}());