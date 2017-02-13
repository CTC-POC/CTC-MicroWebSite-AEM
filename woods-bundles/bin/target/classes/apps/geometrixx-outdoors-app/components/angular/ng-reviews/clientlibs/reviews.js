/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2015 Adobe Systems Incorporated
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

    var SOCIAL_JSON = ".social.json";
    var LOGGED_IN_USER_SERVICE = "/services/social/getLoggedInUser";

    angular.module('cqMobileReviews', []);

    function MobileReviewsCtrl($rootScope, $scope, $http, packageUtils) {
        $scope.reviewData = {};
        $scope.showReviewForm = false;
        $scope.showCreateButton = false;
        $scope.showErrorMessage = false;
        $scope.showLoadMore = false;
        $scope.submittedRatings = {};
        $scope.message = "";
        $scope.errorMessage = "";

        // Read server URL from contentPackageDetails
        $scope.serverURL = packageUtils.getServerURL($scope.contentPackageName);

        if ($scope.wcmMode === true) {
            $scope.serverURL = location.protocol + '//' + location.hostname + (location.port ? ':' + location.port: '');
        }
        var dataURL = $scope.serverURL + $scope.reviewDataPath + SOCIAL_JSON;
        var loggedInUserURL = $scope.serverURL + LOGGED_IN_USER_SERVICE;

        var req = {
            method: 'GET',
            url: dataURL,
            headers: {
                'origin': 'http://geo'
            }
        }

        $http(req).then(loadDataSuccess, httpError);

        $scope.setShowReviewForm = function(show) {
            $scope.showReviewForm = show;
            $scope.showCreateButton = !show;
        }

        $scope.submitReviewForm = function() {
            $scope.showReviewForm = false;

            var ratings = "";
            var submittedRatings = $scope.submittedRatings;
            for (var rating in submittedRatings) {
                if (submittedRatings.hasOwnProperty(rating)) {
                    ratings += rating + ";" + submittedRatings[rating] + ";";
                }
            }

            var headers = {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            };

            var data = {
                "id": "nobot",
                ":operation": "social:createReview",
                "message": $scope.message,
                "ratings": ratings,
                "_charset_": "UTF-8",
                "tags": ""
            };

            var config = {
                "method": "POST",
                "url": dataURL,
                "headers": headers,
                "data": data,
                "withCredentials": true,
                "transformRequest": transformPostData
            };

            $http(config).then(createReviewSuccess, httpError);


        }

        $scope.resetReviewForm = function() {
            $scope.submittedRatings = {};
            $scope.message = "";
            $scope.showReviewForm = false;
            $scope.showCreateButton = true;
        }

        $scope.loadMoreClick = function() {
            var nextPageUrl = $scope.serverURL + $scope.reviewData.pageInfo.nextPageURL;
            $http.get(nextPageUrl).then(loadMoreSuccess, httpError);
        }

        function loadMoreSuccess(response) {
            var newReviews = response.data.items;
            $scope.reviewData.items = $scope.reviewData.items.concat(newReviews);
            $scope.showLoadMore = $scope.reviewData.totalSize > $scope.reviewData.items.length;
        }

        function createReviewSuccess(response) {
            var newReview = response.data.response;
            newReview.isNew = true;

            //initial review data if needed
            if (! $scope.reviewData.items) {
                $scope.reviewData.items = [];
            }

            //push the new review
            $scope.reviewData.items.push(newReview);

            //increment the total count
            var totalCount = $scope.reviewData.totalSize;
            $scope.reviewData.totalSize = totalCount + 1;

            //calculate the new averages

            //initialize the averages if needed
            if (! $scope.reviewData.ratingAverages) {
                $scope.reviewData.ratingAverages = {};
            }
            var averages = $scope.reviewData.ratingAverages;

            //initialize the ratings if needed
            if (! $scope.reviewData.ratings) {
                $scope.reviewData.ratings = {};
            }
            var ratings = $scope.reviewData.ratings;

            var allowed_ratings = $scope.reviewData.allowedRatings;

            for (var i = 0; i < allowed_ratings.length; i++) {
                var name = allowed_ratings[i].name;
                var avg = averages[name];

                var ratingValue = newReview.ratingResponses[name];

                if (ratingValue > 0) {
                    var totalResponses = 0;
                    if (! ratings[name]) {
                        ratings[name] = {};
                    } else {
                        totalResponses = ratings[name].totalNumberOfResponses;
                    }
                    avg = (avg * totalResponses + ratingValue) / (totalResponses + 1);
                    averages[name] = avg.toFixed(2);
                    if (ratings) {
                        ratings[name].totalNumberOfResponses = totalResponses + 1;
                        ratings[name].averageRating = avg.toFixed(2);
                    }
                }
            }

            $scope.showCreateButton = false;
            $scope.submittedRatings = {};
            $scope.message = "";
        }

        function loadDataSuccess(response) {
            $scope.reviewData = response.data;

            if ($rootScope.currentUser.username) {
                $scope.showCreateButton = true;
            }
            if ($scope.reviewData.items) {
                $scope.showLoadMore = $scope.reviewData.totalSize > $scope.reviewData.items.length;
            }

            $http.get(loggedInUserURL).then(loggedInUserSuccess, httpError);
        }

        function loggedInUserSuccess(response) {
            $scope.reviewData.loggedInUser = response.data;
            if (response.data.name) {
                $scope.reviewData.loggedInUser.loggedIn = true;
            }
        }

        function httpError(response) {
            if (response.data && response.data.error) {
                $scope.showErrorMessage = true;
                $scope.errorMessage = response.data.error.message;
            } else {
                console.log( 'response.data not set.' );
            }
        }

        var transformPostData = function(obj) {
            var query = '', name, value, fullSubName, subName, subValue, innerObj, i;

            for(name in obj) {
                value = obj[name];

                if(value instanceof Object) {
                    for(subName in value) {
                        subValue = value[subName];
                        fullSubName = name + '[' + subName + ']';
                        innerObj = {};
                        innerObj[fullSubName] = subValue;
                        query += param(innerObj) + '&';
                    }
                } else if(value !== undefined && value !== null) {
                    query += encodeURIComponent(name) + '=' + encodeURIComponent(value) + '&';
                }
            }

            return query.length ? query.substr(0, query.length - 1) : query;
        };
    };

    angular.module('cqMobileReviews')
        .controller('MobileReviewsCtrl', ["$rootScope","$scope", "$http", "cqPackageUtils", MobileReviewsCtrl]);

})(angular);
