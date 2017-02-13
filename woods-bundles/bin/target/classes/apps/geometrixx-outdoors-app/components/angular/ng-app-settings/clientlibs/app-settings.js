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
(function( angular, contentUtils, undefined ) {

    'use strict';

    /**
     * Module to handle general app settings.
     */
    angular.module( 'cqAppSettings', [] )
        .controller( 'AppSettingsFormController', ['$scope', '$http', 'CordovaConfig',
            function( $scope, $http, CordovaConfig ) {
                // Initialize the form
                var contentPackageName = $scope.contentPackageName;
                var contentPackageDetails = contentUtils.getContentPackageDetailsByName(contentPackageName);

                if (contentPackageDetails) {
                    $scope.serverURL = contentPackageDetails.serverURL;
                }

                // Pull version details from config
                CordovaConfig.fetch().then( function ( config ) {
                    if (config && config.querySelector) {
                        $scope.appVersion = config.querySelector( "widget" ).getAttribute( "version" );
                    }
                });

                $scope.submit = function() {
                    if (contentPackageDetails) {
                        contentPackageDetails.serverURL = $scope.serverURL;
                        // Sample workaround: increment the timestamp to trigger an update of the stored
                        // content package details. Only necessary for 2.0.16 version of FP2.
                        contentPackageDetails.timestamp++;
                        contentUtils.storeContentPackageDetails( contentPackageName, contentPackageDetails, true );
                    }
                    $scope.appSettings.$setPristine();
                    $scope.settingsUpdateComplete = true;
                };
            }
        ])
        .factory( 'CordovaConfig', ['$http', '$q', function ( $http, $q ) {
            return {
                config: undefined,

                fetch: function () {
                    var deferred = $q.defer();

                    var pathToConfigFile = contentUtils.getPathToWWWDir(window.location.href) + "config.xml";

                    $http.get( pathToConfigFile ).then(
                        function ( result ) {
                            var parser = new DOMParser();
                            this.config = parser.parseFromString( result.data, "application/xml" );
                            deferred.resolve( this.config );
                        }.bind( this ),
                        function () {
                            console.error( "Error loading config.xml.", arguments );
                            deferred.resolve.apply( undefined, arguments );
                        } );

                    return deferred.promise;
                }
            }
        }])

})( angular, CQ.mobile.contentUtils );