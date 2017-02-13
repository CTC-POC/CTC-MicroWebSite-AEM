/*
 * ADOBE CONFIDENTIAL
 * __________________
 *
 *  Copyright 2013 Adobe Systems Incorporated
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


ContextHub.console.log('[+] loading [contexthub.store.contexthub.profileinfo] store.profileinfo.js');

;(function ($, window) {
    'use strict';

    var data;

    var addAttribute = function(key, value) {
        var result = {};
        result[key] = value;
        data = $.extend(true, data, result);
        return result;
    };

    function ProfileInfoStore(name, config) {

    	this.init(name, config);
    	this.config = $.extend({}, this.config, config);
    	var isLoggedIn = getCookie('isLoggedIn');
    	if(isLoggedIn == "true")
    	{
    		this.readData();
    	}
    	else 
    	{
    		addAttribute('firstName', ''); 
    		addAttribute('lastName', '');
    		addAttribute('webAddressPersonal', '');
    		addAttribute('webProfileId', '');
    		addAttribute('organizationName', ''); 
    		addAttribute('designation', '');
    		addAttribute('department', '');
    		addAttribute('country', '');
            this.addAllItems(data, { defer: 0 });
    	}
    }

    ContextHub.Utils.inheritance.inherit(ProfileInfoStore, ContextHub.Store.PersistedStore);

    ProfileInfoStore.prototype.readData = function() {
    	data = {};
    	try {
    		var isProfileLoaded = getCookie('isProfileLoaded');
    		if(isProfileLoaded == "" || isProfileLoaded == "false")
    		{
    			var url = "/content/data/informa/servlet/editProfile";
    			var profile = CQ.shared.HTTP.eval(url); 
    			if(profile.webProfileId != null )
    			{
    				addAttribute('firstName', profile.firstName); 
    				addAttribute('lastName', profile.surname);
    				addAttribute('webAddressPersonal', profile.webAddressPersonal);
    				addAttribute('webProfileId', profile.webProfileId);
    				localStorage.setItem('webProfileId', profile.webProfileId);
    				setCookie('isProfileLoaded', true);
    				if(typeof profile.organization != 'undefined' && profile.organization != null)
    				{
    					addAttribute('organizationName', profile.organization.organizationName); 
    					addAttribute('designation', profile.organization.designation);
    					addAttribute('department', profile.organization.department);
    				}
    				if(typeof profile.contactInformation != 'undefined' && profile.contactInformation != null)
    				{
    					if(typeof profile.contactInformation.address != 'undefined' && profile.contactInformation.address != null)
    					{
    						addAttribute('country', profile.contactInformation.address.addressCountry);
    					}
    				}
    			}
                this.addAllItems(data, { defer: 0 });
    		}

    	}
    	catch(err) {
    		console.log(err);
    	}
    };

    ProfileInfoStore.prototype.reset = function(keepRemainingData) {
        this.uber("reset", keepRemainingData);
        this.readData();
    };

    ContextHub.Utils.storeCandidates.registerStoreCandidate(ProfileInfoStore, 'contexthub.profileinfo', 0);

    function setCookie(cookieName, cookieValue) {
    	var d = new Date();
    	d.setTime(d.getTime() + (30 * 60 * 1000));
    	var expires = "expires=" + d.toUTCString();
    	document.cookie = cookieName + "=" + cookieValue + ";" + expires + ";path=/";
    }

    function getCookie(cname) {
    	var name = cname + "=";
    	var ca = document.cookie.split(';');
    	for(var i = 0; i <ca.length; i++) {
    		var c = ca[i];
    		while (c.charAt(0)==' ') {
    			c = c.substring(1);
    		}
    		if (c.indexOf(name) == 0) {
    			return c.substring(name.length,c.length);
    		}
    	}
    	return "";
    }

}(ContextHubJQ, this));
