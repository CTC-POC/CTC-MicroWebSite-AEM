<%--
/*
 * ADOBE CONFIDENTIAL
 *
 * Copyright 2015 Adobe Systems Incorporated
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
--%><%
%><%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" %><%
%>

<div class="review" ng-class="{'scf-is-new': item.isNew}">
    <hr/>
    <aside class="scf-comment-author">
        <img class="scf-comment-avatar" ng-class="{'withTopLevel': item.topLevel}" ng-src="{{item.author.avatarUrl}}" />
    </aside>
    <div ng-class="{'withTopLevel': item.topLevel}">
        <div >
            <div >
                <div class="scf-comment-author-name">
                    {{item.author.name}}
                </div>
                <div>
                    <time class="scf-comment-time scf-quiet">{{item.created | date}}</time>
                </div>
                <div class="ratings-block">
                    <ul>
                        <li ng-repeat="(key, value) in item.ratingResponses">
                            <span ng-show="reviewData.compositeRating"> {{key}} </span>
                            <div>
                                <div class="ratings-bar-empty">
                                    <div class="ratings-bar ratings-bar-full" data-rating-shown="{{value}}" title="{{value}} of 5 stars">
                                    </div>
                                </div>
                                <br>
                                <div class="scf-comment-msg scf-js-comment-msg">
                                    {{item.message}}
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
                <br/>
            </div>
        </div>
    </div>
</div>
