/*
 * ADOBE CONFIDENTIAL
 *
 * Copyright 2013 Adobe Systems Incorporated
 * All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 */
;(function ($, ns, channel, window, undefined) {

    // extjs compatibility layer
    // this objects are necessary to parse the edit config list
    var CQ = window.CQ ||{};

    CQ.wcm = CQ.wcm || {};
    CQ.WCM = CQ.WCM || {};
    CQ.wcm.EditBase = CQ.wcm.EditBase || { // shim necessary for the component list
        'EDIT' : 'EDIT',
        'ANNOTATE': 'ANNOTATE',
        'DELETE': 'DELETE',
        'MOVE': 'MOVE',
        'COPY': 'COPY',
        'INSERT': 'INSERT',
        'INLINE_MODE_AUTO': 'auto',
        'INLINE_MODE_FORCED': 'forced',
        'INLINE_MODE_NEVER': 'never',
        'COPYMOVE': 'COPYMOVE',
        'EDITDELETE': 'EDITDELETE',
        'EDITDELETEINSERT': 'EDITDELETEINSERT',
        'EDITCOPYMOVEINSERT': 'EDITCOPYMOVEINSERT',
        'EDITCOPYMOVEDELETEINSERT': 'EDITCOPYMOVEDELETEINSERT',
        'EDITANNOTATE': 'EDITANNOTATE',
        'EDITANNOTATEDELETE': 'EDITANNOTATEDELETE',
        'EDITANNOTATECOPYMOVEDELETEINSERT': 'EDITANNOTATECOPYMOVEDELETEINSERT',
        'EDITANNOTATECOPYMOVEINSERT': 'EDITANNOTATECOPYMOVEINSERT',
        'EDITANNOTATEDELETEINSERT': 'EDITANNOTATEDELETEINSERT'
    };

    CQ.WCM.getTopWindow = CQ.WCM.getTopWindow || function () {
        return window;
    };

    /**
     * Calculates all the different Cell Search Paths for a given Cell Search Path expression.
     * The Cell Search Path expression is basically a simple string that describes in a condensed form the possible design cell paths of a given Editable. It is generally available under the Editable's editConfig.
     * The Cell Search Paths are then used to resolve design properties (i.e., allowed components of a parsys) under /etc/designs/
     * 
     * @param {Granite.author.Editable~EditConfig|string} cfg - Either the whole editConfig object of the Editable (deprecated), or the Cell Search Path expression string (preferred) that will be used to compute all the different Cell Search Paths.
     *
     * @return {Array} - An array of all the Cell Search Paths derived from the Cell Search Path expression.
     */
    ns.calculateSearchPaths = function(cfg) {
        var self  = {};
        // cfg is not used apart from getting the csp property here; keeping cfg for API compatibility
        var searchExpr = (typeof cfg == "string" ? cfg : cfg.csp);

        /**
         * Internal function that multiplies the given paths array with the names.
         * @param {Array} paths array of paths
         * @param {Array} names array of names
         * @return {Array} the product
         */
        self.multiply = function(paths, names) {
            var tmp = [];
            for (var i=0; i<paths.length; i++) {
                var path = paths[i];
                for (var j=0; j<names.length; j++) {
                    var name = names[j];
                    var s = path;
                    if (s.length > 0) {
                        s+="/";
                    }
                    s+=name;
                    tmp[tmp.length] = s;
                }
            }
            return tmp.concat(paths);
        };

        self.names = [];
        self.searchPaths = [];
        var ps = (searchExpr || '').split('/');
        var unique = {};
        var segments = [];
        var i;
        for (i = 0; i<ps.length; i++) {
            if (ps[i].length > 0 && !unique[ps[i]]) {
                unique[ps[i]] = true;
                segments[segments.length] = ps[i].split('|');
            }
        }
        if (segments.length > 0) {
            var start = 0;
            var end = segments.length;
            self.names = segments[--end];

            // calculate the search path
            var parentPaths = [];
            while (start < end) {
                var segs = segments[start++];
                if (self.searchPaths.length == 0) {
                    for (i=0;i<segs.length; i++) {
                        self.searchPaths[self.searchPaths.length] = segs[i];
                        parentPaths[parentPaths.length] = segs[i];
                    }
                } else {
                    var ret = self.multiply(parentPaths, segs);
                    parentPaths = [];
                    for (i=0; i<ret.length; i++) {
                        parentPaths[i] = ret[i];
                    }
                    for (i=0; i<self.searchPaths.length; i++) {
                        ret[ret.length] = self.searchPaths[i];
                    }
                    self.searchPaths = ret;
                }
            }
            self.searchPaths = self.multiply(self.searchPaths, self.names);
            for (i=0; i<self.names.length; i++) {
                self.searchPaths[self.searchPaths.length] = self.names[i];
            }
        }

        return self.searchPaths;
    };

    /**
     * Cleans config data; removing objects that are jcr: prefixed or have "xtype" keys
     *
     * @param {Object} data The editing config data to clean
     */
    ns.configCleaner = function(data) {
        var jcrPrefix = "jcr:",
            cfg = data;

        // Remove unwanted keys
        for (var key in cfg) {
            if (cfg.hasOwnProperty(key)) {
                if (key == "xtype") {
                    delete cfg[key];
                } else if (key.length >= jcrPrefix.length && key.substring(0, jcrPrefix.length) == jcrPrefix) {
                    delete cfg[key];
                }

            }
        }

        // Repeat
        for (var key in cfg) {
            if (cfg.hasOwnProperty(key)) {
                var child = cfg[key];
                if ($.isArray(child)) {
                    for (var c = 0; c < child.length; c++) {
                        child[c] = ns.configCleaner(child[c]);
                    }
                } else if ($.isPlainObject(child)) {
                    child = ns.configCleaner(child);
                }
            }
        }

        return cfg;
    };

    /**
     * parses the legacy config for CQ editables
     */
    ns.configParser = function (config) {
        // either it is a real JSON object or we have to resolve it as an JS config (resolving legacy const)
        var cfg = !$.isPlainObject(config) ? eval("(" + config + ")") : config;

        // clean in-place editing config
        if (cfg.ipeConfig) {
            cfg.ipeConfig = ns.configCleaner(cfg.ipeConfig);
        }

        return cfg;
    };

}(jQuery, Granite.author, jQuery(document), this));