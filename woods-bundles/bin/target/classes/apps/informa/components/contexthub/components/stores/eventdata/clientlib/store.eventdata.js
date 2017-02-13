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


ContextHub.console.log('[+] loading [contexthub.store.contexthub.eventdata] store.eventdata.js');

;(function ($, window) {
    'use strict';

    var data;

    var addAttribute = function(key, value) {
        var result = {};
        result[key] = value;
        data = $.extend(true, data, result);
        return result;
    };

    function EventDataStore(name, config) {

        this.init(name, config);
        this.config = $.extend({}, this.config, config);
		this.readData();
    }

    ContextHub.Utils.inheritance.inherit(EventDataStore, ContextHub.Store.PersistedStore);

    EventDataStore.prototype.readData = function() {
        data = {};
        try {

			//ContextHub.set("eventdata", {"region" : "banglore1"});
            }
		catch(err) {
   		 console.log('Error');
		}
    };

    EventDataStore.prototype.reset = function(keepRemainingData) {
        this.uber("reset", keepRemainingData);
        this.readData();
    };

    ContextHub.Utils.storeCandidates.registerStoreCandidate(EventDataStore, 'contexthub.eventdata', 0);


}(ContextHubJQ, this));
