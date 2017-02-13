/*
 *
 * ADOBE CONFIDENTIAL
 * __________________
 *
 *  Copyright 2012 Adobe Systems Incorporated
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
 */

(function($CQ, _, Backbone, SCF) {
    "use strict";
    var GMForumView = SCF.ForumView.extend({
        viewName: "GMForum",
        showComposer: function(e) {
            SCF.ForumView.prototype.toggleComposer.apply(this, arguments);
            var cancel = this.$el.find('.cancel-new-topic');
            cancel.toggle();
        },
        hideComposer: function(e) {
            SCF.ForumView.prototype.toggleComposer.apply(this, arguments);
            var cancel = this.$el.find('.cancel-new-topic');
            cancel.toggle();
        }
    });

    var GMTopicView = SCF.TopicView.extend({
        viewName: "GMTopic",
        toggleComposerCollapse : function(e) {
            SCF.TopicView.prototype.toggleComposerCollapse.apply(this, arguments);
            var cancel = this.$el.find('.topic-cancel-reply-button:first');
            cancel.toggle();
            var newTopic = this.$el.find('.topic-reply-button:first');
            newTopic.toggle();
        }
    });

    SCF.registerComponent('geometrixx-media/components/social/forum/components/hbs/post', SCF.Post, SCF.PostView);
    SCF.registerComponent('geometrixx-media/components/social/forum/components/hbs/topic', SCF.Topic, GMTopicView);
    SCF.registerComponent('geometrixx-media/components/social/forum/components/hbs/forum', SCF.Forum, GMForumView);
})($CQ, _, Backbone, SCF);
