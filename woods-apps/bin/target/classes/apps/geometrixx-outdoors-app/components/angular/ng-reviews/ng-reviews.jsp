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
%><%@page session="false"
          import="com.day.cq.i18n.I18n" %><%
%>

<c:set var="showSummary"><%= properties.get("showSummary", Boolean.FALSE).equals(Boolean.TRUE) %></c:set>

<%
    I18n i18n = new I18n(slingRequest);
    int maxLen = properties.get("/maxMessageLength", 4096);
%>

<div class="mobile-reviews" ng-controller="MobileReviewsCtrl" data-component-id="{{reviewData.id}}" data-scf-component="social/reviews/components/hbs/reviews">
    <div ng-show="reviewData.items">
        <c:choose>
            <c:when test="${showSummary}">
                <sling:include resourceType="mobileapps/components/reviewsummary" replaceSelectors="fullsize-template"/>
            </c:when>
        </c:choose>
    </div>
    <div class="scf-comment-system scf scf-reviews">
        <ul class="scf-comments-list" >
            <li class="scf-comment" ng-repeat="item in reviewData.items" data-component-id="{{reviewData.id}}" data-scf-component = 'social/reviews/components/hbs/reviews/review'>
                <cq:include script="review/review.jsp" />
            </li>
        </ul>
    </div>
    <hr/>
    <div class="create-reviews" ng-show="reviewData.loggedInUser.loggedIn">
        <button class="topcoat-button--cta" id="create" ng-show="showCreateButton" ng-click="setShowReviewForm(true)"><%= i18n.get("Write a review") %></button>
        <div class="scf-review-form scf-composer-block scf-js-composer-block" ng-show="showReviewForm">
            <form ng-submit="submitReviewForm()" class="scf-composer scf-review-composer">
                <div class="allowed-ratings" ng-repeat="rating in reviewData.allowedRatings">
                    <div class="rating">
                        <input type="radio" id="star5" name="rating" ng-model="submittedRatings[rating.name]" value="5" /><label for="star5" ></label>
                        <input type="radio" id="star4" name="rating" ng-model="submittedRatings[rating.name]" value="4" /><label for="star4" ></label>
                        <input type="radio" id="star3" name="rating" ng-model="submittedRatings[rating.name]" value="3" /><label for="star3" ></label>
                        <input type="radio" id="star2" name="rating" ng-model="submittedRatings[rating.name]" value="2" /><label for="star2" ></label>
                        <input type="radio" id="star1" name="rating" ng-model="submittedRatings[rating.name]" value="1" /><label for="star1" ></label>
                    </div>
                </div>
                <br>
                <br>
                <textarea class="topcoat-textarea--large" ng-model="message" ng-maxlength="<%= maxLen %>" data-attrib="message" name="message" placeholder="<%= i18n.get("Write a review") %>"></textarea>
                <br>
                <br>
                <div>
                    <button class="topcoat-button--cta" id="reset" type="reset" ng-click="resetReviewForm()"><%= i18n.get("Cancel")%></button>
                    <button class="topcoat-button--cta" id="post" type="submit"><%= i18n.get("Post")%></button>
                </div>
            </form>
        </div>
    </div>
    <div class="reviews-error" ng-show="showErrorMessage">
        {{errorMessage}}
    </div>
    <button class="reviews-load-more" id="loadMore" ng-show="showLoadMore" ng-click="loadMoreClick()"><%= i18n.get("Load more reviews") %></button>
</div>
