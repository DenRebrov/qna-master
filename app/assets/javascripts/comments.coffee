ready = ->
  $('.question_comments, .answer_comments').on 'click', '.add-comment-link', (e) ->
    e.preventDefault();
    $(this).hide();
    resource_id = $(this).data('resourceId');
    resource_type = $(this).data('resourceType');
    $('form#new-comment-' + resource_type + '-' + resource_id).show();

  $('.question_comments, .answer_comments').on 'click', '.edit-comment-link', (e) ->
    e.preventDefault();
    $(this).hide();
    comment_id = $(this).data('commentId');
    $('form#edit-comment-' + comment_id).show();

  $('.question_comments, .answer_comments').on 'click', '.hide-comment-link', (e) ->
    e.preventDefault();
    resource_id = $(this).data('resourceId');
    resource_type = $(this).data('resourceType');
    $('form#new-comment-' + resource_type + '-' + resource_id).hide();
    $('.add-comment-link').show();

  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'follow', question_id: gon.question_id
      ,
    received: (data) ->
      if data.comment.user_id != gon.user_id
        resourceType = data.comment.commentable_type.toLowerCase();
        commentsContainer =
          if resourceType == 'question'
          then $('.question_comments')
          else $('.answer_' + data.comment.commentable_id).find('.answer_comments');
        commentsContainer.append(JST['templates/comment'](
          comment: data.comment
        ));
  });

$(document).on('turbolinks:load', ready);