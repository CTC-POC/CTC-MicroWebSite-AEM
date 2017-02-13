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

    function formatDistance(d) {
        d = d || 0;
        if (d > 1) {
            return Math.round(d) + " km";
        } else {
            d = d * 1000;
            return Math.round(d) + " m";
        }
    }

    function LocationItemCtrl($scope, $window, cqDeviceUtils, cqLocationService) {

        $scope.details = function(path) {
            cqLocationService.selectedLocation = $scope.location;
            $scope.go(path);
        }

        $scope.phone = function(e) {
            window.open("tel:" + $scope.location.phone, '_system');
            e.preventDefault();
            e.stopPropagation();
        };

        $scope.directions = function(e) {
            var source = $scope.origin,
                dest = $scope.location;

            var scoords = source.lat + "," + source.lng,
                dcoords = dest.coordinates.lat + "," + dest.coordinates.lng;

            // Open the device's map application with the two coordinates
            var url;
            if (cqDeviceUtils.isiOS()) {
                url = "maps:saddr=" + scoords + "&daddr=" + dcoords;
            } else if (cqDeviceUtils.isAndroid()) {
                url = "geo:" + dcoords;
            }
            if (url) {
                window.open(url , '_system');
            } else {
                console.log("Unable to open native maps app");
            }
            e.preventDefault();
            e.stopPropagation();
        };
    }

    angular.module('cqLocations')
        .controller('LocationItemCtrl', ["$scope", "$window", "cqDeviceUtils", "cqLocationService",
            LocationItemCtrl])
        .filter('distance', function() {
            return function(input) {
                return formatDistance(input);
            }
        });


}(angular));
