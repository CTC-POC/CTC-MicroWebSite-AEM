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

    var settings = {
            locationURI: "",
            sensor: true,
            offline: false,
            mapHeight: 0
        }

    function LocationListCtrl($scope, $timeout, cqDeviceUtils, cqLocationService, cqMapUtils, toaster) {

        /**
         * Sort the locally provided location list or fetch a sorted list from server
         */
        function sortLocations() {
            if (settings.offline) {
                //Use local locations
                if (!$scope.origin) return;
                $scope.locations = cqLocationService.sort($scope.origin);
                $scope.$apply();
            } else {
                //Fetch locations from server
                if (cqDeviceUtils.isConnected()) {
                    var options = {};
                    if ($scope.origin) {
                        options.data = {lat: $scope.origin.lat, lng: $scope.origin.lng};
                    } else if ($scope.query) {
                        options.data = {q: $scope.query};
                    }
                    if (!options.data) return;
                    cqLocationService.fetch(settings.locationURI, options.data)
                        .then(function(data) {
                            if (data.origin) {
                                $scope.origin = data.origin.coordinates;
                            }
                            $scope.locations = cqLocationService.locations();
                        });
                } else {
                    toaster.pop("No connection");
                }
            }
        }

        $scope.init = function(dataName) {
            // Combine default settings with scope
            settings = angular.extend({}, settings, $scope.$eval(dataName));

            $scope.$watchCollection(dataName+".locations", function(newValue) {
                if (!cqLocationService.hasLocations()) {
                    cqLocationService.reset(newValue);
                }
                $scope.locate();
            }, true);
        };

        $scope.showMap = false;
        $scope.origin = null;
        $scope.locations = null;

        $scope.locate = function(forceLocation) {
            $scope.origin = null;
            //Determine device location
            if (!$scope.query) {
                if (!forceLocation) {
                    //use cached location
                    $scope.origin = cqLocationService.position;
                }
                if (!$scope.origin) {
                    //use geolocation
                    toaster.pop("Waiting for location...");
                    cqDeviceUtils.getPosition(function(position) {
                        $scope.origin = {
                            lat: position.coords.latitude,
                            lng: position.coords.longitude
                        }
                        cqLocationService.position = $scope.origin;
                        toaster.clear();
                        sortLocations();
                    }, function(error){
                        if (error.POSITION_UNAVAILABLE == error.code || error.PERMISSION_DENIED == error.code) {
                            console.log("Please enable location services and try again.");
                        } else {
                            console.log('Location error code: ' + error.code + '\n'+ 'message: ' + error.message);
                        }
                        toaster.pop("Location unavailable");
                    });
                } else {
                    $timeout(sortLocations);
                }
            } else {
                if (settings.offline) {
                    if (google && cqDeviceUtils.isConnected()) {
                        //geocode the query on client
                        var geocoder = new google.maps.Geocoder();
                        toaster.pop("Searching for location...");
                        geocoder.geocode( { 'address': $scope.query}, function(results, status) {
                            if (status == google.maps.GeocoderStatus.OK) {
                                var result = results[0];
                                toaster.pop("Location set to: " + cqMapUtils.getAddressName(result.address_components, "locality"));
                                $scope.origin = cqMapUtils.fromLatLng(result.geometry.location);
                                cqLocationService.position = $scope.origin;
                                sortLocations();
                            } else {
                                console.log('Geocode was not successful for the following reason: ' + status);
                                toaster.pop("Location not found");
                            }
                        });
                    } else {
                        toaster.pop("No connection");
                    }
                } else {
                    $timeout(sortLocations);
                }
            }
        };
    }

    angular.module('cqLocations')
        .controller('LocationListCtrl',
            ["$scope", "$timeout", "cqDeviceUtils", "cqLocationService", "cqMapUtils", "cqToastService",
                LocationListCtrl]);

}(angular));
