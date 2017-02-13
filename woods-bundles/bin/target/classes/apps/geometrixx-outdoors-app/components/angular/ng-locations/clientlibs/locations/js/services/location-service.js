/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
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
 **************************************************************************/
;(function (angular, undefined) {

    "use strict";

    angular.module('cqLocations')
        .service('cqLocationService', ['$http', '$q', function ($http, $q) {

            var locations = [];

            /** Converts numeric degrees to radians */
            if (typeof Number.prototype.toRad == 'undefined') {
                Number.prototype.toRad = function() {
                    return this * Math.PI / 180;
                }
            }

            function compareDistance(a,b) {
                if (a.distance == undefined || b.distance == undefined) return 0;
                if (a.distance < b.distance)
                    return -1;
                if (a.distance > b.distance)
                    return 1;
                return 0;
            }

            function calculateDistance(start, end) {
                var d = 0;
                if (start && end) {
                    var R = 6371;
                    var lat1 = start.lat.toRad(), lon1 = start.lng.toRad();
                    var lat2 = end.lat.toRad(), lon2 = end.lng.toRad();
                    var dLat = lat2 - lat1;
                    var dLon = lon2 - lon1;

                    var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                        Math.cos(lat1) * Math.cos(lat2) *
                            Math.sin(dLon/2) * Math.sin(dLon/2);
                    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
                    d = R * c;
                }
                return d;
            }

            function applyDistance(origin) {
                if (origin.lat && origin.lng) {
                    for (var i=0; i < locations.length; i++) {
                        var loc = locations[i];
                        loc["distance"] = calculateDistance(origin, loc.coordinates);
                    }
                }
            }

            return {

                position: undefined,
                selectedLocation: undefined,

                locations:function () {
                    return locations;
                },
                hasLocations:function () {
                    return (locations != undefined && locations.length > 0);
                },
                add:function (items) {
                    if (items == null || items == undefined) return;
                    if (!angular.isArray(items)) {
                        items = [items];
                    }
                    locations = locations.concat(items);
                },
                reset:function (items) {
                    locations = [];
                    this.add(items);
                },
                sort:function (origin) {
                    applyDistance(origin);
                    return locations.sort(compareDistance);
                },
                fetch:function(url, params) {
                    var def = $q.defer();
                    $http.get(url, {
                        params: params
                    }).success(function(data, status) {
                        locations = data.locations;
                        def.resolve(data);
                    }).error(function(data,status){
                        def.reject(data);
                    });
                    return def.promise;
                }
            };
        }
    ]);

}(angular));
