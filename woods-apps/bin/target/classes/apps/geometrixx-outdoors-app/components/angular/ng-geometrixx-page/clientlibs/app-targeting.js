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
;(function(angular, undefined) {

    'use strict';

    angular
        .module('cqTargetingDirective', ['btford.phonegap.ready'])
        .directive('cqTargeting', TargetingDirective);

    TargetingDirective.$inject = ['$rootScope', 'phonegapReady'];
    function TargetingDirective($rootScope, phonegapReady) {

        function load(mboxId, el) {
            var target = new cq.mobileapps.targeting.Target(mboxId, el, {
                'gender' : 'profile.gender'
            });
            target.targetLoadRequest($rootScope.targetData);
        };

        return {
            restrict: 'A',
            scope: false,
            link: phonegapReady(function(scope, element, attrs) {
                var mboxId = attrs.mboxid;
                var el = element[0];

                scope.$on('cqTargeting:dataChange', function() {
                    load(mboxId, el);
                });

                load(mboxId, el);
            })
        };
    }

})(angular);