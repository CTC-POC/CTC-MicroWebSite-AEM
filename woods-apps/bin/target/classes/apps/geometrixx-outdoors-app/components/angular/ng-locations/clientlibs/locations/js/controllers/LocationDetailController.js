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
        .filter('phonenumber', function() {
            function formatPhone(phone) {
                var regexObj = /^(?:\+?1[-. ]?)?(?:\(?([0-9]{3})\)?[-. ]?)?([0-9]{3})[-. ]?([0-9]{4})$/;
                if (regexObj.test(phone)) {
                    var parts = phone.match(regexObj);
                    var formatted = "";
                    if (parts[1]) {
                        formatted += "(" + parts[1] + ") ";
                    }
                    formatted += parts[2] + "-" + parts[3];
                    return formatted;
                }
                else {
                    //invalid phone number
                    return phone;
                }
            }

            return function(input) {
                return formatPhone(input);
            }
        })
        .controller('LocationDetailsCtrl', ["$scope", "$timeout", "cqLocationService",
            function($scope, $timeout, cqLocationService) {

                $scope.init = function(dataName) {
                    if (!cqLocationService.selectedLocation) {
                        //Watch page scope for store location
                        $scope.$watch(dataName, function(newValue) {
                            if (newValue) {
                                cqLocationService.add(newValue);
                                cqLocationService.selectedLocation = newValue;
                                buildScope();
                            }
                        }, true);
                    } else {
                        //Use selected location from location service
                        buildScope();
                    }
                };

                $scope.phone = function(e) {
                    window.open("tel:" + $scope.location.phone, '_system');
                    e.preventDefault();
                    return;
                };

                function buildScope() {
                    $scope.location = cqLocationService.selectedLocation;
                    if ($scope.location) {
                        $scope.location.formattedHours = formatHours($scope.location.hours);

                        if ($scope.location.coordinates) {
                            $scope.origin = $scope.location.coordinates;
                            $scope.showMap = true;
                        }
                    }
                }

                /**
                 * Convert [Monday|9:00-5:00,...] to [{day: Monday, time: 9:00-5:00},...]
                 */
                function formatHours(hours) {
                    var newHours = [];
                    if (hours && angular.isArray(hours)) {
                        for (var i=0; i < hours.length; i++) {
                            var hour = hours[i];
                            if (angular.isObject(hour)) {
                                continue;
                            }
                            var hourList = hour.split("|"),
                                day = "";
                            if (hourList.length > 1) {
                                day = hourList.splice(0,1)[0];
                            }
                            hour = hourList.join(" ");
                            newHours.push({day: day, time: hour});
                        }
                    }
                    return newHours;
                }

            }
        ]);


})(angular);