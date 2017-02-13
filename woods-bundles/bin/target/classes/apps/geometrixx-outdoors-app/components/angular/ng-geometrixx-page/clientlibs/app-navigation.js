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
(function( angular, contentUpdate, contentUtils, undefined ) {

	'use strict';

	/**
	 * Module to handle general navigation in the app
	 */
	angular.module( 'cqAppNavigation', ['btford.phonegap.ready'] )

        .factory('cqPackageUtils', function() {
            return {
                getServerURL: function(packageName) {
                    var contentPackageDetails = contentUtils.getContentPackageDetailsByName(packageName);
                    if (contentPackageDetails) {
                        return contentPackageDetails.serverURL.replace(/\/+$/, "");
                    }
                    return undefined;
                }
            };
        })

		.controller( 'AppNavigationController', ['$rootScope', '$scope', '$window', '$location', '$timeout', 'phonegapReady', 'userAuthentication', '$rootElement', 'cqLogin.config', 'cqPackageUtils',
			function($rootScope, $scope, $window, $location, $timeout, phonegapReady, userAuthentication, $rootElement, config, packageUtils) {

				$scope.updating = false;

				// Request headers for Content Sync
				var reqHeaderObject = {
					// Basic auth example:
					//Authorization: "Basic " + btoa("username:password")
				};

				// Use app name as ContentSync package ID
				var appName = $rootElement.attr('ng-app');
				var contentUpdater = contentUpdate({
					id: appName,
					requestHeaders: reqHeaderObject,
					// Indicate that self-signed certificates should be trusted
					// should be set to `false` in production.
					trustAllHosts: false
				});

				// Counter to indicate how far we've travelled from the root of the app
				var numberOfPagesFromRoot = 0;
				$scope.atRootPage = true;

				// Page dimensions for consistent transitions
				var headerHeight = 44;
				var footerHeight = 48;

				// Add 20px to headerHeight if iOS is detected
				var isiOSDevice = /iPad|iPhone|iPod/.test(navigator.platform);
				if (isiOSDevice) {
					headerHeight += 20;
				}

				// Page transition constants
				var pageTransitions = {
					direction: {
						right: 	'right',
						left:	'left',
						up:		'up',
						down:	'down',
						none:	'none'
					},
					effect: {
						slide: function(){
							// NOOP
						},
						flip: function(){
							// NOOP
						}
					}
				};

                // Initialize pageTransition effect options once deviceready has fired
				var initializeTransitions = phonegapReady(function() {
					if (($scope.wcmMode === false) &&
							(window.plugins && window.plugins.nativepagetransitions)) {
						pageTransitions.effect = {
							slide: window.plugins.nativepagetransitions.slide.bind(window.plugins.nativepagetransitions),
							flip: window.plugins.nativepagetransitions.flip.bind(window.plugins.nativepagetransitions)
						}
					}
				});
				initializeTransitions();

				// Initialize status bar
				var initializeStatusBar = phonegapReady(function() {
					if (window.StatusBar) {
						if (cordova.platformId == "android") {
							StatusBar.backgroundColorByHexString("#cdcdcd");
						} else {
							StatusBar.backgroundColorByHexString("#ffffff");
						}
					}
				});
				initializeStatusBar();

				/**
				 * Handle back button
				 */
				$scope.back = function() {
					numberOfPagesFromRoot--;
					navigateBack( pageTransitions.effect.slide, pageTransitions.direction.right );

					console.log( '[nav] handled back event.' );
				};

				/**
				 * Handle navigation to app pages
				 */
				$scope.go = function( path, trackingTitle, transitionDirection ) {
					numberOfPagesFromRoot++;
					$scope.atRootPage = false;
					transitionDirection = transitionDirection || pageTransitions.direction.left;
					navigateToPage( path, trackingTitle,
							pageTransitions.effect.slide, transitionDirection );
					console.log( '[nav] app navigated to: [' + (trackingTitle || path) + '].' );
				};

				/**
				 * Handle navigation to another tab, with no transition
				 */
				$scope.goTab = function( path, trackingTitle, tabId ) {
					numberOfPagesFromRoot = 0;
					$scope.atRootPage = true;
					navigateToPage( path, trackingTitle,
							pageTransitions.effect.slide, pageTransitions.direction.none );
					console.log( '[nav] app navigated to tab: [' + (trackingTitle || path) + '].' );
                    if (tabId) {
                        $scope.selectedTab = tabId;
                    }
				};

                /**
                 * Logout the current user
                 */
                $scope.logout = function( path, trackingTitle ) {
                    $rootScope.authorization.logout(function() {
                        $rootScope.currentUser = null;
                        $rootScope.authorization = null;
                    });
                    $scope.goTab(path, trackingTitle);
                };

                $scope.login = function(isAutoLogin) {
                    if ($scope.wcmMode) {
                        return $scope.goMenuItem('/content/phonegap/geometrixx-outdoors/en/home/login', "Basic Auth Login");
                    }

                    cq.mobileapps.util.file.fetchJSON('MobileAppsConfig.json', function(error, data) {

                        // Get the configured serverURL from packageUtils
                        config.serverURL = packageUtils.getServerURL($scope.contentPackageName);

                        // ignore errors the data will come back empty
                        if (data && data.oauth) {
                            $rootScope.authorization = new cq.mobileapps.auth.OAuth({
                                'server': config.serverURL,
                                'client_id': data.oauth.clientId,
                                'client_secret': data.oauth.clientSecret,
                                'redirect_uri': data.oauth.redirectURI
                            });

                            var profileProvider = cq.mobileapps.provider.ProfileProviderRegistry.getProvider($rootScope.authorization);

                            $rootScope.authorization.authorize(function(error) {
                                if (error) {
                                    return console.error("Unable to login" + error);
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
                                }
                            });

                            $scope.toggleMenu(); // load the profile behind the scenes
                        } else {
                            if (!isAutoLogin) {
                                $scope.goMenuItem('/content/phonegap/geometrixx-outdoors/en/home/login', "Basic Auth Login");
                            }
                        }
                    });
                };

                var doAutoLogin = phonegapReady(function() {
                    if (!$scope.wcmMode) {
                        $scope.login(true);
                    }
                });
                doAutoLogin();

                /**
				 * Handle navigation from menu items to pages in the app
				 */
				$scope.goMenuItem = function( path, trackingTitle ) {
					numberOfPagesFromRoot++;
					$scope.atRootPage = false;
					// Navigate to the given path with a fixed header & footer size of 0
					navigateToPage( path, trackingTitle,
							pageTransitions.effect.slide, pageTransitions.direction.left, 0, 0 );
					console.log( '[nav] app navigated to menu item: [' + (trackingTitle || path) + '].' );
				};

				/**
				 * Toggle the menu
				 */
				$scope.toggleMenu = function() {
					if( window.ADB && !$scope.navigationMenuStatus ) {
						ADB.trackState( 'menu', {} );
					}

					$scope.navigationMenuStatus = !$scope.navigationMenuStatus;
				};

				/**
				 * Trigger an app update
				 */
				$scope.updateApp = function() {
					// don't start updating again if we're already updating.
					if($scope.updating) return;

					// Check if an update is available
					contentUpdater.isContentPackageUpdateAvailable($scope.contentPackageName,
						function callback(error, isUpdateAvailable) {
							if (error) {
								// Alert the error details.
								return navigator.notification.alert(error, null, 'Content Update Error');
							}

							if (isUpdateAvailable) {
								// Confirm if the user would like to update now
								navigator.notification.confirm('Update is available, would you like to install it now?',
									function onConfirm(buttonIndex) {
										if (buttonIndex == 1) {
											// user selected 'Update'
											$scope.updating = true;
											contentUpdater.updateContentPackageByName($scope.contentPackageName,
												function callback(error, pathToContent) {
													if (error) {
														return navigator.notification.alert(error, null, 'Error');
													}
													// else
													console.log('Update complete; reloading app.');
													window.location.reload( true );
												});
										}
										else {
											// user selected Later
											// no-op
										}
									},
									'Content Update',		// title
									['Update', 'Later']	// button labels
								);
							}
							else {
								navigator.notification.alert('App is up to date.', null, 'Content Update', 'Done');
							}
						}
					);
				};

				/**
				 * Handle navigation to product pages
				 */
				$scope.goProduct = function( templatePath, sku, trackingTitle ) {
					if( $scope.wcmMode ) {
						navigateToPage( getFullProductPagePath(templatePath, sku), trackingTitle );
					}
					else {
						numberOfPagesFromRoot++;
						$scope.atRootPage = false;
						navigateToPage( templatePath + '/' + sku, trackingTitle,
							pageTransitions.effect.slide,
							pageTransitions.direction.left );
					}

					console.log( '[nav] app navigated to product: [' + sku + '].' );
				};

				/*
				 * Private helpers
				 */
				function navigateToPage( path, trackingTitle, transition, transitionDirection, 
						fixedHeaderHeight, fixedFooterHeight) {

					if( $scope.wcmMode ) {
						// WCMMode is enabled; head to the page itself
						$window.location.href = path + '.html';
					}
					else {
						if (window.ADB) {
							// Track using trackingTitle, falling back to path if unavailable
							ADB.trackState(trackingTitle || path, {});
						}

						// Set to default values if parameters are undefined (0 is OK)
						if (fixedHeaderHeight === undefined) {
							fixedHeaderHeight = headerHeight;
						}
						if (fixedFooterHeight === undefined) {
							fixedFooterHeight = footerHeight;
						}

						// Configure transition options
						var transitionConfig = {
							// Change $location below after a brief $timeout
							'href': null,
							'direction': transitionDirection
						};

						// Set the fixed pixels properties *only* if they are > 0
						if (fixedHeaderHeight > 0) {
							transitionConfig.fixedPixelsTop = fixedHeaderHeight;
						}
						if (fixedFooterHeight > 0) {
							transitionConfig.fixedPixelsBottom = fixedFooterHeight;
						}

						if (transition && (transitionDirection !== pageTransitions.direction.none)) {
							// Invoke transition
							transition(
								transitionConfig,
								function success(msg) {
									// NOOP
								},
								function error(msg) {
									console.error('[native transitions][ERROR] msg: ' + msg);
								}
							);
						}

						// Manually change the $location
						$timeout(function () {
							$location.url(path);
							$scope.navigationMenuStatus = false;
						}, 10);
					}
				}

				function navigateBack(transition, transitionDirection) {
					if( $scope.wcmMode ) {
						$window.history.back();
					}
					else {
						if (numberOfPagesFromRoot < 0) {
							// Don't allow user to navigate further back than the first page
							return;
						}

						transition(
							{
								'direction': transitionDirection,
								// Change $location below after a brief $timeout
								'href': null,
								'fixedPixelsTop': headerHeight,
								'fixedPixelsBottom': footerHeight
							},
							function success(msg) {
								// NOOP
							},
							function error(msg) {
								console.error('[native transitions][ERROR] msg: ' + msg);
							}
						);

						$scope.navigationMenuStatus = false;

						$timeout(function() {
							$window.history.back();
							if (numberOfPagesFromRoot === 0) {
								$scope.atRootPage = true;
							}
						}, 10);
					}
				}

				function getFullProductPagePath( base, sku ) {
					// Sample SKUs are at least 6 chars long, but 4 is the min.
					if( sku.length < 4 ) {
						// Invalid SKU
						return null;
					}

					return base + '/' + sku.substring( 0, 2 ) + '/' + sku.substring( 0, 4 ) + '/' + sku;
				}
			}
		]
	);
})( angular, CQ.mobile.contentUpdate, CQ.mobile.contentUtils );
