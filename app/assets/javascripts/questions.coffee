ready = ->
  $('.questions').on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');

  $('.question_like_dislike').on 'ajax:success', (e) ->
    vote = e.detail[0];
    $('.question_rating').html('<b>' + vote['rating'] + '</b>');

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
      ,
    received: (data) ->
      console.log(data)
      $('.questions-list').append(JST["templates/question"](data))
  });

$(document).on('turbolinks:load', ready);