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
;(function( angular, document, auth, undefined ) {

    'use strict';

    angular.module('cqLoginPage', [])

        .constant('cqLogin.config', {
            'serverURL': 'http://localhost:4502'
        })

        .factory('userAuthentication', ['$rootScope', '$q', '$http', 'cqLogin.config',
            function($rootScope, $q, $http, config) {

                var login = function(username, password) {

                    var deferred = $q.defer();

                    $rootScope.authorization = new cq.mobileapps.auth.BasicAuth({
                        'server': config.serverURL,
                        'username': username,
                        'password': password
                    });

                    var profileProvider = cq.mobileapps.provider.ProfileProviderRegistry.getProvider($rootScope.authorization);

                    $rootScope.authorization.authorize(function(error) {
                        if (error) {
                            var message = "Login Failed";
                            deferred.reject(message);
                        } else {
                            profileProvider.fetch(function(error, profile) {
                                if (!error && profile) {
                                    var firstName = profile['givenName'] || '';
                                    var familyName =  profile['familyName'] || '';

                                    var user = {
                                        'username': firstName + " " + familyName
                                    }

                                    $rootScope.currentUser = user;
                                    $rootScope.targetData = profile;

                                    $rootScope.$broadcast('cqTargeting:dataChange');
                                }
                            });
                            deferred.resolve();
                        }
                    });

                    return deferred.promise;
                };

                var logout = function() {
                    var deferred = $q.defer();
                    $rootScope.authorization.logout(function(error) {
                        if (error) {
                            deferred.reject("unable to logout");
                        } else {
                            $rootScope.targetData = null;
                            deferred.resolve();
                        }
                    });
                    return deferred.promise;
                };

                return {
                    login: login,
                    logout: logout
                };
            }
        ])

        .controller('LoginPageFormController', ['$scope', '$rootScope', 'userAuthentication', 'cqPackageUtils', 'cqLogin.config',
            function($scope, $rootScope, userAuthentication, packageUtils, config) {
                $scope.username = "";
                $scope.password = "";

                // Update login config server URL
                config.serverURL = packageUtils.getServerURL($scope.contentPackageName);

                $scope.login = function(path, trackingTitle) {

                    $scope.errorMessage = "";

                    userAuthentication.login($scope.username, $scope.password).then(
                        function success() {
                            $scope.$emit('cqTargeting:profileChange', $rootScope.currentProfile);

                            $scope.password = "";
                            console.log('cqLoginPage LoginPageFormController login success');
                            $scope.goTab(path, trackingTitle);
                        },
                        function error(message) {
                            console.warn('cqLoginPage LoginPageFormController login error', message);
                            $scope.errorMessage = "Login failed";
                        }
                    );
                }
            }
        ])

        // If there is a username stored, set a variable on $rootScope indicating
        // which user is logged in.
        .run(['$rootScope',
            function($rootScope) {
                var user = new CQ.mobile.User();
                user.restore();
                if (user.getUsername().length > 0) {
                    $rootScope.currentUser = user;
                }
            }
        ]);

})(angular, document, cq.mobileapps.auth);