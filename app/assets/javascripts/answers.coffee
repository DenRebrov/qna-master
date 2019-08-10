ready = ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');

  $('.answer_like_dislike').on 'ajax:success', (e) ->
    vote = e.detail[0];
    $('.answer_rating_' + vote['id']).html('<b>' + vote['rating'] + '</b>');

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      @perform 'follow', question_id: gon.question_id
      ,
    received: (data) ->
      console.log(data)
      if data.answer.user_id != gon.user_id
        $('.answers').append(JST["templates/answer"](data))
  });

$(document).on('turbolinks:load', ready);